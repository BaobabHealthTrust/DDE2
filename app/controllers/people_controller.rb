class PeopleController < ApplicationController
	
	def find
		json = JSON.parse(params.to_json)
		json = json.delete_if { |k, v| v.empty? }
		@people = Utils::PersonUtil.process_person_data(json.to_json)
		if @people.blank?
			respond_to do |format|
				format.json { render :json => {}.to_json }
			end
		else
			respond_to do |format|
				format.json { render :json => @people}
			end
		end
	
	end
	
	def create
		@person = Utils::PersonUtil.process_person_data(params.to_json)
		@person_hash = JSON.parse(@person.to_json)
		@npid_hash = {npid: {value: @person_hash["_id"]}}
		@person_hash.merge!@npid_hash
		
		if @person_hash
			respond_to do |format|
				format.json { render :json => @person_hash, :status => :created, :location => @person_hash }
			end
		end
	end
	
	def create_footprint
		json = params
		footprint = Utils::FootprintUtil.log_application_and_site(json) if params
		render :text => footprint.to_s and return
	end
	
	def confirm_demographics
		@matching_records = Utils::PersonUtil.confirm_person_to_update(params)
		render :layout => false
	end
	
	def update_person
		Utils::PersonUtil.process_person_data(params)
	end
	
	def find_demographics
		
		params["action"] = "check_similarities"
		people = Utils::PersonUtil.process_person_data(params.to_json)
		birthdate = (params["person"]["data"]["birth_year"] +"-"+ params["person"]["data"]["birth_month"] +
				"-"+params["person"]["data"]["birth_day"] ).to_date rescue ""
		case people.size
			when 0
				result = {}
			when 1
				person = Person.find(people.first.id)
				result = person unless !((person.birthdate >=  (birthdate - 5.years)) && (person.birthdate <=  (birthdate + 5.years))) rescue false
			else
				result = []
				(people || []).each do |person_hash|
					person_obj =  Person.find(person_hash.id)
					result << person_obj unless !((person_obj.birthdate >=  (birthdate - 5.years)) && (person_obj.birthdate <=  (birthdate + 5.years))) rescue false
				end
		end
		
		respond_to do |format|
			format.json { render :json => result.to_json}
			format.xml  { render :xml  => result }
		end
	end
	
	def update_demographics
		@matching_records = Utils::PersonUtil.confirm_person_to_update(params.to_json)
		render :action =>"confirm_demographics" , :layout => false
	end
	
	#################################### Village listinng APIs starts ##############################
	def population_stats
		if params[:stat] == 'current_district_ta_parameter'
			
			month = params[:month_period]
			year = Date.today.year
			
			month_to_i = Date::MONTHNAMES.index(month).to_i
			month_beginning = Date.new(year, month_to_i)
			month_ending = month_beginning.end_of_month

			start_date = month_beginning.strftime('%Y-%m-%d')
			end_date = month_ending.strftime('%Y-%m-%d')
			
			district = params[:district]
			ta = params[:ta]
			parameter = params[:parameter]
			data = []
			
			if parameter == 'deaths'
				Outcome.all.each do |outcome|
					person = Person.find_by__id(outcome['person'])
					outcome['person_record'] = person
					if outcome['outcome_date'].to_datetime.strftime('%F') >= start_date && outcome['outcome_date'].to_datetime.strftime('%F') <= end_date
						data << outcome
					end
				end
			elsif parameter == 'births'
				start_date = month_beginning.strftime('%Y/%-m/%d')
				end_date = month_ending.strftime('%Y/%-m/%d')
				
				Person.by_birthdate.startkey(start_date).endkey(end_date).each do |outcome|
					person = Person.find_by__id(outcome['_id'])
					outcome['person_record'] = person
					data << outcome
				end
			end
			
			render :text => data.to_json and return
		end
		
		if params[:stat] == 'current_district_ta_village_outcome_cause'
			district = params[:district] ; ta = params[:ta] ; village = params[:village] ; outcome = params[:outcome]
			data = []
			
			Outcome.all.each do |outcome|
				person = Person.find_by__id(outcome['person'])
				outcome['person_record'] = person
				if outcome['outcome_date'].to_datetime.strftime('%F') >= '2016-04-01' && outcome['outcome_date'].to_datetime.strftime('%F') <= '2017-03-31'
					data << outcome
				end
			end
			
			render :text => data.to_json and return
		end
		
		if params[:stat] == 'current_district_ta_village'
			district = params[:district] ; ta = params[:ta] ; village = params[:village]
=begin
      data = []
      Person.current_district_ta_village.key([district,ta,village]).all.each do |person|
        outcome_record = Outcome.find_by_person(person['_id'])
        person['outcome'] = outcome_record.outcome rescue nil
        person['outcome_date'] = outcome.outcome_date rescue nil
        data << person
      end
      render :text => data.to_json and return
=end
			data = Person.current_district_ta_village.key([district,ta,village]).all.each
			render :text => data.to_json and return
		end
		
		if params[:stat] == 'current_village_outcomes'
			district = params[:district] ; ta = params[:ta] ; village = params[:village]
			data = Person.current_district_ta_village.key([district,ta,village]).all.each
			people_ids = data.map(&:id)
			outcomes = Outcome.by_person.keys(people_ids).each
			transfer_out_data = Outcome.by_from_district_and_from_ta_and_from_village.key([district,ta,village]).each
			
			died = 0 ; transfer_out = 0
			(outcomes || []).each do |outcome|
				died += 1 if outcome['outcome'] == 'Died'
			end
			
			(transfer_out_data || []).each do |outcome|
				next if people_ids.include?(outcome.person)
				transfer_out += 1
			end
			
			alive = (data.count - (died + transfer_out))
			render :text => { alive: alive, transfer_out: transfer_out , died: died }.to_json and return
		end
		
		if params[:stat] == 'bloomberg_union'
			month = params[:month_period]
			month_to_i = Date::MONTHNAMES.index(month).to_i
			
			year = Date.today.year
			district = params[:district] ; ta = params[:ta]
			data = Person.current_district_ta.key([district,ta]).all.each
			people_ids = data.map(&:id)
			outcome_cause = Outcome.by_person.keys(people_ids).each
			
			start_day = "#{year}/#{month_to_i}/01"
			end_day = "#{year}/#{month_to_i}/31"
			
			month_births = Person.by_birthdate.startkey(start_day).endkey(end_day).all.each
			
			births = month_births.count
			deaths = 0
			overall_deaths = 0
	
			(outcome_cause || []).each do |outcome|
				deaths += 1 if outcome['outcome_date'].to_date.month.to_i == month_to_i && outcome['outcome_date'].to_date.year.to_i == year
				overall_deaths += 1
			end
			
			render :text => { deaths: deaths,
			                  births: births,
			                  total_census: (data.count - overall_deaths),
			}.to_json and return
		end
		
		if params[:stat] == 'current_death_outcomes'
			district = params[:district] ; ta = params[:ta] ; village = params[:village]
			data = Person.current_district_ta_village.key([district,ta,village]).all.each
			people_ids = data.map(&:id)
			outcome_cause = Outcome.by_person.keys(people_ids).each
			
			unknown = 0;
			ngozi = 0;
			adadzipha = 0;
			adaphedwa = 0;
			anadwala_kwa_nthawi_yochepa_mwezi_sunakwane = 0;
			anadwala_kwa_nthawi_yayitali_kudutsa_mwezi = 0
			
			(outcome_cause || []).each do |outcome|
				unknown += 1 if outcome['outcome_cause'] == '' || outcome['outcome_cause'].nil?
				ngozi += 1 if outcome['outcome_cause'] == 'Ngozi'
				adadzipha += 1 if outcome['outcome_cause'] == 'Adadzipha'
				adaphedwa += 1 if outcome['outcome_cause'] == 'Adaphedwa'
				if outcome['outcome_cause'] == 'Anadwala kwa nthawi yayitali (kudutsa mwezi)'
					anadwala_kwa_nthawi_yayitali_kudutsa_mwezi += 1
				end
				if outcome['outcome_cause'] == 'Anadwala kwa nthawi yochepa (mwezi sunakwane)'
					anadwala_kwa_nthawi_yochepa_mwezi_sunakwane += 1
				end
			end
			
			render :text => { unknown: unknown,
			                  ngozi: ngozi,
			                  adadzipha: adadzipha,
			                  adaphedwa: adaphedwa,
			                  anadwala_kwa_nthawi_yochepa_mwezi_sunakwane: anadwala_kwa_nthawi_yochepa_mwezi_sunakwane,
			                  anadwala_kwa_nthawi_yayitali_kudutsa_mwezi: anadwala_kwa_nthawi_yayitali_kudutsa_mwezi
			}.to_json and return
		end
		
		if params[:stat] == 'home_district_ta_village'
			district = params[:district] ; ta = params[:ta] ; village = params[:village]
			data = Person.home_district_ta_village.key([district,ta,village]).all.each
			render :text => data.to_json and return
		end
		
		if params[:stat] == 'ta_population_tabulation'
			district = params[:district] ; ta = params[:ta]
			data = Person.current_district_ta.key([district,ta]).all.each
			render :text => data.to_json and return
		end
		
		if params[:stat] == 'ta_population'
			district = params[:district]
			data = Person.current_district.key([district]).each
			render :text => data.to_json and return
		end
		
		if params[:stat] == 'update_outcome'
			person = Person.find(params[:identifier])
			if person.blank?
				render :text => [].to_json and return
			end
			
			outcome_record = Outcome.find_by_person(person.id)
			outcome_date = Date.today ; outcome_date_estimated = false
			
			year = params[:outcome]['year'] ; month = params[:outcome]['month'] ; day = params[:outcome]['day']
			if year != 'Unknown' and month == 'Unknown'
				outcome_date = "#{year}/7/15".to_date
				outcome_date_estimated = true
			elsif year != 'Unknown' and month != 'Unknown' and day == 'Unknown'
				outcome_date = "#{year}/#{month}/1".to_date
				outcome_date_estimated = true
			elsif year == 'Unknown'
				outcome_date = "1900/1/1".to_date
				outcome_date_estimated = true
			else
				outcome_date = "#{year}/#{month}/#{day}".to_date
			end
			
			if outcome_record.blank?
				if params[:outcome]['outcome'] == 'Died'
					outcome_record = Outcome.create(outcome: params[:outcome]['outcome'], person: person.id,
					                                outcome_cause: params[:outcome]['cause_of_death'],
					                                outcome_date: outcome_date, outcome_date_estimated: outcome_date_estimated)
				else
					outcome_record = Outcome.create(outcome: params[:outcome]['outcome'], person: person.id,
					                                outcome_cause: params[:outcome]['cause_of_death'],
					                                outcome_date: outcome_date, outcome_date_estimated: outcome_date_estimated,
					                                to_district: params[:outcome]['transfering_location']['district'],
					                                to_ta: params[:outcome]['transfering_location']['ta'],
					                                to_village: params[:outcome]['transfering_location']['village'],
					                                from_district: person.addresses.current_district,
					                                from_ta: person.addresses.current_ta,
					                                from_village: person.addresses.current_village)
					
					person.addresses.current_district = outcome_record.to_district
					person.addresses.current_ta = outcome_record.to_ta
					person.addresses.current_village = outcome_record.to_village
					person.save
				end
			else
				if params[:outcome]['outcome'] == 'Died'
					outcome_record.update_attributes(outcome: params[:outcome]['outcome'],
					                                 outcome_cause: params[:outcome]['cause_of_death'],
					                                 outcome_date: outcome_date, outcome_date_estimated: outcome_date_estimated)
				else
					outcome_record = Outcome.create(outcome: params[:outcome]['outcome'], person: person.id,
					                                outcome_cause: params[:outcome]['cause_of_death'],
					                                outcome_date: outcome_date, outcome_date_estimated: outcome_date_estimated,
					                                to_district: params[:outcome]['transfering_location']['district'],
					                                to_ta: params[:outcome]['transfering_location']['ta'],
					                                to_village: params[:outcome]['transfering_location']['village'],
					                                from_district: person.addresses.current_district,
					                                from_ta: person.addresses.current_ta,
					                                from_village: person.addresses.current_village)
					
					person.addresses.current_district = outcome_record.to_district
					person.addresses.current_ta = outcome_record.to_ta
					person.addresses.current_village = outcome_record.to_village
					person.save
				end
			end
			render :text => { person: person, outcome_data: outcome_record }.to_json and return
		end
		
		if params[:stat] == 'fetch_outcome'
			person = Person.find(params[:identifier])
			if person.blank?
				render :text => [].to_json and return
			end
			
			outcome_record = Outcome.find_by_person(person.id)
			if outcome_record.blank?
				render :text => [].to_json and return
			else
				render :text => {person: person, outcome_data: outcome_record}.to_json and return
			end
		end
	
	end
	
	def person_names
		if params[:name] == 'given_name'
			names = []
			Person.given_name_code.keys([[params[:given_name].soundex]]).all.each.map do |person|
				names << person.names.given_name
				names = names.uniq
			end
			render :text => names.to_json and return
		elsif params[:name] == 'family_name'
			names = []
			Person.family_name_code.keys([[params[:family_name].soundex]]).all.each.map do |person|
				names << person.names.family_name
				names = names.uniq
			end
			render :text => names.to_json and return
		end
	end
	
	
	def create_relation
		relationship_type = params["people"]["relationship_type"]
		site_code = params["people"]["site_code"]
		primary_person_national_id = (params["people"]["primary"]["_id"] || params["people"]["primary"]["national_id"])
		secondary_person_national_id = (params["people"]["secondary"]["national_id"] || params["people"]["secondary"]["_id"])
		relation_status = Relationship.create_relation(primary_person_national_id, secondary_person_national_id, relationship_type, site_code)
		render :text => relation_status and return
	end
	
	def retrieve_relations
		primary_person_national_id = (params["person"]["_id"] || params["person"]["national_id"])
		people = Relationship.relations(primary_person_national_id)
		render :text => people.to_json and return
	end
	
	def person_relations
		national_id = params["national_id"]
		person_relations = Relationship.get_person_relations(national_id)
		render :text => person_relations.to_json and return
	end
	
	def add_place_of_birth
		national_id = params["person"]["national_id"]
		place_of_birth = params["person"]["place_of_birth"]
		outcome = Outcome.add_place_of_birth(national_id, place_of_birth)
		render :text => outcome.to_json and return
	end
	
	def retrieve_place_of_birth
		national_id = params["national_id"]
		place_of_birth = Outcome.retrieve_place_of_birth(national_id)
		render :text => place_of_birth and return
	end
	
	def retrieve_births
		m = params[:date].to_date.strftime("%m").to_i
		birth_date = params[:date].to_date.strftime("%Y/#{m}/%d").gsub(/\s+/, '') rescue params[:date]
		people = Person.by_birthdate.key(birth_date).all.each
		render :text => people.to_json and return
	end
	
	def census
		
		villages = params[:villages] || []
		data = {}
		(villages || []).each do |location|
			district, ta, village = location.split("__")
			next if district.blank? || ta.blank? || village.blank?
			
			data["#{location}"] = Person.current_district_ta_village.key([district.humanize, ta.humanize, village.humanize]).each.count
		end
		
		render :text => data.to_json and return
	end
	
	def retrieve_births_month
		
		start = params[:start_date].to_date
		endd = params[:end_date].to_date
		people = []
		(start .. endd).each do |date|
			m = date.to_date.strftime("%m").to_i
			d = date.strftime("%Y/#{m}/%d").gsub(/\s+/, '')
			people_on_date = Person.by_birthdate.key("#{d}").all.each.to_a
			if people_on_date.count > 0
				people += people_on_date
			end
		end
		
		#startdate = params[:start_date].to_date.strftime("%Y/#{m}/%d").gsub(/\s+/, '')
		#enddate = params[:end_date].to_date.strftime("%Y/%#{m}/%d").gsub(/\s+/, '')
		#people = Person.by_birthdate.startkey("#{startdate}").endkey("#{enddate}").all.each
		render :text => people.to_json and return
	end
	
	def retrieve_deaths_month
		m = params[:start_date].to_date.strftime("%m").to_i
		startdate = params[:start_date].to_date.strftime("%Y-%m-%d")
		enddate = params[:end_date].to_date.strftime("%Y-%m-%d")
		outcomes = Outcome.by_outcome_date.startkey("#{startdate}").endkey("#{enddate}").each.collect{|c|
			Person.find(c.person) if c.outcome == "Died" and c.created_at.to_date == Date.today
		}.compact.uniq
		
		render :text => outcomes.to_json and return
	end
	
	#################################### Village listing APIs ends ##############################
end
