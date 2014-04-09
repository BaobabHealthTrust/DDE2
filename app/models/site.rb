require 'couchrest_model'

class Site < CouchRest::Model::Base

  def code
    self['_id']
  end

  def code=(value)
    self['_id']=value
  end

  property :name, String
  property :description, String
  
  timestamps!

end
