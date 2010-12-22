require "spec_helper"

describe Admin::TermsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/terms" }.should route_to(:controller => "admin/terms", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/terms/new" }.should route_to(:controller => "admin/terms", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/terms/1" }.should route_to(:controller => "admin/terms", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/terms/1/edit" }.should route_to(:controller => "admin/terms", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/terms" }.should route_to(:controller => "admin/terms", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/terms/1" }.should route_to(:controller => "admin/terms", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/terms/1" }.should route_to(:controller => "admin/terms", :action => "destroy", :id => "1")
    end

  end
end
