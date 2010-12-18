require 'spec_helper'

describe "admin/layouts/index.html.haml" do
  before(:each) do
    assign(:layouts, [
      stub_model(Layout),
      stub_model(Layout)
    ])
  end

  it "renders a list of layouts" do
    render
  end
end
