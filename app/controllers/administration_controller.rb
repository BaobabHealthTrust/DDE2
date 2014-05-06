class AdministrationController < ApplicationController
  def index
    @sites = {
      "Centre" => {
        data: [],
        allocated: Npid.allocated_to_central_region.count,
        assigned: Npid.assigned_at_central_region.count,
        available: Npid.available_at_central_region.count,
        unassigned: Npid.unassigned_at_central_region.count,
        status: nil,
        national_untaken: Npid.unassigned_to_region.count
      },
      "North" => {
        data: [],
        allocated: Npid.allocated_to_northern_region.count,
        assigned: Npid.assigned_at_northern_region.count,
        available: Npid.available_at_northern_region.count,
        unassigned: Npid.unassigned_at_northern_region.count,
        status: nil,
        national_untaken: Npid.unassigned_to_region.count
      },
      "South" => {
        data: [],
        allocated: Npid.allocated_to_southern_region.count,
        assigned: Npid.assigned_at_southern_region.count,
        available: Npid.available_at_southern_region.count,
        unassigned: Npid.unassigned_at_southern_region.count,
        status: nil,
        national_untaken: Npid.unassigned_to_region.count
      }
    }
    
    Site.all.each{|s| 
      
        @sites[s.region][:data] << {
            sitecode: s.site_code,
            name: s.name,
            count: s.site_id_count,
            threshold: s.threshold,
            batchsize: s.batch_size,
            region: s.region,
            assigned: (Npid.assigned_at_region.keys([s.site_code]).rows.length rescue 0),
            allocated: (Npid.assigned_to_region.keys([s.site_code]).rows.length rescue 0),
            available: (Npid.untaken_at_region.keys([s.site_code]).rows.length rescue 0),
            status: nil
        } rescue nil
      
    }
    
    # raise @sites.inspect
  end
  
  def national_map
    @sites = Site.all.collect{|s| 
      {
        sitecode: s.site_code,
        name: s.name,
        count: s.site_id_count,
        threshold: s.threshold,
        batchsize: s.batch_size,
        region: s.region,
        x: s.x,
        y: s.y
      }
    }
    
    render :layout => false
  end
  
  def site_add
  end

  def map
    @region = params["region"] rescue nil
    @label = nil
    
    @region = "blank" if @region.blank?
    
    case @region.to_s.downcase
      when "centre"
        @label = "Central Region"
      when "north"
        @label = "Northern Region"
      when "south"
        @label = "Southern Region"
    end
    
    @x = nil
    @y = nil
    
    if !params["x"].blank?
      @x = params["x"]
    end
    
    if !params["y"].blank?
      @y = params["y"]
    end
    
    render :layout => false
  end

  def create_site
    
    Site.create(
        site_code: params["sitecode"],
        name: params["sitename"],
        description: params["description"],
        region: params["region"],
        batchsize: params["batchsize"],
        threshold: params["threshold"],
        x: params["x"],
        y: params["y"]
      )  
       
      redirect_to "/administration/site_add" and return
       
  end

  def site_edit
    @sitecodes = Site.all.collect{|s| s.site_code}
  end

  def update_site
    site = Site.find_by__id(params["sitecode"]) rescue nil
    
    if !site.nil?
      result = site.update_attributes(
          site_code: params["sitecode"],
          name: params["sitename"],
          description: params["description"],
          region: params["region"],
          batchsize: params["batchsize"],
          threshold: params["threshold"],
          x: params["x"],
          y: params["y"]
        ) rescue nil
        
      if !result.nil?
        flash[:notice] = "Site updated!"
      else 
        flash[:error] = "Sorry! Site update failed!"
      end
    else
      flash[:error] = "Sorry! Site update failed!"
    end
    
    redirect_to "/" and return
  end

  def site_show
    @sites = {}
    
    Site.all.each{|s| 
      
        @sites[s.site_code] = {
            sitecode: s.site_code,
            name: s.name,
            count: s.site_id_count,
            threshold: s.threshold,
            batchsize: s.batch_size,
            region: s.region,
            assigned: (Npid.assigned_at_region.keys([s.site_code]).rows.length rescue 0),
            allocated: (Npid.assigned_to_region.keys([s.site_code]).rows.length rescue 0),
            available: (Npid.untaken_at_region.keys([s.site_code]).rows.length rescue 0),
            status: nil,
            x: s.x,
            y: s.y
        }
      
    }
    
    # raise @sites.inspect
  end

  def regional_map
    @region = params["id"] rescue nil
    @label = nil
    
    @sites = Site.where({region: @region}) rescue []
    
    @region = "blank" if @region.blank?
    
    case @region.to_s.downcase
      when "centre"
        @label = "Central Region"
      when "north"
        @label = "Northern Region"
      when "south"
        @label = "Southern Region"
    end
    
    render :layout => false
  end

  def region_add
  end

  def region_edit
  end

  def region_show
    @sites = {
      "Centre" => {
        data: [],
        allocated: Npid.allocated_to_central_region.count,
        assigned: Npid.assigned_at_central_region.count,
        available: Npid.available_at_central_region.count,
        unassigned: Npid.unassigned_at_central_region.count,
        status: nil
      },
      "North" => {
        data: [],
        allocated: Npid.allocated_to_northern_region.count,
        assigned: Npid.assigned_at_northern_region.count,
        available: Npid.available_at_northern_region.count,
        unassigned: Npid.unassigned_at_northern_region.count,
        status: nil
      },
      "South" => {
        data: [],
        allocated: Npid.allocated_to_southern_region.count,
        assigned: Npid.assigned_at_southern_region.count,
        available: Npid.available_at_southern_region.count,
        unassigned: Npid.unassigned_at_southern_region.count,
        status: nil
      }
    }
    
    Site.all.each{|s| 
      
        @sites[s.region][:data] << {
            sitecode: s.site_code,
            name: s.name,
            count: s.site_id_count,
            threshold: s.threshold,
            batchsize: s.batch_size,
            region: s.region,
            assigned: (Npid.assigned_at_region.keys([s.site_code]).rows.length rescue 0),
            allocated: (Npid.assigned_to_region.keys([s.site_code]).rows.length rescue 0),
            available: (Npid.untaken_at_region.keys([s.site_code]).rows.length rescue 0),
            status: nil
        }
      
    }
  end

  def assign_npids_to_region
    if !params[:region].nil? and !params[:quantity].nil?
      Utils::Master.assign_npids_to_region(params[:region], params[:quantity])
    end
    
    redirect_to "/administration/region_show?region=#{params[:region]}" and return
  end

  def assign_npids_to_site
    if !params[:site].nil? and !params[:quantity].nil?
      Utils::Master.assign_npids_to_site(params[:site], params[:quantity])
    end
    
    redirect_to "/administration/site_show?site=#{params[:site]}" and return
  end

  def user_add
  end

  def user_edit
  end

  def user_show
  end

  def master_people
  end

  def proxy_people
  end
end
