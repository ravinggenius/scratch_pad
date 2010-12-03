require 'spec_helper'

describe Admin::AddonsController do

  def mock_addon(stubs={})
    (@mock_addon ||= mock_model(Addon).as_null_object).tap do |addon|
      addon.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all addons as @addons" do
      Addon.stub(:all) { [mock_addon] }
      get :index
      assigns(:addons).should eq([mock_addon])
    end
  end

  describe "GET show" do
    it "assigns the requested addon as @addon" do
      Addon.stub(:find).with("37") { mock_addon }
      get :show, :id => "37"
      assigns(:addon).should be(mock_addon)
    end
  end

  describe "GET new" do
    it "assigns a new addon as @addon" do
      Addon.stub(:new) { mock_addon }
      get :new
      assigns(:addon).should be(mock_addon)
    end
  end

  describe "GET edit" do
    it "assigns the requested addon as @addon" do
      Addon.stub(:find).with("37") { mock_addon }
      get :edit, :id => "37"
      assigns(:addon).should be(mock_addon)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created addon as @addon" do
        Addon.stub(:new).with({'these' => 'params'}) { mock_addon(:save => true) }
        post :create, :addon => {'these' => 'params'}
        assigns(:addon).should be(mock_addon)
      end

      it "redirects to the created addon" do
        Addon.stub(:new) { mock_addon(:save => true) }
        post :create, :addon => {}
        response.should redirect_to(admin_addon_url(mock_addon))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved addon as @addon" do
        Addon.stub(:new).with({'these' => 'params'}) { mock_addon(:save => false) }
        post :create, :addon => {'these' => 'params'}
        assigns(:addon).should be(mock_addon)
      end

      it "re-renders the 'new' template" do
        Addon.stub(:new) { mock_addon(:save => false) }
        post :create, :addon => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested addon" do
        Addon.should_receive(:find).with("37") { mock_addon }
        mock_addon.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :addon => {'these' => 'params'}
      end

      it "assigns the requested addon as @addon" do
        Addon.stub(:find) { mock_addon(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:addon).should be(mock_addon)
      end

      it "redirects to the addon" do
        Addon.stub(:find) { mock_addon(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_addon_url(mock_addon))
      end
    end

    describe "with invalid params" do
      it "assigns the addon as @addon" do
        Addon.stub(:find) { mock_addon(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:addon).should be(mock_addon)
      end

      it "re-renders the 'edit' template" do
        Addon.stub(:find) { mock_addon(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested addon" do
      Addon.should_receive(:find).with("37") { mock_addon }
      mock_addon.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the admin/addons list" do
      Addon.stub(:find) { mock_addon }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_addons_url)
    end
  end

end
