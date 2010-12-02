require 'spec_helper'

describe "admin/settings/show.html.haml" do
  before(:each) do
    @setting = assign(:setting, stub_model(Setting))
  end

  it "renders attributes in <p>" do
    render
  end
end
