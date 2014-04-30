require 'couchrest_model'

class Npid < CouchRest::Model::Base

  
  def incremental_id
    self['_id']
  end

  def self.last_id
    previous_id = self.by__id.last.id rescue 0
    return previous_id
  end

  def incremental_id=(value) 
       self['_id'] = (value.to_i + 1).to_s
  end
  
  property :national_id, String  
  property :site_code, String
  property :assigned, TrueClass, :default => false
  property :region, String
  
  timestamps!

  design do
    view :by__id
    view :by__national_id
    
    # Site views
    view :unassigned_to_site,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['site_code'] == ''){
                  emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned});
            }
          }"
    view :unassigned_at_site,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['site_code'] == '#{Site.current_code}' && !doc.assigned ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned});
            }
          }"
    view :assigned_at_site,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['site_code'] == '#{Site.current_code}' && doc.assigned ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned});
            }
          }"
    view :assigned_to_site,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['site_code'] == '#{Site.current_code}' ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned});
            }
          }"
          
    # Current Region views    
    view :unassigned_to_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && (doc['region'] == '' || doc['region'] == null)){
                  emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :unassigned_at_this_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == '#{Site.current_region}' && (doc['site_code'] == '' || doc['site_code'] == null) ){
              emit(doc.region, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :assigned_at_this_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == '#{Site.current_region}' && (doc['site_code'] != '' && doc['site_code'] != null) && doc.assigned ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :assigned_to_this_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == '#{Site.current_region}' ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :untaken_at_this_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == '#{Site.current_region}' && (doc['site_code'] != '' && doc['site_code'] != null) && !doc.assigned ){
              emit(doc.region, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    # General views
    view :unassigned_at_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && (doc['site_code'] == '' || doc['site_code'] == null) ){
              emit(doc.region, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :assigned_at_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && (doc['site_code'] != '' && doc['site_code'] != null) && doc.assigned ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :assigned_to_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] != '' && doc['region'] != null ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :untaken_at_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] != '' && doc['region'] != null && (doc['site_code'] != '' && doc['site_code'] != null) && !doc.assigned ){
              emit(doc.region, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
          
    # Central Region views 
    view :unassigned_at_central_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'Centre' && (doc['site_code'] == '' || doc['site_code'] == null) ){
              emit(doc.region, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :assigned_at_central_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'Centre' && (doc['site_code'] != '' && doc['site_code'] != null) && doc.assigned ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :allocated_to_central_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'Centre' ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :available_at_central_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'Centre' && (doc['site_code'] != '' && doc['site_code'] != null) && !doc.assigned ){
              emit(doc.region, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
          
    # Northern Region views 
    view :unassigned_at_northern_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'North' && (doc['site_code'] == '' || doc['site_code'] == null) ){
              emit(doc.region, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :assigned_at_northern_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'North' && (doc['site_code'] != '' && doc['site_code'] != null) && doc.assigned ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :allocated_to_northern_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'North' ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :available_at_northern_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'North' && (doc['site_code'] != '' && doc['site_code'] != null) && !doc.assigned ){
              emit(doc.region, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
          
    # Southern Region views 
    view :unassigned_at_southern_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'South' && (doc['site_code'] == '' || doc['site_code'] == null) ){
              emit(doc.region, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :assigned_at_southern_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'South' && (doc['site_code'] != '' && doc['site_code'] != null) && doc.assigned ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :allocated_to_southern_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'South' ){
              emit(doc.national_id, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"
    view :available_at_southern_region,
         :map => "function(doc){
            if (doc['type'] == 'Npid' && doc['region'] == 'South' && (doc['site_code'] != '' && doc['site_code'] != null) && !doc.assigned ){
              emit(doc.region, {id: doc._id ,national_id: doc.national_id, site_id: doc.site_code, assigned: doc.assigned, region: doc.region});
            }
          }"         
         
  end
  
  

end
