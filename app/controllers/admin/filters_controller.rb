class Admin::FiltersController < Admin::ApplicationController
  # GET /admin/filters
  # GET /admin/filters.xml
  def index
    @filter_groups = FilterGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @filter_groups }
    end
  end

  # GET /admin/filters/1
  # GET /admin/filters/1.xml
  def show
    @filter = Filter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @filter }
    end
  end

  # GET /admin/filters/new
  # GET /admin/filters/new.xml
  def new
    @filter = Filter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @filter }
    end
  end

  # GET /admin/filters/1/edit
  def edit
    @filter = Filter.find(params[:id])
  end

  # POST /admin/filters
  # POST /admin/filters.xml
  def create
    @filter = Filter.new(params[:admin_filter])

    respond_to do |format|
      if @filter.save
        format.html { redirect_to(@filter, :notice => 'Filter was successfully created.') }
        format.xml  { render :xml => @filter, :status => :created, :location => @filter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/filters/1
  # PUT /admin/filters/1.xml
  def update
    @filter = Filter.find(params[:id])

    respond_to do |format|
      if @filter.update_attributes(params[:admin_filter])
        format.html { redirect_to(@filter, :notice => 'Filter was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/filters/1
  # DELETE /admin/filters/1.xml
  def destroy
    @filter = Filter.find(params[:id])
    @filter.destroy

    respond_to do |format|
      format.html { redirect_to(admin_filters_url) }
      format.xml  { head :ok }
    end
  end
end
