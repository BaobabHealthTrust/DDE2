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

  def index

  end

  def show
  end

  def new
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

  def edit

  end

  def update

  end

  def destroy
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
    case people.size
      when 0
        result = {}.to_json
      when 1
        person = Person.find(people.first.id)
        result = person
      else
        result = people.collect{|x| Person.find(x.id)}
    end
    respond_to do |format|
      format.json { render :json => result}
      format.xml  { render :xml  => result }
    end
  end
end
