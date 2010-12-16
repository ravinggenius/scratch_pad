class SessionsController < ApplicationController
  def new
    @user = User.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @user }
    end
  end

  def create
    @user = User.first :username => params[:user][:username]

    respond_to do |format|
      if @user && !@user.is_locked? && (@user.password == params[:user][:password])
        self.current_user = @user
        format.html { redirect_to(root_url, :notice => 'You have successfully signed in.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        message = if @user && @user.is_locked?
          'Your account has been locked. Please contact a site administrator for assistance.'
        else
          'You supplied an incorrect username or password.'
        end
        format.html { render :action => 'new', :error => message }
        format.xml { render :xml => message, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    self.current_user = User.anonymous

    respond_to do |format|
      format.html { redirect_to(root_url) }
      format.xml { head :ok }
    end
  end
end
