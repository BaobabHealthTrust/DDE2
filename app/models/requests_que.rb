class RequestsQue < CouchRest::Model::Base

  property :site_code, String
  property :region, String
  property :threshold, Integer
  property :request_processed, TrueClass, :default => false
  
  timestamps!

  design do
    view :by__id
    
    view :pending,
         :map => "function(doc){
            if (doc['type'] == 'RequestsQue' && doc['request_processed'] == false && doc['region'] == '#{Site.current_region}'){
                  emit(doc.site_code, {id: doc._id ,site_code: doc.site_code, 
                      region: doc.region, threshold: doc.threshold, request_processed: doc.request_processed});
            }
          }"
  end

end
