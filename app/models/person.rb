require 'couchrest_model'

class Person < CouchRest::Model::Base
	property :national_id,String
  property :assigned_site,String
  property :patient_assigned,Boolean, :default => false
  property :gender,String
  property :birthdate,String
  property :birthdate_estimated,Boolean, :default => false
  timestamps!
end
