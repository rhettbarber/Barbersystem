
USE_FILES_FOR_RAILS_CACHE = true

ADMIN_IPS = ["192.168.0.122","192.168.0.116","127.0.0.1" ]

ADMIN_EMAIL_ADDRESSES = [ 'rhett@barberandcompany.com',  'kenny@barberandcompany.com']

DEVELOPMENT_ENVS = [ "thor_development", "thor_production","apollo_development","apollo_production","development"]

RELOAD_LIBS = Dir[Rails.root + 'lib/**/*.rb'] if DEVELOPMENT_ENVS.include?( Rails.env)