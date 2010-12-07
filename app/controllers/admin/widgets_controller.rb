class Admin::WidgetsController < Admin::ApplicationController
  def index
    @widgets = Widget.enabled

    respond_to do |format|
      format.html
      format.xml  { render :xml => @widgets }
    end
  end

  def update
    respond_to do |format|
      if @widget.update_attributes(params[:widget])
        format.html { redirect_to(@widget, :notice => 'Widget was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => admin_widgets_url }
        format.xml  { render :xml => @widget.errors, :status => :unprocessable_entity }
      end
    end
  end
end
