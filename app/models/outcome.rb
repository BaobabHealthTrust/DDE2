require 'couchrest_model'

class Outcome < CouchRest::Model::Base

 use_database "outcome"
 
 property :person, String
 property :outcome, String 
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
     view :by_person_and_outcome
     view :by_from_district_and_from_ta_and_from_village
     view :by_updated_at
     view :by_created_at
  end

end
