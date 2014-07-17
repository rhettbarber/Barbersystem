module StartupOptimusPrime

def startup_optimus_prime
    @optimus_prime_on = true
		if @optimus_prime_on == true
				ensure_session_user_agent_stability
				logger.warn "OPTIMUS PRIME PROTECTED"
		else
				logger.warn "OPTIMUS PRIME OFF"
		end
end


def ensure_session_user_agent_stability
		logger.debug "BEGIN ------------------------------lib/startup_optimus_prime/ensure_session_user_agent_stability"
		
		if request.env["HTTP_USER_AGENT"].nil?
				######### THIS MAY BE TOO HARSH
				logger.warn "MAY HAVE BEEN TO HARSH ON IP: #{request.remote_ip}"
			add_security_warning(4)
		end
		
		@cache_expiration = 5.hours
		@ensure_session_user_agent_stability_cache_string =  request.session_options[:id].to_s + '_user_agent'
		@session_last_user_agent  = Rails.cache.read @ensure_session_user_agent_stability_cache_string
   begin
		Rails.cache.write @ensure_session_user_agent_stability_cache_string , request.env["HTTP_USER_AGENT"].delete(" ")    , :expires_in => @cache_expiration
   rescue
     end
		logger.debug "READ CACHE STRING: #{@ensure_session_user_agent_stability_cache_string}"
		logger.debug " request.env[HTTP_USER_AGENT].delete(" ") : #{ request.env["HTTP_USER_AGENT"].delete(" ") }"
		if @session_last_user_agent
							if  @session_last_user_agent ==  request.env["HTTP_USER_AGENT"].delete(" ")
										logger.debug "GOOD!!!! ---------------- user agent matches last known for session"
							elsif @threat_level_high
										logger.warn "Error 606 ---------- Please call our webmaster at 1-800-448-3062"
										logger.warn "WARN!!!! ---------------- user agent DOES NOT MATCH last known for session"
										logger.warn "@session_last_user_agent: #{@session_last_user_agent}"
										logger.warn "request.env HTTP_USER_AGENT: #{ request.env["HTTP_USER_AGENT"]}"
										logger.warn "WARN!!!! ---------------- reset_session_and_redirect"
										logger.warn "SESSION CHANGED USER AGENT!!!!"
										logger.warn "SESSION CHANGED USER AGENT!!!!"
										logger.warn "SESSION CHANGED USER AGENT!!!!"
										@error_description_string = "SESSION CHANGED USER AGENT!!!!"
										send_error_to_admin
										add_security_warning(4)
										perform_token_rescue
							else
									add_security_warning(1)
									logger.warn "SESSION CHANGED USER AGENT!!!!"
									@error_description_string = "SESSION CHANGED USER AGENT!!!!"
									send_error_to_admin
									reset_session  #TO DO: VERIFY SESSION ENTRY IS DELETED!
									render :text => " Problem accessing website, Please try updating or swiching your web browser. Try google chrome at: http://google.com/chrome "
							end
			else
					logger.warn "WARN!!!! ---------------- ERROR READING @session_last_user_agent CACHE" unless session[:first_request].nil?
					session[:first_request] = 1
			end
			logger.debug "DEBUG ------------------------------@session_last_user_agent: #{@session_last_user_agent}"
			logger.debug "END ------------------------------lib/startup_optimus_prime/ensure_session_user_agent_stability"
end





end
