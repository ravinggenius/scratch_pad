require 'spec_helper'

describe "admin/widgets/index.html.haml" do
  before(:each) do
    assign(:widgets, [
      stub_model(Widget),
      stub_model(Widget)
    ])
  end

  it "renders a list of widgets" do
    render
  end
end
