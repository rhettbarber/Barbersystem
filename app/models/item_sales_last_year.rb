class ItemSalesLastYear < ActiveRecord::Base
belongs_to :item
set_primary_key "item_id"

end
