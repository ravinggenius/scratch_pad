class Admin::UsersController < Admin::ApplicationController
  # GET /admin/users
  # GET /admin/users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @users }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html { render 'shared/edit_new' }
      format.xml { render :xml => @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
    @user = User.find(params[:id])
    render 'shared/edit_new'
  end

  # POST /admin/users
  # POST /admin/users.xml
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

  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    @user = User.find(params[:id])

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

  # DELETE /admin/users/1
  # DELETE /admin/users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
      format.xml { head :ok }
    end
  end
end
