class CategoryClass  < ActiveRecord::Base

  has_many :items, :through => :categories
has_many :categories
has_many :items, :through => :categories

	validates_presence_of   :item_type
	validates_uniqueness_of   :name



  attr_accessible :opposite_category_ids


end
