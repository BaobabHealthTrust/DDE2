module Utils

  class Proxy
    
=begin
  + check_if_npids_available():BOOLEAN
  
  
=end
    def self.check_if_npids_available()
      result = Npid.unassigned_at_site.count
      
      return (result > 0)
    end
   
=begin
  + assign_npid_to_person(JSON):JSON
  
  
=end
    def self.assign_npid_to_person(json)
    
      raise "First argument can only be a JSON Object" if !json.match(/\{(.+)?\}/)
    
      result = Npid.unassigned_at_site.first rescue nil
      
      if !result.nil?
      
        js = JSON.parse(json)
      
        result.update_attributes(assigned: true)
        
        # Keep current npid as a reference for later        
        js["patient"] = {} if js["patient"].blank?
        
        js["patient"]["identifiers"] = [] if js["patient"]["identifiers"].blank?
        
        js["patient"]["identifiers"] << {"Old Identification Number" => js["national_id"]}
              
        js["national_id"] = result.national_id rescue nil
        
        js["assigned_site"] = Site.current.site_code rescue nil
        
        js["patient_assigned"] = true
      
        js["patient"]["identifiers"] = js["patient"]["identifiers"].uniq
      
        return js.to_json
        
      else 
      
        return {}.to_json
        
      end
    
    end
   
=begin
  + assign_temporary_npid(JSON):JSON
  
  
=end
    def self.assign_temporary_npid(json)
    
      raise "First argument can only be a JSON Object" if !json.match(/\{(.+)?\}/)    
    
      suffix = "%04d" % (rand * 1000).round(0)
      
      temporary_id = "#{Site.current_code}#{Time.now.strftime("%Y%m%d%H%M%S")}#{suffix}"
      
      js = JSON.parse(json)
      
      js["identifiers"] = [] if js["identifiers"].nil?
      
      # Keep current npid as a reference for later          
      js["patient"] = {} if js["patient"].blank?
      
      js["patient"]["identifiers"] = [] if js["patient"]["identifiers"].blank?
      
      js["patient"]["identifiers"] << {"Old Identification Number" => js["national_id"]} if !js["national_id"].blank?
      
      js["patient"]["identifiers"] << {"Temporary ID" => temporary_id}
      
      js["national_id"] = temporary_id
    
      js["assigned_site"] = Site.current.site_code rescue nil
      
      js["patient_assigned"] = true
      
      return js.to_json
    
    end
   
=begin
  + get_unassigned_npids():Array(JSON)
  
  
=end
    def self.get_unassigned_npids()
      Npid.unassigned_at_site.collect{|e| e}
    end
   
=begin
  + request_for_npids(
      site:String,
      site_code:String
    ):BOOLEAN
  
  
=end
    def self.request_for_npids(site, site_code)
    
      raise "First argument cannot be blank" if site.blank?
      
      raise "Second argument cannot be blank" if site_code.blank?
    
      return false  # Disabled as not being appropriate
    
      result = RestClient.get("#{CONFIG["masterip"]}?site=#{site}&site_code={site_code}") rescue nil
      
      return (!result.nil?)
    
    end

=begin
    + transpose_params(json):json
=end
    def self.transpose_params(json)
     #Method to handle json of old format
       js = JSON.parse(json)

       if js["person"]["data"]["birthdate"].blank?
         js["person"]["data"]["birthdate"] = (js["person"]["data"]["birth_year"] +"-"+ js["person"]["data"]["birth_month"] + "-"+js["person"]["data"]["birth_day"] ).to_date rescue ""
       end

      result = {
        "npid" => js["npid"].blank? ? nil : js["npid"]["value"],
        "application" => "",
        "birthdate" => js["person"]["data"]["birthdate"] || nil,
        "birthdate_estimated" => js["person"]["data"]["birthdate_estimated"] || nil,
        "names" => {
            "family_name" => js["person"]["data"]["names"]["family_name"],
            "given_name" => js["person"]["data"]["names"]["given_name"]
        },
        "gender" => js["person"]["data"]["gender"],
        "attributes" => {
            "citizenship" => js["person"]["data"]["attributes"]["citizenship"] || nil,
            "occupation" => js['person']["data"]["attributes"]["occupation"] || nil,
            "home_phone_number" => js['person']["data"]["attributes"]["home_phone_number"] || nil,
            "cell_phone_number" => js['person']["data"]["attributes"]["cell_phone_number"] || nil,
            "race" => js['person']["data"]["attributes"]["race"] || nil
        },
        "addresses" => {
            "current_residence" =>  js["person"]["data"]["addresses"]["city_village"] || nil,
            "current_village" => js["person"]["data"]["addresses"]["city_village"] || nil,
            "current_ta" => js["person"]["data"]["addresses"]["state_province"] || nil,
            "current_district" => js["person"]["data"]["addresses"]["state_province"] || nil,
            "home_village" => js["person"]["data"]["addresses"]["neighbourhood_cell"] || nil,
            "home_ta" => js["person"]["data"]["addresses"]["county_district"] || nil,
            "home_district" => js["person"]["data"]["addresses"]["address2"] || nil
        }
      }

      result.to_json
    end

end

end
