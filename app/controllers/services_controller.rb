class ServicesController < ApplicationController

  def check_thresholds
    result = Utils::Master.check_site_thresholds()
    
    render :text => result
  end
  
  def process_queued_sites
    result = Utils::Master.process_queued_sites()
    
    render :text => result
  end

end
