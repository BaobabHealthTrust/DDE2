module Utils

  class Master
    
=begin
  + assign_npids_to_site(
      site:String, quantity:Integer
    ):BOOLEAN
  
  
=end
    def self.assign_npids_to_site(site, quantity)
    
      raise "First argument cannot be blank" if site.to_s.strip.match(/^$/)
      
      raise "Second argument is supposed to be an integer" if !quantity.to_s.match(/^\d+$/)
    
    end
   
=begin
  + add_site(
      site:String, site_code:String
    ):BOOLEAN
  
  
=end
    def self.add_site(site, site_code)
    
      raise "First argument cannot be empty" unless site.to_s.strip.match(/^$/)
      
      raise "Second argument cannot be empty" unless site.to_s.strip.match(/^$/)
    
    end
    
=begin
  + get_unassigned_npids():Array(JSON)
  
  
=end
    def self.get_unassigned_npids()
    
    end
    
=begin
  + get_all_sites():Array(JSON)
  
  
=end
    def self.get_all_sites()
    
    end
     
  end

end
