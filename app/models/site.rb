require 'couchrest_model'

class Site < CouchRest::Model::Base

  def self.current     
    if self.proxy?
      self.by__id.key("KCH").first
    end
  end

  def self.current_name
    if self.proxy?
      self.current.try(:name) || '- unknown -'
    else
      'Master Service'
    end
  end

  def self.currentsite_code
    if self.proxy?
       SITE_CONFIG[:site_code]
    else
      'DDE'
    end
  end

  def self.master?
    SITE_CONFIG[:mode] == 'master'
  end

  def self.proxy?
    SITE_CONFIG[:mode] == 'proxy'
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
