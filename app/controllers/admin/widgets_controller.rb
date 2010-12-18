class Admin::WidgetsController < Admin::ApplicationController
  def index
    @widgets = Widget.enabled

    if params[:theme]
      @themes = [ Theme[params[:theme]] ]
      @layout = Theme[params[:theme]].layout(params[:layout]) if params[:layout]
    else
      @themes = Theme.enabled
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @widgets }
    end
  end

  def update
    @theme = Theme[params[:theme]]
    @layout = @theme.layout params[:layout]

    params[:regions].each do |region_name, widget_names|
      widget_names.each do |widget_name|
        next if widget_name.blank?
        @layout.region(region_name).widgets << Widget[widget_name]
      end
    end

    respond_to do |format|
      if @layout.save
        format.html { redirect_to(admin_widgets_url, :notice => 'Layout was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => admin_widgets_url }
        format.xml  { render :xml => [], :status => :unprocessable_entity }
      end
    end
  end
end
