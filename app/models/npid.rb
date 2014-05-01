require 'couchrest_model'

class Npid < CouchRest::Model::Base

=begin  
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
=end
  
  property :national_id, String  
  property :site_code, String
  property :assigned, TrueClass, :default => false
  property :region, String
  
  timestamps!
  
  def self.where(params = {})
    result = []
    limit = 0
    
    if !params[:site].blank? and !params[:start].nil? and !params[:limit].nil? and params[:start].strip.downcase == "last"
      
      npids = Npid.assigned_to_region.collect{|e| e if (e.site_code.downcase.strip == params[:site].strip.downcase rescue false)}.compact.uniq
      
      limit = npids.length
      
      if npids.length > 0
      
        params[:start] = ((npids.length / params[:limit].to_i) * params[:limit].to_i)
        
        params[:start] = (params[:start].to_i - params[:limit].to_i) if (params[:start].to_i == npids.length)
        
        ((params[:start].to_i)..(npids.length - 1)).each do |i|
           
          person = Person.find_by__id(npids[i].national_id) rescue nil
          
          result << {
            npid: npids[i].national_id,
            assigned: npids[i].assigned,
            region: npids[i].region,
            sitecode: npids[i].site_code,
            name: ("#{person.names.given_name} #{person.names.family_name}" rescue nil),
            updated: (npids[i].updated_at.strftime("%Y-%m-%d %H:%M") rescue nil),
            pos: npids[i].id
          } 
          
        end
      
      else
        params[:start] = 0
      end
      
    elsif !params[:site].blank? and !params[:start].nil? and !params[:limit].nil?

      npids = Npid.assigned_to_region.collect{|e| e if (e.site_code.downcase.strip == params[:site].strip.downcase rescue false)}.compact.uniq
      
      if npids.length > 0
      
        limit = npids.length
      
        params[:limit] = (npids.length - params[:start].to_i) if ((params[:start].to_i + params[:limit].to_i - 1) > npids.length)
        
        # raise "#{params[:limit]} : #{params[:start]} : #{npids.length}"
        
        ((params[:start].to_i)..(params[:start].to_i + params[:limit].to_i - 1)).each do |i|
           
          person = Person.find_by__id(npids[i].national_id) rescue nil
          
          result << {
            npid: npids[i].national_id,
            assigned: npids[i].assigned,
            region: npids[i].region,
            sitecode: npids[i].site_code,
            name: ("#{person.names.given_name} #{person.names.family_name}" rescue nil),
            updated: (npids[i].updated_at.strftime("%Y-%m-%d %H:%M") rescue nil),
            pos: npids[i].id
          } 
          
        end
      
      else
        params[:start] = 0
      end
        
    end
    
    [result, params[:start], limit]
  end

  design do
    view :by__id
    view :by__national_id
    view :by_site_code
    
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
