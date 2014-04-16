require 'couchrest_model'

class Site < CouchRest::Model::Base

  def code
    self['_id']
  end


  def self.current_id
    SITE_CONFIG[:site_id].to_i
  end

  def self.current     
    if self.proxy?
      self.find self.current_id
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
    if self.proxy?
      self.current.try(:code) || '???'
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
   

  def code=(value)
    self['_id']=value
  end

  def self.site_code
      "KCH"
  end

  property :name, String
  property :description, String
  
  timestamps!

  design do
    view :by__id
  end
end
