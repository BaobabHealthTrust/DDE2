class ServicesController < ApplicationController

  def check_thresholds
    result = Utils::Master.check_site_thresholds()
    
    render :text => result
  end
  
  def process_queued_sites
    result = Utils::Master.process_queued_sites()
    
    render :text => result
  end

  def check_site_code    
    if !params["sitecode"].nil?
      result = Site.find_by__id(params["sitecode"]) # rescue nil
     
      render :text => result.nil? and return
    else
      render :text => true and return
    end
  end
  
  def search_by_site_code
    result = Site.find_by__id(params["id"]) rescue nil
    
    hash = {}
    
    if !result.nil?
      hash = {
        name: result.name,
        description: result.description,
        region: result.region,
        threshold: result.threshold,
        batchsize: result.batch_size,
        x: result.x,
        y: result.y,
        sitecount: result.site_id_count
      }
    end
    
    render :json => hash.to_json
    
  end

  def check_region_allocation
    limit = Npid.unassigned_to_region.count
    
    if !params["quantity"].nil?
      render :text => (params["quantity"].to_i < limit.to_i and limit.to_i > 0) and return
    else
      render :text => false and return
    end
  end

  def check_site_allocation
    
    if !params["quantity"].nil? and !params[:site].nil?
    
      limit = 0
      
      site = Site.find_by__id(params[:site]) # rescue nil
      
      if !site.nil?
        
        case site.region.downcase
          when "centre"
            limit = Npid.unassigned_at_central_region.count
          when "north"
            limit = Npid.unassigned_at_northern_region.count
          when "south"
            limit = Npid.unassigned_at_southern_region.count
        end
      
        render :text => (params["quantity"].to_i <= limit.to_i and limit.to_i > 0) and return
        
      else
        
        render :text => false and return
        
      end
    else
      render :text => false and return
    end
  end

  def search_for_patients_by_site
    
    hash = []
    
    if !params["site"].nil? and !params["start"].nil? and !params["limit"].nil? and params["start"].strip.downcase == "last"
    
      hash = Npid.where({site: params["site"], start: params["start"], limit: params["limit"]})
      
    elsif !params["site"].nil? and !params["start"].nil? and !params["limit"].nil?
    
      hash = Npid.where({site: params["site"], start: params["start"], limit: params["limit"]})
      
    elsif !params["site"].nil? and !params["limit"].nil?
    
      hash = Npid.where({site: params["site"], start: params["start"], limit: params["limit"]})
      
    end
    
    render :json => hash.to_json
    
  end

end
