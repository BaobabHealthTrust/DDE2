class Footprint < CouchRest::Model::Base
  
  use_database "person"
 
  property :npid, String
  property :application, String
  property :site_code, String
  
  timestamps!

  design do
    view :by__id

    view :where_gone,
       :map => "function(doc) {
            if (doc['type'] == 'Footprint') {
              emit(doc.npid, {application: doc.application, site: doc.site_code, when: doc.updated_at});
            }
          }"
  end

end
