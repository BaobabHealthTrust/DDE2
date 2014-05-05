class UserController < ApplicationController
  def login
    if request.post?
      user = User.find params[:user]["username"]
      if user and user.password_matches?(params[:user]["password"])
        session_data[:user_id] = user.username
        redirect_to "/" and return
      else
        flash[:error] = 'That username and/or password was not valid.'
      end
    else
      reset_session
    end

  end

  def logout
    redirect_to '/user/login' 
  end

  def create
    user = Utils::UserUtil.create(params)
    if not user.blank?
      redirect_to '/user/settings'
    else
      redirect_to '/user/view' 
    end
  end

  def new
  end

  def username_availability
    user = User.find params[:search_str]
    render :text => user = user.blank? ? 'available' : 'not available' and return
  end

  def settings
    if params[:id]
      if params[:id] == 'users'
        @users = User.all
        @partial = params[:id]
      elsif params[:id] == 'delete'
        u = User.find params[:username]   
        u.destroy()
        @users = User.all
        @partial = 'users'
      elsif params[:id] == 'newuser'
        @partial = 'newuser'
      end
    else
      @partial = 'users'
      @users = User.all
    end
  end

end
