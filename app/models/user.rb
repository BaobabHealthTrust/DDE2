require 'couchrest_model'

class User < CouchRest::Model::Base

  property :name, String
  property :password_hash, String
  property :email, String
  property :description, String
  property :disabled, TrueClass, :default => false
  property :notify, TrueClass, :default => false
  property :site_code, String
  
  timestamps!
  
end
