module Affiliate
################################################################################################ 

def startup_logger
		logger  = Logger.new(STDOUT)
		logger.level = Logger::DEBUG
end

def startup_affiliate
		logger.warn('begin startup_affiliate')
		logger.warn('------------------------------------------------------------------------------------------------------------------------------------------')
		logger.warn( session[:affiliate_a_id] )
		begin
					if session[:affiliate_a_id]  == '0' or session[:affiliate_a_id]  == 0
								logger.warn("Do nothing, session has been determined as non-affiliate")
					else
									if params[:a_id] 
												logger.warn('params[:a_id] was found')
												random_string = rand(1000).to_s
												@cookie_trace = CookieTrace.new
												@cookie_trace.trace_code = random_string
												@cookie_trace.referer = request.referer
												@cookie_trace.save
												@the_cookie_id = @cookie_trace.id.to_s
							 					@the_a_id = params[:a_id] 
							 					@the_trace_code = random_string
							 					@value_for_cookie = @the_cookie_id + '_' + @the_a_id + '_' + @the_trace_code
							 					logger.warn(@the_cookie_id + '_' + @the_a_id + '_' + @the_trace_code)
							 					logger.warn(@value_for_cookie)
							 					cookies[:_barber_affiliate] =  {:value => @value_for_cookie , :expires => 45.days.from_now }
							 					session[:affiliate_a_id] = @the_a_id
						 			else
							 					if session[:affiliate_a_id].nil? 
							 							if cookies[:_barber_affiliate].nil?
							 										logger.warn('params[:a_id] was NOT found and session[:affiliate_a_id].nil == true AND cookie was nil  ')
								 									session[:affiliate_a_id]  = 0
								 						else			
								 									logger.warn('session[:affiliate_a_id].nil? == true ')
								 									verify_and_update_cookie_traces_and_cookie
							 							end
							 					else
							 							if cookies[:_barber_affiliate].nil?
							 									logger.warn("NO COOKIE FOUND")
							 									session[:affiliate_a_id]  = 0
							 							else
							 								logger.warn('session[:affiliate_a_id].nil? == false ')
							 								verify_and_update_cookie_traces_and_cookie
							 							end	
							 					end
									end
					end
		rescue
				
		  		file = File.open('log_permanent/affiliate_errors.log', File::WRONLY | File::APPEND)
				affiliate_error_logger = Logger.new(file)
				warning_message =  "ERROR WITH startup_affiliate: #{request.remote_ip} - #{request.referer}" 
				logger.warn( warning_message )
				affiliate_error_logger.warn( warning_message )	
				cookies.delete :_barber_affiliate
		end
		logger.warn('end startup_affiliate')		
end
################################################################################################ 
def verify_and_update_cookie_traces_and_cookie
		# cookie_traces is the database table containing the cookie tracking info
		logger.warn('params[:a_id] was NOT found and session[:affiliate_a_id]   > 0' )
		logger.warn('begin verify_and_update_cookie_traces_and_cookie')
		find_cookie_values
		if cookie_traces_trace_code_matches_cookie_trace_code?
					update_cookie_traces_and_cookie
		else
					report_and_log_violation_info_and_delete_offending_cookie
		end
		logger.warn('end verify_and_update_cookie_traces_and_cookie')
end
################################################################################################ 
def find_cookie_values
		cookie_value = cookies[:_barber_affiliate]
		@the_cookie_id = cookie_value.split('_')[0]
		@the_a_id = cookie_value.split('_')[1]
		@the_trace_code = cookie_value.split('_')[2]
		@cookie_traces = CookieTrace.find  @the_cookie_id
end
################################################################################################ 
def cookie_traces_trace_code_matches_cookie_trace_code?
	   logger.warn('begin cookie_traces_trace_code_matches_cookie_trace_code?')
	   logger.warn('@cookie_traces.trace_code:' + @cookie_traces.trace_code )
	   logger.warn('@the_trace_code:' + @the_trace_code)
		if @cookie_traces.trace_code == @the_trace_code
				logger.warn('COOKIE MATCHED TRACE CODE')
				true
		else
				logger.warn('AFFILIATE COOKIE VIOLATION DETECTED')
				false
		end
end
################################################################################################ 
def update_cookie_traces_and_cookie
				@the_new_trace_code = rand(1000).to_s
				@new_value_for_cookie  =  @the_cookie_id + '_' + @the_a_id + '_' + @the_new_trace_code
				cookies.delete :_barber_affiliate
				cookies[:_barber_affiliate] =  {:value => @new_value_for_cookie , :expires => 45.days.from_now }
				
				logger.warn('cookies[:_barber_affiliate] :' + cookies[:_barber_affiliate]  )
				logger.warn( '@new_value_for_cookie' +  @new_value_for_cookie )
				@cookie_traces.a_id = @the_a_id
				@cookie_traces.trace_code = @the_new_trace_code 
				if @purchase
						logger.warn( '@cookie_traces.purchase_id = @purchase.id WAS SET')
						@cookie_traces.purchase_id = @purchase.id
				end
				@cookie_traces.save
				session[:affiliate_a_id] = @the_a_id
				logger.warn('final value :' + cookies[:_barber_affiliate] )
end
################################################################################################ 
def report_and_log_violation_info_and_delete_offending_cookie
			logger.warn('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
			logger.warn('begin report_and_log_violation_info_and_delete_offending_cookie')
			  file = File.open('log_permanent/affiliate_offenses.log', File::WRONLY | File::APPEND)
			  # To create new (and to remove old) logfile, add File::CREAT like;
			  #   file = open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
			  message_to_log = "#{request.remote_ip }, #{@the_cookie_id} , #{@the_a_id} , #{@the_trace_code}, #{@user.id}" 
			  
			  affiliate_offender_logger = Logger.new(file)
#			  affiliate_offender_logger.warn('- request.remote_ip ----- @the_cookie_id------@the_a_id--------@the_trace_code----@user.id--')

			  affiliate_offender_logger.warn( message_to_log )
			  logger.warn( message_to_log )
			  
			  cookies.delete :_barber_affiliate
			  session[:affiliate_a_id]  = 0
		 	  logger.warn('end report_and_log_violation_info_and_delete_offending_cookie')
		 	  logger.warn('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
end


end
