class ItemSalesThisYear < ActiveRecord::Base
belongs_to :item
set_primary_key "item_id"

#belongs_to :category, :through => :items




end
