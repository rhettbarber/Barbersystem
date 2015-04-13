class Catalog < ActiveRecord::Base
  attr_accessible :category_ids, :description, :name,:category_ids_with_header
end
