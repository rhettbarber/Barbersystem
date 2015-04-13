class ItemExtended < ActiveRecord::Base
 belongs_to :item
 belongs_to :category
set_primary_key "item_id"

end
