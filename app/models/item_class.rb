class ItemClass < ActiveRecord::Base

  has_many :advanced_combinations
	has_many :item_class_components ,  :order       => 'Detail2 ASC, Detail1 ASC'  
	has_many :items, :through => :item_class_components
  belongs_to :department
             #.includes(:item).where( "items.Inactive = ? and items.WebItem = ?", false, true )


 def all_active_components
                     all_component_ids = []
           for component in  self.item_class_components
                 if component.item
                      all_component_ids << component.id    if component.item.Inactive == false  && component.item.WebItem == true
                 end
           end
                     ItemClassComponent.find(:all,:conditions => ["item_class_id = ? and id in (?)" , id, all_component_ids  ],:order => "Detail2 ASC, Detail1 ASC")
end
 

 def light_components_only
                      light_component_ids = []
           for component in  self.item_class_components
                 if component.item
                        if component.item.SubDescription2 == 'light'
                              light_component_ids << component.id    if component.item.Inactive == false  && component.item.WebItem == true
                        end
                 end
           end
                     ItemClassComponent.find(:all,:conditions => ["item_class_id = ? and id in (?)" , id, light_component_ids  ],:order => "Detail2 ASC, Detail1 ASC")
end
 
 

def inactive_and_non_web_components
                   return self.item_class_components.includes(:item).where( "items.Inactive = ? and items.WebItem = ?", true, false ).order("Detail2 ASC, Detail1 ASC")
end  



  def all_valid_components
    return self.item_class_components.order("Detail2 ASC, Detail1 ASC").includes(:item).where( "items.Inactive = ? and items.WebItem = ?", false, true )
  end

  
  
  def item_class_available_for_web?
        icc = ItemClassComponent.find(:all,:conditions => ["item_class_id = ?", self.id ])
        truth = []
        truth = Array.new
                for i in icc
                item = Item.find(i.item_id)
                    if item.WebItem == '1' && item.Inactive == '0'
                    truth << 'true'
                    end
                 end
          if truth.include?('true')
            item_class_available_for_web = true
          else
          item_class_available_for_web = false
          end
  end
  
  



end


#def all_valid_components_old
#  component_ids = []
#  for component in  self.item_class_components
#    if component.item
#      component_ids << component.id   unless component.item.Inactive == true  or component.item.WebItem == false
#    end
#  end
#  return  ItemClassComponent.where( "item_class_id = ? and id in (?)" , self , component_ids  ).order("Detail2 ASC, Detail1 ASC")
#end