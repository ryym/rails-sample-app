require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  test 'following page' do
    assert @user.following.any?
    following_users = @user.following

    get following_user_path @user
    assert_template 'show_follow'
    assert_select '.user_avatars > a', following_users.count

    following_users.each do |following|
      assert_select 'a[href=?]', user_path(following)
    end
  end

  test 'followers page' do
    assert @user.followers.any?
    followers = @user.followers

    get followers_user_path @user
    assert_template 'show_follow'
    assert_select '.user_avatars > a', followers.count

    followers.each do |follower|
      assert_select 'a[href=?]', user_path(follower)
    end
  end

  test 'should follow a user the standard way' do
    assert_not @user.following?(@other)
    assert_difference '@user.following.count', 1 do
      post relationships_path, followed_id: @other.id
    end
  end

  test 'should follow a user with Ajax' do
    assert_not @user.following?(@other)
    assert_difference '@user.following.count', 1 do
      xhr :post, relationships_path, followed_id: @other.id
    end
  end

  test 'should unfollow a user the standard way' do
    @user.follow @other
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test 'should unfollow a user with Ajax' do
    @user.follow @other
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end

  test 'feed on Home page' do
    get root_path
    @user.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end
end
