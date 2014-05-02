require 'couchrest_model'

class User < CouchRest::Model::Base

  #property :username, String
  property :first_name, String
  property :last_name, String
  property :password_hash, String
  property :email, String
  property :active, TrueClass, :default => true
  property :notify, TrueClass, :default => false
  property :role, String
  property :site_code, String
  
  timestamps!

  cattr_accessor :current

  design do
    view :by_username
  end

  def username
   self['_id']
  end

  def username=(value)
   self['_id'] = value
  end

  before_save do |pass|
    self.password_hash = BCrypt::Password.create(self.password_hash)
  end
 
  def password_matches?(plain_password)
    not plain_password.nil? and self.password == plain_password
  end

  def password
    @password ||= BCrypt::Password.new(password_hash)
  rescue BCrypt::Errors::InvalidHash
    Rails.logger.error "The password_hash attribute of User[#{self.username}] does not contain a valid BCrypt Hash."
    return nil
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end
 
end
