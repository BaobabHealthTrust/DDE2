require 'couchrest_model'

class Site < CouchRest::Model::Base

  def site_code=(value)
    self['_id']=value
  end

  def site_code
      self['_id']
  end

  property :name, String
  property :description, String
  
  timestamps!

  def self.current     
     return self.by__id.key(self.current_code).first
  end

  def self.current_name
     return self.current.try(:name) || 'Master Service'
  end

  def self.current_code

    if CONFIG["sitecode"].blank?
       settings = YAML.load_file(Rails.root.join('config', 'couchdb.yml'))[Rails.env]
    else
       settings = CONFIG
    end

    return settings["sitecode"]

  end

  design do
    view :by__id
  end

end
