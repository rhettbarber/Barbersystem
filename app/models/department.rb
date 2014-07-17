
require 'actionpack_action_controller_caching_fragments_in_model.rb'

class Department < ActiveRecord::Base
#has_one :table_image
has_many :items
has_many :crest_prints
has_many :categories
has_many :item_classes, :order => :ItemLookupCode

 include ModelFragments


@@requires_license = ['DX','DG','DB','DY']



def categories_and_additive_categories
  self_with_additives = []

   self.categories.each do |cat|
                  self_with_additives << cat
                  cat.additives.each do |adtv|
                          self_with_additives << adtv
                  end if cat.additives
     end


  return self_with_additives
end



#############################################################################################
def is_all_websites_department
         if [1,2,3,4,5,6,7,8,9].include?(self.id)
                       true
        else
                   false
         end
end
#############################################################################################
def generic_category_ids
		generic_department_ids_array = ['1','5']
		generic_departments = Department.find(generic_department_ids_array)
		gcis = []
		generic_departments.each do |dep|
			gcis << dep.category.id
		end
		return gcis
end
#############################################################################################
def generic_counterpart(parameter_department)
               if parameter_department.id == 2 or parameter_department.id == 3
                          return 1
		      elsif parameter_department.id == 6 or parameter_department.id == 9
                          return 5
              else
                          return parameter_department.id
               end
end
#############################################################################################
  def letter_section_code
        if self.id == 9
                  'b'
         elsif self.id == 6
                   'g'
	    elsif self.id == 21
                   'a'
	    elsif self.id == 22
                   'a'
	    elsif self.id == 28
                   'a'
         elsif self.id == 26
                   'a'
         else
                 a = self.Name
                a[0,1].downcase
              end
end
#############################################################################################
 def christian_design_departments
       [2,3,4,6,7,8,9,10,11,12,19,22]
 end
#############################################################################################
 def dixie_design_departments
       [2,3,4,6,7,8,9,10,11,12,19,22]
 end
#############################################################################################
def department_type
          if  self.categories.first.category_class.item_type == 'slave'
                'design'
          else
                'item'
          end
end
#############################################################################################
def item_department
         if [1,2,3,4,5,6,7,8,9].include?(self.id)
                       true
        else
                   false
         end
end
#############################################################################################
def runtime_additive_category_ids_split
      if self.runtime_additive_category_ids  != nil
               self.runtime_additive_category_ids.split(/,/)
     else
               nil
     end
end
#############################################################################################
def categories_with_additives
             Category.order("Name ASC").where("department_id = ? or id IN  (?)", self.id, runtime_additive_category_ids_split )
end
 #############################################################################################
 def license_required
      if @@requires_license.include?(self.code)
            true
      else
           false
      end
 end
#############################################################################################
 def section_name
          self.Name.gsub(/[^a-z1-9]+/i, '_').downcase
end
#############################################################################################


end



#def categories_cache
#		Caching::MemoryCache.instance.delete  'categories_in_department_' +self.id.to_s
#end
#
#def delete_categories_cache
#		Caching::MemoryCache.instance.delete  'categories_in_department_' +self.id.to_s
#end
#
#def delete_shared_menu_fragment
#		expire_fragment(%r{/views/.*/user_type_id/.*/shared_menu/menu_category/sym_category_class_id/.*/purchase_symbiote_item_shade/.*/department_id/#{self.id.to_s}})
#end
#
#def delete_department_categories_fragment
#		expire_fragment(%r{/views/.*/user_type_id/.*/shared_department/department_categories/sym_category_class_id/.*/purchase_symbiote_item_shade/.*/department_id/#{self.id.to_s}})
#end
#
#def delete_department_items_fragment
#		expire_fragment(%r{/views/.*/user_type_id/.*/shared_item/items/department_id/#{self.id.to_s}/category_id/.*/symbiote_item_category_category_class_id/.*})
#end
