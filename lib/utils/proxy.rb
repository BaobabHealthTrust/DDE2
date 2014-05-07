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
        
        js["national_id"] = result.national_id rescue nil
      
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
    
      temporary_id = "#{Site.current_code}#{Time.now.strftime("%Y%m%d%H%M%S")}"
      
      js = JSON.parse(json)
      
      js["identifiers"] = {} if js["identifiers"].nil?
      
      js["identifiers"]["temporary_id"] = temporary_id
    
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
