class Footprint < CouchRest::Model::Base
  
  use_database "person"
 
  property :npid, String
  property :application, String
  property :site_code, String
  
  timestamps!

  design do
    view :by__id
  end

end
