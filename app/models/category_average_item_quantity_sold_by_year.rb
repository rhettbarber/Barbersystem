class CategoryAverageItemQuantitySoldByYear < ActiveRecord::Base

  has_many :items_with_yearly_sales

scope :average_in_year, lambda { |*args| {:conditions => ["sale_year = ?", (args.first || Date.today.year )]} }

  


end
