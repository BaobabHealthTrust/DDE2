require 'couchrest_model'

class Relationship < CouchRest::Model::Base
  
  use_database "relationship"
  
  property :primary, String
  property :secondary, String 
  property :relationship_type, String
  property :site_code, String
  
  timestamps!
  
  design do 
     view :by__id
     view :by_primary
     view :by_secondary
     view :by_primary_secondary
     view :by_relationship_type
     view :by_site_code
     view :by_updated_at
     view :by_created_at
  end
 
end
