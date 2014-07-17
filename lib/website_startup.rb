module WebsiteStartup
  #protected

############################################################################################################
def current_website
      logger.debug "BEGIN ------------------------------ website_startup/current_website "
      session[:activate]  = 1
      if request.session_options[:id] == nil
        session_options_id_is_nil
      end
        if 	session[:server_port] == request.server_port
                      @website = Caching::MemoryCache.instance.read  request.session_options[:id] + '_website'  unless cache_on? == false
        end
        unless @website
                   @website = Website.current_website(request.env["HTTP_HOST"])
                   session[:server_port] = request.server_port
                   g = "g"
                   Caching::MemoryCache.instance.write  request.session_options[:id] + '_website' ,  @website unless cache_on? == false
        end
        #if @@VIRTUAL_WEBSITES.include?( request.domain )
        #      @non_profit_domain = true
        #end
        #User.is_administrator_subdomain     = request.subdomains.include?('us')
        #Website.is_administrator_subdomain  = request.subdomains.include?('us')

        logger.debug "Rails.configuration: " + Rails.configuration.inspect
        #logger.debug "Rails.configuration: " + Rails.application.inspect
        logger.debug "Rails.env: " + Rails.env
        logger.debug "request.server_port: " + request.server_port.to_s
        logger.debug "request.domain: " + request.domain.to_s
        logger.warn "@website.id: " + @website.id.to_s if @website
        logger.debug "@website.name :" + @website.name

        Website.current_website_id = @website.id
        request.session_options[:current_website_id]  = @website.id
        logger.debug "END ------------------------------ website_startup/current_website "
        return @website = @website
end
#############################################################################################################
def  current_website_id
      return @website.id
end









end
