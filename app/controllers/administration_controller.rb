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
        batch_size: params["batchsize"],
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
        batch_size: params["batchsize"],
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
            
    result = JSON.parse(RestClient.get("http://#{CONFIG["username"]}:#{CONFIG["password"]}@#{CONFIG["host"]}:5984/_active_tasks")) rescue []
  
    connections = {}
    
    result.each do |conn|
    
      src = conn["source"].strip.match(/(http\:\/\/(.+)\:\d+\/)?([^\/]+)/) # rescue nil
      
      tgt = conn["target"].strip.match(/(http\:\/\/(.+)\:\d+\/)?([^\/]+)/) # rescue nil
      
      connections[[
            (!src[2].nil? ? src[2] : "127.0.0.1"),
            src[3],
            (!tgt[2].nil? ? tgt[2] : "127.0.0.1"),
            tgt[3]
          ]] = {
              replication_id:           conn["replication_id"],
              pid:                      conn["pid"]
            }
      
    end
  
    if !source.nil? and !sink.nil? 
      if !connections[[source.ip_address, source.site_db1, sink.ip_address, sink.site_db1]].blank?
        result = %x[curl -H 'Content-Type: application/json' -X POST -d '#{{
            replication_id: "#{connections[[source.ip_address, source.site_db1, sink.ip_address, sink.site_db1]][:replication_id]}",
            cancel: true
          }.to_json}' "http://#{source.username}:#{source.password}@#{source.ip_address}:5984/_replicate"]
      end
      
      if !connections[[source.ip_address, source.site_db2, sink.ip_address, sink.site_db2]].blank?
        result = %x[curl -H 'Content-Type: application/json' -X POST -d '#{{
            replication_id: "#{connections[[source.ip_address, source.site_db2, sink.ip_address, sink.site_db2]][:replication_id]}",
            cancel: true
          }.to_json}' "http://#{source.username}:#{source.password}@#{source.ip_address}:5984/_replicate"]
      end
                  
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

  def search    
  end
  
  def ajax_search
    results = []
    
    results = []
    
    Person.search.keys(
        [[params["first_name"].soundex, 
        params["last_name"].soundex, 
        params["gender"]]]).page(params["page"].to_i).per(params["pagesize"].to_i).rows.collect{|person|
        
          id = person["id"]
        
          person = {"value" => {}}
          
          person["value"] = Person.find_by__id(id) rescue nil
          
          next if person["value"].nil?
        
          results << {
            name: "#{person["value"]["names"]["given_name"] rescue nil} #{person["value"]["names"]["family_name"] rescue nil}",
            gender: "#{(!person["value"]["gender"].blank? ? (person["value"]["gender"].strip.downcase == "f" ? "Female" : "Male") : "")}",
            dob: "#{(((person["value"]["birthdate_estimated"] and person["value"]["birthdate"].to_date.month == 7 and (person["value"]["birthdate"].to_date.day == 15 or person["value"]["birthdate"].to_date.day == 10 or person["value"]["birthdate"].to_date.day == 5)) ? "?" : person["value"]["birthdate"].to_date.day) rescue nil)}/#{(((person["value"]["birthdate_estimated"] and person["value"]["birthdate"].to_date.month == 7 and (person["value"]["birthdate"].to_date.day == 15 or person["value"]["birthdate"].to_date.day == 10)) ? "?" : person["value"]["birthdate"].to_date.strftime("%b")) rescue nil)}/#{(person["value"]["birthdate"].to_date.year rescue '?')}",
            current_address: "#{person["value"]["addresses"]["current_residence"] rescue nil}<br/>#{person["value"]["addresses"]["current_village"] rescue nil}<br/>#{person["value"]["addresses"]["current_ta"] rescue nil}<br/>#{person["value"]["addresses"]["current_district"] rescue nil}".gsub(/(\<br\/\>){3}|(\<br\/\>){2}|^\<br\/\>/,""),
            home_address: "#{person["value"]["addresses"]["home_village"] rescue nil}<br/>#{person["value"]["addresses"]["home_ta"] rescue nil}<br/>#{person["value"]["addresses"]["home_district"] rescue nil}".gsub(/(\<br\/\>){3}|(\<br\/\>){2}|^\<br\/\>/,""),
            national_id: "#{(0..(person["id"].length-1)).step(3).collect{|e| person["id"][e,3]}.join("-") rescue nil}",
            other_identifiers: "#{person["value"]["patient"]["identifiers"].collect{|id| id.keys[0] + ":" + (0..(id[id.keys[0]].length-1)).step(3).collect{|e| id[id.keys[0]][e,3]}.join("-")}.join("<br/>") rescue nil}"
          }
        }
    
    render :text => results.to_json
  end

  def footprint
    pid = params["npid"].gsub(/\-/, "") rescue nil
    
    @sites = []
    
    if !pid.blank?
      ids = []
      
      ids << pid
      
      Person.find_by__id(pid).patient.identifiers.each do |identifier|
      
        id = identifier[identifier.keys[0]] rescue nil
        
        ids << id if !id.blank?
      
      end rescue nil
      
      ids = ids.uniq
      
      # raise ids.inspect
      
      visits = Footprint.where_gone.keys(ids).rows rescue []
      
      visits.each do |visit|
        s = Site.find_by__id(visit["value"]["site"])
        
        site = {
          sitecode: s.site_code,
          name: "#{s.name} (#{visit["value"]["application"]} on #{visit["value"]["when"].to_time.to_s rescue nil})",
          region: s.region,
          x: s.x,
          y: s.y
        } rescue nil
        
        @sites << site if !site.nil?
      end
    end
    
    render :layout => false
  end

end
