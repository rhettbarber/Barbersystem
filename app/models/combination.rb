class Combination < ActiveRecord::Base


  attr_accessible :item_prefix, :design_prefix, :height

def self.compatible_symbiont?(item, design)
	if item && design
		items_opposites = item.category.category_class.opposite_category_ids
		designs_opposites = design.category.category_class.opposite_category_ids
		if     designs_opposites.include?(item.category.id.to_s) && items_opposites.include?(design.category.id.to_s)
			return true
		else
			return false
		end
	else
		false
	end
end


def self.find_combo_by_prefixes(item_prefix, design_prefix)
 #   if item.item_combination_slave_style_override != false
 #          false
 #   else    
              h  =  self.find(:first, :conditions => ["item_prefix = ? and design_prefix = ?", item_prefix, design_prefix     ])
                  if h
                          h
                  else
                        reversed = self.find(:first, :conditions => ["item_prefix = ? and design_prefix = ?",  design_prefix , item_prefix    ])
                        if reversed
                        	reversed
                        else
                  			false
              			end
                  end
 #   end
end



def self.find_combo(item, design)
 #   if item.item_combination_slave_style_override != false
 #          false
 #   else    
              h  =  self.find(:first, :conditions => ["item_prefix = ? and design_prefix = ?", item.category.prefix, design.category.prefix     ])
                  if h
                          h
                  else
                        false
                  end
 #   end
end




end
