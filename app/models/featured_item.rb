class FeaturedItem < ActiveRecord::Base
  attr_accessible :active, :carousel_name, :description, :image_name, :carousel_url, :onclick   , :list_url   , :verbiage, :list
end
