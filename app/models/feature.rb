class Feature < ActiveRecord::Base
  attr_accessible :carousel_url, :description, :image_name, :list_url, :name, :onclick, :price, :verbiage
  has_many :item_features
  has_many :items, :through => :item_features

def feature_image_name
              if  self.image_name and  self.image_name  != ""
                         the_image_name = self.image_name
             else
                       the_image_name = "/images/item_thumbnails/" +  self.items.first.PictureName
             end
                return the_image_name
  end


end
