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

  property :attributes  do
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
    property :identifiers do 
     property :old_national_id,String
     property :diabetes_number,String	
    
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

end
