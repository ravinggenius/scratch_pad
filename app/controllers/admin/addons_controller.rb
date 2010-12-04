class Admin::AddonsController < Admin::ApplicationController
  def index
    @addons = {}
    [
      Filter,
      NodeExtension,
      Theme,
      Widget
    ].each do |addon|
      @addons[addon] = addon.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @addons }
    end
  end

  # TODO :disable needs to be called instead of Addon.delete_all
  def update
    Addon.delete_all

    [
      :filter,
      :node_extension,
      :theme,
      :widget
    ].each do |addon_type|
      (params[addon_type] || {}).each { |addon_name, one| AddonBase[addon_name].enable }
    end

    respond_to do |format|
      format.html { redirect_to(admin_addons_url, :notice => 'Addons were successfully updated.') }
      format.xml  { head :ok }
    end
  end
end
