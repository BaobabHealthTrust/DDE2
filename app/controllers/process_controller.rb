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
		
		json = params[:person] rescue {}
		
		@json = json.to_json
		
		@results = []
		
		if @json.class.to_s.downcase.strip != "string"
			
			@json = @json.to_json
		
		end
		
		target = params[:target]
		
		target = "update" if target.blank?
		
		if !@json.blank?
			@results = Utils::UPerson.confirmed_person_to_create_or_update_or_select(@json, target)
		end
		
		render :text => @results.to_json
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
		
		data = JSON.parse(params["data"]) rescue {}
		
		merged = data["Identifiers"]["Merged"] rescue nil
		
		render :json => {error: "Merge data not available"} and return if merged.nil?
		
		voided_npid = Npid.find_by_national_id(merged["National ID"]) rescue nil
		
		render :json => {error: "Merge target not found"} and return if voided_npid.nil?
		
		voided_npid_original_site = voided_npid.site_code
		
		voided_npid_result = voided_npid.update_attributes(site_code: "???") rescue nil
		
		if voided_npid_result.nil?
			
			voided_npid.update_attributes(site_code: voided_npid_original_site) rescue nil
			
			render :json => {error: "Merge target void failed"} and return
		
		end
		
		voided_person = Person.find_by__id(merged["National ID"]) rescue nil
		
		if voided_person.nil?
			
			voided_npid.update_attributes(site_code: voided_npid_original_site) rescue nil
			
			render :json => {error: "Merge target not found"} and return
		
		end
		
		voided_person_original_site = voided_person.assigned_site
		
		voided_person_result = voided_person.update_attributes(assigned_site: "???") rescue nil
		
		if voided_person_result.nil?
			
			voided_npid.update_attributes(site_code: voided_npid_original_site) rescue nil
			
			voided_person.update_attributes(assigned_site: voided_person_original_site) rescue nil
			
			render :json => {error: "Merge target person void failed"} and return
		
		end
		
		person = Person.find_by__id(data["Identifiers"]["National ID"]) rescue nil
		
		if person.nil?
			
			voided_npid.update_attributes(site_code: voided_npid_original_site) rescue nil
			
			voided_person.update_attributes(assigned_site: voided_person_original_site) rescue nil
			
			render :json => {error: "Merge source person not found"} and return
		
		end
		
		person["patient"]["identifiers"] << {"Old Identification Number" => merged["National ID"]}
		
		merged["Identifiers"].each do |id|
			
			person["patient"]["identifiers"] << id
		
		end rescue nil
		
		fields = [
				"Given Name",
				"Middle Name",
				"Family Name",
				"Gender",
				"Birthdate",
				"Birthdate Estimated",
				"Current Village",
				"Current T/A",
				"Current District",
				"Home Village",
				"Home T/A",
				"Home District",
				"Occupation",
				"Home Phone Number",
				"Cell Phone Number",
				"Office Phone Number",
				"Citizenship",
				"Race"
		]
		
		fields.each do |field|
			
			case field
				when "Given Name"
					person["names"]["given_name"] = data[field]
					person["names"]["given_name_code"] = data[field].soundex
				
				when "Middle Name"
					person["names"]["middle_name"] = data[field]
				
				when "Family Name"
					person["names"]["family_name"] = data[field]
					person["names"]["family_name_code"] = data[field].soundex
				
				when "Gender"
					person["gender"] = data[field][0] rescue nil
				
				when "Birthdate"
					person["birthdate"] = data[field]
				
				when "Birthdate Estimated"
					person["birthdate_estimated"] = data[field]
				
				when "Current Village"
					person["addresses"]["current_village"] = data[field]
				
				when "Current T/A"
					person["addresses"]["current_ta"] = data[field]
				
				when "Current District"
					person["addresses"]["current_district"] = data[field]
				
				when "Home Village"
					person["addresses"]["home_village"] = data[field]
				
				when "Home T/A"
					person["addresses"]["home_ta"] = data[field]
				
				when "Home District"
					person["addresses"]["home_district"] = data[field]
				
				when "Occupation"
					person["person_attributes"]["occupation"] = data[field]
				
				when "Home Phone Number"
					person["person_attributes"]["home_phone_number"] = data[field]
				
				when "Cell Phone Number"
					person["person_attributes"]["cell_phone_number"] = data[field]
				
				when "Office Phone Number"
					person["person_attributes"]["office_phone_number"] = data[field]
				
				when "Citizenship"
					person["person_attributes"]["citizenship"] = data[field]
				
				when "Race"
					person["person_attributes"]["race"] = data[field]
			
			end
		
		end
		
		person.save
		
		render :json => {success: "OK"} and return
	
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
