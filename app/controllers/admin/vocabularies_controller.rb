class Admin::VocabulariesController < Admin::ApplicationController
  def index
    @vocabularies = Vocabulary.all

    respond_to do |format|
      format.html
      format.xml { render :xml => @vocabularies }
    end
  end

  def new
    @vocabulary = Vocabulary.new
    set_fieldset_ivars

    respond_to do |format|
      format.html { render 'shared/edit_new' }
      format.xml { render :xml => @vocabulary }
    end
  end

  def edit
    @vocabulary = Vocabulary.find(params[:id])
    set_fieldset_ivars
    render 'shared/edit_new'
  end

  def create
    @vocabulary = Vocabulary.new(params[:vocabulary])

    respond_to do |format|
      if @vocabulary.save
        format.html { redirect_to(admin_vocabularies_url, :notice => 'vocabulary was successfully created.') }
        format.xml { render :xml => @vocabulary, :status => :created, :location => [:admin, @vocabulary] }
      else
        set_fieldset_ivars
        format.html do
          flash[:error] = @vocabulary.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @vocabulary.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @vocabulary = Vocabulary.find(params[:id])

    respond_to do |format|
      if @vocabulary.update_attributes(params[:vocabulary])
        format.html { redirect_to(admin_vocabularies_url, :notice => 'vocabulary was successfully updated.') }
        format.xml { head :ok }
      else
        set_fieldset_ivars
        format.html do
          flash[:error] = @vocabulary.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @vocabulary.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @vocabulary = Vocabulary.find(params[:id])
    @vocabulary.destroy

    respond_to do |format|
      format.html { redirect_to(admin_vocabularies_url) }
      format.xml { head :ok }
    end
  end

  private

  def set_fieldset_ivars
    @node_extensions_optional = NodeExtension.all.map { |ne| [ne.name, ne.machine_name] }
    @node_extensions_optional_selected = @vocabulary.node_types_optional.map { |ne| ne.machine_name }
    @node_extensions_required = NodeExtension.all.map { |ne| [ne.name, ne.machine_name] }
    @node_extensions_required_selected = @vocabulary.node_types_required.map { |ne| ne.machine_name }
  end
end
