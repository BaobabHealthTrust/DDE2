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
  property :region, String
  property :threshold, Integer, :default => 10
  property :batch_size, Integer, :default => 100
  property :site_id_count, Integer, :default => 0
  property :x, String
  property :y, String
  
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

  def self.current_region

    if CONFIG["region"].blank?
       settings = YAML.load_file(Rails.root.join('config', 'couchdb.yml'))[Rails.env]
    else
       settings = CONFIG
    end

    return settings["region"]

  end

  def self.where(params = {})
    result = []
    
    if !params[:region].blank?
      result = Site.all.collect { |site|
        site if site.region.downcase.strip == params[:region].to_s.strip.downcase
      }.compact.uniq
    end
    
    result
  end

  design do
    view :by__id
  end

end
