class UserController < ApplicationController
  def login
    if request.post?
      user = Utils::UserUtil.get_active_user(params[:user]["username"])
      if user and user.password_matches?(params[:user]["password"])
        session[:user_id] = user.username
        flash[:error] = nil
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
    user = Utils::UserUtil.create(params) rescue nil?
    if not user.blank?
      redirect_to '/user/settings'
    else
      flash[:error] = "Failed to create user"
      
      redirect_to '/user/settings?id=newuser' 
    end
  end

  def new
  end

  def username_availability
    user = Utils::UserUtil.get_active_user(params[:search_str])
    render :text => user = user.blank? ? 'available' : 'not available' and return
  end

  def edit    
    user = Utils::UserUtil.get_active_user(params[:user]["username"])
    if user and user.password_matches?(params[:user]["password"])
      flash[:error] = "Wrong old password!"
      
      redirect_to '/' and return
    end
        
    result = Utils::UserUtil.edit(params) rescue nil
    
    if result.nil?
      flash[:error] = "Failed to change password!"
    else
      flash[:notice] = "Password change successiful"
    end
    
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
      elsif params[:id] == 'add_site'
        @partial = 'add_site'
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
