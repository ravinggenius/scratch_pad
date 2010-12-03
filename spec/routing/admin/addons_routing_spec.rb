require "spec_helper"

describe Admin::AddonsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/addons" }.should route_to(:controller => "admin/addons", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/addons/new" }.should route_to(:controller => "admin/addons", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/addons/1" }.should route_to(:controller => "admin/addons", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/addons/1/edit" }.should route_to(:controller => "admin/addons", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/addons" }.should route_to(:controller => "admin/addons", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/addons/1" }.should route_to(:controller => "admin/addons", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/addons/1" }.should route_to(:controller => "admin/addons", :action => "destroy", :id => "1")
    end

  end
end
