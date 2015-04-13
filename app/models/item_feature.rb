class ItemFeature < ActiveRecord::Base
   attr_accessible :item_id, :feature_id
  belongs_to :item
  belongs_to :feature


end
