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

end
