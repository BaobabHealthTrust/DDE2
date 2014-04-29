module Utils

  class PersonUtil
  
=begin
  + process_person_data(JSON):JSON
  
  
=end
    def self.process_person_data(json)
    
      raise "First argument can only be a JSON Object" unless !(JSON.parse(json) rescue nil).nil?
     #check if json object is whole person data or just person national id 

      person = nil
		  if json[:value].blank?
          #create person
          person = self.create_person(json)
          return person
		  else
       	if json.length == 4
         #json object is only a npid
         person = self.get_person(npid)
         Utils::FootprintUtil.log_application_and_site(json) if person
		     return person
        else
         #json object is person data
          if self.person_has_v4_id(json)
           #json object has valid version 4 id
		       person = self.get_person(npid)
           return person
		     	else
           #json object has no valid version 4 id therefore create person and keep id
		       person = self.create_person(json)
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

       js = Proxy.assign_npid_to_person(json)

       unless js.blank?

       @person = Person.new(
      				 :national_id => js[:national_id],
							 :assigned_site =>  Site.current_code,
							 :patient_assigned => true,

               :npid => {
                        	:value => js[:national_id]
               				  },

							 :person_attributes => { :citizenship => js[:person]["data"]["attributes"]["citizenship"] || nil,
																			 :occupation => js[:person]["data"]["attributes"]["occupation"] || nil,
																			 :home_phone_number => js[:person]["data"]["attributes"]["home_phone_number"] || nil,
																			 :cell_phone_number => js[:person]["data"]["attributes"]["cell_phone_number"] || nil,
																			 :race => js[:person]["data"]["attributes"]["race"] || nil
										                  },

								:gender => js[:person]["data"]["gender"],

								:names => { :given_name => js[:person]["data"]["names"]["given_name"],
							 					    :family_name => js[:person]["data"]["names"]["family_name"]
										      },

								:birthdate => js[:person]["data"]["birthdate"] || nil,
								:birthdate_estimated => js[:person]["data"]["birthdate_estimated"] || nil,

								:addresses => {:current_residence => js[:person]["data"]["addresses"]["city_village"] || nil,
												       :current_village => js[:person]["data"]["addresses"]["city_village"] || nil,
												       :current_ta => js[:person]["data"]["addresses"]["state_province"] || nil,
												       :current_district => js[:person]["data"]["addresses"]["state_province"] || nil,
												       :home_village => js[:person]["data"]["addresses"]["neighbourhood_cell"] || nil,
												       :home_ta => js[:person]["data"]["addresses"]["county_district"] || nil,
												       :home_district => js[:person]["data"]["addresses"]["address2"] || nil
                              }
		 )
      
     person = @person.save 
   
     return person

     end

   end
         
=begin
  + update_person(JSON):BOOLEAN
  
  
=end
    def self.update_person(json)

      person = Person.get(json[:value])

      if person.blank?
        create_person(json)
      else
        has_new_id = person_has_v4_id(json)

        if !has_new_id
          new_id = Proxy.assign_npid_to_person(json)
          unless new_id.blank?
            if person.national_id.first == "p"
              person["patient"]["identifiers"]["legacy_npid"] = person.national_id
            else
              person["patient"]["identifiers"]["temporary_npid"] = person.national_id
            end
            person.national_id = new_id[:national_id]
          end
        end

        if !compare_people(person, json)
          person.gender = json[:gender] unless json[:gender].blank?
          person.birthdate = json[:birthdate] unless json[:birthdate].blank?
          person['names']['given_name'] = json[:names][:given_name ] unless json[:names][:given_name ].blank?
          person['names']['family_name'] = json[:names][:family_name] unless json[:names][:family_name]
          person['addresses']['current_residence'] = json['addresses']['current_residence'] unless json['addresses']['current_residence'].blank?
          person['addresses']['current_village'] = json['addresses']['current_village'] unless json['addresses']['current_village'].blank?
          person['addresses']['current_district'] = json['addresses']['current_district'] unless json['addresses']['current_district'].blank?
          person['addresses']['current_ta'] = json['addresses']['current_ta'] unless json['addresses']['current_ta'].blank?
          person['addresses']['home_district'] = json['addresses']['home_district'] unless json['addresses']['home_district'].blank?
          person['addresses']['home_ta'] = json['addresses']['home_ta'] unless json['addresses']['home_ta'].blank?
          person['addresses']['home_village'] = json['addresses']['home_village'] unless json['addresses']['home_village'].blank?
          person['person_attributes']['citizenship'] = json['person_attributes']['citizenship'] unless json['person_attributes']['citizenship'].blank?
          person['person_attributes']['occupation'] = json['person_attributes']['occupation'] unless json['person_attributes']['occupation'].blank?
          person['person_attributes']['home_phone_number'] = json['person_attributes']['home_phone_number'] unless json['person_attributes']['home_phone_number'].blank?
          person['person_attributes']['cell_phone_number'] = json['person_attributes']['cell_phone_number'] unless json['person_attributes']['cell_phone_number'].blank?
          person['person_attributes']['race'] = json['person_attributes']['race'] unless json['person_attributes']['race'].blank?

        end

        person.save
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
