class Admin::SettingsController < ApplicationController
  # GET /admin/settings
  # GET /admin/settings.xml
  def index
    @settings = Setting.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @settings }
    end
  end

  # GET /admin/settings/1
  # GET /admin/settings/1.xml
  def show
    @setting = Setting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @setting }
    end
  end

  # GET /admin/settings/new
  # GET /admin/settings/new.xml
  def new
    @setting = Setting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @setting }
    end
  end

  # GET /admin/settings/1/edit
  def edit
    @setting = Setting.find(params[:id])
  end

  # POST /admin/settings
  # POST /admin/settings.xml
  def create
    @setting = Setting.new(params[:setting])

    respond_to do |format|
      if @setting.save
        format.html { redirect_to(@setting, :notice => 'Setting was successfully created.') }
        format.xml  { render :xml => @setting, :status => :created, :location => @setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/settings/1
  # PUT /admin/settings/1.xml
  def update
    @setting = Setting.find(params[:id])

    respond_to do |format|
      if @setting.update_attributes(params[:setting])
        format.html { redirect_to(@setting, :notice => 'Setting was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/settings/1
  # DELETE /admin/settings/1.xml
  def destroy
    @setting = Setting.find(params[:id])
    @setting.destroy

    respond_to do |format|
      format.html { redirect_to(settings_url) }
      format.xml  { head :ok }
    end
  end
end
