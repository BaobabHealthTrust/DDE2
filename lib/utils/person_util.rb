module Utils

  class PersonUtil
  
=begin
  + process_person_data(JSON):JSON
  
  
=end
    def self.process_person_data(json)
    
      raise "First argument can only be a JSON Object" unless !(JSON.parse(json) rescue nil).nil?
     #check if json object is whole person data or just person national id 

      json = Proxy.transpose_params(json) unless JSON.parse(json)["person"].blank?

      person = nil
		  if JSON.parse(json)["npid"].blank?
          #create person
          person = self.create_person(json)
          return person
		  else
       	if JSON.parse(json).length == 6
         #json object is only a npid
         person = self.get_person(JSON.parse(json))
         Utils::FootprintUtil.log_application_and_site(json) if person
		     return person
        else
         #json object is person data
          if self.person_has_v4_id(JSON.parse(json))
           #json object has valid version 4 id
		       person = self.get_person(json[:value])
           return person
		     	else
           #json object has no valid version 4 id therefore create person and keep id
           person = self.get_person(JSON.parse(json[:value]))
           if person.blank?
             person = self.create_person(json)
           else
             person = self.update_person(json)
           end

           return person
		     	end
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
    def self.search_for_person_by_params(first_name,last_name ,gender, date_of_birth=nil, home_t_a=nil, home_district=nil)
      people = []
      if (date_of_birth.blank? && home_t_a.blank? && home_district.blank?)
        return Person.search.keys([[first_name,last_name ,gender]]).rows
      elsif (!date_of_birth.blank? && home_t_a.blank? && home_district.blank?)
        return Person.search_with_dob.keys([[first_name,last_name ,gender, date_of_birth]]).rows
      elsif (date_of_birth.blank? && home_t_a.blank? && !home_district.blank?)
        return Person.search_with_home_district.keys([[first_name,last_name ,gender,home_district]]).rows
      elsif (date_of_birth.blank? && !home_t_a.blank? && home_district.blank?)
        return Person.search_with_home_ta.keys([[first_name,last_name ,gender,home_t_a]]).rows
      elsif (date_of_birth.blank? && !home_t_a.blank? && !home_district.blank?)
        return Person.search_with_home_ta_district.keys([[first_name,last_name ,gender,home_t_a,home_district]]).rows
      elsif (!date_of_birth.blank? && !home_t_a.blank? && home_district.blank?)
        return Person.search_with_dob_home_ta.keys([[first_name,last_name ,gender,date_of_birth,home_t_a]]).rows
      elsif (!date_of_birth.blank? && home_t_a.blank? && !home_district.blank?)
        return Person.search_with_dob_home_district.keys([[first_name,last_name ,gender,date_of_birth, home_district]]).rows
      elsif (!date_of_birth.blank? && !home_t_a.blank? && !home_district.blank?)
        return Person.advanced_search.keys([[first_name,last_name ,gender,date_of_birth, home_t_a, home_district]]).rows
      end

    end
  
=begin
  + confirm_person_to_update(JSON):Array(JSON)
  
  
=end
    def self.confirm_person_to_update(json)
      person = Person.get(json[:value])
      results = []
      if !person.blank?
        if compare_people(person, json)
           results << json << person
        end
      end

      return results
    end
   
=begin
  + create_person(JSON):BOOLEAN
  
  
=end
    def self.create_person(json)

       js = JSON.parse(Proxy.assign_npid_to_person(json))

       js = JSON.parse(Proxy.assign_temporary_npid(json)) if js.blank?

       unless js.blank?

       @person = Person.new(
							 :assigned_site =>  Site.current_code,
							 :patient_assigned => true,

							 :person_attributes => { :citizenship => js["person"]["data"]["attributes"]["citizenship"] || nil,
																			 :occupation => js['person']["data"]["attributes"]["occupation"] || nil,
																			 :home_phone_number => js['person']["data"]["attributes"]["home_phone_number"] || nil,
																			 :cell_phone_number => js['person']["data"]["attributes"]["cell_phone_number"] || nil,
																			 :race => js['person']["data"]["attributes"]["race"] || nil
										                  },

								:gender => js["person"]["data"]["gender"],

								:names => { :given_name => js["person"]["data"]["names"]["given_name"],
							 					    :family_name => js["person"]["data"]["names"]["family_name"]
										      },

								:birthdate => js["person"]["data"]["birthdate"] || nil,
								:birthdate_estimated => js["person"]["data"]["birthdate_estimated"] || nil,

								:addresses => {:current_residence => js["person"]["data"]["addresses"]["city_village"] || nil,
												       :current_village => js["person"]["data"]["addresses"]["city_village"] || nil,
												       :current_ta => js["person"]["data"]["addresses"]["state_province"] || nil,
												       :current_district => js["person"]["data"]["addresses"]["state_province"] || nil,
												       :home_village => js["person"]["data"]["addresses"]["neighbourhood_cell"] || nil,
												       :home_ta => js["person"]["data"]["addresses"]["county_district"] || nil,
												       :home_district => js["person"]["data"]["addresses"]["address2"] || nil
                              }
		 )


      if js["national_id"].blank?
        @person.national_id = js["identifiers"]["temporary_id"]
      else
        @person["npid"] =  {:value => js["national_id"]}
        @person.national_id = js["national_id"]
      end

     person = @person.save 

     return person

     end

   end
         
=begin
  + update_person(JSON):BOOLEAN
  
  
=end
    def self.update_person(json)

      js = JSON.parse(json)
      person = Person.get(js["npid"])

      if person.blank?
        person = create_person(json)
      else

        if !self.compare_people(person, js)
          person.gender = js['gender'] unless js['gender'].blank?
          person.birthdate = js['birthdate'] unless js['birthdate'].blank?
          person['names']['given_name'] = js['names']['given_name'] unless js['names']['given_name'].blank?
          person['names']['family_name'] = js['names']['family_name'] unless js['names']['family_name'].blank?

          unless js['addresses'].blank?
            person['addresses'] = {} if person['addresses'].blank?
            person['addresses']['current_residence'] = js['addresses']['current_residence'] unless js['addresses']['current_residence'].blank?
            person['addresses']['current_village'] = js['addresses']['current_village'] unless js['addresses']['current_village'].blank?
            person['addresses']['current_district'] = js['addresses']['current_district'] unless js['addresses']['current_district'].blank?
            person['addresses']['current_ta'] = js['addresses']['current_ta'] unless js['addresses']['current_ta'].blank?
            person['addresses']['home_district'] = js['addresses']['home_district'] unless js['addresses']['home_district'].blank?
            person['addresses']['home_ta'] = js['addresses']['home_ta'] unless js['addresses']['home_ta'].blank?
            person['addresses']['home_village'] = js['addresses']['home_village'] unless js['addresses']['home_village'].blank?
          end

          unless js['person_attributes'].blank?
            person['person_attributes'] = {} if person['person_attributes'].blank?
            person['person_attributes']['citizenship'] = js['person_attributes']['citizenship'] unless js['person_attributes']['citizenship'].blank?
            person['person_attributes']['occupation'] = js['person_attributes']['occupation'] unless js['person_attributes']['occupation'].blank?
            person['person_attributes']['home_phone_number'] = js['person_attributes']['home_phone_number'] unless js['person_attributes']['home_phone_number'].blank?
            person['person_attributes']['cell_phone_number'] = js['person_attributes']['cell_phone_number'] unless js['person_attributes']['cell_phone_number'].blank?
            person['person_attributes']['race'] = js['person_attributes']['race'] unless js['person_attributes']['race'].blank?
          end


        end
        raise person.inspect
        person.save

        has_new_id = person_has_v4_id(js)

        if !has_new_id
          if Proxy.check_if_npids_available()

            new_person = create_person(json)

            new_person["patient"] = { "identifiers" => {} } if person["patient"].blank?
            if new_person.national_id.first == "p"
              new_person["patient"]["identifiers"]["legacy_npid"] = person.national_id
            else
              new_person["patient"]["identifiers"]["temporary_npid"] = person.national_id
            end
            person.destroy if new_person.save
          end
        end

      end

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
=begin
    + compare_people(person_a:JSON, person_b:JSON):BOOLEAN
=end

    def self.compare_people(personA,personB )

      single_attributes = ['birthdate', 'gender']
      addresses = ['current_residence','current_village','current_ta','current_district','home_village','home_ta','home_district',]
      attributes = ['citizenship', 'race', 'occupation','home_phone_number', 'cell_phone_number']

      single_attributes.each do |metric|
        if personA[metric] != personB[metric]
          return false
        end
      end

      attributes.each do |metric|
        if personA['person_attributes'][metric] != personB['person_attributes'][metric]
          return false
        end
      end

      addresses.each do |metric|
        if self['addresses'][metric] != person['addresses'][metric]
          return false
        end
      end

      return true

    end
  end


end
