module Utils

  class UserUtil
  
    def self.create(params)
      user = User.new()
      user.username = params[:user]['username']
      user.password_hash = params[:user]['password']
      user.first_name = params[:user]['first_name']
      user.last_name = params[:user]['last_name']
      user.role = params[:user]['role']
      user.site_code = 'XXXX'
      user.email = 'XXXX@XXXX'
      user.save
      return user
    end

  end
end
