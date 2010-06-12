require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @session = sessions(:one)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create session' do
    assert_difference('Session.count') do
      post :create, :session => @session.attributes
    end

    assert_redirected_to session_path(assigns(:session))
  end

  test 'should destroy session' do
    assert_difference('Session.count', -1) do
      delete :destroy, :id => @session.to_param
    end

    assert_redirected_to sessions_path
  end
end
