require 'test_helper'

class Admin::NodesControllerTest < ActionController::TestCase
  setup do
    @admin_node = admin_nodes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_nodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_node" do
    assert_difference('Admin::Node.count') do
      post :create, :admin_node => @admin_node.attributes
    end

    assert_redirected_to admin_node_path(assigns(:admin_node))
  end

  test "should show admin_node" do
    get :show, :id => @admin_node.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_node.to_param
    assert_response :success
  end

  test "should update admin_node" do
    put :update, :id => @admin_node.to_param, :admin_node => @admin_node.attributes
    assert_redirected_to admin_node_path(assigns(:admin_node))
  end

  test "should destroy admin_node" do
    assert_difference('Admin::Node.count', -1) do
      delete :destroy, :id => @admin_node.to_param
    end

    assert_redirected_to admin_nodes_path
  end
end
