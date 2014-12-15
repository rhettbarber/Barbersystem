module RubyRequirements




  require 'bigdecimal'
  require 'net/https'

  require 'active_shipping'


  #require 'tree_with_dotted_ids'
  #ActiveRecord::Base.send :include, ActiveRecord::Acts::TreeWithDottedIds

  #require 'active_shipping/lib/util'
  #require 'active_shipping/lib/base'
  #require 'active_shipping/lib/location'
  #require 'active_shipping/lib/handling'
  #require 'active_shipping/lib/ups_gateway'
  #require 'active_shipping/lib/usps_gateway'
  #require 'active_shipping/lib/con_way_gateway'
  #require 'active_shipping/lib/fedex_gateway'

#require 'hash'
#require 'scruffy'
#require 'gruff'
#require 'shipping'  
#require 'rio'
require 'fileutils'
require 'pathname'

require 'core_ext/string'




#require 'activerecord_default_scope'

# require 'msfte.rb'

#require 'actionpack_action_controller_caching_fragments.rb'
require 'actionpack_action_controller_caching_fragments_in_model.rb'
#require 'activesupport_cache_memory_store.rb'
#require 'lib/monkey_patched/page_caching_patch'
#require "will_paginate"
#require "lib/rack/firebug_logger.rb"

#require "responds_to_parent.rb"
#require "url_upload.rb"

  if ["production_testing","development"].include?(Rails.env)  and Rails.configuration.action_controller.perform_caching
        require_dependency 'category.rb'
        require_dependency 'category_class.rb'
        require_dependency 'customer.rb'
        require_dependency 'department.rb'
        require_dependency 'item.rb'
        require_dependency 'purchase.rb'
        require_dependency 'ship_to.rb'
        require_dependency 'website.rb'
        require_dependency 'user.rb'
        require_dependency 'user_session.rb'
        require_dependency 'website.rb'
  end


end
