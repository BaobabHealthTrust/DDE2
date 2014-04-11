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
  property :gender, String
  property :birthdate, String
  property :birthdate_estimated,  TrueClass, :default => false

  timestamps!


  design do
    view :by__id
  end
end
