class Admin::ThemesController < Admin::ApplicationController
  def index
    @themes = Theme.regular
    @admin_themes = Theme.admin

    respond_to do |format|
      format.html
      format.xml { render :xml => @themes }
    end
  end

  def show
    @theme = Theme.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render :xml => @theme }
    end
  end

  def new
    @theme = Theme.new

    respond_to do |format|
      format.html { render 'shared/edit_new' }
      format.xml { render :xml => @theme }
    end
  end

  def edit
    @theme = Theme.find(params[:id])
    render 'shared/edit_new'
  end

  def create
    @theme = Theme.new(params[:admin_theme])

    respond_to do |format|
      if @theme.save
        format.html { redirect_to([:admin, @theme], :notice => 'Theme was successfully created.') }
        format.xml { render :xml => @theme, :status => :created, :location => [:admin, @theme] }
      else
        format.html do
          flash[:error] = @theme.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @theme.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @theme = Theme.find(params[:id])

    respond_to do |format|
      if @theme.update_attributes(params[:theme])
        format.html { redirect_to([:admin, @theme], :notice => 'Theme was successfully updated.') }
        format.xml { head :ok }
      else
        format.html do
          flash[:error] = @theme.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @theme.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy

    respond_to do |format|
      format.html { redirect_to(admin_themes_url) }
      format.xml { head :ok }
    end
  end
end
