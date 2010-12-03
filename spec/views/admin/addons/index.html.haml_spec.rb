require 'spec_helper'

describe "admin/addons/index.html.haml" do
  before(:each) do
    assign(:addons, [
      stub_model(Addon),
      stub_model(Addon)
    ])
  end

  it "renders a list of admin/addons" do
    render
  end
end
