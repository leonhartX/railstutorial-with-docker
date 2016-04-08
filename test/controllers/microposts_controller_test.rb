require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = users(:leonhart)
  	@micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
  	assert_no_difference 'Micropost.count' do
  		post microposts_path, params: {
  			content: "Lorem ipsum"
  		}
  	end
  	assert_redirected_to login_path
  end

  test "should redirect destroy when not logged in" do
  	assert_no_difference 'Micropost.count' do
  		delete micropost_path(@micropost.id)
  	end
  	assert_redirected_to login_path
  end

  test "should redirect destroy for wrong micropost" do
  	log_in_as(@user)
  	micropost = microposts(:ants)
  	assert_no_difference 'Micropost.count' do
  		delete micropost_path(micropost.id)
  	end
  	assert_redirected_to root_path
  end
end
