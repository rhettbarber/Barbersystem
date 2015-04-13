class CloneItemRequest < ActiveRecord::Base
  belongs_to :item
  belongs_to :clone_item_type

  validates_uniqueness_of :clone_item_type_id, :scope => :item_id, :message => "Error, This clone item has already been requested"

end
