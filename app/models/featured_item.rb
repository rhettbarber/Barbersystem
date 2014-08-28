class FeaturedItem < ActiveRecord::Base
  attr_accessible :active, :carousel_name, :description, :image_name, :url
end
