class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.html
      format.xml { render :xml => @users }
    end
  end

  def show
    @user = User.from_param(params[:id])

    respond_to do |format|
      format.html
      format.xml { render :xml => @user }
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html { render 'shared/edit_new' }
      format.xml { render :xml => @user }
    end
  end

  def edit
    @user = User.from_param(params[:id])
    render 'shared/edit_new'
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to([:admin, @user], :notice => 'User was successfully created.') }
        format.xml { render :xml => @user, :status => :created, :location => [:admin, @user] }
      else
        format.html do
          flash[:error] = @user.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.from_param(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to([:admin, @user], :notice => 'User was successfully updated.') }
        format.xml { head :ok }
      else
        format.html do
          flash[:error] = @user.errors.full_messages
          render 'shared/edit_new'
        end
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.from_param(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
      format.xml { head :ok }
    end
  end
end
