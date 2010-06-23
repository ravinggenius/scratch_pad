class SessionsController < ApplicationController
  def new
    @user = @user_klass.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
    end
  end

  def create
    @user = @user_klass.first :username => params[:user][:username]

    respond_to do |format|
      if @user && (@user.password == params[:user][:password])
        @user_klass.current = @user
        format.html { redirect_to(root_url, :notice => 'You have successfully signed in.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_klass.current = @user_klass.anonymous

    respond_to do |format|
      format.html { redirect_to(root_url) }
      format.xml  { head :ok }
    end
  end
end
