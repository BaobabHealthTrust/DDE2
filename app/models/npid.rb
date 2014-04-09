require 'couchrest_model'

class Npid < CouchRest::Model::Base

  

  def incremental_id
    self['_id']
  end

  def self.last_id
    previous_id = self.by__id.last.id
    return previous_id
  end

  def incremental_id=(value) 
       self['_id'] = (value.to_i + 1).to_s
  end
  
  property :national_id, String  
  property :site_code, String
  property :assigned, TrueClass, :default => false
  
  timestamps!


  design do
    view :by__id
  end

end
