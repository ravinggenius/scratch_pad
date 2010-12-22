require 'spec_helper'

describe "admin/terms/new.html.haml" do
  before(:each) do
    assign(:term, stub_model(Term).as_new_record)
  end

  it "renders new term form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_terms_path, :method => "post" do
    end
  end
end
