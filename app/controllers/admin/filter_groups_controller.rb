class Admin::FilterGroupsController < Admin::ApplicationController
  before_filter :only => [:create, :update] do
    params[:filter_group][:filters].reject! { |filter_name| filter_name.blank? }
  end

  def index
    @filter_groups = FilterGroup.all

    respond_to do |format|
      format.html
      format.xml { render :xml => @filter_groups }
    end
  end

  def show
    @filter_group = FilterGroup.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render :xml => @filter_group }
    end
  end

  def new
    @filter_group = FilterGroup.new
    @filters = Filter.enabled

    respond_to do |format|
      format.html { render 'shared/edit_new' }
      format.xml { render :xml => @filter_group }
    end
  end

  def edit
    @filter_group = FilterGroup.find(params[:id])
    @filters = Filter.enabled
    render 'shared/edit_new'
  end

  def create
    @filter_group = FilterGroup.new(params[:filter_group])

    respond_to do |format|
      if @filter_group.save
        format.html { redirect_to([:admin, @filter_group], :notice => 'FilterGroup was successfully created.') }
        format.xml { render :xml => @filter_group, :status => :created, :location => [:admin, @filter_group] }
      else
        format.html do
          flash[:error] = @filter_group.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @filter_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @filter_group = FilterGroup.find(params[:id])

    respond_to do |format|
      if @filter_group.update_attributes(params[:filter_group])
        format.html { redirect_to([:admin, @filter_group], :notice => 'FilterGroup was successfully updated.') }
        format.xml { head :ok }
      else
        format.html do
          flash[:error] = @filter_group.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @filter_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @filter_group = FilterGroup.find(params[:id])
    @filter_group.destroy

    respond_to do |format|
      format.html { redirect_to(admin_filters_url) }
      format.xml { head :ok }
    end
  end
end
