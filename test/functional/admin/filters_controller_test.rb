require 'test_helper'

class Admin::FiltersControllerTest < ActionController::TestCase
  setup do
    @admin_filter = admin_filters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_filters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_filter" do
    assert_difference('Admin::Filter.count') do
      post :create, :admin_filter => @admin_filter.attributes
    end

    assert_redirected_to admin_filter_path(assigns(:admin_filter))
  end

  test "should show admin_filter" do
    get :show, :id => @admin_filter.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_filter.to_param
    assert_response :success
  end

  test "should update admin_filter" do
    put :update, :id => @admin_filter.to_param, :admin_filter => @admin_filter.attributes
    assert_redirected_to admin_filter_path(assigns(:admin_filter))
  end

  test "should destroy admin_filter" do
    assert_difference('Admin::Filter.count', -1) do
      delete :destroy, :id => @admin_filter.to_param
    end

    assert_redirected_to admin_filters_path
  end
end
