require 'test_helper'

class Admin::VocabulariesControllerTest < ActionController::TestCase
  setup do
    @admin_vocabulary = admin_vocabularies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_vocabularies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_vocabulary" do
    assert_difference('Admin::Vocabulary.count') do
      post :create, :admin_vocabulary => @admin_vocabulary.attributes
    end

    assert_redirected_to admin_vocabulary_path(assigns(:admin_vocabulary))
  end

  test "should show admin_vocabulary" do
    get :show, :id => @admin_vocabulary.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_vocabulary.to_param
    assert_response :success
  end

  test "should update admin_vocabulary" do
    put :update, :id => @admin_vocabulary.to_param, :admin_vocabulary => @admin_vocabulary.attributes
    assert_redirected_to admin_vocabulary_path(assigns(:admin_vocabulary))
  end

  test "should destroy admin_vocabulary" do
    assert_difference('Admin::Vocabulary.count', -1) do
      delete :destroy, :id => @admin_vocabulary.to_param
    end

    assert_redirected_to admin_vocabularies_path
  end
end
