class SessionsController < ApplicationController
  # GET /sessions/new
  # GET /sessions/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /sessions
  # POST /sessions.xml
  def create
    @user = User.first(:username => params[:user][:username])

    respond_to do |format|
      if @user.verify_password params[:user][:password]
        User.current = @user
        format.html { redirect_to(root_url, :notice => 'Session was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.xml
  def destroy
    User.current = User.anonymous

    respond_to do |format|
      format.html { redirect_to(root_url) }
      format.xml  { head :ok }
    end
  end
end
