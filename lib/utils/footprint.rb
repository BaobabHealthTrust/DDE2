module Utils

  class FootprintUtil
    
=begin
  + log_application_and_site(
      npid:String,
      application:String,
      site:String
    ):Array(JSON)
  
  
=end
    def self.log_application_and_site(npid, application, site)
      footprint = FootPrint.create(npid: npid,application: application, site_code: site)
      return footprint.to_json
    end
     
  end

end
