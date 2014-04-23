require 'couchrest_model'

class Site < CouchRest::Model::Base

=begin
  # Not sure of the relevance of this code
  def self.current     
    if self.proxy?
      self.by__id.key(self.current_code).first
    end
  end

  def self.current_name
    if self.proxy?
      self.current.try(:name) || '- unknown -'
    else
      'Master Service'
    end
  end
=end

  def self.current_code
    settings = YAML.load_file("#{Rails.root}/config/couchdb.yml")[Rails.env] rescue {}
    
    return settings["site_code"]
  end

  def site_code=(value)
    self['_id']=value
  end

  def site_code
      self['_id']
  end

  property :name, String
  property :description, String
  
  timestamps!

  design do
    view :by__id
  end
end
