require 'test_helper'

class Admin::ThemesControllerTest < ActionController::TestCase
  setup do
    @admin_theme = admin_themes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_themes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_theme" do
    assert_difference('Admin::Theme.count') do
      post :create, :admin_theme => @admin_theme.attributes
    end

    assert_redirected_to admin_theme_path(assigns(:admin_theme))
  end

  test "should show admin_theme" do
    get :show, :id => @admin_theme.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_theme.to_param
    assert_response :success
  end

  test "should update admin_theme" do
    put :update, :id => @admin_theme.to_param, :admin_theme => @admin_theme.attributes
    assert_redirected_to admin_theme_path(assigns(:admin_theme))
  end

  test "should destroy admin_theme" do
    assert_difference('Admin::Theme.count', -1) do
      delete :destroy, :id => @admin_theme.to_param
    end

    assert_redirected_to admin_themes_path
  end
end
