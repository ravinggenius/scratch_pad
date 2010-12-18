require 'spec_helper'

describe Admin::LayoutsController do

  def mock_layout(stubs={})
    (@mock_layout ||= mock_model(Layout).as_null_object).tap do |layout|
      layout.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all layouts as @layouts" do
      Layout.stub(:all) { [mock_layout] }
      get :index
      assigns(:layouts).should eq([mock_layout])
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested layout" do
        Layout.should_receive(:find).with("37") { mock_layout }
        mock_layout.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :layout => {'these' => 'params'}
      end

      it "assigns the requested layout as @layout" do
        Layout.stub(:find) { mock_layout(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:layout).should be(mock_layout)
      end

      it "redirects to the layout" do
        Layout.stub(:find) { mock_layout(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_layout_url(mock_layout))
      end
    end

    describe "with invalid params" do
      it "assigns the layout as @layout" do
        Layout.stub(:find) { mock_layout(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:layout).should be(mock_layout)
      end

      it "re-renders the 'edit' template" do
        Layout.stub(:find) { mock_layout(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end
end
