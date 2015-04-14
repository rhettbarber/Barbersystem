#require 'actionpack_action_controller_caching_fragments.rb'
require 'item_class_sales_this_years_with_item_id.rb'

class Item < ActiveRecord::Base
attr_accessible :id, :ItemLookupCode  # :description, :created_at, :updated_at, :customer, :work_order_id, :total_column
has_many :item_features
has_many :features, :through => :item_features
has_many :item_sales
has_many :customer_item_sales_by_years
has_many :crest_prints
has_one :category_class, :through => :category
has_one :item_class, :through => :item_class_component
has_one :design_specific_breast_print
has_many :clone_item_requests
has_many :aliasings, :conditions => ["items.WebItem" => true, "items.Inactive" => false ]
has_many :clone_items
has_one :sales_of_item_by_year
has_many :items_with_yearly_sales
#has_one :item_sales_by_year
has_one :item_sales_this_year
has_one :item_sales_last_year
has_one :item_class_sales_this_years_with_item_id
has_one :sales_entry
has_one  :customer_item
belongs_to :department
has_many :aliasings
has_one :item_class_component
has_one :item_class, :through => :item_class_component
belongs_to :category
belongs_to :quantity_discount
has_one :customer_item
has_many :purchases_entries

attr_accessible :category_id    , :Notes , :ExtendedDescription, :PictureName, :Price, :PriceA, :PriceB, :PriceC, :Cost, :shipcost, :imagecost, :laborcost, :Notes
cattr_accessor :commission_customer_id

@@NOT_PERMANENT_OR_VOLUME_DISCOUNTABLE_DEPARTMENT_IDS = ['1','2','3','3','4','5','6','7','8','9','10','11','12','19','21','22','24','26','28','35','43']
 @@STOCK_DESIGN_PATH = 'W://AUTOMATION_DATABASE/ORIGINAL_PSD/'
#@@PRODUCTION_FILE_PATH = 'Y://STORAGE_DISK_1/MAIN_FILES_STORAGE/ITEM_MANAGEMENT/PRODUCTION_FILES/'
@@DESIGN_SEPARATION_PATH =  'W://AUTOMATION_DATABASE/SEPARATION/' 
@@TEMPLATE_PATH = 'Y://STORAGE_DISK_1/MAIN_FILES_STORAGE/ITEM_MANAGEMENT/TEMPLATES/'
#@@ALL_OVER_PRODUCTION_JPGS = 'Y://STORAGE_DISK_1/MAIN_FILES_STORAGE/ITEM_MANAGEMENT/ALL_OVER_PRODUCTION_JPGS/'

cattr_reader :per_page
@@per_page = 10

#scope :unique_and_one_of_item_class_in_departments, joins(:item_class) & Item.with_no_item_class_in_departments
default_scope  :conditions => { :WebItem =>  true, :Inactive => false  }

### this method also exists in listing_designs... take heed!
### this method also exists in listing_designs... take heed!
### this method also exists in listing_designs... take heed!
### this method also exists in listing_designs... take heed!
### this method also exists in listing_designs... take heed!
def sublimation_status
      if self.SubDescription1.downcase.include? "sublimation_only"
              return "sublimation_only"
      else
              return "not_sublimation"
      end
end

  def minimum_quantity_message
          if sublimation_status == "sublimation_only"
                  return " - 300 min"
          else
                  return ""
            end
  end


  def is_sublimation?
    return true
  end

  def default_quantity(pricelevel=0)
             if pricelevel  > 1
                            if self.category and self.category.category_class  and self.category.category_class.item_type == 'slave'
                                     return 12
                            else
                                    return 1
                            end
             else
                          return 1
               end
  end


  def self.string_overriden_quantity_discount_id( transfer_type_string )
     if @@NOT_PERMANENT_OR_VOLUME_DISCOUNTABLE_DEPARTMENT_IDS.include?( self.department_id )
            if transfer_type_string.include? 'sublim9'
              return  22651
            elsif transfer_type_string.include? 'sublim12'
              return   22652
            elsif transfer_type_string.include? 'sublim14'
              return   22650
            elsif transfer_type_string.include? 'sublimfull'
              return  22649
            else
              wrong_wrong
            end
     else

            if transfer_type_string.include? 'sublim9'
              return  22651
            elsif transfer_type_string.include? 'sublim12'
              return   22652
            elsif transfer_type_string.include? 'sublim14'
              return   22650
            elsif transfer_type_string.include? 'sublimfull'
              return  22649
            else
              wrong_wrong
            end
       end
  end


  def unit_quantity_tier_discount_price(customer=0,quantity=1, the_price_override=0)
              ############################################################################################################
              ############################################################################################################
          logger.debug " the_price_override.kind_of?(PurchasesEntry): " +  the_price_override.kind_of?(PurchasesEntry).to_s
          logger.debug " the_price_override.kind_of?(String): " +  the_price_override.kind_of?(String).to_s

              if        the_price_override.kind_of?(String)
                                        the_override_quantity_discount_id =  Item.string_overriden_quantity_discount_id  the_price_override
                                      overridden_quantity_discount = QuantityDiscount.find the_override_quantity_discount_id

                                      if  overridden_quantity_discount.use_pre_tier_price(quantity)
                                        unit_quantity_tier_discount_price = overridden_quantity_discount.PriceB
                                      elsif overridden_quantity_discount.use_price_1(quantity)
                                        unit_quantity_tier_discount_price = overridden_quantity_discount.Price1B
                                      elsif overridden_quantity_discount.use_price_2(quantity)
                                        unit_quantity_tier_discount_price = overridden_quantity_discount.Price2B
                                      elsif overridden_quantity_discount.use_price_3(quantity)
                                        unit_quantity_tier_discount_price = overridden_quantity_discount.Price3B
                                      elsif overridden_quantity_discount.use_price_4(quantity)
                                        unit_quantity_tier_discount_price = overridden_quantity_discount.Price4B
                                      end

              elsif      the_price_override.kind_of?(PurchasesEntry)   and  the_price_override.override_quantity_discount?
                                    the_override_quantity_discount_id =  the_price_override.overriden_quantity_discount_id
                                    overridden_quantity_discount = QuantityDiscount.find the_override_quantity_discount_id

                                    if  overridden_quantity_discount.use_pre_tier_price(quantity)
                                              unit_quantity_tier_discount_price = overridden_quantity_discount.PriceB
                                    elsif overridden_quantity_discount.use_price_1(quantity)
                                               unit_quantity_tier_discount_price = overridden_quantity_discount.Price1B
                                    elsif overridden_quantity_discount.use_price_2(quantity)
                                               unit_quantity_tier_discount_price = overridden_quantity_discount.Price2B
                                    elsif overridden_quantity_discount.use_price_3(quantity)
                                                unit_quantity_tier_discount_price = overridden_quantity_discount.Price3B
                                    elsif overridden_quantity_discount.use_price_4(quantity)
                                                unit_quantity_tier_discount_price = overridden_quantity_discount.Price4B
                                    end
                else
                              if   customer.class != Customer
                                              ss= 'ss'
                                              if customer == 2000
                                                            if  self.quantity_discount.use_pre_tier_price(quantity)
                                                              unit_quantity_tier_discount_price = self.PriceB
                                                            elsif self.quantity_discount.use_price_1(quantity)
                                                              unit_quantity_tier_discount_price = self.quantity_discount.Price1B
                                                            elsif self.quantity_discount.use_price_2(quantity)
                                                              unit_quantity_tier_discount_price = self.quantity_discount.Price2B
                                                            elsif self.quantity_discount.use_price_3(quantity)
                                                              unit_quantity_tier_discount_price = self.quantity_discount.Price3B
                                                            elsif self.quantity_discount.use_price_4(quantity)
                                                              unit_quantity_tier_discount_price = self.quantity_discount.Price4B
                                                            end

                                              else
                                                            unit_quantity_tier_discount_price = self.Price
                                              end
                              else
                                              if customer.PriceLevel == 0
                                                            if  self.quantity_discount
                                                                          unit_quantity_tier_discount_price = self.Price
                                                            else
                                                                          unit_quantity_tier_discount_price =  self.Price
                                                            end
                                                            #BEGIN PREPRINT CUSTOMER  ---
                                              elsif customer.PriceLevel == 1
                                                            if  self.quantity_discount
                                                                          if  self.quantity_discount.use_pre_tier_price(quantity)
                                                                            unit_quantity_tier_discount_price = self.PriceA
                                                                          elsif self.quantity_discount.use_price_1(quantity)
                                                                            unit_quantity_tier_discount_price = self.quantity_discount.Price1A
                                                                          elsif self.quantity_discount.use_price_2(quantity)
                                                                            unit_quantity_tier_discount_price = self.quantity_discount.Price2A
                                                                          elsif self.quantity_discount.use_price_3(quantity)
                                                                            unit_quantity_tier_discount_price = self.quantity_discount.Price3A
                                                                          elsif self.quantity_discount.use_price_4(quantity)
                                                                            unit_quantity_tier_discount_price = self.quantity_discount.Price4A
                                                                          end
                                                            else
                                                                       unit_quantity_tier_discount_price =  self.PriceA
                                                            end
                                                            #END PREPRINT CUSTOMER  ---
                                                            #
                                                            #BEGIN BLANK CUSTOMER  ---
                                              elsif customer.PriceLevel == 2
                                                            if  self.quantity_discount
                                                                          if  self.quantity_discount.use_pre_tier_price(quantity)
                                                                            unit_quantity_tier_discount_price = self.PriceB
                                                                          elsif self.quantity_discount.use_price_1(quantity)

                                                                           logger.debug "item.id: " + self.id.to_s
                                                                           logger.debug "quantity.to_s: " + quantity.to_s
                                                                           logger.debug "item.quantity_discount.inspect: " + self.quantity_discount.inspect
                                                                           logger.debug "self.quantity_discount.Price1B.to_s: " + self.quantity_discount.Price1B.to_s
                                                                           logger.debug " ----------------------------------: " + self.quantity_discount.Price1B.to_s


                                                                            unit_quantity_tier_discount_price = self.quantity_discount.Price1B
                                                                          elsif self.quantity_discount.use_price_2(quantity)
                                                                            unit_quantity_tier_discount_price = self.quantity_discount.Price2B
                                                                          elsif self.quantity_discount.use_price_3(quantity)
                                                                            unit_quantity_tier_discount_price = self.quantity_discount.Price3B
                                                                          elsif self.quantity_discount.use_price_4(quantity)
                                                                            unit_quantity_tier_discount_price = self.quantity_discount.Price4B
                                                                          end
                                                            else
                                                                         unit_quantity_tier_discount_price =  self.PriceB
                                                            end
                                                            #END BLANK CUSTOMER  ---
                                                            #
                                                            #BEGIN FRANCHISE CUSTOMER  ---
                                              elsif customer.PriceLevel == 3
                                                              if  self.quantity_discount
                                                                            if  self.quantity_discount.use_pre_tier_price(quantity)
                                                                              unit_quantity_tier_discount_price = self.PriceC
                                                                            elsif self.quantity_discount.use_price_1(quantity)
                                                                              unit_quantity_tier_discount_price = self.quantity_discount.Price1C
                                                                            elsif self.quantity_discount.use_price_2(quantity)
                                                                              unit_quantity_tier_discount_price = self.quantity_discount.Price2C
                                                                            elsif self.quantity_discount.use_price_3(quantity)
                                                                              unit_quantity_tier_discount_price = self.quantity_discount.Price3C
                                                                            elsif self.quantity_discount.use_price_4(quantity)
                                                                              unit_quantity_tier_discount_price = self.quantity_discount.Price4C
                                                                            end
                                                              else
                                                                             unit_quantity_tier_discount_price =  self.PriceC
                                                              end
                                                              #END BLANK CUSTOMER  ---
                                                              #
                                                              #
                                                              #
                                              else
                                                            unit_quantity_tier_discount_price =   unit_quantity_tier_discount_price = self.Price
                                              end
                              end
              end
          return   unit_quantity_tier_discount_price
  end
########################################################################################################





def new_number_made_from_last_core_value
        logger.debug "self.prefix_from_full_item_lookup_code.class: " + self.prefix_from_full_item_lookup_code.class.to_s
        logger.debug "Item.last_core_value class: " + Item.last_core_value.class.to_s

           return   self.prefix_from_full_item_lookup_code +    Item.last_core_value 
end


  def prefix_from_full_item_lookup_code
          if self.ItemLookupCode.split('-').size > 1
                       return  self.ItemLookupCode.split('-').first +  '-'
          else
                              if self.ItemLookupCode.upcase.match('[A-Z][A-Z]') != nil
                                                return  self.ItemLookupCode.split('-').first.upcase.match('[A-Z][A-Z]')[0].to_s
                                  else
                                                  return ''
                                  end
          end
  end


  def self.last_core_value
             items = Item.order("id DESC" ).limit("200").all
            potential_last_core_values = Set.new
            items.each do |item|
                       potential_last_core_values.add?(  item.core_grep_value )
            end
            if  potential_last_core_values.sort.last
                       return    potential_last_core_values.sort.last.to_s
            else
                       items = Item.order("id DESC" ).limit("700").all
                      potential_last_core_values = Set.new
                      items.each do |item|
                                 potential_last_core_values.add?(  item.core_grep_value )
                      end
                       return    potential_last_core_values.sort.last.to_s
            end
  end


  def core_grep_value
        self.ItemLookupCode.grep /^[0-9][0-9][0-9][0-9]$/

  end

  

def most_popular_compatible_opposite( websites_department_ids_to_search)
             logger.debug "self.category_id:  " +  self.category_id.to_s
             logger.debug "self.category.category_class.item_type: " + self.category.category_class.item_type
             logger.debug "self.category.category_class.name " + self.category.category_class.name
        logger.debug "websites_department_ids_to_search: " +  websites_department_ids_to_search.inspect
            logger.debug " self.applicable_opposite_category_ids: " +  self.applicable_opposite_category_ids.inspect

#            mpco_candidates =   Item.order("item_class_sales_this_years_with_item_ids.sum_of_quantity DESC").includes(:item_class_component, :category, :department, :item_class_sales_this_years_with_item_id ).where("items.department_id in (?)",  websites_department_ids_to_search.split(/,/)  )
#            mpco_candidates =   Item.order("item_class_sales_this_years_with_item_ids.sum_of_quantity DESC").includes(:item_class_component, :category, :department, :item_class_sales_this_years_with_item_id ).where("items.category_id in (?)", self.applicable_opposite_category_ids   )
#            mpco_candidates =   Item.order("item_class_sales_this_years_with_item_ids.sum_of_quantity DESC").includes(:item_class_component, :category, :department, :item_class_sales_this_years_with_item_id ).where("items.category_id in (?) and items.department_id in (?)", self.applicable_opposite_category_ids, websites_department_ids_to_search ).all
#               mpco_candidates =   Item.order("item_sales_this_years.sum_of_quantity DESC").includes(:item_class_component, :category, :department, :item_sales_this_year ).where("items.category_id in (?) and items.department_id in (?)", self.applicable_opposite_category_ids, websites_department_ids_to_search ).all
               mpco_candidates =   Item.order("item_sales_this_years.sum_of_quantity DESC").includes(:item_class_component, :category, :department, :item_sales_this_year ).where("items.category_id in (?) and items.department_id in (?)", self.applicable_opposite_category_ids, websites_department_ids_to_search ).all
               
              #logger.debug "mpco_candidates: " + mpco_candidates.size.to_s
              #  mpco_candidates.each do |mpco|
              #             logger.debug "mpco.ItemLookupCode :" + mpco.ItemLookupCode +  "sum_of_quantity: " +
              #              if mpco.item_sales_this_year
              #                        logger.debug "mpco.item_sales_this_year.sum_of_quantity.to_s"  +  mpco.item_sales_this_year.sum_of_quantity.to_s
              #              else
              #                         logger.debug "mpco.item_sales_this_year.sum_of_quantity is NULL"
              #              end
              #  end
              #  ss = 'ss'
              #  t = 'tt'
  return mpco_candidates.first
end

def most_popular_compatible_opposites
            mpco_candidates =   Item.limit('15').order("item_class_sales_this_years_with_item_ids.sum_of_quantity DESC").includes(:item_class_component, :category, :department, :item_class_sales_this_years_with_item_id ).where("category_id in (?)", self.applicable_opposite_category_ids)
            return mpco_candidates
end

  def png_image_name
              self.ItemLookupCode + '.png'
  end


  def source_png_exists?
                  File.file?(  source_png_file_url  )
  end

  def source_png_file_url
                     'W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' + self.png_image_name
end


  def designer_front_file_image_name
                    self.ItemLookupCode + '-0.jpg '
end


def designer_front_file_url
                     'W:\\AUTOMATION_DATABASE\PRODUCTION_FILES\ALL-OVER-T\\' + self.designer_front_file_image_name
end


def designer_front_exists?
                   File.file?(  designer_front_file_url  )
end

def designer_back_file_image_name
                    self.ItemLookupCode + '-1.jpg '
end

def designer_back_file_url
                     'W:\\AUTOMATION_DATABASE\PRODUCTION_FILES\ALL-OVER-T\\' + self.designer_back_file_image_name
end

def designer_back_exists?
                   File.file?( designer_back_file_url )
end


  def is_applicable_with?( design )
             logger.debug "design.category_id: " +  design.category_id.to_s
             logger.debug " self.applicable_opposite_category_ids: " +  self.applicable_opposite_category_ids.join(',').to_s
              if  self.applicable_opposite_category_ids.include?( design.category.id.to_s )
                           true
              else
                           false
              end
  end



 def is_crest_print?
          if   crest_print_item_ids.include?( self.id )
                       true
          else
                      false
          end
 end


 def crest_print_item_ids
        the_ids = Set.new
          CrestPrint.all.each do |the_bp|
                  the_ids.add?( the_bp.item_id )
          end
          return the_ids
 end




def  applicable_crest_prints
                  logger.debug "self.department_id: " + self.department_id.to_s
                  crest_prints  = CrestPrint.where( "crest_prints.category_id = ?",  self.category_id.to_s  ).all
                  logger.debug "crest_prints.inspect: " + crest_prints.inspect


                  # default_crest_print = CrestPrint.where("category_id = ? and default_crest = ?", @back_design.category_id, 1  ).first
                  #default_crest_item_id = default_crest_print.item_id

                  #if crest_prints == [] or crest_prints.nil?
                  #      #is_nil
                  #      crest_prints  = CrestPrint.where( "crest_prints.category_id = ?", '0'  )
                  #else
                  #      #not_nil
                  #
                  #end
                  logger.debug "crest_prints.size: " + crest_prints.size.to_s
                  applicable_crest_prints = Set.new
                  crest_prints.sort_by{ |x| x.default_crest }.reverse.each do | the_bps|
                                logger.debug "the_bps"
                                the_item =
                                Item.unscoped do
                                    the_bps.item
                                end
                                if  the_item
                                  applicable_crest_prints.add?(  the_bps.item  )
                                                logger.debug "the_bps.item.id: " + the_bps.item_id.to_s + "   the_bps.item.ItemLookupCode: " +  the_bps.item.ItemLookupCode
                                else
                                                logger.debug "the_bps.inspect: " +  the_bps.inspect
                                end
                  end
                  logger.debug "find_applicable_crest_prints.size " + applicable_crest_prints.size.to_s
                  return  applicable_crest_prints.to_a
end

def  non_applicable_crest_prints
                  logger.debug "self.department_id: " + self.department_id.to_s
                  crest_prints  = CrestPrint.where( "crest_prints.category_id = ?",  self.category_id.to_s  ).all
                  logger.debug "crest_prints.inspect: " + crest_prints.inspect
                  #if crest_prints == [] or crest_prints.nil?
                  #      #is_nil
                  #      crest_prints  = CrestPrint.where( "crest_prints.category_id = ?", '0'  )
                  #else
                  #      #not_nil
                  #
                  #end
                  logger.debug "crest_prints.size: " + crest_prints.size.to_s
                  applicable_crest_prints = Set.new
                  crest_prints.each do | the_bps|
                                logger.debug "the_bps"
                                the_item =
                                Item.unscoped do
                                    the_bps.item
                                end
                                if  the_item
                                  applicable_crest_prints.add?(  the_bps.item  )
                                                logger.debug "the_bps.item.id: " + the_bps.item_id.to_s + "   the_bps.item.ItemLookupCode: " +  the_bps.item.ItemLookupCode
                                else
                                                logger.debug "the_bps.inspect: " +  the_bps.inspect
                                end
                  end
                  logger.debug "find_applicable_crest_prints.size " + applicable_crest_prints.size.to_s
                  return  applicable_crest_prints.to_a
end





def applicable_crest_print_ids
                    logger.debug "######################################"   ### REMEMBER TO UNSCOPE!!!
                    logger.debug "######################################"
                    bpdr = Set.new
                    self.applicable_crest_prints.each do | bpd |
                                bpdr.add?(  bpd.id )
                    end
                    logger.debug "bpdr.inspect: " +  bpdr.inspect
                    return  bpdr.to_a.join(',')
                    logger.debug "######################################"
                    logger.debug "######################################"
end




def crest_print_category_records
                    bpdr = Set.new
                    self.crest_prints.each do | bpd |
                                bpdr.add?(  bpd.department )
                    end
                    return  bpdr 
end





# def opposite_categories_most_popular_from_each_item_class
#   self.opposite_categories
# end

def item_class_item_lookup_code
          self.item_class_component.item_class.ItemLookupCode
end

def find_first_icc_from_each_category_of_applicable_opposites_in_departments(parameter_department_ids_array)
  #########     UNVERIFIED
          the_icc_items = Set.new
          parameter_department_ids_array.each do | the_dept_id|
                             the_icc_items <<  find_first_icc_from_each_category_of_applicable_opposites_in_department( the_dept_id )
          end
          the_icc_items
end


def opposite_categories
        @opposite_categories = Caching::MemoryCache.instance.read 'opposite_categories_' + self.category.category_class_id.to_s
        if @opposite_categories
                      logger.debug 'HIT OPPOSITE_CATEGORIES'
                     return @opposite_categories
        else
                      the_cats_set = Set.new
                     find_first_of_each_type_of_applicable_opposite.each do |the_item|
                          the_cats_set.add?(the_item.category)
                     end
                     Caching::MemoryCache.instance.write  'opposite_categories_' + self.category.category_class_id.to_s ,  the_cats_set.sort_by{|a| a.Name}
                     logger.debug 'MISSED OPPOSITE_CATEGORIES'
                      return the_cats_set.sort_by{|a| a.Name}
        end
end


 def opposite_category_ids
       the_cat_ids_set = Set.new
      opposite_categories.each do |the_cat|
                the_cat_ids_set.add?(the_cat.id)
      end
      return the_cat_ids_set
end



def opposite_departments
        @opposite_departments = Caching::MemoryCache.instance.read 'opposite_departments_' + self.category.id.to_s
        if @opposite_departments
                      logger.debug 'HIT OPPOSITE_DEPARTMENTS'
                     return @opposite_departments
        else
                      the_depts_set = Set.new
                     find_first_of_each_type_of_applicable_opposite.each do |the_item|
                          the_depts_set.add?(the_item.department)
                     end
                     the_opposite_deparments =  the_depts_set.sort_by{|a| a.Name}.to_a
                     Caching::MemoryCache.instance.write  'opposite_departments_' + self.category.id.to_s , the_opposite_deparments
                     logger.debug 'MISSED OPPOSITE_DEPARTMENTS'
                      return the_depts_set.sort_by{|a| a.Name}
        end
end

def opposite_department_ids
       the_dept_ids_set = Set.new
      opposite_departments.each do |dep_id|
                the_dept_ids_set.add?(dep_id.id)
      end
      return the_dept_ids_set
end





#######################################################################################################
def find_first_of_each_type_of_applicable_opposite_in_category(parameter_category)
		Item.first_of_component_items.to_set.intersection(self.parameter_plus_additive_items(parameter_category).to_set)
end
#######################################################################################################
  def parameter_plus_additive_items(parameter_category)
    additive_cat_ids = parameter_category.additive_category_ids_split.to_set if parameter_category.additive_category_ids_split
    cat_ids = parameter_category.id.to_s.split(',').to_set.add(additive_cat_ids)
    n_cat_ids = cat_ids.flatten
    return  Item.includes(:item_class_component).where("category_id in (?)", n_cat_ids  )
  end
#######################################################################################################
def self.deprecate_bad_see_below_find_first_of_each_type_from_parameter_category_plus_additive_item_categories(parameter_category)
        if parameter_category.class == String
                parameter_category = Category.find parameter_category
        end
          additive_cat_ids = parameter_category.additive_category_ids_split.flatten.to_set if parameter_category.additive_category_ids_split
           logger.debug "additive_cat_ids.inspect: "+  additive_cat_ids.inspect
          #cat_ids = parameter_category.id.to_s.to_set.add(additive_cat_ids)
          cat_ids = additive_cat_ids.add( parameter_category)   #.id.to_s.to_set.add(additive_cat_ids)
          logger.debug "cat_ids.inspect: "+  cat_ids.inspect
          xx = 'xx'
          n_cat_ids = cat_ids.flatten
          items_in_categories = Item.order("item_class_sales_this_years_with_item_ids.sum_of_quantity DESC").includes(:item_class_component,:item_class_sales_this_years_with_item_id).where("items.category_id in (?) and items.id in (?)", n_cat_ids ,  Item.first_of_components_item_ids  )
          logger.warn "########################################################################"
          logger.warn "########################################################################"
          logger.warn "########################################################################"
          logger.warn "item.rb reports: items_in_categories: " + items_in_categories.inspect
          logger.warn "item.rb reports: items_in_categories.size in model: " + items_in_categories.size.to_s
          logger.warn "########################################################################"
          logger.warn "########################################################################"
          logger.warn "########################################################################"
        return items_in_categories
      #	return Item.first_of_component_items.to_set.intersection(items_in_categories.to_set)    #.to_a.sort_by{|a| a.sum_of_quantity}.reverse
end



  def self.find_first_of_each_type_from_parameter_category_plus_additive_item_categories(parameter_category)

    items_in_categories = Caching::MemoryCache.instance.read  'find_first_of_each_type_from_parameter_category_plus_additive_item_categories_parameter_category_' + parameter_category.id.to_s  unless Rails.configuration.action_controller.perform_caching == false
    if items_in_categories
            logger.debug "FOUND USING CACHE:   find_first_of_each_type_from_parameter_category_plus_additive_item_categories"
            return items_in_categories
    else
            parameter_category = Category.find parameter_category
            additive_cat_ids = parameter_category.additive_category_ids_split.to_set if parameter_category.additive_category_ids_split
            cat_ids = parameter_category.id.to_s.split(',').to_set.add(additive_cat_ids)
            n_cat_ids = cat_ids.flatten
            logger.debug "n_cat_ids.inspect: " + n_cat_ids.inspect
            logger.debug "Item.first_of_components_item_ids: " + Item.first_of_components_item_ids.inspect
            #items_in_categories = Item.find(:all, :conditions => ["category_id in (?) and Inactive != -1", n_cat_ids ])

            #items_in_categories = Item.find(:all ,:include => [ :item_class_sales_this_years_with_item_id ] , :conditions => ["items.id in (?) and items.category_id in (?) and Inactive != -1", Item.first_of_components_item_ids, n_cat_ids ]  ,  :order       => 'item_class_sales_this_years_with_item_ids.sum_of_quantity DESC'    )

            items_in_categories = Item
                      .where("category_id in (?)",   n_cat_ids    )
                      .includes(:item_class_sales_this_years_with_item_id).where("items.id in (?)", Item.first_of_components_item_ids)

            Caching::MemoryCache.instance.write  'find_first_of_each_type_from_parameter_category_plus_additive_item_categories_parameter_category_' + parameter_category.id.to_s , items_in_categories  unless Rails.configuration.action_controller.perform_caching == false
            return items_in_categories
    end

    #return Item.first_of_component_items.to_set.intersection(items_in_categories.to_set)
  end

#######################################################################################################
def self.first_of_component_items
#  deprecated_first_of_component_items
	Item.order("item_class_sales_this_years_with_item_ids.sum_of_quantity DESC").includes(:item_class_component, :category, :department, :item_class_sales_this_years_with_item_id ).where("items.id in (?)", Item.first_of_components_item_ids )
end
#######################################################################################################
def self.find_first_of_each_type_from_parameter_category_plus_additive_item_categories_plus_non_symbiont_items(parameter_category)
            logger.warn "########################################################################"
            logger.warn "########################################################################"
            logger.warn "########################################################################"
            a = Item.find_first_of_each_type_from_parameter_category_plus_additive_item_categories(parameter_category).to_set
            logger.warn "a: " + a.inspect
            b = a.merge(Item.non_component_items_in_category(parameter_category).to_set)
          #  b = a
            logger.warn "b: " + b.inspect
            logger.warn "########################################################################"
            logger.warn "########################################################################"
            logger.warn "########################################################################"
            return b
end
#######################################################################################################
 def clone_item_of_type( clone_item_type_id )
              CloneItem.find( :first, :include => ["item"], :conditions => ["clone_items.clone_item_type_id = ? and clone_items.item_id = ? and items.Description IS NOT NULL" ,  clone_item_type_id  , self.id     ] )
end
#######################################################################################################
def clone_item_status( clone_item_type_id )
          the_clone_item =   self.clone_item_of_type( clone_item_type_id )

          if the_clone_item
                    the_clone_item_clone =  the_clone_item.clone
                    if the_clone_item_clone
                                if the_clone_item_clone_file_exists?
                                    true
                                else
                                      'clone_requested_but_not_completed'
                                end

                    else
                             'clone_item_improperly_created'
                    end
          else
                  'clone_not_requested'
          end
end
#######################################################################################################
def the_clone_item_clone_file_exists?( clone_item_type_name  , clone_item_clone_itemlookupcode )
      if File.file?( 'W:\\AUTOMATION_DATABASE\\PRODUCTION_JPG\\' + clone_item_type_name + '\\' + clone_item_clone_itemlookupcode + '.jpg ' )
                true
      else
               false
      end
end
#######################################################################################################
def stock_design_file_exists?
      if File.exists?( self.stock_design_filename   +  '.psd') or  File.exists?( self.stock_design_filename   +  '.tif')
                true
      else
               false
      end
end

def stock_design_filename
           @@STOCK_DESIGN_PATH  +  self.bare_filename
end


def self.item_class_included
           includes(:item_class).
             where("items.department_id in (?)" , ['35']  ).all
end


 def self.in_departments( departments)
      where("items.department_id in (?)" , departments  )
 end

 def self.first_of_item_class( departments)
   joins( :item_class ) & Item.in_departments(departments)
 end

 
def available_image_name
          if    rio( RIO.cwd +  "/public/images/item_thumbnails/" +  self.png_image_name ).exist?
                       "/images/item_thumbnails/" +  self.png_image_name
          elsif    rio( RIO.cwd +  "/public/images/item_thumbnails/" +  self.jpg_image_name ).exist?
                     '/images/item_thumbnails/' + self.jpg_image_name
          else
                      '/images/item_thumbnails/missing-thumbnail.jpg'
          end
end


def show_derivative_locations?
        if self.usable_core_number?
                    true
        else
                   if Item.unscoped.exists?([ "ItemLookupCode = ? or ItemLookupCode = ?",  self.core_number_only,  self.core_number_only + 'L' ])
                                    true
                   else
                                     false
                   end
end

end



def usable_core_number?
      if self.category.clone_item_type
                      if self.category.clone_item_type.core_number == '1'
                                      true
                      else
                                     false
                      end
      else
            false
      end
end


def core_number_only
			no = self.ItemLookupCode.split('-').last[/\d+/]
			if no.nil?
					'0'
			else
					no
			end
 end


def number_only
			no = self.ItemLookupCode[/\d+/]
			if no.nil?
					'0'
			else
					no
			end
 end

def base_itemlookupcode
          self.ItemLookupCode.split('-').first
end


def ytdn          
           if self.item_sales_this_year
                  return  self.item_sales_this_year.sum_of_quantity
           else
                return 0
           end
end

def lytdn
           if self.item_sales_last_year
                  return  self.item_sales_last_year.sum_of_quantity
           else
                return 0
           end
end

def  new_clone_with_default_attributes( clone_item_example_id , clone_item_type_id )
          the_clone_item_example = Item.find clone_item_example_id
          new_clone = the_clone_item_example.clone
          new_clone.Description =  self.Description
          new_clone.ItemLookupCode =    the_clone_item_example.base_itemlookupcode + '-' + self.number_only
          new_clone.save
          new_clone_item = CloneItem.new

          new_clone_item.clone_id = new_clone.id
          new_clone_item.item_id = self.id
          new_clone_item.clone_item_type_id = clone_item_type_id
          new_clone_item.save
end


def generic_values
#          item = Item.new
#          item.SubDescription1 = '0',
#          item.SubDescription2 = '0',
#          item.ExtendedDescription = '0',
#          item.Consignment = 1 ,
#          item.SubDescription3 = 1 ,
#          item.message_id = 1 ,
#          item.SalePrice = 1 ,
#          item.CommissionAmount = 1 ,
#          item.Content = '1' ,
#          item.DateCreated = Time.now ,
#          item.sale_schedule_id= 0 ,
#          item.MSRP = 0 ,
#          item.ItemNotDiscountable = 0 ,
#          item.quantity_discount_id = 0 ,
#          item.CommissionPercentSale = 0 ,
#          item.SaleType = 0 ,
#          item.category_id = 0 ,
#          item.Weight = 1 ,
#          item.ItemType = 0 ,
#          item.DoNotOrder = 1 ,
#          item.supplier_id = 1 ,
#          item.WebItem = 1 ,
#          item.SubCategoryID = 0 ,
#          item.CommissionMode = 0 ,
#          item.BlockSalesReason = 0 ,
#          item.BlockSalesType = 0 ,
#          item.department_id = 1 ,
#          item.ItemLookupCode = 1 ,
#          item.CommissionPercentProfit = 1 ,
#item.Description = 'asdfasds' ,
#          item.block_sales_schedule_id = 1 ,
#          item.LastUpdated = Time.now ,
#          item.PictureName = 1 ,
#          item.Cost = 1 ,
#          item.Price = 1 ,
#          item.PriceA = 1 ,
#          item.PriceB = 1 ,
#          item.PriceC = 1 ,
#          item.Quantity = 1 ,
#          item.Inactive = 0
#          item.save
#          item
end



def main_item_status
  if self.stock_design_file_exists? and self.design_separation_file_exists? and  self.all_over_file_exists?
        true
  else
        false
  end
end


 def call_method( method_name)
              method(method_name).call if method_name
  end

def bare_filename
        self.PictureName.gsub(/.png/, '')
end

def status_tip( the_status_name )
            the_tip_case = case the_status_name
            when  'stock_design_file_exists?' then  self.stock_design_filename +  ' as .psd or .tif'
            when 'production_file_exists?' then 'Main designs do not have production file, only clones '
            when 'template_file_exists?' then   'Main designs do not have template file, only clones'
            when 'design_separation_file_exists?' then  self.design_separation_filename +  ' as .psd or .tif'
            when 'prefix_is_set?' then 'The prefix is currently: ' +  self.clone.category.prefix
            when 'web_category_is_true?' then 'This items category web_category is to: ' +  self.clone.category.web_category
            when 'category_class_id_is_set?' then  'The category_class_id is currently: ' +  self.clone.category.category_class_id.to_s
            when 'thumbnail_image_exists?' then  self.item_thumbnail_filename
            when 'specsheet_image_exists?' then  self.item_specsheet_filename
            when 'item_is_webitem?' then 'WebItem is currently set to: ' +  self.clone.WebItem.to_s
            end
end

  def all_over_file_exists?
           if File.exists?(   self.all_over_filename   +  '.png')
                true
           else
                false
           end
  end

def all_over_filename
          @@ALL_OVER_PRODUCTION_JPGS +  self.bare_filename
end


def production_file_exists?
     stock_design_file_exists?
end

def template_file_exists?
       stock_design_file_exists?
end


  def design_separation_file_exists?
           if File.exists?(   self.design_separation_filename   +  '.psd')  or   File.exists?(  self.design_separation_filename   +  '.tif')
                true
           else
                false
           end
  end

def design_separation_filename
          @@DESIGN_SEPARATION_PATH +  self.bare_filename
end

def web_category_is_true?
     self.category.web_category != '0'
end

def category_class_id_is_set?
      self.category.category_class_id != 31
end

 def prefix_is_set?
     self.category.prefix != '0'
end

def thumbnail_image_exists?
    if Net::HTTP.get_response(URI.parse( self.item_thumbnail_filename  )).code == "200"
                true
      else
               false
      end
end

def item_thumbnail_filename
         'http://localhost:7000/images/item_thumbnails/' + self.PictureName
end

def specsheet_image_exists?
    if Net::HTTP.get_response(URI.parse( self.item_specsheet_filename  )).code == "200"  #other response is message
                true
      else
               false
      end
end

def item_specsheet_filename
       'http://localhost:7000/images/item_specsheets/' + self.PictureName
end

def item_is_webitem?
      self.WebItem?
end

  #############################################################################################################################

def all_over_shirt_design_department_ids
        return  RecordGroup.all_over_shirt_department_ids.to_s
end

def self.all_over_shirt_design_department_ids
        return  RecordGroup.all_over_shirt_department_ids
end

def sum_of_prices
		begin
			return quantity_discount.Price1 + quantity_discount.Price1A + quantity_discount.Price1B + quantity_discount.Price1C + quantity_discount.Price2 + quantity_discount.Price2A + quantity_discount.Price2B + quantity_discount.Price2C + quantity_discount.Price3 + quantity_discount.Price3A + quantity_discount.Price3B + quantity_discount.Price3C
		rescue
				0.0
		end
end
#############################################################################################################################
def item_ids_in_category_with_same_sum_of_prices
			@iwsp = []
      		self.category.items.each do |category_item|
			                  @iwsp << category_item.id.to_s  if  category_item.sum_of_prices == self.sum_of_prices
              end
        return  @iwsp
 end 

def is_first_item_in_category_with_same_sum_of_prices
		if self == self.first_item_in_category_with_same_sum_of_prices
				true
		else
				false
		end
end

def first_item_in_category_with_same_sum_of_prices
		return Item.find(:first, :conditions => ["id in (?) ", self.item_ids_in_category_with_same_sum_of_prices] )
end

def items_in_category_with_same_sum_of_prices
      return Item.find(:all, :conditions => ["id in (?)", self.item_ids_in_category_with_same_sum_of_prices] )
end

#############################################################################################################################

def item_ids_in_class_with_same_sum_of_prices
			@iwsp = []
      		self.item_class.item_class_components.each do |icc|
			                  @iwsp << icc.item.id.to_s  if icc.item.sum_of_prices == self.sum_of_prices
              end
        return  @iwsp
 end 

def is_first_item_in_class_with_same_sum_of_prices
		if self == self.first_item_in_class_with_same_sum_of_prices
				true
		else
				false
		end
end

def first_item_in_class_with_same_sum_of_prices
		return Item.find(:first, :conditions => ["id in (?) ", self.item_ids_in_class_with_same_sum_of_prices] )
end

def items_in_class_with_same_sum_of_prices
      return Item.find(:all, :conditions => ["id in (?)", self.item_ids_in_class_with_same_sum_of_prices] )
end

def colors_of_items_in_class_with_same_sum_of_prices_separated_by_commas
        @colors = Set.new
        self.items_in_class_with_same_sum_of_prices.each do |the_item|
              @colors =	@colors.add(the_item.color)
        end
      return @colors.to_a.join(',')
end
      
  def sizes_of_items_in_class_with_same_sum_of_prices_separated_by_commas
        @sizes = Set.new
        self.items_in_class_with_same_sum_of_prices.each do |the_item|
              @sizes =	@sizes.add(the_item.size)
        end
      return @sizes.to_a.join(',')

end




#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
#############################################################################################################################


#############################################################################################################################
def self.ids_array(items)
			the_ids_array = []
			items.each do |it|
					the_ids_array << it.id
			end
			return the_ids_array
end
#############################################################################################################################
def commissionable_dollars_sold(begin_date,end_date)
		@records_to_calculate = sales_entry_records(begin_date,end_date)
		
	#	debugger
		
		if @records_to_calculate
				@rtc = 0.0
				@records_to_calculate.each do |rec|
						@rtc +=  rec.QuantityRTD * rec.commissioned_price
				end
				return @rtc
		else
				return 0
		end
end
#############################################################################################################################
def lowest_quantity_discount_price_b
			if quantity_discount.Price4B > 0.0
						return quantity_discount.Price4B
			elsif  quantity_discount.Price3B > 0.0
						return quantity_discount.Price3B
			elsif  quantity_discount.Price2B > 0.0
						return quantity_discount.Price2B
			elsif  quantity_discount.Price1B > 0.0
						return quantity_discount.Price1B	
			else
				return 0.0
			end
end
#############################################################################################################################
def  self.add_all_commissions(items, begin_date, end_date )
		@items = items
		if @items
				@all_commissions_total = 0.0
				@items.each do |it|
							@all_commissions_total +=      it.commission_in_dollars(begin_date, end_date )
				end	
				return @all_commissions_total
		else
				return 0.0
		end
end
#############################################################################################################################
def commission_percent_multiplier
		self.CommissionPercentSale * 0.01
end
#############################################################################################################################
def commission_in_dollars(begin_date,end_date)
					@rtc = 0.0
						if  self.CommissionAmount > 0
										@rtc += self.commissionable_quantity(begin_date,end_date)  * self.CommissionAmount 
						elsif self.CommissionPercentSale > 0
										@records_to_calculate = sales_entry_records(begin_date,end_date)
										if @records_to_calculate  
										  @records_to_calculate.each do |se|
													@rtc   +=    se.combined_total 
											end
										end
						else
								@rtc += 0.0
						end
						return @rtc
end
#############################################################################################################################
def quantity_sold(begin_date,end_date)
		#conditions = ["item_id = ? and sales.sale_time > ? and sales.sale_time < ?  and Quantity > 0", self.id, begin_date, end_date ] 
		conditions = ["item_id = ? and sales.sale_time > ? and sales.sale_time < ?  and Quantity > 0 and sales.customer_id IS NOT NULL", self.id, begin_date, end_date ] 
		SalesEntry.sum("Quantity", :conditions => conditions, :include => ['sale'] )
		#SalesEntry.find( :all, :conditions => conditions, :include => ['sale'] )
end
#############################################################################################################################
def quantity_returned(begin_date,end_date)
		conditions = ["item_id = ? and sales.sale_time > ? and sales.sale_time < ? and Quantity < 0 ", self.id, begin_date, end_date ] 
		SalesEntry.sum("Quantity", :conditions => conditions, :include => ['sale'] )
end
#############################################################################################################################
def commissionable_quantity(begin_date,end_date)
		conditions = ["item_id = ? and sales.sale_time > ? and sales.sale_time < ? ", self.id, begin_date, end_date ] 
		SalesEntry.sum("Quantity", :conditions => conditions, :include => ['sale'] )
end
#############################################################################################################################
def sales_entry_records(begin_date,end_date)
		conditions = ["item_id = ? and sales.sale_time > ? and sales.sale_time < ?  and Quantity > 0 and sales.customer_id IS NOT NULL", self.id, begin_date, end_date ] 
		SalesEntry.find( :all, :conditions => conditions, :include => ['sale'] )
end

#############################################################################################################################
#############################################################################################################################
#############################################################################################################################
def default_opposite_product
		#begin
			all_opposite_category_ids = self.category.category_class.opposite_category_ids.split(/,/)
      logger.debug "all_opposite_category_ids: " + all_opposite_category_ids.to_s
      logger.debug "all_opposite_category_ids.class : " + all_opposite_category_ids.class.to_s
              opposite_categories_first_items  = Set.new
							opposite_categories = Category.find all_opposite_category_ids
							opposite_categories.each do |the_category|
                        the_category.items.each do |item|
                                      logger.debug "item.class.to_s: " + item.class.to_s
                                      if item.item_class_component
                                          item_class_component_items = Set.new
                                          item.item_class_component.item_class.item_class_components.each do |icc_item|
                                                item_class_component_items.add(icc_item)
                                           end
                                          first_chosen_item_class_component =   item_class_component_items.to_a.first
                                          to_add_first_item = first_chosen_item_class_component
                                          logger.debug "different_items.add(item)---------------different_items.add(#{item})"
                                      else
                                        to_add_first_item = item
                                      end
                                      opposite_categories_first_items.add(to_add_first_item)
                          end
              end
							return opposite_categories_first_items.first

		#rescue
		#	false
		#end
end
#############################################################################################################################
def default_opposite_item
		#begin
  all_opposite_category_ids = self.category.category_class.opposite_category_ids  #.split(/,/)
  different_items = Set.new
  the_category = Category.find all_opposite_category_ids   #.to_s
  the_category.items.each do |item|
    if item.item_class_component
      different_items.add(item)
      logger.debug "different_items.add(item)---------------different_items.add(#{item})"
    end
  end
  return different_items.to_a.first
	
		#rescue
		#	false
		#end
end
#############################################################################################################################
def has_exactly_one_opposite_category_with_one_item_class
    logger.debug "BEGIN item.has_exactly_one_opposite_category_with_one_item_class"
		begin
			all_opposite_category_ids = self.category.category_class.opposite_category_ids.split(/,/)
			if all_opposite_category_ids.size == 1 and all_opposite_category_ids != ['0']
							different_class_ids = Set.new
							the_category = Category.includes(:items).where("id in (?)",   all_opposite_category_ids.join(',') ).first
							the_category.items.each do |item|
										if item.item_class_component
												different_class_ids.add(item.item_class_component.item_class.id) if item.item_class_component.item_class
												logger.debug "different_class_ids.add(item.item_class_component.item_class.id)---------------different_class_ids.add(#{item.item_class_component.item_class.id})"
										end
							end
							if different_class_ids.size == 1
									true
							else
									false
							end
			else
				return false
			end
		rescue
			false
		end
    logger.debug "END item.has_exactly_one_opposite_category_with_one_item_class"
end
#############################################################################################################################


def notes_as_keywords
			if self.Notes
				split_notes = self.Notes.split.collect{|c| "#{c + ','}"}
					if split_notes.size> 0
							split_notes = split_notes.to_s
					else
								'0'
					end
			else
				'0'
			end
end





def self.easyfind(argHash) ## this is work in progress
    fieldnames = argHash[:fieldnames]
    keywords = argHash[:keywords]
    order = argHash[:order]
    incl = argHash[:include]
    unless keywords.empty?
        keywordArray = []
        theSqlArray = keywords.inject([]) do |agg, keyword| 
            aLineArray = fieldnames.inject([]) {|lineSectionsArray, aFieldname| 
                    keywordArray << '"' + keyword.downcase + '"'
                    lineSectionsArray << aFieldname + " LIKE LOWER(?)" 
                }
            aLine = aLineArray.join(" OR ")
            aLine = "(" + aLine + ")" 
            agg << aLine
        end
        theSql = theSqlArray.join(" AND ")
        result = self.find(:all, :conditions => [theSql] + keywordArray, :order => order, :include => incl)
    else
        result = []
    end
    return result
end


def self.update_hash(ids_to_change_category_parameter)
 	a = ids_to_change_category_parameter
  a.collect {|x| "#{x} => 'category_id' => 7 "}
  return a
end


def ids_to_change_category
		icc_ids = []
	if self.item_class_component
		 	self.item_class_component.item_class.item_class_components.each do |icc|
		 		icc_ids << icc.item.id.to_s 
			end
			return icc_ids.split(/,/).flatten 
	else
		return icc_ids << self.id
	end
end


def color
  if self.item_class_component
              	return self.item_class_component.color
    else
        return  'no_color'
    end
end
#######################################################################################################
def designer_specsheet_url

  
end


#######################################################################################################
def image_url(department,directory='thumbnails/',design='_back',item_prefix_override="0" )
#debugger
#			begin
			#debugger
                  if department == nil or department == false
                      department = self.default_master_department_id
                    end
                            if department.class == Fixnum or  department.class == String
                              department = Department.find(department)
                            end
                            if  design == '_back'
                                        image_url  = @item.PictureName.split('.')[0] + '_back.png'
                            elsif  design == '_front'
                                         image_url  =@item.PictureName

                            elsif design != 'x' and design != nil
                                        directory = 'item_combinations/'
                                        if self.item_class_component
                                               image_url  =   '/images/' + directory +  self.item_class_component.item_class.ItemLookupCode + '/' + department.letter_section_code + self.number   + self.color + '_' + design.category.prefix  + '_' +  design.number  +  design.opacity_letter +  '.jpg'
                                        else
                                              image_url  =  '/images/' +  directory +  self.number + '/' + department.letter_section_code + self.number   + self.color + '_' + design.category.prefix  + '_' +  design.number  +  design.opacity_letter +  '.jpg'
                                       end
                            elsif self.category.category_class.item_type == 'slave'
                                               image_url =  '/images/' + directory + self.PictureName
                            elsif self.category.category_class.item_type == 'master'
                                       if self.category.use_generic_department != '0'
                                               image_url   =   '/images/' +  directory   +  self.number  + self.shade_letter + 'a' + self.category.prefix + '_' + self.color +  '.png'
                                       else

                                               if item_prefix_override == '0' or item_prefix_override == nil
                                                 image_url   =   '/images/' +   directory +  self.number  + self.shade_letter +  department.letter_section_code + self.category.prefix + '_' + self.color +  '.png'
                                              else
                                                  if self.category.use_generic_department == '0' or self.category.use_generic_department == nil
                                                 image_url   =   '/images/' +   directory +  self.number  + self.shade_letter +   department.letter_section_code + item_prefix_override + '_' + self.color +  '.png'  ##current error
                                                else
                                                  image_url   =    '/images/' +  directory +  self.number  + self.shade_letter +  'a' + item_prefix_override + '_' + self.color +  '.png'  ##current error
                                              end
                                            end
                                       end
                             elsif self.category.category_class.item_type == 'all_over_design'
                                                  image_url  =      '/images/' +   directory +  self.ItemLookupCode + '-0.png'
                               elsif  self.category.use_picturename == '1'
                                                   image_url  =     '/images/' +   directory +  self.PictureName
                               else
                                                  if self.category.use_generic_department != '0'
                                                    image_url  =    '/images/' +    directory +  self.number +  'nona' + '_' + self.color +  '.png'  ##since this item is set to use generic, it will be 'nona'
                                                 else
                                                    image_url  =   '/images/' +  directory + self.number + 'non' + department.letter_section_code +  '_' + self.color +  '.png'  ##otherwise, it will be 'non' + the local department
                                                  end
                               end

                  image_url = image_url.gsub("/images//images", "/images")


                  if $request
                        if   $request.protocol == 'https://'
                                              image_url = image_url.gsub( "/images", "https://dixieoutfitters.com/images")
                        else
                                              image_url = image_url.gsub( "/images", "http://cdn.dixieoutfitters.com/images")
                        end
                  else
                                image_url = image_url.gsub( "/images", "https://dixieoutfitters.com/images")
                  end

            return image_url
              #rescue
               # 	'image_name_error'
							#end
end
###########################################################################################################################


def default_master_department_id
	   if self.category.use_generic_department == '0'
	                   if self.department_id == 1
	                               2
	                   elsif self.department_id == 5
	                              9
	                  else
	                              self.department_id
	                   end
	    else
	             self.department_id
	    end
end
########################################################################################################
def self.non_component_items_in_category(parameter_category)
#	Item.find(:all, :conditions => ["id in (?) and category_id = ? and Inactive != -1", Item.non_component_item_ids, parameter_category ])
  Item.where("id in (?) and category_id = ?", Item.non_component_item_ids, parameter_category )

end
#######################################################################################################
def find_applicable_opposite_items_in_parameter_category(parameter_category)
	return Item.includes(:item_class_component ).where("category_id in (?) and category_id = ?", self.applicable_opposite_category_ids, parameter_category )
end
#######################################################################################################
def find_applicable_opposites_in_parameter_category_and_additive_categories(parameter_category)
	items_applicable_and_non = Item.parameter_plus_additive_items(parameter_category)
	return self.items_in_opposites_categories.to_set.intersection(items_applicable_and_non)
end	
#######################################################################################################
def self.parameter_plus_additive_items(parameter_category)
	additive_cat_ids = parameter_category.additive_category_ids_split.to_set if parameter_category.additive_category_ids_split
	cat_ids = parameter_category.id.to_s.split(',').to_set.add(additive_cat_ids)
	n_cat_ids = cat_ids.flatten
	return Item.includes(:item_class_component).where("category_id in (?)", n_cat_ids )
end
#######################################################################################################
#######################################################################################################
#######################################################################################################
def find_applicable_categories_by_category(parameter_category)
	return Category.find(:all, :conditions => ["id = ? or id = ? and id in (?)", parameter_category  , parameter_category.additive_category_ids   , self.applicable_opposite_category_ids ])
end
#######################################################################################################
def find_applicable_categories_by_department(parameter_department)
	return Category.find(:all, :conditions => ["department_id = ? and id in (?)", parameter_department , self.applicable_opposite_category_ids ])
end
#######################################################################################################
def self.first_icc_items_from_master_categories
	first_icc_items = Set.new
	Category.includes(:items, :category_class).all.each do |cat|
		if cat.category_class.item_type == 'master'
			first_icc_items.add?(
         if cat.items.where("Inactive = ?", false).first
          if cat.items.where("Inactive = ?", false).first.item_class_component
            cat.items.where("Inactive = ?", false).first if cat.items.where("Inactive = ?", false).first
          end
         end
       )
		end
	end	
	return first_icc_items
end
#######################################################################################################
 def self.first_of_applicable_components_item_ids_in_categories(categories)
         fociti = []
         item_classes =  ItemClass.includes(:items).where("category_id in (?)", categories )
         for item_class in item_classes
           fociti  <<
               if item_class.items
                 if item_class.items.first
                   item_class.items.first.id  if item_class.items.first.Inactive == false
                 end
               end
         end
         return fociti
end
#######################################################################################################
def  self.first_of_components_item_ids
          #fociti = Caching::MemoryCache.instance.read  'first_of_components_item_ids'  unless Rails.configuration.action_controller.perform_caching == false
          #if fociti
          #          logger.debug "READ FIRST OF COMPONENTS ITEM IDS"
          #          logger.debug "READ FIRST OF COMPONENTS ITEM IDS"
          #          logger.debug "READ FIRST OF COMPONENTS ITEM IDS"
          #          logger.debug "READ FIRST OF COMPONENTS ITEM IDS"
          #          logger.debug "READ FIRST OF COMPONENTS ITEM IDS"
          #          logger.debug "READ FIRST OF COMPONENTS ITEM IDS"
          #         return fociti
          #else
                  fociti = []
                   items = Item.first_of_components_items
                    for item in items
                           fociti  <<   item.id  if  item and item.Inactive == false
                    end
                  #fociti = Caching::MemoryCache.instance.write  'first_of_components_item_ids'  , fociti
                  return fociti
           #end
end
########################################################################################################
def  self.first_of_components_items
          fociti = []
           item_classes =  ItemClass.includes(:items)
           	for item_class in item_classes
                   fociti  <<      
		                 if item_class.items  
		                   	if item_class.items.first
		                   		 item_class.items.first  if item_class.items.first.Inactive == false
                   			 end
		                 end
            end
        return fociti
end
########################################################################################################
def  self.first_of_components_items_for_each_color
          unique_names = []
          unique_color_items = []
           item_classes = ItemClass.includes(:items, :item_class_components).all
           	for item_class in item_classes    
		                 if item_class.items  
								item_class.items.each do |item|
									unique_name = item_class.ItemLookupCode.to_s + item.item_class_component.color.to_s
									if unique_names.include?(unique_name)
									else
									unique_names << unique_name
									unique_color_items << item
			                   		end 
	                   			end
		                 end
            end
        return unique_color_items
end
########################################################################################################
def find_first_icc_from_each_category_of_applicable_opposites_in_department(parameter_department)
	return Item.items_in_parameter_department_and_generic_department(parameter_department).to_set.intersection(Item.first_icc_items_from_master_categories.to_set.add(Item.non_component_items.to_set)).intersection(self.items_in_opposites_categories.to_set)
end
#######################################################################################################
def self.find_first_of_each_icc_of_applicable_opposite_in_department(parameter_department)
	Item.first_of_component_items.to_set.intersection(Item.items_in_parameter_department_and_generic_department(parameter_department).to_set)
end
#######################################################################################################
def self.items_in_parameter_department_and_generic_department(parameter_department)
	generic_department_id = Item.find_generic_department_id(parameter_department)
	items = Item.includes(:item_class_component, :category, :category_class, :department).where("department_id = ? or department_id = ?", parameter_department.id , generic_department_id    )
	return items
end
#######################################################################################################
def self.items_in_parameter_department(parameter_department)
	items = Item.includes(:item_class_component, :category, :category_class, :department).where("department_id = ? and Inactive != -1", parameter_department.id   )
	return items
end
#######################################################################################################
def self.find_generic_department_id(parameter_department)
               if parameter_department.id == 2 or parameter_department.id == 3
                          return 1
		      elsif parameter_department.id == 6 or parameter_department.id == 9
                          return 5
              else
                          return parameter_department.id
               end
end
#######################################################################################################
def split_additive_category_ids
	return self.category.additive_category_ids.split(/,/)
end	
#######################################################################################################
def parameter_plus_additive_category_items(parameter_category)
	Item.includes(:item_class_component, :category, :category_class, :department).where("category_id in (?)", parameter_category.parameter_and_symbiote_opposites_category_ids)
end
#######################################################################################################
def find_first_of_each_type_of_applicable_opposite
					return Item.first_of_component_items.to_set.intersection(self.items_in_opposites_categories.to_set)
end
#######################################################################################################
def opposite_representatives_sorted_by_sales # SLOW, CACHING IS A MUST
					return Item.first_of_component_items.to_set.intersection(self.items_in_opposites_categories.to_set).sort_by {|a| a.item_class_sales_this_years_with_item_id.sum_of_quantity}.reverse
end
#######################################################################################################



def applicable_opposite_category_ids
		return self.category.category_class.opposite_category_ids.split(/,/)
end
#######################################################################################################
def items_in_opposites_categories    #( websites_departments_to_search)
		#return Item.find_all_by_category_id(self.applicable_opposite_category_ids )

  	return Item.order("item_class_sales_this_years_with_item_ids.sum_of_quantity DESC").includes(:item_class_component, :category, :department, :item_class_sales_this_years_with_item_id ).where("category_id in (?)", self.applicable_opposite_category_ids )


end
#######################################################################################################
def  self.all_item_ids
        items =  Item.all
         all_item_ids = []
                      for item in  items
                            all_item_ids << item.id
                      end
        return all_item_ids
end
########################################################################################################
def self.non_component_applicable_master_ids
         ncami = []
         for item in self.non_component_items
                  ncami << item.id  if item.category.category_class.item_type == 'master' && item.Inactive == false
          end
          return ncami
end
########################################################################################################
def  self.all_component_item_ids
         item_classes = ItemClass.includes( 'item_class_components', 'items').all
         all_item_class_component_items = []
          for item_class in item_classes
                      for icc in   item_class.item_class_components 
                            all_item_class_component_items << icc.item_id if icc.item and icc.item.Inactive == false
                      end
              end
        all_item_class_component_items
end
########################################################################################################
def self.non_component_items
                  Item.includes(:item_class_component, :category, :department, :category_class).where("id in (?)", self.non_component_item_ids )
end
########################################################################################################
def self.non_component_item_ids
                  all_item_ids = []
                  all_items = Item.all   #.includes(:item_class_component).all
                  for item in all_items
                        all_item_ids << item.id if item and item.Inactive == false
                  end

                  return   all_item_ids -   self.all_component_item_ids
end
########################################################################################################
def  self.first_of_light_components_item_ids
          foic = []
           item_classes = ItemClass.includes(:items).all
            for item_class in item_classes
                   foic  <<      
                   if  item_class.light_components_only.first
                   		item_class.light_components_only.first.item_id if item_class.light_components_only.first.item.Inactive == false
             	   end
             
             
          end
        return foic
end
########################################################################################################
def self.search_items_max_one_component_using_keywords( website,keywords )
              non_class_item_ids
              first_of_class_item_ids
              
              search_conditions = [ " department_id in (?) and Description LIKE ? or ItemLookupCode LIKE ? and Inactive != -1 ",  website.all_department_ids, "%#{keywords}%","%#{keywords}%" ]
              Item.find(:all, :conditions => search_conditions )
end
########################################################################################################
def self.find_new_all_first_of_components_items_and_no_component_items( imported_scope_conditions )
        imported_scope_conditions =  ["id not like  ?", 7777]   if   imported_scope_conditions.nil?
        item_classes = ItemClass.find(:all,:include => [ :item_class_components ],  :order       => 'Detail2 ASC'   )
        first_item_class_component_item_ids  = Array.new
        all_item_class_component_item_ids = Array.new
        for item_class in item_classes
           first_item_class_component_item_ids <<      item_class.item_class_components.first.item_id  
                    for icc in   item_class.item_class_components 
                          all_item_class_component_item_ids << icc.item_id
                    end
            end
       no_component_items = []
       icc_first_items = []
       items = []
                               items_conditions = ["id not  IN (?) and Inactive != -1 " , all_item_class_component_item_ids ]
                              Item.with_scope(:find => { :conditions => imported_scope_conditions }) do
                                       no_component_items = Item.find(:all,:conditions => items_conditions, :limit => 20, :order       => 'DateCreated DESC' ,:include => [ :item_class_components, :category, :department, :category_class ])
                               end
                              icc_items_conditions = ["id   IN (?) and Inactive != -1",   first_item_class_component_item_ids  ] 
                               Item.with_scope(:find => { :conditions => imported_scope_conditions }) do
                                     icc_first_items = Item.find(:all,:conditions => icc_items_conditions, :limit => 20, :order       => 'DateCreated DESC' ,:include => [ :item_class_components, :category, :department, :category_class ] )
                              end
                              items = no_component_items.concat(icc_first_items).uniq
                       return items
end
########################################################################################################
def in_generic_department?
      if self.department.id == 1  or self.department.id == 5
            true
       else
            false
      end
end
########################################################################################################
def item_combination_slave_style_override
      if self.SubDescription3 != nil
                    style_array = self.SubDescription3
                    style_array = style_array.split(/,/)
                    if style_array[0] != nil && style_array[1] != nil && style_array[2] != nil
                           return       'position: relative; height: ' + style_array[0]  +  'px; left:' + style_array[1]  +  'px; top:'  +  style_array[2]  + 'px;'
                    else
                              false
                    end    
      else
                 false
      end
end
########################################################################################################
def opposites_applicable_item_class_components(item)
       #if  self.opacity_letter == 'o'
                 item.item_class_component.item_class.all_active_components
        #else
        #         item.item_class_component.item_class.light_components_only
        #end
end
########################################################################################################
#def self.find(*args)
#		options = args.extract_options!
#         validate_find_options(options)
#         set_readonly_option!(options)
#
#         case args.first
#         when :first then
#		           webitem_scope do
#		             	find_initial(options)
#		            end
#
#		      when :all   then
#		           webitem_scope do
#		               find_every(options)
#		           end
#		       when :all_not_scoped   then
#		                find_every(options)
#     			else
#     								find_from_ids(args, options)
#         end
#end
#########################################################################################################
####### PRICING / TOTALS AREA
def symbiont_your_unit_price(opposite,customer=0,quantity=1)   
        self.your_unit_price(customer,quantity).to_f + opposite.your_unit_price(customer,quantity).to_f
end

def your_unit_price(customer=0,quantity=1,the_purchases_entry=false)
        if customer != 0
                  if quantity != 0
                           up = full_unit_price(customer,the_purchases_entry).to_f  -  unit_quantity_and_permanent_savings(customer,quantity,the_purchases_entry).to_f
                           return sprintf("%.2f", up).to_f
                  else
                           0
                  end
        else
              if quantity != 0
                         up = full_unit_price(customer).to_f - unit_quantity_tier_discount_savings(customer,quantity).to_f
               			 return sprintf("%.2f", up).to_f
               else
                         0
                end
        end
end

def  full_unit_price(customer=0, the_purchases_entry)
        unit_quantity_tier_discount_price(customer,1, the_purchases_entry )
end


def department_is_permanent_or_volume_discountable
	if @@NOT_PERMANENT_OR_VOLUME_DISCOUNTABLE_DEPARTMENT_IDS.include?(self.department_id.to_s)
		false
	else
		true
	end
end


def unit_quantity_and_permanent_savings(customer=0,quantity=1,the_purchases_entry)
  if  quantity
        if customer 
            if self.department_is_permanent_or_volume_discountable == true  
                    permanent_discounted_savings =   self.unit_quantity_tier_discount_price(customer,quantity,the_purchases_entry).to_f  *   customer.permanent_discount_multiple.to_f    ##real error here
            else
                  permanent_discounted_savings = 0
            end
        else
          permanent_discounted_savings = 0
        end
        discounted_price =    self.unit_quantity_tier_discount_price(customer,quantity,the_purchases_entry).to_f  -     permanent_discounted_savings.to_f
        unit_quantity_and_permanent_savings = self.full_unit_price(customer,the_purchases_entry).to_f  - discounted_price.to_f
   else
        unit_quantity_and_permanent_savings = 0
   end 
          return unit_quantity_and_permanent_savings  
end

def unit_quantity_tier_discount_savings(customer=0,quantity=1, the_purchases_entry)
             unit_quantity_tier_discount_savings = self.full_unit_price(customer,the_purchases_entry).to_f   -     self.unit_quantity_tier_discount_price(customer,quantity,the_purchases_entry ).to_f
             unit_quantity_tier_discount_savings 
end

########################################################################################################
####### TESTING/REQUIREMENTS AREA
def design_decides_opposites_department
       if self.category.category_class.slaves_opposite_master_default_department_id != '0'
                self.category.category_class.slaves_opposite_master_default_department_id
      else
                false
      end
end


def masters_department_decides_default_department_id
	if self.department_id == 1
		return 2
	elsif self.department_id == 2
		return 2
	elsif self.department_id == 3
		return 3
	elsif self.department_id == 4
		return 4
	elsif self.department_id == 5
		return 9
	elsif self.department_id == 6
		return 6
	elsif self.department_id == 7
		return 7
	elsif self.department_id == 8
		return 8
	elsif self.department_id == 9
		return 9
	else
		return 2
	end
end


def in_error
        error_compilation = []
        incomplete = ['',0,'0',nil]         
                      if self.category.category_class
                                   if  self.category.category_class.item_type.to_s.include?("n") &&  incomplete.include?(self.PictureName)
                                            error_compilation << '-Non Item missing PictureName-' 
                                   end
                      else  
                            error_compilation << '-No Cat Class-' 
                      end                              
                      if  incomplete.include?(self.category.prefix)
                           error_compilation << '-Missing Prefix-' 
                      end
             if  error_compilation == []   
                   false
            else
                error_compilation
             end
end

def requires_license
      if self.department.license_required == true
                   true
      else
                    false
      end
end

########################################################################################################
####### VIRUTAL ATTRIBUTES AREA

#def description_after_backspace






def description_before_color_and_size
       description_before = StringScanner.new(self.Description)
       if description_before.exist?(/["\\"]/)
               description_in_progress  = description_before.scan_until(/["\\"]/)
               description_after =    description_in_progress.gsub('\\','')
                             return   description_after.to_s
        else
                 return self.Description.to_s
        end
end

def letter_section_code
    department = Department.find(self.department_id)
    letter_section_code = department.letter_section_code
end



def dimensions
         if ItemClassComponent.exists?(:item_id => self.id)
             if self.item_class_component.dimensions != nil
              		size = self.item_class_component.dimensions
              else
              		size =  ''
              end
        else
        	size =  ''
        end
end


def size
         if ItemClassComponent.exists?(:item_id => self.id)
             if self.item_class_component.size != nil
              size = self.item_class_component.size
              else
              size =  'no_size'
              end
        else
        size =  'no_size'
        end
end

def shade
	if self.SubDescription2
     self.SubDescription2.downcase
 	else
 		0.to_s
 	end    
end

def shade_letter
          if    self.shade  == 'light'
                              shade_letter = 'l'                   
          elsif self.shade == 'colored'
                              shade_letter = 'c'
           else
                         	  shade_letter = 'no item opacity info_'
          end
end

def opacity_description
      begin
          s = StringScanner.new( self.PictureName)  
        if item.category.category_class.item_type == 'slave'
	        if s.exist? /_o_/     
	                      "This design was created for both light and colored garments/items."  
	        else      
	                      "This design was created for light garments/items only." 
	        end  
		else
		end
	rescue
		return nil
	end
end
     


def opacity_football
          s = StringScanner.new( self.PictureName)  
        if s.exist? /_t_/     
                      "/images/indicators/Transparent.gif"
        else      
                    "/images/indicators/Opaque.gif"   
        end  
end
        
def opacity_letter
           if self.PictureName.include?'_t_'
                       't'
          elsif  self.PictureName.include?'_o_'
                      'o'
           else
                     'not_design'
            end
end


def number
          if self.item_class_component
                      return self.item_class_component.item_class.ItemLookupCode + '_'
          else
                                      a = StringScanner.new(self.PictureName)
                                      if a.nil?
                                                 return 'number is nil'
                                      else
                                                 c =  a.scan_until /_/
                                                 if c.nil?
                                                      return self.ItemLookupCode
                                                else
                                                    return c
                                                end
                                    end
          end
 end


def self.has_category
      where("items.category_id > ?", 0 )
end




protected

#scope :has_a_category, has_category                  #@categories = Category.hidden




########################################################################################################
########################################################################################################
########################################################### DEPRECATE  #################################
########################################################### DEPRECATE  #################################
########################################################### DEPRECATE  #################################
########################################################################################################
########################################################### DEPRECATE  #################################
########################################################### DEPRECATE  #################################
########################################################### DEPRECATE  #################################


end
