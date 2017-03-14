require 'couchrest_model'

class Outcome < CouchRest::Model::Base

 use_database "outcome"
 
 property :person, String
 property :place_of_birth, String
 property :outcome, String
 property :outcome_cause, String
 property :outcome_date, Date 
 property :from_district, String 
 property :from_ta, String 
 property :from_village, String 
 property :to_district, String 
 property :to_ta, String 
 property :to_village, String 
 property :outcome_date_estimated, TrueClass, :default => false 
 
 timestamps!
 
 design do 
     view :by__id
     view :by_person
     view :by_outcome
     view :by_outcome_cause
     view :by_outcome_date
     view :by_person_and_outcome
     view :by_created_at_and_outcome
     view :by_from_district_and_from_ta_and_from_village
     view :by_from_district_and_from_ta_and_from_village_and_outcome_cause
     view :by_updated_at
     view :by_created_at
  end

  def self.add_place_of_birth(national_id, place_of_birth)
    outcome = Outcome.by_person_and_outcome.keys([[national_id, 'Alive']]).last
    outcome_date = outcome.outcome_date rescue Date.today
    outcome = Outcome.new if outcome.blank?
    outcome.person = national_id if outcome.person.blank?
    outcome.outcome_date = outcome_date
    outcome.place_of_birth = place_of_birth
    outcome.outcome = 'Alive'
    outcome.save
    
    return outcome
  end

  def self.retrieve_place_of_birth(national_id)
    outcome = Outcome.by_person_and_outcome.keys([[national_id, 'Alive']]).last
    return "" if outcome.blank?
    return outcome.place_of_birth
  end

end
