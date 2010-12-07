require 'spec_helper'

describe Admin::WidgetsController do

  def mock_widget(stubs={})
    (@mock_widget ||= mock_model(Widget).as_null_object).tap do |widget|
      widget.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all widgets as @widgets" do
      Widget.stub(:all) { [mock_widget] }
      get :index
      assigns(:widgets).should eq([mock_widget])
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested widget" do
        Widget.should_receive(:find).with("37") { mock_widget }
        mock_widget.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :widget => {'these' => 'params'}
      end

      it "assigns the requested widget as @widget" do
        Widget.stub(:find) { mock_widget(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:widget).should be(mock_widget)
      end

      it "redirects to the widget" do
        Widget.stub(:find) { mock_widget(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_widget_url(mock_widget))
      end
    end

    describe "with invalid params" do
      it "assigns the widget as @widget" do
        Widget.stub(:find) { mock_widget(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:widget).should be(mock_widget)
      end

      it "re-renders the 'edit' template" do
        Widget.stub(:find) { mock_widget(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end
end
