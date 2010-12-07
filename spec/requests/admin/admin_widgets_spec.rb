require 'spec_helper'

describe "Admin::Widgets" do
  describe "GET /admin/widgets" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get admin_widgets_path
      response.status.should be(200)
    end
  end
end
