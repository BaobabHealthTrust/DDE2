require 'couchrest_model'

class Outcome < CouchRest::Model::Base

 use_database "outcome"
 
 timestamps!

end
