require 'tree_with_dotted_ids'
ActiveRecord::Base.send :include, ActiveRecord::Acts::TreeWithDottedIds
