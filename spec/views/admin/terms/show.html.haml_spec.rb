require 'spec_helper'

describe "admin/terms/show.html.haml" do
  before(:each) do
    @term = assign(:term, stub_model(Term))
  end

  it "renders attributes in <p>" do
    render
  end
end
