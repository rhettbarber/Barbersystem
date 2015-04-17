ThreeTwoThree::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  Rails.configuration.use_individual_assets_without_sprocket  = :false

  # Rails.application.config.assets.prefix = "assets_development"

  # Rails.application.config.assets.manifest = File.join(Rails.public_path, config.assets.prefix)

  config.watchable_dirs['lib'] = [:rb]

  config.action_controller.page_cache_extension  = true

  config.autoload_paths += %W{#{config.root}/lib/active_shipping}
  config.autoload_paths += %W{#{config.root}/lib/active_shipping/lib}

  Rails.configuration.use_individual_assets_without_sprocket  = :false

  Rails.application.config.assets.prefix = "assets_development"

  FMCache = ActiveSupport::Cache::FileStore.new('/tmp/cache/views/')

  #config.serve_static_assets = false

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5


  config.cache_store = :file_store, "/tmp/cache"

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false

  SslRequirement.disable_ssl_check = true

  config.action_controller.asset_host = Proc.new { |source, request|
    if   request.protocol == 'https://'
      if source =~ /\b(.png|.jpg|.gif)\b/i
        config.action_controller.asset_host = "https://dixieoutfitters.com"
      end
    else
      if source =~ /\b(.png|.jpg|.gif)\b/i
        config.action_controller.asset_host = "http://cdn.dixieoutfitters.com"
      end
    end
  }

end
