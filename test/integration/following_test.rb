require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'following page' do
    assert @user.following.any?
    following_users = @user.following

    log_in_as @user
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

    log_in_as @user
    get followers_user_path @user
    assert_template 'show_follow'
    assert_select '.user_avatars > a', followers.count

    followers.each do |follower|
      assert_select 'a[href=?]', user_path(follower)
    end
  end
end
