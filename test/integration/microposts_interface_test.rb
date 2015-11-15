require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    # User with zero microposts
    @no_post_user = users(:mallory)
  end

  test 'micropost interface' do
    log_in_as(@user)

    get root_path
    assert_select 'div.pagination'

    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: "" }
    end
    assert_select 'div#error_explanation'

    # Valid submission
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # Delete a post.
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit a different user.
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'micropost sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body

    # User with zero microposts
    log_in_as(@no_post_user)
    get root_path
    assert_match '0 microposts', response.body

    @no_post_user.microposts.create!( content: 'A micropost' )
    get root_path
    assert_match '1 micropost', response.body
  end

  test 'micropost picture uploading' do
    log_in_as(@no_post_user)
    get root_path
    assert_select 'input[type=file]'

    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: {
        content: 'I will upload a picture!',
        picture: fixture_file_upload('test/fixtures/rails.png', 'image/png') 
      }
    end
    assert @no_post_user.microposts.first.picture?, 'should have a picture'

    follow_redirect!
    assert_select '.content img'
  end
end
