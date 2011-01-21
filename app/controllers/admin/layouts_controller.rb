class Admin::LayoutsController < Admin::ApplicationController
  def edit
    @theme = ScratchPad::Addon::Theme[params[:theme_id]]
    @layout = @theme.layout params[:id]
    @widgets = ScratchPad::Addon::Widget.enabled.sort

    respond_to do |format|
      format.html
      format.xml  { render :xml => @widgets }
    end
  end

  def update
    @theme = ScratchPad::Addon::Theme[params[:theme_id]]
    @layout = @theme.layout params[:id]

    params[:regions].each do |region_name, widget_names|
      region = @layout.region region_name
      region.widgets = []
      widget_names.each do |widget_name|
        next if widget_name.blank?
        region.widgets << ScratchPad::Addon::Widget[widget_name]
      end
    end

    respond_to do |format|
      if @layout.save
        format.html { redirect_to(admin_themes_url, :notice => 'Layout was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => edit_admin_theme_layout_url(@theme.machine_name, @layout) }
        format.xml  { render :xml => [], :status => :unprocessable_entity }
      end
    end
  end
end
