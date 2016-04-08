require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = users(:leonhart)
  	@ghost = users(:ghost)
  end

  test "show shuold not show unactivated user" do
  	log_in_as(@user)
  	get user_path(@ghost)
  	assert_redirected_to root_path
  end
end
