module Security
protected
############################################################################################################
def initialize_security_variables
      @request_remote_ip = session[:request_remote_ip] || request.remote_ip
      @my_ip_split =  @request_remote_ip.split(".")
      @my_ip_deviations = Set.new
      @my_ip_deviations.add(   @request_remote_ip  )
      @my_ip_deviations.add(   @my_ip_split[0] + '.*.*.*' )
      @my_ip_deviations.add(   @my_ip_split[0] + '.' + @my_ip_split[1] + '.*.*' )
      @my_ip_deviations.add(   @my_ip_split[0] + '.' + @my_ip_split[1] + '.' + @my_ip_split[2] + '.*' )
      session[:request_remote_ip] = @request_remote_ip
      @request_uri = request.fullpath
      @request_uri_split =  @request_uri.split('/')
end
############################################################################################################
def in_allowed_security_loophole_ips?
    @request_remote_ip = @request_remote_ip
     @allowed_ips_set = Caching::MemoryCache.instance.read  'allowed_ips'  unless cache_on? == false
    if   @allowed_ips_set
             logger.debug "@allowed ips set found"
    else
             #@allowed_ips = ["207.44.160.47", "80.248.176.136", "205.178.184.84", "69.36.45.65", "127.0.0.*" ]
            logger.debug "###################################################"
            logger.debug "@allowed ips set NOT found"
            @allowed_ips = []
            AllowedIp.all.each { |address| @allowed_ips << address.ip_address }
              logger.debug "###################################################"
              logger.debug "@allowed_ips: " + @allowed_ips.join(",")
            @allowed_ips_set = Set.new( @allowed_ips )
            Caching::MemoryCache.instance.write  'allowed_ips' ,  @allowed_ips_set  ,:expires_in => 227.minutes unless cache_on? == false
      end
      logger.debug "@allowed_ips_set: " + @allowed_ips_set.inspect
      logger.debug "@my_ip_deviations " + @my_ip_deviations.inspect
    if @allowed_ips_set.intersection(@my_ip_deviations).size > 0
				return true
		else
				return false
		end
end
############################################################################################################
def startup_blocked_ip_addresses
    logger.debug "BEGIN -----------------------------lib/startup_security/startup_blocked_ip_addresses"
		 @blocked_ips_set = Caching::MemoryCache.instance.read  'blocked_ips_set'  unless cache_on? == false
     unless @blocked_ips_set
                            @blocked_ip_addresses = []
                            BlockedIp.all.each do |bia|
                            @blocked_ip_addresses << bia.ip_address
              end
               @blocked_ips_set = Set.new( @blocked_ip_addresses )
              Caching::MemoryCache.instance.write  'blocked_ips_set', @blocked_ips_set ,:expires_in => 227.minutes unless cache_on? == false
              logger.warn "-------------------------------------@blocked_ip_addresses NOT read from cache"
      else
           logger.debug "-------------------------------------@blocked_ip_addresses read from cache"
      end
      @blocked_ip = false
      if @blocked_ips_set.intersection(@my_ip_deviations).size > 0
            add_security_warning(8)
            block_threat
            logger.warn "-------------------------------------@warned_times: #{@warned_times}"
            logger.warn "-------------------------------------ABOUT TO BLOCK THREAT!!!"
            logger.warn "-------------------------------------IP IN BLOCKED IP ADDRESSES!!!"
            logger.warn "-------------------------------------IP IN BLOCKED IP ADDRESSES!!!"
            logger.warn "-------------------------------------IP IN BLOCKED IP ADDRESSES!!!"
            logger.warn "-------------------------------------IP IN BLOCKED IP ADDRESSES!!!"
	else
            logger.debug "-------------------------------------@request_remote_ip:#{@request_remote_ip}--is not blocked"
	end
           logger.debug "END -------------------------------lib/startup_security/startup_blocked_ip_addresses"
end
############################################################################################################
def startup_security
    logger.debug "###################################################"
    logger.debug "###################################################"
		logger.debug "BEGIN -----------------------------lib/startup_security/startup_security"
    initialize_security_variables
   	if  in_allowed_security_loophole_ips? == true
							logger.warn "IP IN ALLOWED SECURITY LOOPHOLE IPS!" unless  @request_remote_ip == '206.82.83.129'
							logger.warn "IP IN ALLOWED SECURITY LOOPHOLE IPS!" unless  @request_remote_ip == '206.82.83.129'
							logger.warn "IP IN ALLOWED SECURITY LOOPHOLE IPS!" unless  @request_remote_ip == '206.82.83.129'
							logger.warn "IP IN ALLOWED SECURITY LOOPHOLE IPS!" unless  @request_remote_ip == '206.82.83.129'
							logger.warn "ip at work is allowed security bypass!"
    else
                logger.debug "IP NOT SPECIALLY PRIVILEDGED" + @request_remote_ip
                @warned_times = Caching::MemoryCache.instance.read  'warned_ip_' + request.remote_ip  unless cache_on? == false
                 # @warned_times = Caching::MemoryCache.instance.delete  'warned_ip_' + request.remote_ip
                  @warned_times ||= 0.0
                  if  @warned_times > 0
                    logger.warn "--!!!!----!!!----!!!--- @warned_times: #{@warned_times}"
                  end
                  if  @warned_times > 3
                    logger.warn "----------SECURITY WARNING"
                    logger.warn "----------SECURITY WARNING"
                    logger.warn "----------WARN COUNT: #{@warned_times}"
                  end
                  if  @warned_times > 7
                    logger.warn "----------WARN COUNT: #{@warned_times}"
                        block_threat
                  end
                logger.debug "-------------------------------------@warned_times: #{@warned_times}"
 #               startup_uri_length_blocker
                startup_blocked_ip_addresses
                startup_optimus_prime   # lib/starup_optimus_prime/startup_optimus_prime
    end
	logger.debug "END --------------------------------lib/startup_security/startup_security"
        logger.debug "###################################################"
    logger.debug "###################################################"
end
############################################################################################################
def add_security_warning(warn_level=0.25)
       ################# SECURITY WARNING SYSTEM BEGIN
       logger.warn "------ DANGER -----------------------add_security_warning BEGIN warn_level:#{warn_level}"
		       @warned_times = Caching::MemoryCache.instance.read  'warned_ip_' + request.remote_ip  unless cache_on? == false
		    logger.warn "------ DANGER -----------------------@warned_times -!-:#{@warned_times}"
				if @warned_times
						@warned_times = @warned_times + warn_level
						logger.warn "------ DANGER -----WARNED MULTIPLE TIMES -@warned_times: #{@warned_times}"
				else
						logger.warn "------ DANGER ----------------------WARNED FOR FIRST TIME "
						@warned_times = warn_level
				end
				Caching::MemoryCache.instance.write  'warned_ip_' + request.remote_ip, @warned_times ,:expires_in => 227.minutes unless cache_on? == false
				logger.warn "------ DANGER -----------------------warn_level:#{warn_level} "
				logger.warn "------ DANGER -----------------------@warned_times:#{@warned_times} "
       ################# SECURITY WARNING SYSTEM END
end
############################################################################################################
def block_threat
	logger.debug "BEGIN -----------------------------lib/startup_security/block_threat"
  initialize_variables unless @my_ip_deviations #this need deprecation but don't remove without proper thought
   if  in_allowed_security_loophole_ips? == true
          logger.warn "------SECURITY BYPASSED DUE TO ALLOWANCE"
   else
            logger.warn "------BLOCKING THREAT----------BLOCKING THREAT-------------BLOCKING THREAT"
            logger.warn "------BLOCKING THREAT----------BLOCKING THREAT-------------BLOCKING THREAT"
            @warned_times = Caching::MemoryCache.instance.read  'warned_ip_' + request.remote_ip
            @warned_times ||= 0
              begin
                  @remote_ip_to_ban =  request.remote_ip
                  @ban_string =  " netsh ipsec static  add filter filterlist=\"BLOCK_SOME_IPS\" srcaddr= #{@remote_ip_to_ban}  dstaddr=\"Me\" "
                  logger.warn @ban_string
                  system(  @ban_string   ) unless @remote_ip_to_ban == "206.82.83.129"
                  UserNotifier.deliver_named_error(@user, @website, @purchase, params, 'BANNED  IP-' + request.remote_ip   )

              rescue
                  UserNotifier.deliver_named_error(@user, @website, @purchase, params, 'FAILED TO BAN  IP-' + request.remote_ip   )
              end
            if @warned_times < 9
              UserNotifier.deliver_named_error(@user, @website, @purchase, params, 'POSSIBLE HACK ATTEMPT-' + request.remote_ip   )
              @new_blocked_ip = BlockedIp.new(:ip_address => request.remote_ip )
              @new_blocked_ip.save
                logger.warn "----------BLOCKED THREAT"
                logger.warn "----------BLOCKED THREAT"
                logger.warn "----------BLOCKED THREAT"
                logger.warn "----------BLOCKED THREAT"
                logger.warn "----------BLOCKED THREAT"
                logger.warn "----------BLOCKED THREAT"
                logger.warn "----------BLOCKED THREAT"
                logger.warn "----------BLOCKED THREAT"
                logger.warn "----------BLOCKED THREAT"
                logger.warn "----------BLOCKED THREAT"
            else
              logger.warn "---- @warned_times < 9 so ip was not added "
              logger.warn "---- @warned_times < 9 so ip was not added "
              logger.warn "---- @warned_times < 9 so ip was not added "
              logger.warn "---- @warned_times < 9 so ip was not added "
              logger.warn "---- @warned_times < 9 so ip was not added "
              logger.warn "---- @warned_times < 9 so ip was not added "
            end
          add_security_warning(1)
            Caching::MemoryCache.instance.delete  'blocked_ip_addresses'
            logger.warn "-------------------------------------deleted blocked_ip_addresses cache"
            render :text => "<div align='center'><br /> http://www.usdoj.gov/criminal/cybercrime/cc.html<br /><img src='/images/company_logos/department_of_justice.jpg' <br /> Hacking is illegal. You have been warned </div>"
   end
	logger.debug "END --------------------------------lib/startup_security/block_threat"
end
############################################################################################################
def startup_uri_length_blocker
	logger.debug "BEGIN -----------------------------lib/startup_security/startup_uri_length_blocker"
	if @request_uri.size > 400
				logger.warn "-------------------------------------BLOCKING THREAT BECAUSE URI IS TOO LONG"
				logger.warn "-------------------------------------BLOCKING THREAT BECAUSE URI IS TOO LONG"
				block_threat 
	else
				logger.debug "-------------------------------------@request_uri is within length limits"
	end
	logger.debug "END -------------------------------lib/startup_security/startup_uri_length_blocker"
end
############################################################################################################		
def check_suspect_paths_for_blocked_keywords
	logger.debug "BEGIN -----------------------------lib/startup_security/startup_blocked_keywords"
		@illegal_keywords = Caching::MemoryCache.instance.read  'illegal_keywords'  unless cache_on? == false
	if !@illegal_keywords
		@illegal_keywords = []
		BlockedKeyword.all.each do |bk|
			@illegal_keywords << bk.keyword
		end
		@illegal_keywords = Caching::MemoryCache.instance.write  'illegal_keywords' , @illegal_keywords ,:expires_in => 227.minutes unless cache_on? == false
		logger.warn "-------------------------------------@illegal_keywords NOT read from cache"
	else
		logger.debug "-------------------------------------@illegal_keywords read from cache"
	end
	@contains_illegal_keyword_in_uri = false
    logger.debug "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    logger.warn "@request_uri_split: " + @request_uri_split.inspect
	if @request_uri_split.to_set.intersection(@illegal_keywords.to_set).size > 0
		logger.warn("DANGER----OFFENDING KEYWORD FOUND")
		@offending_keyword = @request_uri_split.to_set.intersection(@illegal_keywords.to_set)
		logger.warn("DANGER----OFFENDING KEYWORD IS: #{@offending_keyword}")
		@contains_illegal_keyword_in_uri = true
		logger.warn "------ DANGER -----------------------ABOUT TO ADD NEW WARN TIME FOR KEYWORD THREAT "
		logger.warn "------ DANGER -----------------------ABOUT TO ADD NEW WARN TIME FOR KEYWORD THREAT "
				add_security_warning(1.5)		  
		logger.warn "-------------------------------------@warned_times: #{@warned_times} !!!"
		logger.warn "-------------------------------------@warned_times: #{@warned_times} !!!"
		logger.warn "---DANGER------------------------------ABOUT TO BLOCK KEYWORD THREAT !!!"
		logger.warn "---------------------------------------ABOUT TO BLOCK KEYWORD THREAT !!!"
		logger.warn "---------------------SECURITY WARN COUNT:@warned_times: #{@warned_times}"
		logger.warn "---------------------SECURITY WARN COUNT:@warned_times: #{@warned_times}"	
		logger.warn "---------------------------------------ABOUT TO BLOCK KEYWORD THREAT !!!"
		logger.warn "-----DANGER----------------------------ABOUT TO BLOCK KEYWORD THREAT !!!"
	else
		logger.warn "-------------------------------------NO BLOCKED KEYWORDS ENCOUNTERED !!!"
	end	
	logger.debug "END -------------------------------lib/startup_security/startup_blocked_keywords"
end
############################################################################################################


end
