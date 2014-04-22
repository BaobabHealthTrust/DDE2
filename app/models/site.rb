require 'couchrest_model'

class Site < CouchRest::Model::Base

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

  def self.current_code
    return CONFIG["site_code"]
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
