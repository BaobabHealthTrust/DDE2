logger = Logger.new("#{Rails.root}/log/background_processes_thresholds.log")

settings = YAML.load_file(Rails.root.join('config', 'couchdb.yml'))[Rails.env]

logger.info("Running in '#{(!settings["mode"].nil? ? settings["mode"] : "undefined")}' mode")

if !settings["mode"].nil? && Rails.env.downcase != "test"

  if settings["mode"].to_s.strip.downcase == "master"

    Thread.new do |t|
      
      while true
        
        logger.info("Checking thresholds")
        
        result = RestClient.get("http://localhost:3000/check_thresholds") rescue "nothing"
        
        logger.info("Received #{result}")
        
        sleep 1000
        
        logger.info("Processing queues")
        
        result = RestClient.get("http://localhost:3000/process_queued_sites") rescue "nothing"
        
        logger.info("Received #{result}")
        
        sleep 1000
        
      end

    end
  
  end

end
