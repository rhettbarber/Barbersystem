class ItemsController < ApplicationController

  #ssl_exceptions
before_filter :redirect_unless_admin, :except => [:advanced_search]
before_filter  :initialize_variables_except_store

require 'pathname'
require 'csv'
#before_filter :initialize_customer_types, :only => [:array_to_csv,:barber_price_list_full, :barber_price_list_designs, :barber_price_list_items, :barber_price_list_example, :custom_listing, :list_by_department]



  def image_availability_picturename
    @departments =  [1,2]
    #@local_department =  Department.find(2)
    @items = Item.order("item_class_components.item_class_id").includes(:item_class_component,:item_class,:category).where("items.department_id in (?)",  @departments  ).limit("100")
  end

  def image_availability_noimage
    @departments =  [1,2]
    #@local_department =  Department.find(2)
    @items = Item.order("item_class_components.item_class_id").includes(:item_class_component,:item_class,:category).where("items.department_id in (?)",  @departments  ).limit("100")
  end





#  DEPRECATE BELOW
#  DEPRECATE BELOW
#  DEPRECATE BELOW

  def search
             keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}

                                if params[:search_scope] == "Matches Any"

                                                  @initial_items = ListingItem.find_with_msfte :matches_any => keywords
                                                  @items_with_rank = []
                                                  keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}

                                                  @initial_items.each do |item|

                                                             item_words_string = item.ItemLookupCode.to_s + ' ' + item.Description.to_s + ' ' + item.ExtendedDescription.to_s + ' ' + item.Notes.to_s
                                                             item_words_array  = item_words_string.split.collect {|c| "#{c.downcase}"}
                                                             item_words_set = item_words_array.to_set

                                                              keywords_set      = keywords.to_set
                                                              word_count = 0
                                                              keywords.each do  |kw|
                                                                  matching_words = keywords_set.intersection(item_words_set)
                                                                  if matching_words.size > 0
                                                                        logger.debug "matching_words: " + matching_words.inspect
                                                                  else
                                                                         logger.debug "item_words_set because none match: " + item_words_set.inspect
                                                                  end
                                                                  if matching_words.size > 0
                                                                    word_count = matching_words.size
                                                                  end
                                                              end
                                                               item.SubDescription3 = word_count
                                                                @items_with_rank	<< item if item.SubDescription3 != 0
                                                                @items = @items_with_rank.sort_by {|a| a.SubDescription3}.reverse
                                                  end


                                else
                                                 @initial_items = ListingItem.find_with_msfte :matches_all => keywords
                                                  @items_with_rank = []
                                                  keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}

                                                  @initial_items.each do |item|

                                                             item_words_string = item.ItemLookupCode.to_s + ' ' + item.Description.to_s + ' ' + item.ExtendedDescription.to_s + ' ' + item.Notes.to_s
                                                             item_words_array  = item_words_string.split.collect {|c| "#{c.downcase}"}
                                                             item_words_set = item_words_array.to_set

                                                              keywords_set      = keywords.to_set
                                                              word_count = 0
                                                              keywords.each do  |kw|
                                                                  matching_words = keywords_set.intersection(item_words_set)
                                                                  if matching_words.size > 0
                                                                        logger.debug "matching_words: " + matching_words.inspect
                                                                  else
                                                                         logger.debug "item_words_set because none match: " + item_words_set.inspect
                                                                  end
                                                                  if matching_words.size > 0
                                                                    word_count = matching_words.size
                                                                  end
                                                              end
                                                               item.SubDescription3 = word_count
                                                                @items_with_rank	<< item if item.SubDescription3 != 0
                                                                @items = @items_with_rank.sort_by {|a| a.SubDescription3}.reverse
                                                  end
                                end


            render(:update) { |page|
                               page.replace_html 'search_results',   :partial => "items/list"
                               page.hide 'progress_bar_container'
             }
             logger.debug "ending search"
  end



def activate_this_item
	if params[:item_class_component]
		item_id = params[:item_class_component][:item_id]
	else
		item_id = params[:item_id]
	end
		@item = Item.find item_id
		@item.Inactive = false
		@item.WebItem = true
		if @item.save
			 delete_category_cache(@item.category_id)
			flash[:notice] = "item activated and made web item"
		else
			flash[:notice] = "item activation failed"
		end
		redirect_to :back
end

def turn_off_web_item
	if params[:item_class_component]
		item_id = params[:item_class_component][:item_id]
	else
		item_id = params[:item_id]
	end
		@item = Item.find item_id
		@item.WebItem = false
		if @item.save
			 delete_category_cache(@item.category_id)
			flash[:notice] = "web item turned off"
		else
			flash[:notice] = "webitem off failed"
		end
		redirect_to :back
end

def inactivate_and_set_webitem_off
	if params[:item_class_component][:item_id]
		item_id = params[:item_class_component][:item_id]
	else
		item_id = params[:item_id]
	end
		@item = Item.find item_id
		@item.Inactive = true
		@item.WebItem = false
		if @item.save
			 delete_category_cache(@item.category_id)
			flash[:notice] = "item activated and made web item"
		else
			flash[:notice] = "item made inactive and made web item turned off"
		end
		redirect_to :back
end

def find_item
	 keywords = params[:item_keywords]
	 conditions = ["ItemLookupCode LIKE ? or Description LIKE ?","%#{keywords}%","%#{keywords}%" ]
	@found_items = Item.find(:all , :conditions => conditions, :limit => 50 )
	render :partial => "items/found_item", :collection => @found_items, :spacer_template => "page_divider" ,:layout => 'none'
end
################################################


def advanced_search
     logger.debug "-------------------------------------begin advanced_search"
    @found_items = Item.find(:all  , :limit => 50 )
    logger.debug "-------------------------------------end advanced_search"
 end
################################################



 def update_and_send_back
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { redirect_to :back }
      else
        format.html { redirect_to :back }
      end
    end
 end



def  initialize_customer_types
        @retail_customer = Customer.find(:first, :conditions => ["PriceLevel = ?",0])
        @preprint_customer = Customer.find(:first, :conditions => ["PriceLevel = ?",1])
        @blank_customer = Customer.find(:first, :conditions => ["PriceLevel = ?",2])
        @franchise_customer = Customer.find(:first, :conditions => ["PriceLevel = ?",3])
        @departments = Department.find(:all, :conditions => ["id in (?)", [10    ]   ],:limit => 30    )
end


def array_to_csv
  @items = Item.find(:all)
    report = StringIO.new
    CSV::Writer.generate(report, ',') do |csv|
      csv << %w(ItemLookupCode Description Retail Preprint Qty1Preprint Qty3Preprint Qty7Preprint Qty50Preprint FullBlank Qty1Blank Qty3Blank Qty7Blank Qty50Blank FullFranchise Qty1Franchise Qty3Franchise Qty7Franchise Qty50Franchise    )
      @items.each do |item|
        csv << [
        item.ItemLookupCode,
        item.Description,
        item.full_unit_price(@retail_customer) ,
        item.full_unit_price(@preprint_customer),
        item.unit_quantity_tier_discount_price(@preprint_customer,1),
        item.unit_quantity_tier_discount_price(@preprint_customer,3),
        item.unit_quantity_tier_discount_price(@preprint_customer,7),
        item.unit_quantity_tier_discount_price(@preprint_customer,50) ,
        item.full_unit_price(@blank_customer) ,
        item.unit_quantity_tier_discount_price(@blank_customer,1) ,
        item.unit_quantity_tier_discount_price(@blank_customer,3) ,
        item.unit_quantity_tier_discount_price(@blank_customer,7) ,
        item.unit_quantity_tier_discount_price(@blank_customer,50) ,
        item.full_unit_price(@franchise_customer) ,
        item.unit_quantity_tier_discount_price(@franchise_customer,1) ,
        item.unit_quantity_tier_discount_price(@franchise_customer,3) ,
        item.unit_quantity_tier_discount_price(@franchise_customer,7) ,
        item.unit_quantity_tier_discount_price(@franchise_customer,50)
        ]
      end
    end
    report.rewind
    send_data(report.read,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :filename => 'barber_items_report.csv')
end


def incomplete_item_records
        item_compilation = []
        items = Item.find(:all )
              for item in items
                    if item.in_error != false
                            item_compilation << item
                    end
              end
      @items =   item_compilation.uniq

end


def item_design
      @garments = Item.find(:all,:conditions => ["id in (?)",56..58])
      @designs = Item.find(:all,:conditions => ["id in (?)",2936..2939])
      @items = Cartesian::product(@garments, @designs)
end



def list_by_department
      @departments = Department.find(:all, :conditions => ["id in (?)", [10    ]   ],:limit => 30    )

end



def barber_price_list_full
        @quantity = params[:quantity].to_i
        @items = Item.find(:all, :order => "ItemLookupCode ASC"  )
         render(:partial => "barber_price_list", :layout => 'application' )
end


def barber_price_list_designs
        @quantity = params[:quantity].to_i
        @items = Item.find(:all, :conditions => ["department_id in (?)", [10,11,12,13,14,15,16,17,18,19,20,24    ] ],:order => "ItemLookupCode ASC"  )
                 render(:partial => "barber_price_list", :layout => 'application' )
end


def barber_price_list_items
        @quantity = params[:quantity].to_i
         @items = Item.find(:all, :conditions => ["department_id in (?)", [1,2,3,4,5,6,7,8,9,21,22 ] ] ,:order => "ItemLookupCode ASC"  )
                 render(:partial => "barber_price_list", :layout => 'application' )
end

def barber_price_list_example
        @quantity = params[:quantity].to_i
        @items = Item.find(:all, :conditions => ["id in (?)", [56,57,58,59,60,3918,4398]  ] )
                render(:partial => "barber_price_list", :layout => 'application' )
end


def custom_listing
        @quantity = params[:quantity].to_i
        @items = Item.find(:all, :conditions => ["id in (?)", [56,57,58,59,60,3918,4398]  ] )
end



def slave_images
        @slave_category_ids = []
        @all_categories = Category.find_all
        for category in @all_categories
                @slave_category_ids << category.id  if category.category_class.item_type == 'slave'
        end
      # @local_department =  Department.find(2)
          @items =   Item.find(:all, :conditions => ["category_id in (?) ",   @slave_category_ids  ] )
         render(:partial => "image_availability_by_class", :layout => 'application')
end




def women_images
        @departments =  [1,3]
        @local_department =  Department.find(3)
         @items = Item.find(:all, :conditions => ["department_id in (?) ",  @departments  ] )
         render(:partial => "image_availability_by_class", :layout => 'application')
end


def junior_girl_images
        @departments =  [4]
        @local_department =  Department.find(4)
         @items = Item.find(:all, :conditions => ["department_id in (?) ",  @departments  ] )
        render(:partial => "image_availability_by_class", :layout => 'application')
end


def youth_boy_images
        @departments =  [5,9]
        @local_department =  Department.find(9)
         @items = Item.find(:all, :conditions => ["department_id in (?) ",  @departments  ] )
           render(:partial => "image_availability_by_class", :layout => 'application')
end


def youth_girl_images
        @departments =  [5,6]
        @local_department =  Department.find(6)
         @items = Item.find(:all, :conditions => ["department_id in (?) ",  @departments  ] )
           render(:partial => "image_availability_by_class", :layout => 'application')
end

def toddler_images
        @departments =  [8]
        @local_department =  Department.find(8)
         @items = Item.find(:all, :conditions => ["department_id in (?) ",  @departments  ] )
           render(:partial => "image_availability_by_class", :layout => 'application')
end

def infant_images
        @departments =  [7]
        @local_department =  Department.find(7)
         @items = Item.find(:all, :conditions => ["department_id in (?) ",  @departments  ] )
           render(:partial => "image_availability_by_class", :layout => 'application')
end

def do_merchandise_images
        @departments =  [22]
        @local_department =  Department.find(22)
         @items = Item.find(:all, :conditions => ["department_id in (?) ",  @departments  ] )
           render(:partial => "image_availability_by_class", :layout => 'application')
end


def bc_merchandise_images
        @departments =  [21]
        @local_department =  Department.find(22)
         @items = Item.find(:all, :conditions => ["department_id in (?) ",  @departments  ] )
           render(:partial => "image_availability_by_class", :layout => 'application')
end









  #####################################################################################
  #####################################################################################



  #
  #def index
  #  @items = Item.find(:all, :limit => 20)
  #
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.xml  { render :xml => @items }
  #  end
  #end
  #
  ## GET /items/1
  ## GET /items/1.xml
  #def show
  #  @item = Item.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.xml  { render :xml => @item }
  #  end
  #end
  #
  ## GET /items/new
  ## GET /items/new.xml
  #def new
  #  @item = Item.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.xml  { render :xml => @item }
  #  end
  #end
  #
  ## GET /items/1/edit
  #def edit
  #  @item = Item.find(params[:id])
  #end
  #
  ## POST /items
  ## POST /items.xml
  #def create
  #  @item = Item.new(params[:item])
  #
  #  respond_to do |format|
  #    if @item.save
  #      format.html { redirect_to(@item, :notice => 'Item was successfully created.') }
  #      format.xml  { render :xml => @item, :status => :created, :location => @item }
  #    else
  #      format.html { render :action => "new" }
  #      format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## PUT /items/1
  ## PUT /items/1.xml
  #def update
  #  @item = Item.find(params[:id])
  #
  #  respond_to do |format|
  #    if @item.update_attributes(params[:item])
  #      format.html { redirect_to(@item, :notice => 'Item was successfully updated.') }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## DELETE /items/1
  ## DELETE /items/1.xml
  #def destroy
  #  @item = Item.find(params[:id])
  #  @item.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to(items_url) }
  #    format.xml  { head :ok }
  #  end
  #end
  #
  #
  #
  #











  #  def update
#    @item = Item.find(params[:id])
#
#    respond_to do |format|
#      if @item.update_attributes(params[:item])
#        flash[:notice] = 'Item was successfully updated.'
#        format.html { redirect_to item_url(@item) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @item.errors.to_xml }
#      end
#    end
#  end


end
