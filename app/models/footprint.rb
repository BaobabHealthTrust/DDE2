class Footprint < CouchRest::Model::Base
  
  property :npid, String
  property :application, String
  property :site_code, String
  
  timestamps!

=begin
  + log_application_and_site(
      npid:String,
      application:String,
      site:String
    ):Array(JSON)
  
  
=end
  def self.log_application_and_site(npid, application, site)
  
  end
   
end
