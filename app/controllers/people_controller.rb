class PeopleController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
    @person = Person.new(
      				 :national_id => Npid.unassigned_at_site.first.national_id,
							 :assigned_site =>  Site.current_code,
							 :patient_assigned => true,

               :npid => {
                        	:value => Npid.unassigned_at_site.first.national_id
               				  },

							 :person_attributes => { :citizenship => params[:person]["data"]["attributes"]["citizenship"] || nil,
																			 :occupation => params[:person]["data"]["attributes"]["occupation"] || nil,
																			 :home_phone_number => params[:person]["data"]["attributes"]["home_phone_number"] || nil,
																			 :cell_phone_number => params[:person]["data"]["attributes"]["cell_phone_number"] || nil,
																			 :race => params[:person]["data"]["attributes"]["race"] || nil
										                  },

								:gender => params[:person]["data"]["gender"],

								:names => { :given_name => params[:person]["data"]["names"]["given_name"],
							 					    :family_name => params[:person]["data"]["names"]["family_name"]
										      },

								:birthdate => params[:person]["data"]["birthdate"] || nil,
								:birthdate_estimated => params[:person]["data"]["birthdate_estimated"] || nil,

								:addresses => {:current_residence => params[:person]["data"]["addresses"]["city_village"] || nil,
												       :current_village => params[:person]["data"]["addresses"]["city_village"] || nil,
												       :current_ta => params[:person]["data"]["addresses"]["state_province"] || nil,
												       :current_district => params[:person]["data"]["addresses"]["state_province"] || nil,
												       :home_village => params[:person]["data"]["addresses"]["neighbourhood_cell"] || nil,
												       :home_ta => params[:person]["data"]["addresses"]["county_district"] || nil,
												       :home_district => params[:person]["data"]["addresses"]["address2"] || nil
                              }
		 )
      npid =  Npid.by__national_id.key(@person.national_id).first
        raise npid.inspect
        npid.assigned = true
        npid.save
    respond_to do |format|
      if @person.save
        npid =  Npid.by__national_id.key(@person.national_id).first
        raise npid.inspect
        npid.assigned = true
        npid.save
        
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
end
