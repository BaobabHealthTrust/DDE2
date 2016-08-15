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
    view :by_primary_and_relationship_type
    view :by_relationship_type
    view :by_site_code
    view :by_updated_at
    view :by_created_at
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

  def self.get_person_relations(national_id)
    mother = "Mother"
    father = "Father"
    
    relations_hash = {
      :father => {:first_name => "", :last_name => ""},
      :mother => {:first_name => "", :last_name => ""}
    }

    mother_details = Relationship.by_primary_and_relationship_type.keys([[national_id, mother]]).last
    father_details = Relationship.by_primary_and_relationship_type.keys([[national_id, father]]).last

    unless mother_details.blank?
      mothers_id = mother_details.secondary
      person = Person.by__id(:key => mothers_id).last
      names = person.names
      first_name = names.given_name
      last_name = names.family_name
      relations_hash[:mother][:first_name] = first_name
      relations_hash[:mother][:last_name] = last_name
    end

    unless father_details.blank?
      fathers_id = father_details.secondary
      person = Person.by__id(:key => fathers_id).last
      names = person.names
      first_name = names.given_name
      last_name = names.family_name
      relations_hash[:father][:first_name] = first_name
      relations_hash[:father][:last_name] = last_name
    end

    return relations_hash
  end

end
