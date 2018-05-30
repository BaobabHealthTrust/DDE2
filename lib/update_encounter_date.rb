def update_encounter_date
  Person.current_district_ta.key(['Lilongwe','Mtema']).each do |person|
    if !person[:encounter_date].present? || person[:encounter_date].nil?
      person.update_attributes(encounter_date: person.created_at)

      puts "updated"
    end
  end
end

update_encounter_date