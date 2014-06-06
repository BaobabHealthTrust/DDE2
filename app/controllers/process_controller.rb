class ProcessController < ActionController::Base  # ApplicationController
  
  before_filter :check_login  
  
  def process_data
    
    @json = JSON.parse(params[:person]) rescue {}
    
    @results = []
    
    if !@json.blank?
      @results = Utils::UPerson.process_person_data(params[:person], 1)
    end
    
    render :layout => "ts"
  end

  def ajax_process_data
    
    @json = params[:person] rescue {}
    
    @results = []
    
    if !@json.blank?
      @results = Utils::UPerson.process_person_data(@json.to_json, (params[:page].to_i rescue 1), (!params[:pagesize].blank? ? params[:pagesize].to_i : 10))
    end
    
    render :text => @results.to_json
  end

  def search
    
    @json = JSON.parse(params[:person]) rescue {}
    
    @results = []
    
    if !@json.blank?
      @results = Utils::UPerson.search_by_npid(params[:person], 1)
    end
    
    render :layout => "ts"    
  end
  
  def process_confirmation
    
    @json = params[:person] rescue {}
    
    @results = []
    
    target = params[:target]
    
    target = "update" if target.blank?
    
    if !@json.blank?    
      @results = Utils::UPerson.confirmed_person_to_create_or_update_or_select(@json.to_json, target)
    end
    
    render :text => @results    # .to_json
  end
  
  def lost 
    raise params.inspect
    render :layout => "ts"     
  end
                            
  def login!(user)
    session[:current_user_id] = user.id
    @@current_user = user
  end

  def logout!
    session[:current_user_id] = nil
    @@current_user = nil
  end

  def ajax_log
    
    @json = params[:person] rescue {}
    
    @results = []
    
    if !@json.blank?
      @results = Utils::UPerson.log_footprint(@json.to_json)
    end
    
    render :text => @results.to_json
  end
  
  protected

  def check_login
    if session[:current_user_id].blank?
      authenticate
    end
  end

  def authenticate
    
    authenticate_or_request_with_http_basic do |username, password|
    
      user = Utils::UserUtil.get_active_user(username)
      
      if user and user.password_matches?(password)
        login! user
        # render :action => request.fullpath and return
      else
        flash[:error] = 'That username and/or password was not valid.'
        
        redirect_to "/user/login" and return
      end
    
    end
  end
  

end
