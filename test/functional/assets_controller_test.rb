require 'test_helper'

class AssetsControllerTest < ActionController::TestCase
  test 'should get scripts' do
    get :scripts
    assert_response :success
  end

  test 'should get styles' do
    get :styles
    assert_response :success
  end

  test 'should have the correct content type set' do
    get :scripts
    assert_equal 'application/javascript', response.content_type

    get :styles
    assert_equal 'text/css', response.content_type

    get :styles, :format => :css
    assert_equal 'text/css', response.content_type

    get :styles, :format => :sass
    assert_equal 'text/plain', response.content_type
  end
end
