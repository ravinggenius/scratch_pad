class Admin::ThemesController < Admin::ApplicationController
  def index
    scope = params[:scope].to_s.to_sym
    scope = [:frontend, :backend].include?(scope) ? scope : :enabled

    @themes = {}
    @current_theme = {}
    [:frontend, :backend].each do |s|
      @themes[s] = ScratchPad::Addon::Theme.send s if [s, :enabled].include?(scope)
      @current_theme[s] = ScratchPad::Addon::Theme[Setting[:theme, s]]
    end

    respond_to do |format|
      format.html
      format.xml { render :xml => @themes }
    end
  end

  def update
    theme = ScratchPad::Addon::Theme[params[:frontend] || params[:backend]]

    setting = Setting.first_in_scope :theme, params[:scope]

    respond_to do |format|
      if setting.update_attributes :value => theme.machine_name
        format.html { redirect_to(admin_themes_url, :notice => "#{theme.title} was set as #{params[:scope]} theme.") }
        format.xml  { head :ok }
      else
        format.html { redirect_to(admin_themes_url, :error => setting.errors.full_messages) }
        format.xml { render :xml => setting.errors, :status => :unprocessable_entity }
      end
    end
  end
end
