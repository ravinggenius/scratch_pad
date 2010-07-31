class Admin::VocabulariesController < Admin::ApplicationController
  # GET /admin/vocabularies
  # GET /admin/vocabularies.xml
  def index
    @vocabularies = Vocabulary.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vocabularies }
    end
  end

  # GET /admin/vocabularies/1
  # GET /admin/vocabularies/1.xml
  def show
    @vocabulary = Vocabulary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vocabulary }
    end
  end

  # GET /admin/vocabularies/new
  # GET /admin/vocabularies/new.xml
  def new
    @vocabulary = Vocabulary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vocabulary }
    end 
  end

  # GET /admin/vocabularies/1/edit
  def edit
    @vocabulary = Vocabulary.find(params[:id])
  end

  # POST /admin/vocabularies
  # POST /admin/vocabularies.xml
  def create
    @vocabulary = Vocabulary.new(params[:admin_vocabulary])

    respond_to do |format|
      if @vocabulary.save
        format.html { redirect_to(@vocabulary, :notice => 'vocabulary was successfully created.') }
        format.xml  { render :xml => @vocabulary, :status => :created, :location => @vocabulary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vocabulary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/vocabularies/1
  # PUT /admin/vocabularies/1.xml
  def update
    @vocabulary = Vocabulary.find(params[:id])

    respond_to do |format|
      if @vocabulary.update_attributes(params[:admin_vocabulary])
        format.html { redirect_to(@vocabulary, :notice => 'vocabulary was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vocabulary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/vocabularies/1
  # DELETE /admin/vocabularies/1.xml
  def destroy
    @vocabulary = Vocabulary.find(params[:id])
    @vocabulary.destroy

    respond_to do |format|
      format.html { redirect_to(admin_vocabularies_url) }
      format.xml  { head :ok }
    end
  end
end
