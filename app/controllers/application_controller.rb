class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery	with: :null_session

  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
                                                                                
  before_filter :perform_basic_auth

  rescue_from CanCan::AccessDenied,
      :with => :access_denied

  helper_method :current_user
                    
  protected                                                                     
                              
  def login!(user)
    session[:current_user_id] = user.id
    @current_user = user
  end

  def logout!
    session[:current_user_id] = nil
    @current_user = nil
  end

  def current_user
    unless @current_user == false # meaning a user has previously been established as not logged in
      @current_user ||= authenticate_from_session || authenticate_from_basic_auth || false
      User.current_user = @current_user
    end
  end

  def authenticate_from_basic_auth
    authenticate_with_http_basic do |user_name, password|
      user = Utils::UserUtil.get_active_user(user_name)
      if user and user.password_matches?(password)
        return user
      else
        return false
      end
    end
  end

  def authenticate_from_session
    unless session[:current_user_id].blank?
      user = Utils::UserUtil.get_active_user(session[:current_user_id])
      return user
    end
  end

  def perform_basic_auth
    authorize! :access, :anything
  end

  def access_denied
    respond_to do |format|
      format.html { redirect_to login_path(referrer_param => current_path) }
      format.any  { head :unauthorized }
    end
  end

end
