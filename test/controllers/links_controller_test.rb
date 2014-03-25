require 'test_helper'

class LinksControllerTest < ActionController::TestCase
  test "should get log" do
    get :log
    assert_response :success
  end

end
