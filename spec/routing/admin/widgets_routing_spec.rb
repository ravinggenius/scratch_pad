require "spec_helper"

describe Admin::WidgetsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/widgets" }.should route_to(:controller => "admin/widgets", :action => "index")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/widgets/1" }.should route_to(:controller => "admin/widgets", :action => "update", :id => "1")
    end

  end
end
