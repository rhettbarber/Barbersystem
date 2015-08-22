class HoldingForDepartment < ActiveRecord::Base
  #attr_accessible :category_ids, :description, :name,:category_ids_with_header
  has_one :purchases_entries_with_detail
end
