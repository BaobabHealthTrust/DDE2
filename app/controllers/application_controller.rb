class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery	with: :null_session

  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
                                                                                
  #before_filter :perform_basic_auth, :except => ['login','logout','find','create']                         
  
  protected                                                                     
                                                                                
  def perform_basic_auth                                                        
    if session[:user_id].blank?                                                 
      respond_to do |format|                                                    
        format.html { redirect_to :controller => 'user',:action => 'logout' }   
      end                                                                       
    elsif not session[:user_id].blank?                                          
      User.current = User.find session[:user_id]
    end                                                                         
  end 

end
