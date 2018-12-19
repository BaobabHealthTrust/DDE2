def run_gender_fix
	Person.current_district_ta.key(['Lilongwe','Mtema']).each do |person|
		if person['gender'] == 'Mkazi' || person['gender'] == 'Mwamuna'
			people = []
			people << person
			self.update_person(people.to_json)
			
			puts 'updated'
		end
	end
end

# find person and update gender details if in chichewa
def self.update_person(json)
	
	js = JSON.parse(json) rescue nil
	
	unless js[0].blank?
		person = Person.get(js[0]['_id'])
		js = js[0]
		
		case js['gender']
			when 'Mkazi'
				person.gender = 'F'
			when 'Mwamuna'
				person.gender = 'M'
		end
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
			person['person_attributes']['office_phone_number'] = js['person_attributes']['office_phone_number'] unless js['person_attributes']['office_phone_number'].blank?
			person['person_attributes']['race'] = js['person_attributes']['race'] unless js['person_attributes']['race'].blank?
		end
		return person.save
		
		return true
	end
	return false
end

run_gender_fix