ThreeTwoThree::Application.configure do

#  config.action_controller.relative_url_root = '/store'


  config.assets.enabled = true
  config.assets.precompile += ['initiate_functions.js', 'application.js']


   config.action_controller.asset_host = Proc.new { |source, request|
       if   request.protocol == 'https://'

       else
             if source =~ /\b(.png|.jpg|.gif)\b/i
                    config.action_controller.asset_host = "http://cdn.dixieoutfitters.com"
             end
       end
   }

   # Rails.configuration.use_individual_assets_without_sprocket  = :false

  #Rails.application.config.assets.prefix = "assets_production"

  #Rails.application.config.assets.manifest = File.join(Rails.public_path, config.assets.prefix)

  config.action_controller.page_cache_extension  = true




  class ActionDispatch::RemoteIp
    self.send :remove_const, "TRUSTED_PROXIES"
    TRUSTED_PROXIES = ['127.0.0.1']
  end

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = false

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true


  FMCache = ActiveSupport::Cache::FileStore.new('/tmp/cache/views/')



 #TURN ON FOR REAL PRODUCTION
 # config.action_controller.asset_host = Proc.new { |source, request|
 #    #$stdout.puts "Protocol:  " + request.protocol
 #    #$stdout.puts "\n"
 #    if   request.protocol == 'https://'
 #                            # 				$stdout.puts "protocol_is_https   "
 #                            #config.action_controller.asset_host = "https://dixieoutfitters.barberandcompany.netdna-cdn.com"
 #    else
 #                            #				$stdout.puts "protocol_is_ NOT https   "
 #                            config.action_controller.asset_host = "http://cdn.dixieoutfitters.com"
 #    end
 #
 #    #$stdout.puts "\n"
 #    #$stdout.puts "request.media_type: " + request.media_type
 #    #$stdout.puts "\n"
 #    #$stdout.puts "request.format:  " + request.format
 #    #$stdout.puts "\n"
 # }



  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.cache_store = :file_store, "/tmp/cache"
  SslRequirement.disable_ssl_check = false

end











# 				$stdout.puts "protocol_is_https   "
#config.action_controller.asset_host = "https://dixieoutfitters.barberandcompany.netdna-cdn.com"
#$stdout.puts "Protocol:  " + request.protocol
#$stdout.puts "\n"
#$stdout.puts "\n"
#$stdout.puts "request.media_type: " + request.media_type
#$stdout.puts "\n"
#$stdout.puts "request.format:  " + request.format
#$stdout.puts "\n"







#ThreeTwoThree::Application.configure do
#  # Settings specified here will take precedence over those in config/application.rb
#
#  # Code is not reloaded between requests
#  config.cache_classes = true
#
#  # Full error reports are disabled and caching is turned on
#  config.consider_all_requests_local       = false
#  config.action_controller.perform_caching = true
#
#  # Disable Rails's static asset server (Apache or nginx will already do this)
#  config.serve_static_assets = true
#
#  # Compress JavaScripts and CSS
#  config.assets.compress = false
#
#  # Don't fallback to assets pipeline if a precompiled asset is missed
#  config.assets.compile = false
#
#  # Generate digests for assets URLs
#  config.assets.digest = true
#
#  # Defaults to Rails.root.join("public/assets")
#  # config.assets.manifest = YOUR_PATH
#
#  # Specifies the header that your server uses for sending files
#  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
#  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx
#
#  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
#  # config.force_ssl = true
#
#  # See everything in the log (default is :info)
#  # config.log_level = :debug
#
#  # Prepend all log lines with the following tags
#  # config.log_tags = [ :subdomain, :uuid ]
#
#  # Use a different logger for distributed setups
#  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
#
#  config.cache_store = :file_store, "/tmp/cache"
#
#  # Use a different cache store in production
#  # config.cache_store = :mem_cache_store
#
#  # Enable serving of images, stylesheets, and JavaScripts from an asset server
#  # config.action_controller.asset_host = "http://assets.example.com"
#
#  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
#  # config.assets.precompile += %w( search.js )
#
#  # Disable delivery errors, bad email addresses will be ignored
#  # config.action_mailer.raise_delivery_errors = false
#
#  # Enable threaded mode
#  # config.threadsafe!
#
#  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
#  # the I18n.default_locale when a translation can not be found)
#  config.i18n.fallbacks = true
#
#  # Send deprecation notices to registered listeners
#  config.active_support.deprecation = :notify
#
#  # Log the query plan for queries taking more than this (works
#  # with SQLite, MySQL, and PostgreSQL)
#  # config.active_record.auto_explain_threshold_in_seconds = 0.5
#end
