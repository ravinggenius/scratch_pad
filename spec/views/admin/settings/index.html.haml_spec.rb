require 'spec_helper'

describe "admin/settings/index.html.haml" do
  before(:each) do
    assign(:settings, [
      stub_model(Setting),
      stub_model(Setting)
    ])
  end

  it "renders a list of settings" do
    render
  end
end
