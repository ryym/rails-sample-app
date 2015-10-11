require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user      = users(:michael)
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test 'index incuding pagination' do
    log_in_as @user
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    assert_select 'ul.users > li', 30
    User.where(activated: true).paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test 'index as admin' do
    log_in_as @admin
    get users_path

    assert_template 'users/index'
    User.paginate(page: 1) do |user|
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end

    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as @non_admin
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test 'index excluding inactivated users' do
    log_in_as @user
    get users_path
    assert_select 'ul.users > li', 30
    assert_select 'a',
      { count: 0, text: 'Inactivated User' },
      'The page must contain only activated users.'
  end

   test 'show an inactivated user' do
     log_in_as @user
     ia = users(:inactivated)
     get user_path(ia)
     assert_redirected_to root_url
   end
end
