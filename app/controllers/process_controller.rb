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
    
    if @json.class.to_s.downcase.strip != "string"
    
      @json = @json.to_json
    
    end
    
    if !@json.blank?
      @results = Utils::UPerson.process_person_data(@json, (params[:page].to_i rescue 1), (!params[:pagesize].blank? ? params[:pagesize].to_i : 10))
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
    
    if @json.class.to_s.downcase.strip != "string"
    
      @json = @json.to_json
    
    end
    
    target = params[:target]
    
    target = "update" if target.blank?
    
    if !@json.blank?    
      @results = Utils::UPerson.confirmed_person_to_create_or_update_or_select(@json, target)
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
  
  def merge_duplicates
  
    # {"data"=>{"Office Phone Number"=>"", "Citizenship"=>"", "Home District"=>"", "Race"=>"", "Cell Phone Number"=>"", "Birthdate Estimated"=>"0", "Birthdate"=>"1993/07/05", "Given Name"=>"John", "Home Phone Number"=>"", "Gender"=>"Male", "Home T/A"=>"", "Current Village"=>"", "Home Village"=>"", "Current T/A"=>"", "Family Name"=>"Banda", "Middle Name"=>"", "Occupation"=>"", "Current District"=>"", "Identifiers"=>{"Merged"=>{"National ID"=>"0003EG"}, "National ID"=>"0002FM"}}}
  
    merged = params["data"]["Identifiers"]["Merged"] rescue nil
  
    render :text => false and return if merged.nil?
  
    voided_npid = Npid.find_by_national_id(merged["National ID"]) rescue nil
    
    render :text => false and return if voided_npid.nil?
    
    voided_npid_original_site = voided_npid.site_code
    
    voided_npid_result = voided_npid.update_attributes(site_code: "???") rescue nil
    
    if voided_npid_result.nil?
    
      voided_npid.update_attributes(site_code: voided_npid_original_site) rescue nil
    
      render :text => false and return
    
    end
    
    voided_person = Person.find_by__id(merged["National ID"]) rescue nil
    
    if voided_person.nil?
    
      voided_npid.update_attributes(site_code: voided_npid_original_site) rescue nil
    
      render :text => false and return
    
    end
    
    voided_person_original_site = voided_person.assigned_site
    
    voided_person_result = voided_person.update_attributes(assigned_site: "???") rescue nil
    
    if voided_person_result.nil?
    
      voided_npid.update_attributes(site_code: voided_npid_original_site) rescue nil
      
      voided_person.update_attributes(assigned_site: voided_person_original_site) rescue nil
    
      render :text => false and return
    
    end
    
    person = Person.find_by__id(params["data"]["Identifiers"]["National ID"]) rescue nil
  
    if person.nil?
    
      voided_npid.update_attributes(site_code: voided_npid_original_site) rescue nil
      
      voided_person.update_attributes(assigned_site: voided_person_original_site) rescue nil
    
      render :text => false and return
    
    end
    
    person["patient"]["identifiers"] << {"Old Identification Number" => merged["National ID"]}
    
    merged["Identifiers"].each do |id|
    
      person["patient"]["identifiers"] << id
    
    end rescue nil
    
    render :text => true and return
    
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
