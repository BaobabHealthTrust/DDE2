class PeopleController < ApplicationController

  def find
   Utils::PersonUtil.process_person_data(params.to_json)
    respond_to do |format|
        format.json { render :json   => {}.to_json }
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
            format.html { redirect_to(@person_hash, :notice => 'Person was successfully created.') }
            format.xml  { render :xml  => @person_hash, :status => :created, :location => @person_hash }
            format.json { render :json => @person_hash, :status => :created, :location => @person_hash }
        end
      end    
  end

  def edit

  end

  def update

  end

  def destroy
  end

  def confirm_demographics
    @matching_records = Person.all.collect{|x| x}

  end
end
