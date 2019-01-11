require 'csv'

def push_evr_to_csv
  CSV.open('all_evr_data.csv','w') do |csv|
    csv << ['_id','_rev','assigned_site','patient_assigned',
      'person_attributes.country_of_residence','person_attributes.citizenship',
      'person_attributes.occupation','person_attributes.home_phone_number','person_attributes.cell_phone_number',
      'person_attributes.office_phone_number','gender','names.given_name','names.family_name',
      'names.middle_name','names.maiden_name','names.given_name_code','names.family_name_code',
      'patient.identifiers','birthdate','birthdate_estimated','addresses.current_residence',
      'addresses.current_village','addresses.current_ta','addresses.current_district',
      'addresses.home_village','addresses.home_ta','addresses.home_district','updated_at',
      'created_at','type'
    ]

    Person.current_district_ta.key(['Lilongwe','Mtema']).each do |person|
        csv_text_array = []
        csv_text_array << person['_id']
        csv_text_array << person['_rev']
        csv_text_array << person['assigned_site']
        csv_text_array << person['patient_assigned']
        csv_text_array << person['person_attributes']['country_of_residence']
        csv_text_array << person['person_attributes']['citizenship']
        csv_text_array << person['person_attributes']['occupation']
        csv_text_array << person['person_attributes']['home_phone_number']
        csv_text_array << person['person_attributes']['cell_phone_number']
        csv_text_array << person['person_attributes']['office_phone_number']
        csv_text_array << person['gender']
        csv_text_array << person['names']['given_name']
        csv_text_array << person['names']['family_name']
        csv_text_array << person['names']['middle_name']
        csv_text_array << person['names']['maiden_name']
        csv_text_array << person['names']['given_name_code']
        csv_text_array << person['names']['family_name_code']
        csv_text_array << (person['patient']['identifiers'] rescue nil)
        csv_text_array << person['birthdate']
        csv_text_array << person['birthdate_estimated']
        csv_text_array << (person['addresses']['current_residence'] rescue nil)
        csv_text_array << person['addresses']['current_village']
        csv_text_array << person['addresses']['current_ta']
        csv_text_array << person['addresses']['current_district']
        csv_text_array << person['addresses']['home_village']
        csv_text_array << person['addresses']['home_ta']
        csv_text_array << person['addresses']['home_district']
        csv_text_array << person['updated_at']
        csv_text_array << person['created_at']
        csv_text_array << person['type']
        csv << csv_text_array
    end
  end
end

push_evr_to_csv
