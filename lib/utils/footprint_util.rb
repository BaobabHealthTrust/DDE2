module Utils

  class FootprintUtil
    
=begin
  + log_application_and_site(
      npid:String,
      application:String,
      site:String
    ):BOOLEAN
  
  
=end
    def self.log_application_and_site(npid, application, site)
      result = Footprint.create(npid: npid, application: application, site_code: site) rescue false
    end
  
    # def self.log_application_and_site(json)
    #  footprint = Footprint.create(npid: json[:value], application: json[:application_name], site_code: Site.current_code)
    #  footprint ? true : false
    # end
     
  end

end
