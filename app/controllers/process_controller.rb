class ProcessController < ActionController::Base  # ApplicationController
  
  before_filter :check_login

  def process_data
    if Rails.env == "development" and false
    
      params[:person] = "{\"national_id\":\"\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":[\"P1700000011\",\"KCH20140503083423\",\"000000\"]},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}"
      
    end
    
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
      @results = Utils::UPerson.process_person_data(@json.to_json, (params[:page].to_i rescue 1))
    end
    
    render :text => @results.to_json
  end

  def search
    if Rails.env == "development" and false
    
      params[:person] = "{\"national_id\":\"P1700000011\",\"application\":\"test\",\"site_code\":\"TST\",\"names\":{\"family_name\":\"Test\",\"given_name\":\"Test\"},\"gender\":\"M\",\"attributes\":{\"occupation\":\"\",\"cell_phone_number\":\"\"},\"birthdate\":\"2000-01-01\",\"patient\":{\"identifiers\":[\"P1700000011\",\"KCH20140503083423\"]},\"birthdate_estimated\":0,\"addresses\":{\"current_residence\":null,\"current_village\":null,\"current_ta\":null,\"current_district\":null,\"home_village\":null,\"home_ta\":null,\"home_district\":null}}"
      
    end
    
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
        render :action => request.fullpath and return
      else
        flash[:error] = 'That username and/or password was not valid.'
        
        redirect_to "/user/login" and return
      end
    
    end
  end
end
