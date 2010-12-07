class Admin::AddonsController < Admin::ApplicationController
  def index
    addon = params[:addon].to_s.to_sym
    addon = [
      :filter,
      :node_extension,
      :theme,
      :widget
    ].include?(addon) ? AddonBase[addon] : AddonBase

    @addons = {}
    [
      Filter,
      NodeExtension,
      Theme,
      Widget
    ].each do |addon_type|
      @addons[addon_type] = addon_type.all if addon_type.ancestors.include? addon
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
