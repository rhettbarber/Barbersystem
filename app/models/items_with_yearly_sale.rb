class ItemsWithYearlySale < ActiveRecord::Base
 belongs_to :item
 belongs_to :category
 belongs_to :department
 belongs_to :category_average_item_quantity_sold_by_year
set_primary_key "item_id"

 # scope :sales_in_year, lambda { |the_year| { :conditions => ['sale_year = ?', the_year] }
scope :sales_in_year, lambda { |*args| {:conditions => ["sale_year = ? or sale_year is null", (args.first || Date.today.year )   ]   }  }






def available_image_name
          if    rio( RIO.cwd +  "/public/images/item_thumbnails/" +  self.png_image_name ).exist?
                       "/images/item_thumbnails/" +  self.png_image_name
          elsif    rio( RIO.cwd +  "/public/images/item_thumbnails/" +  self.jpg_image_name ).exist?
                     '/images/item_thumbnails/' + self.jpg_image_name
          else
                      '/images/item_thumbnails/missing-thumbnail.jpg'
          end
end
  

def severity_class_name
                  if   rio( RIO.cwd +  "/public/images/item_thumbnails/" +  self.png_image_name ).exist? and rio( RIO.cwd +  "/public/images/item_thumbnails/" +  self.jpg_image_name ).exist?
                                     'green_severity'
                  elsif   rio( RIO.cwd +  "/public/images/item_thumbnails/" +  self.png_image_name ).exist? and rio( RIO.cwd +  "/public/images/item_thumbnails/" +  self.jpg_image_name ).exist? == false
                                     'orange_severity'
                  elsif   rio( RIO.cwd +  "/public/images/item_thumbnails/" +  self.png_image_name ).exist? == false and rio( RIO.cwd +  "/public/images/item_thumbnails/" +  self.jpg_image_name ).exist?
                                     'pink_severity'
                  elsif rio( RIO.cwd +  "/public/images/item_thumbnails" +  self.png_image_name ).exist?  == false  and rio( RIO.cwd +  "/public/images/item_thumbnails" +  self.jpg_image_name ).exist? == false
                                      'no_images_available'
                  end

end


def severity_class_name_before
                  if rio( RIO.cwd +  "/public/images/item_thumbnails" +  self.jpg_image_name ).exist? and rio( RIO.cwd +  "/public/images/item_thumbnails" +  self.png_image_name ).exist?
                                      'both_images_available anatips'
                  elsif rio( RIO.cwd +  "/public/images/item_thumbnails" +  self.png_image_name ).exist? and rio( RIO.cwd +  "/public/images/item_thumbnails" +  self.png_image_name ).exist?  == false
                                      'only_the_png_name_exists anatips'
                 elsif rio( RIO.cwd +  "/public/images/item_thumbnails" +  self.png_image_name ).exist?  == false  and rio( RIO.cwd +  "/public/images/item_thumbnails" +  self.png_image_name ).exist?
                                      'only_the_jpg_name_exists anatips'
                  elsif rio( RIO.cwd +  "/public/images/item_thumbnails" +  self.png_image_name ).exist?  == false  and rio( RIO.cwd +  "/public/images/item_thumbnails" +  self.png_image_name ).exist? == false
                                      'no_images_available anatips'
                  end

end






end
