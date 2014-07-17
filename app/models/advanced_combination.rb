class AdvancedCombination < ActiveRecord::Base
belongs_to :category
belongs_to :item_class

attr_accessible :front_left, :front_top, :front_width, :number_of_sides, :default_side, :back_left, :back_top, :back_width ,:specsheet_type_id

def self.find_or_create_combo(item, design)
                   if design == "0"
                          design_category_id = '0'
                   else
                          design_category_id =  design.category_id
                   end

                   h  =  self.where( "item_class_id = ? and category_id = ?",  item.item_class_component.item_class_id,    design_category_id    ).first

                  if h
                               return h
                  else
                              new_combo = self.new
                              new_combo.front_left = '0px'
                              new_combo.front_top = '0px'
                              new_combo.front_width = '100px'
                              new_combo.back_left = '0px'
                              new_combo.back_top = '0px'
                              new_combo.back_width = '100px'
                              new_combo.number_of_sides  = '2'
                              new_combo.specsheet_type_id  = 1

                              new_combo.item_class_id =   item.item_class_component.item_class_id
                              new_combo.category_id = design_category_id
                              new_combo.save
                              return new_combo
                  end
end

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








end
