require 'actionpack_action_controller_caching_fragments_in_model.rb'
class Category < ActiveRecord::Base

  has_many :item_class, :through => :items

belongs_to :category_class

has_many :advanced_combinations
has_many :hidden_website_categories
belongs_to  :category_class
belongs_to :department
has_many :items
belongs_to :clone_item_type

#acts_as_tree
#acts_as_list  :scope => :parent_id
#belongs_to    :parent, :class_name => "Category"
#has_many      :children, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
#acts_as_cached
#has_many :items, :dependent => :destroy_all
#has_many :incoming_items, :class_name => 'Item', :conditions => "base_amount > 0"
#@asset.incoming_items

 include ModelFragments

default_scope  :conditions => { :web_category =>  1 }





  def is_design?
    begin
      if self.category_class.item_type == 'slave'
        logger.debug "is_design is true"
        true
      else
        logger.debug "is_design is false"
        false
      end
    rescue
      logger.debug "is_design is rescued"
      false
    end
  end



#def self.find(*args)
#         options = args.extract_options!
#         validate_find_options(options)
#         set_readonly_option!(options)
#
#         case args.first
#           when :first then
#            webcategory_scope do
#               find_initial(options)
#           end
#
#           when :all   then
#	            webcategory_scope do
#	                find_every(options)
#	            end
#		   when :all_no_scope
#		   		 find_every(options)
#           else             find_from_ids(args, options)
#         end
#end

#attr_accessible :Name, :Code, :Prefix


def delete_all_caching_without_touching_additives
			self.delete_category_menu_fragments
    		self.delete_cache
    		self.delete_shared_item_items
			self.delete_category_browser_fragments
end


def delete_all_caching_and_cache_of_which_this_is_an_additive
			logger.warn "BEGIN delete_all_caching_and_cache_of_which_this_is_an_additive category.id: #{self.id}"
			self.delete_category_menu_fragments
    		self.delete_cache
    		self.delete_shared_item_items
			self.delete_category_browser_fragments
			self.delete_categories_of_which_this_is_an_additive_cache
			self.delete_find_category_ids_of_which_this_is_an_additive
			logger.warn "END delete_all_caching_and_cache_of_which_this_is_an_additive"
end


def delete_categories_of_which_this_is_an_additive_cache
		cat_ids_to_delete = self.find_category_ids_of_which_this_is_an_additive
		cat_ids_to_delete.each do |cid|
						logger.warn "CURRENTLY DELETED CATEGORY WHICH IS ADDITIVE: ${cid}"
						this_category = Category.find cid
						this_category.delete_all_caching_without_touching_additives
		end
end



def delete_find_category_ids_of_which_this_is_an_additive
			@cwtcaa = Caching::MemoryCache.instance.delete  self.id.to_s + '_category_ids_of_which_this_is_an_additive'
end

def find_category_ids_of_which_this_is_an_additive
    #  @cwtcaa = Caching::MemoryCache.instance.read  self.id.to_s + '_category_ids_of_which_this_is_an_additive'
       unless @cwtca
       	@cwtcaa = []
		           Category.all.each do |cat|
			           	 if  cat.additive_category_ids
			               		@cwtcaa << cat.id.to_s  if  cat.additive_category_ids.split(',').include?(self.id.to_s)
			               end
		            end
        end
        	logger.warn "category_ids_of_which_this_is_an_additive: #{@cwtcaa.split(',').to_s}"
          return @cwtcaa
end
 #############################################################################################################################
 def delete_category_menu_fragments
 		if self.in_generic_department == true
 					self.specific_department_ids.each do |dept|
 							expire_fragment(%r{/views/.*/user_type_id/.*/shared_menu/menu_category/sym_category_class_id/.*/purchase_symbiote_item_shade/.*/department_id/#{dept}})
 					end
 		else
				expire_fragment(%r{/views/.*/user_type_id/.*/shared_menu/menu_category/sym_category_class_id/.*/purchase_symbiote_item_shade/.*/department_id/#{self.department_id}})
		end
end
 #############################################################################################################################
 def applicable_department_ids
   rename_this
 		if category.in_generic_department == true
				category.specific_department_ids
		else
				category.department.id.to_s
		end
end
#############################################################################################################################
def delete_category_browser_fragments
		#expire_fragment(%r{/views/.*/user_type_id/.*/item_browsing/category_browser/department/.*/department_type/.*/purchase_symbiote_item_category_category_class_id/#{self.category_class_id}/purchase_symbiote_item_shade/.*})
		# the expiry below deletes too much but is temporarily useful
		expire_fragment(%r{/views/.*/user_type_id/.*/item_browsing/category_browser/department/.*/department_type/.*/purchase_symbiote_item_category_category_class_id/.*/purchase_symbiote_item_shade/.*})
end
#############################################################################################################################
def delete_cache
		Caching::MemoryCache.instance.delete 'category_' + self.id.to_s
end
#############################################################################################################################


#def glob_cache_expire( cachepath )
#    logger.debug "cachepath: " + cachepath.inspect
#    glob_directories_to_expire = Dir.glob( cachepath )
#    logger.debug "glob_directories_to_expire: " + glob_directories_to_expire.inspect
#    FileUtils.rm_rf(Dir.glob( glob_directories_to_expire ))
#end


def delete_fragments
     glob_cache_expire( 'C:/tmp/cache/views/user_type_id/*/browse/category_id/' + self.id.to_s )

     glob_cache_expire( 'C:/tmp/cache/views/user_type_id/*/shared_symbiont/symbiote_wrapper_container/symbiote_item_category_id/' + self.id.to_s )

     glob_cache_expire( 'C:/tmp/cache/views/user_type_id/*/shared_menu/menu_organized_category/category_id/' + self.id.to_s )
end
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
def potential_opposite_categories
  opposite_categories
	#poc = Set.new
	##debugger
  #logger.debug "self.category_class.item_type: " + self.category_class.item_type
	#if self.category_class.item_type == 'slave'
   #             self.all_master_categories.each do |amc|
   #               poc.add?(amc) unless  self.category_class.opposite_category_ids.include?(amc.id.to_s)
   #             end
   #           poc
	#elsif self.category_class.item_type == 'master'
   #             self.all_slave_categories.each do |amc|
   #                 poc.add?(amc) unless self.category_class.opposite_category_ids.include?(amc.id.to_s)
   #             end
   #           poc
	#elsif self.category_class.item_type == 'all_over_item'
   #             self.all_over_design_categories.each do |amc|
   #                 poc.add?(amc)  unless self.category_class.opposite_category_ids.include?(amc.id.to_s)
   #             end
   #           poc
   # 	elsif self.category_class.item_type == 'all_over_design'
   #             self.all_over_item_categories.each do |amc|
   #                 poc.add?(amc) unless self.category_class.opposite_category_ids.include?(amc.id.to_s)
   #             end
   #           poc
	#else
   #           nil
	#end
end
#############################################################################################################################
  def potential_opposite_departments

    departments = Set.new
    self.potential_opposite_categories.each do |category|
                  departments.add?( category.department )
    end
     return departments
  end
#############################################################################################################################
  def potential_opposite_department_ids

    departments = Set.new

  if    self.potential_opposite_categories
          self.potential_opposite_categories.each do |category|
                  g = "g"
                  departments.add?( category.department_id )
          end
   else
            departments.add?( '0' )
  end

    return departments
  end
#############################################################################################################################
def self_and_additives_in_opposite_ids(opposite_category_ids)
			all_cats = self && self.additives
				chosen_cats = []
				all_cats.each do |cat|
							chosen_cats << cat if opposite_category_ids.include?(cat.id.to_s)
									 cat.additives.each do |cat2|
													chosen_cats << cat2 if opposite_category_ids.include?(cat2.id.to_s)
															cat2.additives.each do |cat3|
																		chosen_cats << cat3 if opposite_category_ids.include?(cat3.id.to_s)
															end if cat2.additives
									end if cat.additives
				end
			return chosen_cats
end



def self_and_non_generic_additives
	self_with_additives = []
	self_with_additives << self
		self.additives.each do |adtv|
			self_with_additives << adtv unless [1,5].include?(adtv.department_id)
		end if self.additives
	return self_with_additives
end

def has_additives
  #logger.debug "self.additive_category_ids_split" + self.additive_category_ids_split.inspect
	if self.additive_category_ids_split != [] and self.additive_category_ids_split != ['0']
          if self.additives
                #logger.debug "self.additives == true"
                #logger.debug "has_additives == true"
                true
          else
               #logger.debug "has_additives == false"
               false
          end

  else
          #logger.debug "self.additive_category_ids_split IS EQUAL []"
          #logger.debug "has_additives == false"
		false
	end
end

def additives
      if self.additive_category_ids_split
              Category.find(:all, :conditions => ["id in (?)", additive_category_ids_split ] )
      end
end



def all_opposite_categories
	if self.category_class.item_type == 'slave'
		self.all_master_categories
	elsif self.category_class.item_type == 'master'
		self.all_slave_categories
	else
		nil
	end
end

def all_master_category_ids
	mc_ids = []
	all_master_categories.each do |mc|
		mc_ids << mc.id
	end
	mc_ids
end

def all_slave_category_ids
	sc_ids = []
	all_slave_categories.each do |sc|
		sc_ids << sc.id
	end
	sc_ids
end

def all_master_categories
#	conditions = ["category_classes.item_type = ?", 'master']
#	Category.find(:all ,:include => ['category_class','department'], :conditions =>  conditions )
  Category.order("departments.Name ASC").includes(:category_class, :department).where("category_classes.item_type = ?", 'master')
end

def all_over_design_categories
  Category.order("departments.Name ASC").includes(:category_class, :department).where("category_classes.item_type = ?", 'all_over_design')
end

def all_over_item_categories
  Category.order("departments.Name ASC").includes(:category_class, :department).where("category_classes.item_type = ?", 'all_over_item')
end

def self.all_master_categories
            Category.order("departments.Name ASC").includes(:category_class, :department).where("category_classes.item_type = ?", 'master')
end

def all_slave_categories
#	conditions = ["category_classes.item_type = ?", 'slave']
#	Category.find(:all ,:include => ['category_class','department'], :conditions =>  conditions )
    Category.order("departments.Name ASC").includes(:category_class, :department).where("category_classes.item_type = ?", 'slave')
end

def opposite_categories
#	 Category.find(:all,:include => ['department'], :conditions => ["id in (?)", self.category_class.opposite_category_ids.split(/,/) ] )
    Category.order("departments.Name ASC").includes(:category_class, :department).where("categories.id in (?) and visible = ?", self.category_class.opposite_category_ids.split(/,/), 1  )
end

def self.items_in_parameter_category_and_additive_category(parameter_category)
	categories = Category.includes(:items, :category_class).where("id = ? or department_id = ?", parameter_category.id , parameter_category.additive_category_ids_split   )
  
	return categories
end

def parameter_and_symbiote_opposites_category_ids
	return self.additive_category_ids_split + self.id.to_a
end

def additive_first_category
      if self.additive_category_ids_split
              Category.find(:first, :conditions => ["id in (?)", additive_category_ids_split ] )
      end
end



def additive_category_ids_split
      if self.additive_category_ids  != nil
               self.additive_category_ids.split(/,/)
     else
               nil
     end
end


def all_item_ids_and_additive_category_item_ids
		ids = []
		self.items.each do |item|
			ids << item.id
		end
		additive_categories = Category.include(:items).where("id in (?)", self.additive_category_ids)
		additive_categories.items.each do |item|
			ids << item.id
		end
		return ids.uniq
end




def all_item_ids
		ids = []
		self.items.each do |item|
			ids << item.id if item.category_id == self.id
		end
		return ids
end



def self.non_web_category_ids_DEPRECATE
	compiled_non_web_ids = []
	for category in self.non_web_categories
		compiled_non_web_ids  <<  category.id
	end
		return compiled_non_web_ids
end

def category_type
  deprecate_this
      if self.category.category_class.item_type == 'slave'
          'design'
      else
          'item'
      end
end

def in_generic_department
      if self.department_id == 1  or  self.department_id == 5
          true
      else
          false
      end
end

def specific_department_ids
      if self.department_id == 1
                 specific_department_ids =   [2,3]
      elsif self.department_id == 5
                  specific_department_ids = [ 6,9]

    	end
end
####################################################################################################

def category_and_generic_counterpart_category_and_items_to_render
      if self.department_id == 2  or  self.department_id == 3
                 generic_department_id = 1
      elsif self.department_id == 6  or   self.department_id == 9
                  generic_department_id = 5
      end

        return  Category.includes(:items).where( "Name = ? and department_id = ?", self.Name  ,  generic_department_id ).first
end
####################################################################################################





def generic_counterpart
      if self.department_id == 2  or  self.department_id == 3
                 generic_department_id = 1
      elsif self.department_id == 6  or   self.department_id == 9
                  generic_department_id = 5
      end

        return  Category.includes(:items).where( "Name = ? and department_id = ?", self.Name  ,  generic_department_id ).first


#      	conditions =  ["Name = ? and department_id = ?", self.Name.gsub( "'"   ,"-")   ,  generic_department_id  ]
#     	 if Category.exists?(conditions)
#         	 return Category.find(:first, :conditions => conditions )
#       	 else
#       	 	 return self
#       	 end
end
####################################################################################################




def class_name
      category = Category.find(self.id)
       if category.category_class_id == 0 or  category.category_class_id == '0'
          class_name = 'singular_item'
      else
              if category.category_class_id != nil
              category_class = CategoryClass.find(category.category_class_id)
              class_name = category_class.name
             else
              class_name = []
              end
      end
end



  protected



end
