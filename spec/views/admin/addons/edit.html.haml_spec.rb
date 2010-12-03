require 'spec_helper'

describe "admin/addons/edit.html.haml" do
  before(:each) do
    @addon = assign(:addon, stub_model(Addon))
  end

  it "renders the edit addon form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_addon_path(@addon), :method => "post" do
    end
  end
end
