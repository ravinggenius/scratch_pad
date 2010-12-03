class Admin::AddonsController < ApplicationController
  def index
    @addons = Addon.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @addons }
    end
  end

  def show
    @addon = Addon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @addon }
    end
  end

  def new
    @addon = Addon.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @addon }
    end
  end

  def edit
    @addon = Addon.find(params[:id])
  end

  def create
    @addon = Addon.new(params[:addon])

    respond_to do |format|
      if @addon.save
        format.html { redirect_to(@addon, :notice => 'Addon was successfully created.') }
        format.xml  { render :xml => @addon, :status => :created, :location => @addon }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @addon.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @addon = Addon.find(params[:id])

    respond_to do |format|
      if @addon.update_attributes(params[:addon])
        format.html { redirect_to(@addon, :notice => 'Addon was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @addon.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @addon = Addon.find(params[:id])
    @addon.destroy

    respond_to do |format|
      format.html { redirect_to(admin_addons_url) }
      format.xml  { head :ok }
    end
  end
end
