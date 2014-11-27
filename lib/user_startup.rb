module UserStartup
  protected	
############################################################################################################	
def startup_user
		logger.debug "BEGIN ------------------------------ startup_user "
     find_user
        if @user
                  logger.debug "-------------------------------------@user, about to set up @user_array"
                  @user_array ||= @user
                  @user_array_user_type_id = Caching::MemoryCache.instance.read request.session_options[:id]  + '_user_array_user_type_id_' + @user.id.to_s unless cache_on? == false
                  if @user_array_user_type_id
                          logger.debug "@user_array_user_type_id found using cache"
                  else
                           logger.debug "@user_array_user_type_id NOT found using cache"
                          if  admin?
                                  @user_array_user_type_id = @user.user_type_id.to_s
                          else
                                  @user_array_user_type_id = '4'
                          end
                          logger.debug "-------------------------------------about to write cache for @user_array"
                          Caching::MemoryCache.instance.write request.session_options[:id]  + '_user_array_user_type_id_' + @user.id.to_s , @user_array_user_type_id unless cache_on? == false
                  end
        else
                logger.debug "-------------------------------------did NOT FIND @user, about to set up @user_array"
                @user_array_user_type_id = 4.to_s
                unless @user_array
                        @user_array = []
                         @user_array = User.new
                end
        end
        logger.debug '0000000 admin?:  ' + admin?.to_s  + '   00000000000000'
        logger.debug "END ------------------------------lib/startup_user/startup_user"
end
############################################################################################################
def find_user
            logger.debug "BEGIN ------------------------------lib/startup_user/find_user"
           # if session[:user_id]
           #          @user = Caching::MemoryCache.instance.read request.session_options[:id]  + '_user_' + session[:user_id].to_s unless cache_on? == false
           # else
           #          logger.debug "session[:user_id] @user not found using cache- "
           # end
           #  if @user
           #                       logger.debug "@user has been found by cache "
           #  else
                                  if current_user and current_user != :false
                                               logger.debug "current_user.inspect: " + current_user.inspect

                                              if User.exists?(:id => current_user.id   )
                                                        @user ||= User.find(current_user.id )
                                                         session[:user_id] = @user.id
                                                         # if @user
                                                         #      Caching::MemoryCache.instance.write request.session_options[:id]  + '_user_' + session[:user_id].to_s, @user unless  cache_on? == false
                                                         # end
                                              else
                                                  logger.debug "FALSE ON User.exists?(:id => current_user.id   )"
                                              end
                                  else
                                      logger.debug "FALSE ON  != :false -- current_user.inspect: " + current_user.inspect
                                  end
            # end
            # g = "g"
 	logger.debug "END --------------------------------lib/startup_user/find_user"
end	
############################################################################################################ 
def user_can?(action)
  user = @user
#  if session[:user]
#  	 user = User.find(session[:user_id])
#	   if request.subdomains.include?("us")
	    	return user && user.can?(action, @website)
#	   else
#	    	return false
#	   end
#  end
end
###########################################################################################################



end





#            logger.debug "current_user : " + current_user.to_s
#  if session[:user_id]
#            logger.debug  "session[:user_id] : " + session[:user_id].to_s
#  else
#             logger.debug "session[:user_id]  IS NOT SET "
#  end