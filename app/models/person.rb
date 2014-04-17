require 'couchrest_model'

class Person < CouchRest::Model::Base

  def national_id
    self['_id']
  end

  def national_id=(value)
    self['_id']=value
  end

  def compare(person)
    single_attributes = ["birthdate", "gender"]
    addresses = ['current_residence','current_village','current_ta','current_district','home_village','home_ta','home_district',]
    attributes = ['citizenship', 'race', 'occupation','home_phone_number', 'cell_phone_number']

    single_attributes.each do |comparison|
      if self[comparison] != person[comparison]
        return false
      end
    end

    attributes.each do |comparison|
      if self['person_attributes'][comparison] != person['person_attributes'][comparison]
        return false
      end
    end

    addresses.each do |comparison|
      if self['addresses'][comparison] != person['addresses'][comparison]
        return false
      end
    end

    return true
  end

  property :assigned_site, String
  property :patient_assigned, TrueClass, :default => false

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

end
