require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:leonhart)
    @other_user = users(:lc)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), params:{
      user: { name:  '',
              email: 'foo@invalid',
              password:              'foo',
              password_confirmation: 'bar' }
    }
    assert_select 'title', "Edit user | Ruby on Rails Tutorial Sample App"
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
      user: { name:  name,
              email: email,
              password:              '',
              password_confirmation: '' }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_redirected_to login_path
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: {
      user: { name: @user.name, email: @user.email }
    }
    assert_redirected_to login_path
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: {
      user: { name: @user.name, email: @user.email }
    }
    assert_redirected_to root_path
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
      user: { name:  name,
              email: email,
              password:              '',
              password_confirmation: '' }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

  test "only redirect_back_or when fisrt login" do
    get edit_user_path(@user)
    assert_not_nil session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url]
  end

end
