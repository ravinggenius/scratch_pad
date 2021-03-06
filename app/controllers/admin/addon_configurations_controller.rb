class Admin::AddonConfigurationsController < Admin::ApplicationController
  def index
    @addons = {}
    ScratchPad::Addon::Base.addon_types.each do |addon_type|
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
        elsif addon.disabled? && params[type_name][addon.machine_name]
          addon.enable
        end
      end
    end

    respond_to do |format|
      # TODO find out why :addon_type is never set
      format.html { redirect_to(admin_addon_configurations_url(params[:addon_type]), :notice => 'Addons were successfully updated.') }
      format.xml  { head :ok }
    end
  end

  private

  def addon_scope
    types = ScratchPad::Addon::Base.addon_types.map &:machine_name
    types.include?(params[:addon_type]) ? ScratchPad::Addon::Base[params[:addon_type]] : ScratchPad::Addon::Base
  end
end
