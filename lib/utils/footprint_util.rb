module Utils

  class FootprintUtil
    
=begin
  + log_application_and_site(
      npid:String,
      application:String,
      site:String
    ):Array(JSON)
  
  
=end
    def self.log_application_and_site(json)
      footprint = FootPrint.create(npid: json[:value],application: application[:application_name], site_code: Site.current_code)
      return footprint.to_json
    end
     
  end

end
