class ItemSet < ActiveRecord::Base
  attr_accessible :category_id, :department_id, :item_id, :opposite_category_ids, :opposite_department_ids, :opposite_item_ids
end
