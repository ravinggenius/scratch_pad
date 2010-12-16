class Admin::AddonsController < Admin::ApplicationController
  def index
    @addons = {}
    AddonBase.addon_types.each do |addon_type|
      @addons[addon_type] = addon_type.all if addon_type.ancestors.include? addon_scope
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @addons }
    end
  end

  def update
    addon_scope.all_by_type.each do |addon_type, addons|
      type_name = addon_type.machine_name
      next unless params[type_name]

      addons.each do |addon|
        if addon.enabled? && !params[type_name][addon.machine_name]
          addon.disable
          Rails.logger.info "#{addon} disabled"
        elsif addon.disabled? && params[type_name][addon.machine_name]
          addon.enable
          Rails.logger.info "#{addon} enabled"
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to(admin_addons_url, :notice => 'Addons were successfully updated.') }
      format.xml  { head :ok }
    end
  end

  private

  def addon_scope
    types = AddonBase.addon_types.map { |addon_type| addon_type.machine_name }
    types.include?(params[:addon_type]) ? AddonBase[params[:addon_type]] : AddonBase
  end
end
