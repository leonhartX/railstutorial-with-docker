require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:leonhart)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'

    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {
        micropost: { content: "" }
      }
    end
    assert_select 'div#error_explanation'

    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {
        micropost: {content: content}
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_match content, response.body

    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    get user_path(users(:lc))
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
  	log_in_as(@user)
  	get root_path
  	assert_match "#{@user.microposts.count} microposts", response.body

  	other_user = users(:none)
  	log_in_as(other_user)
  	get root_path
  	assert_match "0 microposts", response.body
  	other_user.microposts.create!(content: "a micropost")
    get root_path
    assert_match "1 micropost", response.body
  end

end
