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

    npid = params["value"] rescue nil
    application = params["application_name"] rescue nil
    site = params["site"] rescue nil

    footprint = Utils::FootprintUtil.log_application_and_site(npid, application, site) if params
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

end
