require 'spec_helper'

describe "admin/addons/new.html.haml" do
  before(:each) do
    assign(:addon, stub_model(Addon).as_new_record)
  end

  it "renders new addon form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_addons_path, :method => "post" do
    end
  end
end
