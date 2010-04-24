require 'test_helper'

class AssetsControllerTest < ActionController::TestCase
  test "should get styles" do
    get :styles
    assert_response :success
  end

end
