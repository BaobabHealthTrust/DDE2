module Utils

  class PersonUtil
  
=begin
  + process_person_data(JSON):JSON
  
  
=end
    def self.process_person_data(json)
    
      raise "First argument can only be a JSON Object" unless !(JSON.parse(json) rescue nil).nil?
     #check if json object is whole person data or just person national id 
     unless json[:value].blank?
       #person data
       npid = json[:value]
       if self.person_has_v4_id(json)
         self.get_person(npid)
       else
         self.get_person(npid)
       end
     else
       #person national_id
       found = self.get_person(npid)
       unless found.blank?
         #record footprint
         Utils::FootprintUtil.log_application_and_site(json)
         
       else
         #inform user no match found
       end
     end
      
    end


=begin
  + search_by_npid(npid:String):Array(JSON)
  
  
=end
    def self.search_by_npid(json)
       npid = json[:value]
       return  self.get_person(npid)       
    end


   private
=begin
  + person_has_v4_id(JSON):BOOLEAN
  
  
=end
    def self.person_has_v4_id(json)

       unless json[:value].blank?
           return true if json[:value].length == 6
			 end

       return false

    end
   
=begin
  + search_for_person_by_params(
      first_name:String,
      last_name:String,
      gender:String,
      date_of_birth:String(OPTIONAL),
      home_t_a:String(OPTIONAL),
      home_district:String(OPTIONAL)
    ):JSON
  
  
=end
    def self.search_for_person_by_params(first_name, gender, date_of_birth=nil, home_t_a=nil, home_district=nil)
    
    end
  
=begin
  + confirm_person_to_update(JSON):Array(JSON)
  
  
=end
    def self.confirm_person_to_update(json)
    
    end
   
=begin
  + create_person(JSON):BOOLEAN
  
  
=end
    def self.create_person(json)
       @person = Person.new(
      				 :national_id => Npid.unassigned_at_site.first.national_id,
							 :assigned_site =>  Site.current_code,
							 :patient_assigned => true,

               :npid => {
                        	:value => Npid.unassigned_at_site.first.national_id
               				  },

							 :person_attributes => { :citizenship => json[:person]["data"]["attributes"]["citizenship"] || nil,
																			 :occupation => json[:person]["data"]["attributes"]["occupation"] || nil,
																			 :home_phone_number => json[:person]["data"]["attributes"]["home_phone_number"] || nil,
																			 :cell_phone_number => json[:person]["data"]["attributes"]["cell_phone_number"] || nil,
																			 :race => json[:person]["data"]["attributes"]["race"] || nil
										                  },

								:gender => json[:person]["data"]["gender"],

								:names => { :given_name => json[:person]["data"]["names"]["given_name"],
							 					    :family_name => json[:person]["data"]["names"]["family_name"]
										      },

								:birthdate => json[:person]["data"]["birthdate"] || nil,
								:birthdate_estimated => json[:person]["data"]["birthdate_estimated"] || nil,

								:addresses => {:current_residence => json[:person]["data"]["addresses"]["city_village"] || nil,
												       :current_village => json[:person]["data"]["addresses"]["city_village"] || nil,
												       :current_ta => json[:person]["data"]["addresses"]["state_province"] || nil,
												       :current_district => json[:person]["data"]["addresses"]["state_province"] || nil,
												       :home_village => json[:person]["data"]["addresses"]["neighbourhood_cell"] || nil,
												       :home_ta => json[:person]["data"]["addresses"]["county_district"] || nil,
												       :home_district => json[:person]["data"]["addresses"]["address2"] || nil
                              }
		 )
      
      person_saved = @person.save

      if person_saved
        npid =  Npid.by__national_id.key(@person.national_id).first
        npid.assigned = true
        npid.save
      end
    
     return person_saved

   end
     
      
    
    
=begin
  + update_person(JSON):BOOLEAN
  
  
=end
    def self.update_person(json)
    
    end
    
=begin
  + get_person(npid:String):JSON
  
  
=end
    def self.get_person(npid)
       person = Person.get(npid) rescue nil
       unless person.blank?
          return person.to_json
       else
          return {}
       end
    end
         
  end
  
end
