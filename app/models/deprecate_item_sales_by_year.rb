class ItemSalesByYear < ActiveRecord::Base
belongs_to :item
set_primary_key "item_id"


 def ytdn
        where("sale_year = ?", Time.new.year ).sum_of_quantity
 end


 def lytdn
         where("sale_year = ?", Time.new.year - 1 ).sum_of_quantity
 end


end
