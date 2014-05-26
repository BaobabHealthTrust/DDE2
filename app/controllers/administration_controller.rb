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
    
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
    Site.create(
        site_code: params["sitecode"],
        name: params["sitename"],
        site_type: params["site_type"],
        ip_address: params["ip_address"],
        username: params["username"],
        password: params["password"],
        site_db1: params["site_db1"],
        site_db2: params["site_db2"],
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
    
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
    @sitecodes = Site.all.collect{|s| [s.site_code, s.name]}
  end

  def update_site
  
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
    site = Site.find_by__id(params["sitecode"]) rescue nil
    
    if !site.nil?
      result = site.update_attributes(
        site_code: params["sitecode"],
        name: params["sitename"],
        site_type: params["site_type"],
        ip_address: params["ip_address"],
        username: params["username"],
        password: params["password"],
        site_db1: params["site_db1"],
        site_db2: params["site_db2"],
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
    
    redirect_to "/administration/site_edit" and return
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
  
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
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
  
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
    if !params[:region].nil? and !params[:quantity].nil?
      Utils::Master.assign_npids_to_region(params[:region], params[:quantity])
    end
    
    redirect_to "/administration/region_edit?region=#{params[:region]}" and return
  end

  def assign_npids_to_site
  
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
    if !params[:site].nil? and !params[:quantity].nil?
      Utils::Master.assign_npids_to_site(params[:site], params[:quantity])
    end
    
    redirect_to "/administration/site_assign?site=#{params[:site]}" and return
  end

  def connection_add
  
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
    @sitecodes = Site.all.collect{|s| [s.site_code, s.name]}
  end

  def connection_edit
  
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
    @sitecodes = Site.all.collect{|s| [s.site_code, s.name]}
    
    @connections = Connection.all.collect{|s| [s.src_sink, "#{Site.find_by__id(s.source).name rescue nil} -> #{Site.find_by__id(s.sink).name rescue nil}"]}
  end

  def connection_show
    @sitecodes = Site.all.collect{|s| [s.site_code, s.name]}
    
    @connections = Connection.all.collect{|s| [s.src_sink, "#{Site.find_by__id(s.source).name rescue nil} -> #{Site.find_by__id(s.sink).name rescue nil}"]}
  end

  def connection_create
  
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
    if !params[:source].nil? and !params[:sink].nil?          
      source = Site.find_by__id(params[:source]) rescue nil      
      sink = Site.find_by__id(params[:sink]) rescue nil
              
      if !source.nil? and !sink.nil? 
      
=begin               
        if Rails.env.downcase == "development" or Rails.env.downcase == "test"          
          result = RestClient.get("http://#{source.username}:#{source.password}@#{source.ip_address}:5984/#{source.site_db1}") rescue nil          
          if result.nil?         
            result = RestClient.put("http://#{source.username}:#{source.password}@#{source.ip_address}:5984/#{source.site_db1}", {}.to_json) # rescue nil            
          end
          result = RestClient.get("http://#{sink.username}:#{sink.password}@#{sink.ip_address}:5984/#{sink.site_db1}") rescue nil 
          if result.nil?          
            result = RestClient.put("http://#{sink.username}:#{sink.password}@#{sink.ip_address}:5984/#{sink.site_db1}", {}.to_json) # rescue nil
          end                
          result = RestClient.get("http://#{source.username}:#{source.password}@#{source.ip_address}:5984/#{source.site_db2}") rescue nil          
          if result.nil?         
            result = RestClient.put("http://#{source.username}:#{source.password}@#{source.ip_address}:5984/#{source.site_db2}", {}.to_json) # rescue nil            
          end
          result = RestClient.get("http://#{sink.username}:#{sink.password}@#{sink.ip_address}:5984/#{sink.site_db2}") rescue nil 
          if result.nil?          
            result = RestClient.put("http://#{sink.username}:#{sink.password}@#{sink.ip_address}:5984/#{sink.site_db2}", {}.to_json) # rescue nil
          end       
        end
=end
        
        at_least_one_db_to_sync = false
        
        if !source.site_db1.blank? and !sink.site_db1.blank?
          result = %x[curl -H 'Content-Type: application/json' -X POST -d '#{{
              source: "http://#{source.ip_address}:5984/#{source.site_db1}",
              target: "http://#{sink.ip_address}:5984/#{sink.site_db1}",
              connection_timeout: 60000,
              retries_per_request: 20,
              http_connections: 30,
              continuous: true
            }.to_json}' "http://#{source.username}:#{source.password}@#{source.ip_address}:5984/_replicate"]
          
=begin            
          result = %x[curl -H 'Content-Type: application/json' -X POST -d '#{{
              source: "http://#{sink.ip_address}:5984/#{sink.site_db1}",
              target: "http://#{source.ip_address}:5984/#{source.site_db1}",
              connection_timeout: 60000,
              retries_per_request: 20,
              http_connections: 30,
              continuous: true
            }.to_json}' "http://#{sink.username}:#{sink.password}@#{sink.ip_address}:5984/_replicate"]
=end
            
          at_least_one_db_to_sync = true
        end
          
        if !source.site_db2.blank? and !sink.site_db2.blank?
          result = %x[curl -H 'Content-Type: application/json' -X POST -d '#{{
              source: "http://#{source.ip_address}:5984/#{source.site_db2}",
              target: "http://#{sink.ip_address}:5984/#{sink.site_db2}",
              connection_timeout: 60000,
              retries_per_request: 20,
              http_connections: 30,
              continuous: true
            }.to_json}' "http://#{source.username}:#{source.password}@#{source.ip_address}:5984/_replicate"]
            
=begin            
          result = %x[curl -H 'Content-Type: application/json' -X POST -d '#{{
              source: "http://#{sink.ip_address}:5984/#{sink.site_db2}",
              target: "http://#{source.ip_address}:5984/#{source.site_db2}",
              connection_timeout: 60000,
              retries_per_request: 20,
              http_connections: 30,
              continuous: true
            }.to_json}' "http://#{sink.username}:#{sink.password}@#{sink.ip_address}:5984/_replicate"]
=end
            
          at_least_one_db_to_sync = true
        end
          
        Connection.create(src_sink: "#{params[:source]}-#{params[:sink]}", source: params[:source], sink: params[:sink]) if at_least_one_db_to_sync
             
      end      
    end    
    redirect_to "/administration/connection_add" and return
  end

  def connection_update
  
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
    src = params[:connection].split("-") rescue []
    
    source = Site.find_by__id(src[0]) rescue nil      
    sink = Site.find_by__id(src[1]) rescue nil
            
    if !source.nil? and !sink.nil? 
      result = %x[curl -H 'Content-Type: application/json' -X POST -d '#{{
          source: "http://#{source.ip_address}:5984/dde_#{source.site_code.downcase}",
          target: "http://#{sink.ip_address}:5984/dde_#{sink.site_code.downcase}",
          connection_timeout: 60000,
          retries_per_request: 20,
          cancel: true
        }.to_json}' "http://#{source.username}:#{source.password}@#{source.ip_address}:5984/_replicate"]
        
      result = %x[curl -H 'Content-Type: application/json' -X POST -d '#{{
          source: "http://#{sink.ip_address}:5984/dde_#{sink.site_code.downcase}",
          target: "http://#{source.ip_address}:5984/dde_#{source.site_code.downcase}",
          connection_timeout: 60000,
          retries_per_request: 20,
          http_connections: 30,
          cancel: true
        }.to_json}' "http://#{sink.username}:#{sink.password}@#{sink.ip_address}:5984/_replicate"]
                  
      Connection.find_by__id(params[:connection]).destroy rescue nil
    end
    
    redirect_to "/administration/connection_edit" and return
  end

  def sync_map
    @sites = []
    
    if !params[:src].blank?
      src = params[:src].split("-")
    
      if src.length > 1
        
        source = Site.find_by__id(src[0]) rescue nil
        target = Site.find_by__id(src[1]) rescue nil
        
        if !source.nil? and !target.nil?
          site = {
            source: {
              sitecode: source.site_code,
              region: source.region,
              x: source.x,
              y: source.y,
              name: source.name,
              type: source.site_type,
              ip_address: source.ip_address
            },
            target: {
              sitecode: target.site_code,
              region: target.region,
              x: target.x,
              y: target.y,
              name: target.name,
              type: target.site_type,
              ip_address: target.ip_address
            },
            label: (params[:src] rescue nil)
          } 
          
          @sites << site 
        end
      end
    else 
      Connection.all.rows.each do |row|
        src = row["key"].split("-") rescue []
      
        if src.length > 1
          
          source = Site.find_by__id(src[0]) rescue nil
          target = Site.find_by__id(src[1]) rescue nil
          
          if !source.nil? and !target.nil?
            site = {
              source: {
                sitecode: source.site_code,
                region: source.region,
                x: source.x,
                y: source.y,
                name: source.name,
                type: source.site_type,
                ip_address: source.ip_address
              },
              target: {
                sitecode: target.site_code,
                region: target.region,
                x: target.x,
                y: target.y,
                name: target.name,
                type: target.site_type,
                ip_address: target.ip_address
              },
              label: (row["key"] rescue nil)
            } 
            
            @sites << site 
          end
        end
      end
    end
    
    # raise @sites.inspect
    
    render :layout => false
  end
  
  def site_assign
  
    if CONFIG["master-master"].nil? 
      redirect_to "/" and return
    end
    
    if !CONFIG["master-master"].nil? and !CONFIG["master-master"]
      redirect_to "/" and return
    end
    
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

end
