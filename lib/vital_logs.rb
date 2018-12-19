require 'csv'

def retrieve_vital_log
  CSV.open('evr_vital_logs_17_18.csv','w') do |csv|
    csv << ['Location/Site','Birth Date','Death Date','Transfer Date','Birth Date Entry','Death Date Entry','Transfer Date Entry','Person/Patient ID','Date of Entry','User ID','Location of Entry','Home District','Home TA','Home Village','Current District','Current TA','Current Village']

    total_records = ''

    Person.current_district_ta.key(['Lilongwe','Mtema']).each_with_index do |person, index|
      if person['created_at'].to_date >= '2017-01-01'.to_date && person['created_at'].to_date <= '2018-11-30'.to_date
        death_date = nil
        transfer_date = nil
        birth_date = nil

        death_date_entry = nil
        transfer_date_entry = nil
        birth_date_entry = nil

        birth_date = person['birthdate']
        birth_date_entry = person['created_at'].to_date

        user_tracker = nil

        Outcome.by_person.key(person['_id']).each do |outcome|
          if outcome['outcome'] == 'Died'
            death_date = outcome['outcome_date']
            death_date_entry = outcome['created_at'].to_date
          elsif outcome['outcome'] == 'Transfer Out'
            transfer_date = outcome['outcome_date']
            death_date_entry = outcome['created_at'].to_date
          end
        end

        # UserTracker.by_person_tracker.key().each do |user|
        #   user_tracker = user.username
        # end

        csv_text_array = []
        csv_text_array << person['addresses']['current_village']
        csv_text_array << ((birth_date.nil?)?'N/A':birth_date)
        csv_text_array << ((death_date.nil?)?'N/A':death_date)
        csv_text_array << ((transfer_date.nil?)?'N/A':transfer_date)
        csv_text_array << ((birth_date.nil?)?'N/A':birth_date_entry)
        csv_text_array << ((death_date.nil?)?'N/A':death_date_entry)
        csv_text_array << ((transfer_date.nil?)?'N/A':transfer_date_entry)
        csv_text_array << person['_id']
        csv_text_array << person['created_at'].to_date
        csv_text_array << 'N/A'  #((user_tracker.nil?)?'N/A':user_tracker)
        csv_text_array << 'location'
        csv_text_array << person['addresses']['home_district']
        csv_text_array << person['addresses']['home_ta']
        csv_text_array << person['addresses']['home_village']
        csv_text_array << person['addresses']['current_district']
        csv_text_array << person['addresses']['current_ta']
        csv_text_array << person['addresses']['current_village']
        csv << csv_text_array
        #return
        puts "#{index + 1} records analyzed"
        total_records = index + 1
      end rescue nil
    end

    puts "# ---------------------------------------------------------------------- "
    puts "#                                                                        "
    puts "# Vital logs export completed with a total of #{total_records} analyzed. "
    puts "#                                                                        "
    puts "# ---------------------------------------------------------------------- "
  end
end

retrieve_vital_log
