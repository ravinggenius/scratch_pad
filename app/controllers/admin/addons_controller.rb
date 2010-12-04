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

  def update
    Addon.delete_all

    [
      :filter,
      :node_extension,
      :theme,
      :widget
    ].each do |addon_type|
      params[addon_type].each do |addon, is_enabled|
        Addon.first_or_create :name => AddonBase[addon].name
      end
    end

    respond_to do |format|
      format.html { redirect_to(admin_addons_url, :notice => 'Addons were successfully updated.') }
      format.xml  { head :ok }
    end
  end
end
