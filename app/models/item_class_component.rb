class ItemClassComponent < ActiveRecord::Base
belongs_to :item_class

belongs_to :item
has_one :listing_garment

has_one :category,  :through => :item
has_one :category_class,  :through => :category

def color
	         if  self.item_class.Dimensions == 1                       
	               this_color =  self.Detail1  
	         else
	            	this_color =  self.Detail2
	          end
	           split_color = this_color.split('/')
	           split_color = split_color * '_'
	           split_color = split_color.split(' ')
	           split_color = split_color * '-'
	           split_color = split_color.to_s.downcase
          return split_color || 'no_color'
end



def dimensions
    self.Detail2 + ' ' + self.Detail1
end


def shade
         shade = self.item.SubDescription2
end

def size   
               size =  self.Detail1  
end


def item_class_component_available_for_web?
      item =    Item.find(self.item_id)
          if item.WebItem == true && item.Inactive == false
               item_class_component_available_for_web = true
            else
            item_class_component_available_for_web = false
            end
end


	# Finds all related item_class_components marked for light colored transfers
	def self.light
		find(:all, :conditions => ["shade = 'light'"], :order => "ItemLookupCode")
	end

	# Finds all related item_class_components
	def self.dark
		find(:all, :conditions => ["shade = 'dark'"], :order => "ItemLookupCode")
	end


end
