class UserController < ApplicationController
  def login
    if request.post?
      user = Utils::UserUtil.get_active_user(params[:user]["username"])
      if user and user.password_matches?(params[:user]["password"])
        session[:user_id] = user.username
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
    user = Utils::UserUtil.get_active_user(params[:search_str])
    render :text => user = user.blank? ? 'available' : 'not available' and return
  end

  def edit
    Utils::UserUtil.edit(params)
    redirect_to '/user/settings'
  end

  def settings
    if params[:id]
      if params[:id] == 'users'
        @users = User.active_users
        @partial = params[:id]
      elsif params[:id] == 'delete'
        u = User.find params[:username]   
        #instead of u.destroy() we just mark the user inactive
        u.active = false
        u.save
        @users = User.active_users
        @partial = 'users'
      elsif params[:id] == 'newuser'
        @partial = 'newuser'
      elsif params[:id] == 'editpassword'
        @partial = 'editpassword'
      elsif params[:id] == 'edit'
        @partial = 'edit'
        @user = Utils::UserUtil.get_active_user(params[:username])
      else
        @partial = 'users'
        @users = User.active_users
      end
    else
      @partial = 'users'
      @users = User.active_users
    end
  end

end
