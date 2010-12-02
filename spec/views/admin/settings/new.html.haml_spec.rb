require 'spec_helper'

describe "admin/settings/new.html.haml" do
  before(:each) do
    assign(:setting, stub_model(Setting).as_new_record)
  end

  it "renders new setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_settings_path, :method => "post" do
    end
  end
end
