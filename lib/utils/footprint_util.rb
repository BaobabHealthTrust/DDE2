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
      current = Footprint.existing.keys([[npid, application, site, Date.today.year, Date.today.month, Date.today.day]]).rows
      
      if current.length <= 0
        
        result = Footprint.create(npid: npid, application: application, site_code: site) rescue false
        
      end
      
    end
  
    # def self.log_application_and_site(json)
    #  footprint = Footprint.create(npid: json[:value], application: json[:application_name], site_code: Site.current_code)
    #  footprint ? true : false
    # end
     
  end

end
