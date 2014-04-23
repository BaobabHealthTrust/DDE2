module Utils

  class Master
    
=begin
  + assign_npids_to_site(
      site:String, quantity:Integer
    ):BOOLEAN
  
  Given a site code and the number of ids to assign, this function aims at assigning 
  the given range of ids to the given site.
  
  An example would be given a site with code 'MLS' which has to be assigned 10 ids,
  given the last assigned id was 20, the new ids to be assigned are from 21 to 31.
=end
    def self.assign_npids_to_site(site, quantity)
    
      raise "First argument cannot be blank" if site.to_s.strip.match(/^$/)
      
      raise "Second argument is supposed to be an integer" if !quantity.to_s.match(/^\d+$/)
    
      i = 0 
      
      Npid.unassigned_to_site.each do |e| 
        e.update_attributes(site_code:"TST") 
        
         i += 1
         
        return true if i == quantity.to_i
      end
    
      return false
    end
   
=begin
  + add_site(
      site:String, site_code:String
    ):BOOLEAN
  
    Given a site name and a site code, add a unique site.
=end
    def self.add_site(site, site_code)
    
      raise "First argument cannot be empty" if site.to_s.strip.match(/^$/)
      
      raise "Second argument cannot be empty" if site.to_s.strip.match(/^$/)
    
      result = Site.create(name: site, site_code: site_code) # rescue nil
    
      return !result.nil?
    
    end
    
=begin
  + get_unassigned_npids():Array(JSON)
  
    A list of all npids that have not been assigned to a site.
=end
    def self.get_unassigned_npids()
      Npid.unassigned_to_site.collect{|e| e}
    end
    
=begin
  + get_all_sites():Array(JSON)
  
    A list of all sites captured.
=end
    def self.get_all_sites()
      Site.all.collect{|s| s}
    end
     
  end

end
