class LoginsController < ApplicationController
  skip_before_filter :perform_basic_auth,
      :only => :logout

  layout 'login'

  def show
    # render
  end

  def create
    username = params[:user][:username]
    password = params[:user][:password]
    user = Utils::UserUtil.get_active_user(username)
    if user and user.password_matches?(password)
      login! user
      redirect_to back_or_default
    else
      flash[:error] = 'That username and/or password was not valid.'
      render :action => 'show'
    end
  end

  def logout
    logout!
    flash[:notice] = 'You have been logged out. Good Bye!'
    redirect_to :action => 'show', referrer_param => referrer_path
  end

  protected

  def default_path
    people_path
  end

  def perform_basic_auth
    authorize! :access, :login
  end

  def access_denied
    redirect_to default_path
  end
end
