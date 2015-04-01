require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_title_is "Home"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_title_is "Help"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_title_is "About"
  end

  private

    def assert_title_is(name)
      assert_select "title", "#{name} | Ruby on Rails Tutorial Sample App"
    end
end
