class Catalog < ActiveRecord::Base
  attr_accessible :category_ids, :description, :name
end
