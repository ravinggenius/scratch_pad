require 'spec_helper'

describe "admin/terms/index.html.haml" do
  before(:each) do
    assign(:terms, [
      stub_model(Term),
      stub_model(Term)
    ])
  end

  it "renders a list of terms" do
    render
  end
end
