require 'couchrest_model'

class Npid < CouchRest::Model::Base

  property :national_id, String
  property :site_code, String
  property :assigned, TrueClass, :default => false
  
  timestamps!

end
