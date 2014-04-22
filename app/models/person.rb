require 'couchrest_model'

class Person < CouchRest::Model::Base

  def national_id
    self['_id']
  end

  def national_id=(value)
    self['_id']=value
  end

  property :assigned_site, String
  property :patient_assigned, TrueClass, :default => false

  property :npid do
     property :value, String
  end

  property :person_attributes  do
    property :citizenship, String
    property :occupation, String
    property :home_phone_number, String
    property :cell_phone_number, String
    property :race, String
  end

  property :gender, String

  property :names do
     property :given_name, String
     property :family_name, String 
  end

  property :patient do
    property :identifiers, [String]
  end

  property :birthdate, String
  property :birthdate_estimated,  TrueClass, :default => false

  property :addresses do
    property :current_residence, String
    property :current_village, String
    property :current_ta, String
    property :current_district, String
    property :home_village, String
    property :home_ta, String
    property :home_district, String
  end

  timestamps!


  design do
    view :by__id
  end

=begin
  + process_person_data(JSON):JSON
  
  
=end
  def self.process_person_data(json)
  
    raise "First argument can only be a JSON Object" unless !(JSON.parse(json) rescue nil).nil?
    
  end
   
=begin
  + record_has_v4_id(JSON):BOOLEAN
  
  
=end
  def self.record_has_v4_id(json)
  
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
