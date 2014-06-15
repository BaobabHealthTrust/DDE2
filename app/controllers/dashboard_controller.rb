class DashboardController < ActionController::Base 

  def person_map
    @connections = []
    @sites = []
    
    Site.list.rows.each do |source|
    
      row = source.value
      
      site = {
        site_code: row["site_code"],
        region: row["region"],
        x: row["x"],
        y: row["y"],
        name: row["name"],
        type: row["site_type"],
        ip_address: row["ip_address"]
      }
    
      @sites << site 
    end
    
    Connection.all.rows.each do |row|
      src = row["key"].split("-") rescue []
    
      if src.length > 1
        
        source = Site.find_by__id(src[0]) rescue nil
        target = Site.find_by__id(src[1]) rescue nil
        
        if !source.nil? and !target.nil?
          site = {
            source: {
              site_code: source.site_code,
              region: source.region,
              x: source.x,
              y: source.y,
              name: source.name,
              type: source.site_type,
              ip_address: source.ip_address
            },
            target: {
              site_code: target.site_code,
              region: target.region,
              x: target.x,
              y: target.y,
              name: target.name,
              type: target.site_type,
              ip_address: target.ip_address
            },
            label: (row["key"] rescue nil),
            data: 0
          } 
          
          @connections << site 
        end
      end
    end
      
    # raise @sites.inspect
      
    render :layout => false
  end

  def npids_map
    @connections = []
    @sites = []
    
    Site.list.rows.each do |source|
    
      row = source.value
      
      site = {
        site_code: row["site_code"],
        region: row["region"],
        x: row["x"],
        y: row["y"],
        name: row["name"],
        type: row["site_type"],
        ip_address: row["ip_address"]
      }
    
      @sites << site 
    end
    
    Connection.all.rows.each do |row|
      src = row["key"].split("-") rescue []
    
      if src.length > 1
        
        source = Site.find_by__id(src[0]) rescue nil
        target = Site.find_by__id(src[1]) rescue nil
        
        if !source.nil? and !target.nil?
          site = {
            source: {
              site_code: source.site_code,
              region: source.region,
              x: source.x,
              y: source.y,
              name: source.name,
              type: source.site_type,
              ip_address: source.ip_address
            },
            target: {
              site_code: target.site_code,
              region: target.region,
              x: target.x,
              y: target.y,
              name: target.name,
              type: target.site_type,
              ip_address: target.ip_address
            },
            label: (row["key"] rescue nil),
            data: 0
          } 
          
          @connections << site 
        end
      end
    end
      
    # raise @sites.inspect
      
    render :layout => false
  end

  def ajax_connections
  
    @sites = {sites: [], connections: []}
  
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
              continuous:               conn["continuous"],
              doc_write_failures:       conn["doc_write_failures"],
              docs_read:                conn["docs_read"],
              docs_written:             conn["docs_written"],
              replication_id:           conn["replication_id"],
              started_on:               conn["started_on"],
              updated_on:               conn["updated_on"],
              missing_revisions_found:  conn["missing_revisions_found"],
              progress:                 conn["progress"],
              revisions_checked:        conn["revisions_checked"],
              source_seq:               conn["source_seq"],
              checkpointed_source_seq:  conn["checkpointed_source_seq"],
              pid:                      conn["pid"]
            }
      
    end
    
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
          
          site[:status] = {}
            
          if !connections[[source.ip_address, source.site_db1, target.ip_address, target.site_db1]].blank?
            
            site[:status][:person] = connections[[source.ip_address, source.site_db1, target.ip_address, target.site_db1]]
            
          else
          
            sync = %x[curl -H 'Content-Type: application/json' -X POST -d '#{{
              source: "http://#{source.ip_address}:5984/#{source.site_db1}",
              target: "http://#{target.ip_address}:5984/#{target.site_db1}",
              connection_timeout: 60000,
              retries_per_request: 20,
              http_connections: 30,
              continuous: true
            }.to_json}' "http://#{source.username}:#{source.password}@#{source.ip_address}:5984/_replicate"]          
            
          end
          
          if !connections[[source.ip_address, source.site_db2, target.ip_address, target.site_db2]].blank?
            
            site[:status][:npid] = connections[[source.ip_address, source.site_db2, target.ip_address, target.site_db2]]
            
          else
          
            result = %x[curl -H 'Content-Type: application/json' -X POST -d '#{{
              source: "http://#{source.ip_address}:5984/#{source.site_db2}",
              target: "http://#{target.ip_address}:5984/#{target.site_db2}",
              connection_timeout: 60000,
              retries_per_request: 20,
              http_connections: 30,
              continuous: true
            }.to_json}' "http://#{source.username}:#{source.password}@#{source.ip_address}:5984/_replicate"]
            
          end
          
          @sites[:connections] << site 
        end

      end
    end
  
    Site.list.rows.each do |source|
    
      row = source.value
      
      site = {
        site_code: row["site_code"],
        region: row["region"],
        x: row["x"],
        y: row["y"],
        name: row["name"],
        type: row["site_type"],
        ip_address: row["ip_address"]
      }
    
      @sites[:sites] << site 
    end
    
    render :json => @sites.to_json
  
  end

end
