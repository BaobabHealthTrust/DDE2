class PeopleController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create

    @person = Person.new()

    @person.national_id = ""
    @person.assigned_site =  Site.current_id 
    @person.patient_assigned = true
    @person.person_attributes.citizenship = params[:person]["data"]["attributes"]["citizenship"] rescue nil
    @person.person_attributes.occupation = params[:person]["data"]["attributes"]["occupation"] rescue nil
    @person.person_attributes.home_phone_number = params[:person]["data"]["attributes"]["home_phone_number"] rescue nil
    @person.person_attributes.cell_phone_number = params[:person]["data"]["attributes"]["cell_phone_number"] rescue nil
    @person.person_attributes.race = params[:person]["data"]["attributes"]["race"] rescue nil
    @person.gender = params[:person]["data"]["gender"]
    @person.names.given_name = params[:person]["data"]["names"]["given_name"]
    @person.names.family_name = params[:person]["data"]["names"]["family_name"]
    @person.birthdate = params[:person]["data"]["birthdate"] rescue nil
    @person.birthdate_estimated = params[:person]["data"]["birthdate_estimated"] rescue nil
    @person.addresses.current_residence = params[:person]["data"]["addresses"]["address1"] rescue nil
    @person.addresses.current_village = params[:person]["data"]["addresses"]["addresses"] rescue nil
    @person.addresses.current_ta = params[:person]["data"]["addresses"]["state_province"] rescue nil
    @person.addresses.current_district = params[:person]["data"]["addresses"]["county_district"] rescue nil
    @person.addresses.home_village = params[:person]["data"]["addresses"]["neighborhood_cell"] rescue nil
    @person.addresses.home_ta = params[:person]["data"]["addresses"]["city_village"] rescue nil
    @person.addresses.home_district = params[:person]["data"]["addresses"]["current_district"] rescue nil

    respond_to do |format|
      if @person.save
        format.html { redirect_to(@person, :notice => 'Person was successfully created.') }
        format.xml  { render :xml  => @person, :status => :created, :location => @person }
        format.json { render :json => @person, :status => :created, :location => @person }
      else
        status = @person.errors.delete(:status) || :unprocessable_entity

        format.html { render :action => 'new' }
        format.xml  { render :xml  => @person.errors, :status => status }
        format.json { render :json => @person.errors, :status => status }
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
    @matching_records = params[:found_records]
  end
end
