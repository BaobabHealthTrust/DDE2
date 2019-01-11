module Ws
  module Rest
    class V1Controller < ActionController::Base
           
      before_filter :check_login  
      
      def active_tasks
        
        tasks = RestClient.get("http://#{CONFIG["username"]}:#{CONFIG["password"]}@#{CONFIG["host"]}:#{CONFIG["port"]}/_active_tasks")
        
        render :text => tasks
        
      end    
                                  
      def login!(user)
        session[:current_user_id] = user.id
        @@current_user = user
      end

      def logout!
        session[:current_user_id] = nil
        @@current_user = nil
      end
      
      protected

        def check_login
          if session[:current_user_id].blank?
            authenticate
          end
        end

        def authenticate
          
          authenticate_or_request_with_http_basic do |username, password|
          
            user = Utils::UserUtil.get_active_user(username)
            
            if user and user.password_matches?(password)
              login! user
            else        
              render :text => {error: "Access Denied!"}.to_json + "\n"
            end
          
          end
        end
    
    end
  end
end
