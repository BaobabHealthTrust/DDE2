module Utils

  class Person
  
=begin
  + process_person_data(JSON):JSON
  
  
=end
    def self.process_person_data(json)
    
      raise "First argument can only be a JSON Object" unless !(JSON.parse(json) rescue nil).nil?
      
     unless json.length == 4
       npid = json[:value]
       if self.record_has_v4_id(json)
         self.search_by_npid(npid)
       else
         self.search_by_npid(npid)
       end
     else
       self.search_by_npid(npid)
     end
      
    end
   
=begin
  + record_has_v4_id(JSON):BOOLEAN
  
  
=end
    def self.record_has_v4_id(json)

       unless json[:value].blank?
           return true if json[:value].length == 6
			 end

       return false

    end
   
=begin
  + search_for_record_by_params(
      first_name:String,
      last_name:String,
      gender:String,
      date_of_birth:String(OPTIONAL),
      home_t_a:String(OPTIONAL),
      home_district:String(OPTIONAL)
    ):JSON
  
  
=end
    def self.search_for_record_by_params(first_name, gender, date_of_birth=nil, home_t_a=nil, home_district=nil)
    
    end
  
=begin
  + confirm_record_to_update(JSON):Array(JSON)
  
  
=end
    def self.confirm_record_to_update(json)
    
    end
   
=begin
  + create_person_record(JSON):BOOLEAN
  
  
=end
    def self.create_person_record(json)
    
    end
    
=begin
  + update_person_record(JSON):BOOLEAN
  
  
=end
    def self.update_person_record(json)
    
    end
    
=begin
  + get_person_record(npid:String):JSON
  
  
=end
    def self.get_person_record(json)
    
    end
      
=begin
  + search_by_npid(npid:String):Array(JSON)
  
  
=end
    def self.search_by_npid(npid)
    
    end
   
  end
  
end
