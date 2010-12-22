require 'spec_helper'

describe Admin::TermsController do

  def mock_term(stubs={})
    (@mock_term ||= mock_model(Term).as_null_object).tap do |term|
      term.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all terms as @terms" do
      Term.stub(:all) { [mock_term] }
      get :index
      assigns(:terms).should eq([mock_term])
    end
  end

  describe "GET show" do
    it "assigns the requested term as @term" do
      Term.stub(:find).with("37") { mock_term }
      get :show, :id => "37"
      assigns(:term).should be(mock_term)
    end
  end

  describe "GET new" do
    it "assigns a new term as @term" do
      Term.stub(:new) { mock_term }
      get :new
      assigns(:term).should be(mock_term)
    end
  end

  describe "GET edit" do
    it "assigns the requested term as @term" do
      Term.stub(:find).with("37") { mock_term }
      get :edit, :id => "37"
      assigns(:term).should be(mock_term)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created term as @term" do
        Term.stub(:new).with({'these' => 'params'}) { mock_term(:save => true) }
        post :create, :term => {'these' => 'params'}
        assigns(:term).should be(mock_term)
      end

      it "redirects to the created term" do
        Term.stub(:new) { mock_term(:save => true) }
        post :create, :term => {}
        response.should redirect_to(admin_term_url(mock_term))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved term as @term" do
        Term.stub(:new).with({'these' => 'params'}) { mock_term(:save => false) }
        post :create, :term => {'these' => 'params'}
        assigns(:term).should be(mock_term)
      end

      it "re-renders the 'new' template" do
        Term.stub(:new) { mock_term(:save => false) }
        post :create, :term => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested term" do
        Term.should_receive(:find).with("37") { mock_term }
        mock_term.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :term => {'these' => 'params'}
      end

      it "assigns the requested term as @term" do
        Term.stub(:find) { mock_term(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:term).should be(mock_term)
      end

      it "redirects to the term" do
        Term.stub(:find) { mock_term(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_term_url(mock_term))
      end
    end

    describe "with invalid params" do
      it "assigns the term as @term" do
        Term.stub(:find) { mock_term(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:term).should be(mock_term)
      end

      it "re-renders the 'edit' template" do
        Term.stub(:find) { mock_term(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested term" do
      Term.should_receive(:find).with("37") { mock_term }
      mock_term.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the admin terms list" do
      Term.stub(:find) { mock_term }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_terms_url)
    end
  end

end
