module UserSessionStartup
  protected


#############################################################################################################
def startup_user_session
           logger.debug  "  request.session_options[:id] " +   request.session_options[:id].to_s
           logger.debug "BEGIN ------------------------------/lib/user_session_startup/startup_user_session"
           @user_session = Caching::MemoryCache.instance.read request.session_options[:id] + '_user_session'  unless cache_on? == false
           logger.debug "@user_session already found using cache " if @user_session
                if @user_session
                                 logger.debug "@user_session already found "
                else
                                    if UserSession.exists?(:id =>  request.session_options[:id]    )
                                              @user_session = UserSession.select(:id).where(" id = ?",  request.session_options[:id]  ).first           #"session_id = ?",  request.session_options[:id]  ).first         #id = ?",  request.session_options[:id]  ).first
                                              logger.warn "----------------------------------found @user_session by ActiveRecord"
                                    else
                                              @user_session = UserSession.new
                                              logger.debug "request.session_options[:id].to_s: " +  request.session_options[:id].to_s
                                              @user_session.id = request.session_options[:id].to_s #@user_session.session_id = request.session_options[:id]
                                              @user_session.save
                                              logger.warn "--WARN-------------------------------@user_session created by UserSession.new"
                                    end
                                    Caching::MemoryCache.instance.write request.session_options[:id] + '_user_session' , @user_session unless cache_on? == false
                end

          logger.debug "END --------------------------------lib/user_session_startup/startup_user_session"
end
###############################################################################################################


end



#		@user_session = Caching::MemoryCache.instance.read request.session_options[:id] + '_user_session'  unless cache_on? == false
#		if !@user_session
#    @c = 'c'
#			@user_session = UserSession.find_or_create_by_session_id(  request.session_options[:id]  )
#		else
#			logger.debug "-------------------------------------found @user_session by Caching"
#		end


#
#def ip_hit_count_per_minute
#                 @ip_hit_count = Caching::MemoryCache.instance.read request.ip + '_ip_address'  unless cache_on? == false
#
#
#
#                 if @ip_hit_count
#                        @ip_hit_count  += 1
#                 else
#                        @ip_hit_count = 1
#                 end
#                Caching::MemoryCache.instance.write request.ip + '_ip_address' , @ip_hit , :expires_in => 1.minutes   unless cache_on? == false
#
#                 $stdout.puts "@ip_hit_count_per_minute: " + @ip_hit.to_s
#end

#def has_cookies?
#          $stdout.puts "request.cookies[SESSION_KEY].blank?: " + request.cookies[SESSION_KEY].blank?
#         request.cookies[SESSION_KEY].blank?
#end