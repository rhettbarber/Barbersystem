class Website < ActiveRecord::Base
#require 'lazyeval'

  attr_accessible :name, :title, :default_item_department_ids, :default_design_department_ids, :domain, :phone, :meta_description, :meta_keywords, :allowed_admin_ips, :allowed_cashiers, :store_website, :catalog_item_id, :tracking_number


      has_many  :hidden_website_categories
	has_many  :user_authorities
	has_many   :pages
		has_many :purchases
  belongs_to :customer
    
scope :store_websites, :conditions => {:store_website => '1'}

cattr_accessor  :is_administrator_subdomain
cattr_accessor  :current_website_id




  def breast_print_category_ids
          hwcids = Set.new

          breast_print_categories = Category.unscoped.where("Name = ?", "pocket prints"   )

          breast_print_categories.each do |whc|
                    hwcids.add( whc.id )
          end

          return hwcids.to_a
  end




  def self.day_and_hour
    return  Time.now.strftime("%j") + "_" + Time.now.strftime("%H")
  end

  def self.week_number
        return Time.now.strftime("%U")
  end



  def self.website_search_items
    @website_search_items = Caching::MemoryCache.instance.read self.name + '_search_items'  #unless cache_on? == false
    if @website_search_items
             logger.info "-------------------------------------@website_search_items found by cache"
    else
            @website_search_items =  Item.where("items.department_id in (?)", self.default_all_department_ids_with_generic ).all
            logger.info "-------------------------------------@website_search_items NOT found by cache"
            Caching::MemoryCache.instance.write  self.name + '_search_items', @website_search_items, :expires_in => 257.minutes
    end
    return @website_search_items.to_a.flatten.join(",")
  end


  def website_search_item_ids
    @website_search_item_ids =  Caching::MemoryCache.instance.read self.name + '_search_item_ids'  #  unless cache_on? == false
    if @website_search_item_ids
      logger.debug "found @website_search_item_ids by cache"
      return @website_search_item_ids.to_a.flatten.join(',')
    else
      logger.info "------------------------------------- @all_website_item_ids not found, finding by activerecord"
      @website_search_items = Caching::MemoryCache.instance.read self.name + '_search_items'  #unless cache_on? == false
      if @website_search_items
        logger.info "-------------------------------------@website_search_items found by cache"
      else
        @website_search_items =  Item.where("items.department_id in (?)", self.default_all_department_ids_with_generic ).all
        logger.info "-------------------------------------@website_search_items NOT found by cache"
        Caching::MemoryCache.instance.write  self.name + '_search_items', @website_search_items, :expires_in => 257.minutes
      end
      @website_search_item_ids = Set.new
      @website_search_items.each do |item|
        @website_search_item_ids.add  item.id
      end
      Caching::MemoryCache.instance.write  self.name + '_search_item_ids', @website_search_item_ids
      logger.debug "@website_search_item_ids: " + @website_search_item_ids.inspect
      return @website_search_item_ids.to_a.flatten.join(",")
    end
  end



def hidden_website_category_ids
        @hwcids = Set.new
        self.hidden_website_categories.each do |whc|
               @hwcids.add( whc.category_id )
        end
        return @hwcids.to_a
end


  def designer_departments
#    debugger
    Department.where( "id in (?)", ['42','38'   ]  )

  end

def category_ids
          cat_ids = []
        default_all_departments.each do |dept|
                    dept.categories.each do |cat|
                          cat_ids << cat.id
                    end
        end
        return cat_ids
end


def in_allowed_cashiers(email_address)
	if self.allowed_cashiers
		if    self.allowed_cashiers.include?(email_address)
			return true
		else
			return false
		end
	else
		return false
	end
end

def self.full_width_pages
	['home']
end

def self.all_website_domains
	all_websites = Website.find(:all)
	all_domains = []
	all_websites.each do |website|
		all_domains << website.domain
	end	
	return all_domains
end	

def in_allowed_admin_ips(remote_address)
	if    self.allowed_admin_ips.include?(remote_address)
		return true
	else
		return false
	end
end	



def store_website
	if self.default_item_department_ids != '0'
		true
	else
		false
	end	
end

def self.current_website(http_host)
          s = StringScanner.new(http_host )
	        if s.exist?(/:100/ )
	                      find(1)
	        elsif s.exist?(/:200/)
	                      find(2)
	        elsif s.exist?(/:300/)
                        find(3)
	        elsif s.exist?(/:400/)
	                     find(2)
	        elsif s.exist?(/:500/)
	                      find(1)
	        elsif s.exist?(/:600/)
	                      find(6)
	        elsif s.exist?(/:700/)
	                      find(7)
	        elsif s.exist?(/:800/)
	                      find(8)
	        elsif s.exist?(/:900/)
	                      find(9)
	        elsif s.exist?(/:100/)
	                      find(1)
	        elsif s.exist?(/:110/)
	                      find(11)
	        elsif s.exist?(/:120/)
	                      find(12)
	        elsif s.exist?(/:130/)
	                      find(13)
	        elsif s.exist?(/:140/)
	                      find(14)
	        elsif s.exist?(/:150/)
	                      find(15)
	        elsif s.exist?(/:160/)
	                      find(16)
	        elsif s.exist?(/:170/)
	                      find(17)
	        elsif s.exist?(/:180/)
	                      find(18)
	        elsif s.exist?(/:220/)
	                      find(22)
          elsif s.exist?(/:230/)
	                      find(23)
          elsif s.exist?(/:240/)
	                      find(24)
          elsif s.exist?(/:250/)
	                      find(25)
          else
	                      find(1)
          end
end


  def default_blank_item_departments
    return Department.order("Name  ASC").where("id  IN (?) ",   [1,2,3,4,5,6,7,8,9]   )
  end


  def default_blank_item_department_ids
    default_blank_item_department_ids   = []
    default_blank_item_departments.each do |department|
      default_blank_item_department_ids <<     department.id
    end
    return default_blank_item_department_ids
  end


  def default_non_blank_item_departments
                      return Department.order("Name  ASC").where("id IN (?) and id NOT IN (?) ", self.default_item_department_ids.split(/,/),   [2,3,4,6,7,8,9]   )
  end

  def default_non_blank_item_department_ids
            default_non_blank_item_department_ids   = []
            default_non_blank_item_departments.each do |department|
                      default_non_blank_item_department_ids <<     department.id
            end
            return default_non_blank_item_department_ids
  end


  def default_all_department_ids_with_generic
 	        self.default_design_department_ids.split(/,/) + self.default_item_department_ids.split(/,/)  + ['1','5']
 end	 
  

 
 def default_all_department_ids
          	self.default_design_department_ids.split(/,/) + self.default_item_department_ids.split(/,/)
 end	 
  
  
  def all_department_ids
        self.default_design_department_ids.split(/,/) + self.default_item_department_ids.split(/,/) 
  end
  
  
  
   def last_created_article
                 Revision.find(:first, :conditions => [" published = ?",  true  ], :order => "created_at  DESC")
 end


  def  default_all_departments_with_generic
                Department.order("departments.Name ASC").where( "id in (?)", self.default_all_department_ids_with_generic    )
   end


 def  default_all_departments 
#                Department.find(:all, :conditions => ["id IN (?) ", self.default_design_department_ids.split(/,/) + self.default_item_department_ids.split(/,/)   ]    )
#                Department.order("departments.Name ASC").includes(:categories, :items).where( "id in (?)", self.default_design_department_ids.split(/,/) + self.default_item_department_ids.split(/,/)    )
                Department.order("departments.Name ASC").where( "id in (?)", self.default_design_department_ids.split(/,/) + self.default_item_department_ids.split(/,/)    ).to_set
   end
  
  
  def default_item_departments
#                 Department.find(:all, :conditions => ["id IN (?) ", self.default_item_department_ids.split(/,/)  ]    )
#                 Department.order("departments.Name ASC").includes(:categories, :items).where("id IN (?) ", self.default_item_department_ids.split(/,/)  )
                 Department.order("departments.Name ASC").where("id IN (?) ", self.default_item_department_ids.split(/,/)  ).to_set
 end
  
   def  default_design_departments
#                     Department.order("departments.Name ASC").includes(:categories, :items).where( "id in (?)",  self.default_design_department_ids.split(/,/)   )
                     Department.order("departments.Name ASC").where( "id in (?)",  self.default_design_department_ids.split(/,/)   ).to_set
 end



 

end