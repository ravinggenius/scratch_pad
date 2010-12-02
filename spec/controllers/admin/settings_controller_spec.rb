require 'spec_helper'

describe Admin::SettingsController do

  def mock_setting(stubs={})
    (@mock_setting ||= mock_model(Setting).as_null_object).tap do |setting|
      setting.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all settings as @settings" do
      Setting.stub(:all) { [mock_setting] }
      get :index
      assigns(:settings).should eq([mock_setting])
    end
  end

  describe "GET show" do
    it "assigns the requested setting as @setting" do
      Setting.stub(:find).with("37") { mock_setting }
      get :show, :id => "37"
      assigns(:setting).should be(mock_setting)
    end
  end

  describe "GET new" do
    it "assigns a new setting as @setting" do
      Setting.stub(:new) { mock_setting }
      get :new
      assigns(:setting).should be(mock_setting)
    end
  end

  describe "GET edit" do
    it "assigns the requested setting as @setting" do
      Setting.stub(:find).with("37") { mock_setting }
      get :edit, :id => "37"
      assigns(:setting).should be(mock_setting)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created setting as @setting" do
        Setting.stub(:new).with({'these' => 'params'}) { mock_setting(:save => true) }
        post :create, :setting => {'these' => 'params'}
        assigns(:setting).should be(mock_setting)
      end

      it "redirects to the created setting" do
        Setting.stub(:new) { mock_setting(:save => true) }
        post :create, :setting => {}
        response.should redirect_to(admin_setting_url(mock_setting))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved setting as @setting" do
        Setting.stub(:new).with({'these' => 'params'}) { mock_setting(:save => false) }
        post :create, :setting => {'these' => 'params'}
        assigns(:setting).should be(mock_setting)
      end

      it "re-renders the 'new' template" do
        Setting.stub(:new) { mock_setting(:save => false) }
        post :create, :setting => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested setting" do
        Setting.should_receive(:find).with("37") { mock_setting }
        mock_setting.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :setting => {'these' => 'params'}
      end

      it "assigns the requested setting as @setting" do
        Setting.stub(:find) { mock_setting(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:setting).should be(mock_setting)
      end

      it "redirects to the setting" do
        Setting.stub(:find) { mock_setting(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_setting_url(mock_setting))
      end
    end

    describe "with invalid params" do
      it "assigns the setting as @setting" do
        Setting.stub(:find) { mock_setting(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:setting).should be(mock_setting)
      end

      it "re-renders the 'edit' template" do
        Setting.stub(:find) { mock_setting(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested setting" do
      Setting.should_receive(:find).with("37") { mock_setting }
      mock_setting.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the settings list" do
      Setting.stub(:find) { mock_setting }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_settings_url)
    end
  end

end
