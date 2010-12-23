class Admin::TermsController < Admin::ApplicationController
  before_filter do
    @vocabulary = Vocabulary.find params[:vocabulary_id]
  end

  def index
    @terms = @vocabulary.terms

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @terms }
    end
  end

  def new
    @term = Term.new

    respond_to do |format|
      format.html { render 'shared/edit_new' }
      format.xml  { render :xml => @term }
    end
  end

  def edit
    @term = @vocabulary.terms.find(params[:id])
    render 'shared/edit_new'
  end

  def create
    @term = Term.new(params[:term].merge(:vocabulary => @vocabulary))

    respond_to do |format|
      if @term.save
        format.html { redirect_to(admin_vocabulary_terms_url(@vocabulary), :notice => 'Term was successfully created.') }
        format.xml  { render :xml => @term, :status => :created, :location => [:admin, @vocabulary, @term] }
      else
        format.html { render :action => 'shared/edit_new', :error => @term.errors.full_messages }
        format.xml  { render :xml => @term.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @term = @vocabulary.terms.find(params[:id])

    respond_to do |format|
      if @term.update_attributes(params[:term])
        format.html { redirect_to(admin_vocabulary_terms_url(@vocabulary), :notice => 'Term was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => 'shared/edit_new', :error => @term.errors.full_messages }
        format.xml  { render :xml => @term.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @term = @vocabulary.terms.find(params[:id])
    @term.destroy

    respond_to do |format|
      format.html { redirect_to(admin_vocabulary_terms_url) }
      format.xml  { head :ok }
    end
  end
end
