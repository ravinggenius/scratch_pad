require 'spec_helper'

describe "admin/terms/edit.html.haml" do
  before(:each) do
    @term = assign(:term, stub_model(Term))
  end

  it "renders the edit term form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => term_path(@term), :method => "post" do
    end
  end
end
