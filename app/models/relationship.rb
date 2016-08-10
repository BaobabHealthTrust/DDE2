require 'couchrest_model'

class Relationship < CouchRest::Model::Base
  
  use_database "relationship"
  
  property :primary, String
  property :secondary, String 
  property :relationship_type, String
  property :site_code, String
  
  timestamps!
  
  design do 
    view :by__id
    view :by_primary
    view :by_secondary
    view :by_primary_and_secondary
    view :by_relationship_type
    view :by_site_code
    view :by_updated_at
    view :by_created_atORe
  end

  def self.create_relation(primary_person_national_id, secondary_person_national_id, relationship_type, site_code)
    relationship_exists = Relationship.by_primary_and_secondary.keys([[primary_person_national_id, secondary_person_national_id]]).all
    return "exists" unless relationship_exists.blank? #return if they are already related
    return "error" if primary_person_national_id == secondary_person_national_id
    
    new_relation = Relationship.new
    new_relation.primary = primary_person_national_id
    new_relation.secondary = secondary_person_national_id
    new_relation.relationship_type = relationship_type
    new_relation.site_code = site_code
    new_relation.save
    
    return "success"
  end

  def self.relations(primary_person_national_id)
    relations = Relationship.by_primary(:key => primary_person_national_id).all
    
    people = []
    relations.each do |relation|
      person = Person.by__id(:key => relation.secondary).last
      next if person.blank?
      person[:relationship_type] = relation.relationship_type
      people << person
    end
    
    return people
  end

end
