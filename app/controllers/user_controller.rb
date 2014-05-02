class UserController < ApplicationController
  def login
    if request.post?
      user = User.find params[:user]["username"]
      if user and user.password_matches?(params[:user]["password"])
        session[:user_id] = user.id
        redirect_to "/"
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
    a = params
    user = Utils::UserUtil.create(params)
    if user
      redirect_to '/user/view' 
    else
     redirect_to '/user/new'
    end
  end

  def new
  end

  def username_availability
    user = nil #User.where("username = ?",params[:search_str])
    render :text => user = user.blank? ? 'available' : 'not available' and return
  end

end
