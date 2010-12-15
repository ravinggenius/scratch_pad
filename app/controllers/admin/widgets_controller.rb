class Admin::WidgetsController < Admin::ApplicationController
  def index
    @widgets = Widget.enabled
    @themes = Theme.enabled

    respond_to do |format|
      format.html
      format.xml  { render :xml => @widgets }
    end
  end

  def update
    theme = Theme[params[:theme]]

    params[theme.machine_name].each do |layout_name, regions|
      layout = theme.layouts.first { |l| l.name == layout_name }
      layout.regions = regions.map do |region_name, widgets|
        widgets = widgets.reject { |name| name.blank? }.map { |widget_name| Widget[widget_name] }
        { :name => region_name, :widgets => widgets }
      end
      layout.save
    end

    respond_to do |format|
      if true
        format.html { redirect_to(admin_widgets_url, :notice => 'Layout was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => admin_widgets_url }
        format.xml  { render :xml => [], :status => :unprocessable_entity }
      end
    end
  end
end
