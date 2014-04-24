class RequestsQue < CouchRest::Model::Base

  property :site_code, String
  property :region, String
  property :threshold, Integer
  property :request_processed, TrueClass, :default => false
  
  timestamps!

end
