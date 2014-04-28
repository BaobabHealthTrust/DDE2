logger = Logger.new("#{Rails.root}/log/background_processes_thresholds.log")

settings = YAML.load_file(Rails.root.join('config', 'couchdb.yml'))[Rails.env]

logger.info("Running in '#{(!settings["mode"].nil? ? settings["mode"] : "undefined")}' mode")

# logger.debug(request.inspect)

if !settings["mode"].nil? && Rails.env.downcase != "test"

  if settings["mode"].to_s.strip.downcase == "master"

    Thread.new do |t|
      
      while true
      
        # Wait for server to warm up
        sleep 1000
        
        logger.info("Checking thresholds")
        
        result = RestClient.get("http://localhost:#{settings["port"] rescue 3000}/check_thresholds") rescue "nothing"
        
        logger.info("Received #{result}")
        
        # Wait a bit in case other processes are being affected by this thread
        sleep 1000
        
        logger.info("Processing queues")
        
        result = RestClient.get("http://localhost:#{settings["port"] rescue 3000}/process_queued_sites") rescue "nothing"
        
        logger.info("Received #{result}")
        
      end

    end
  
  end

end
