require "spec_helper"

describe Admin::LayoutsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/layouts" }.should route_to(:controller => "admin/layouts", :action => "index")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/layouts/1" }.should route_to(:controller => "admin/layouts", :action => "update", :id => "1")
    end

  end
end
