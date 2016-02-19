require 'couchrest_model'

class Outcome < CouchRest::Model::Base

 use_database "outcome"
 
 property :person, String
 property :outcome, String 
 
 timestamps!
 
 design do 
     view :by__id
     view :by_person
     view :by_outcome
     view :by_person_and_outcome
     view :by_updated_at
     view :by_created_at
  end

end
