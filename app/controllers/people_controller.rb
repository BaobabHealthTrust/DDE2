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
            outcome_date: outcome_date, outcome_date_estimated: outcome_date_estimated)
        else
          outcome_record = Outcome.create(outcome: params[:outcome]['outcome'], person: person.id, 
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
            outcome_date: outcome_date, outcome_date_estimated: outcome_date_estimated)
        else
          outcome_record = Outcome.create(outcome: params[:outcome]['outcome'], person: person.id, 
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
    primary_person_national_id = params["person"]["_id"]
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
  
  #################################### Village listinng APIs ends ##############################
end
