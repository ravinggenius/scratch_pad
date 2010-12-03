require 'spec_helper'

describe "admin/addons/show.html.haml" do
  before(:each) do
    @addon = assign(:addon, stub_model(Addon))
  end

  it "renders attributes in <p>" do
    render
  end
end
