class Admin::TemplatesController < Admin::ApplicationController
  # GET /admin/templates
  # GET /admin/templates.xml
  def index
    @templates = Template.regular
    @admin_templates = Template.admin

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @templates }
    end
  end

  # GET /admin/templates/1
  # GET /admin/templates/1.xml
  def show
    @template = Template.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @template }
    end
  end

  # GET /admin/templates/new
  # GET /admin/templates/new.xml
  def new
    @template = Template.new

    respond_to do |format|
      format.html { render 'shared/edit_new' }
      format.xml { render :xml => @template }
    end
  end

  # GET /admin/templates/1/edit
  def edit
    @template = Template.find(params[:id])
    render 'shared/edit_new'
  end

  # POST /admin/templates
  # POST /admin/templates.xml
  def create
    @template = Template.new(params[:admin_template])

    respond_to do |format|
      if @template.save
        format.html { redirect_to([:admin, @template], :notice => 'Template was successfully created.') }
        format.xml { render :xml => @template, :status => :created, :location => [:admin, @template] }
      else
        format.html do
          flash[:error] = @template.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/templates/1
  # PUT /admin/templates/1.xml
  def update
    @template = Template.find(params[:id])

    respond_to do |format|
      if @template.update_attributes(params[:template])
        format.html { redirect_to([:admin, @template], :notice => 'Template was successfully updated.') }
        format.xml { head :ok }
      else
        format.html do
          flash[:error] = @template.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/templates/1
  # DELETE /admin/templates/1.xml
  def destroy
    @template = Template.find(params[:id])
    @template.destroy

    respond_to do |format|
      format.html { redirect_to(admin_templates_url) }
      format.xml { head :ok }
    end
  end
end
