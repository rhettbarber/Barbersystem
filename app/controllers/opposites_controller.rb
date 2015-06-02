class OppositesController < ApplicationController
#ssl_required :all




before_filter :initialize_variables

before_filter :redirect_unless_admin





def all_categories_with_same_prefix
    @category = Category.find(params[:id])
    @item_type = @category.category_class.item_type
    @original_prefix = @category.prefix
    @categories = Category.find(:all, :include => [:category_class], :conditions => ["prefix = ? and category_classes.item_type = ?", @original_prefix ,@item_type] )
end

def define_category_class_opposite_categories
    if params[:item_keywords]
        @found_item = Item.find(:first,:conditions => ["ItemLookupCode like ?", "#{params[:item_keywords]}%"  ])
        if @found_item
          flash[:notice] = "Your item was found"
        else
          flash[:notice] = "That item was NOT found"
        end
    end
    if @found_item
          @selected_category_class_id = @found_item.category.category_class_id
    else
          if params[:category_class] #and !params[:category_class] == "1"
              @selected_category_class_id = params[:category_class]
          end
          @selected_category_class_id =  1.to_s  if @selected_category_class_id.nil?
    end
    @selected_category_class = CategoryClass.find(@selected_category_class_id)
 	
	 @selected_category_class_categories_first_id = @selected_category_class.categories.first.id
	if @selected_category_class.item_type == 'master'
		conditions = [ "category_classes.item_type = ?", 'slave' ]
		@categories = Category.find(:all, :conditions => conditions,:order => "prefix ASC",:include => [:category_class]) 
		#@categories = Category.find_by_sql "SELECT ct.name, cc.item_type FROM categories ct, category_classes cc WHERE ct.category_class_id = cc.id AND cc.item_type = 'slave'"
	else
		conditions = [ "category_classes.item_type = ?", 'master' ]
		@categories = Category.find(:all, :conditions => conditions,:order => "prefix ASC",:include => [:category_class]) 
	end
end


def add_category_into_opposites
	category_id_array = params[:id].split('')  # is 213
	opposite_category = Category.find(params[:id])
	selected_category = Category.find(params[:selected_category_id])
	selected_category_id_array = selected_category.id.to_s.split('')
	
	selected_array_to_edit = selected_category.category_class.opposite_category_ids.split(',',77777).to_a
	selected_updated_array = selected_array_to_edit + category_id_array
	selected_category_class_to_update = CategoryClass.find(selected_category.category_class.id)
	selected_category_class_to_update.opposite_category_ids = selected_updated_array.join(',')

	opposite_array_to_edit = opposite_category.category_class.opposite_category_ids.split(',',77777).to_a	
	opposite_updated_array = opposite_array_to_edit + selected_category_id_array
	opposite_category_class_to_update = CategoryClass.find(opposite_category.category_class.id)
	opposite_category_class_to_update.opposite_category_ids = opposite_updated_array.join(',')
	
	if selected_category_class_to_update.save && opposite_category_class_to_update.save
	  flash[:notice] = "save successfull"
	  redirect_to :controller => 'opposites',:action => 'define_category_class_opposite_categories' ,:category_class => selected_category.category_class_id
	else
	  flash[:notice] = "error saving"
	  redirect_to :back
	end
end	



def remove_category_from_opposites
	category_id_array = params[:id].to_a
	opposite_category = Category.find(params[:id])
	selected_category = Category.find(params[:selected_category_id])
	selected_category_id_array = selected_category.id.to_s.to_a

	selected_array_to_edit = selected_category.category_class.opposite_category_ids.split(',',77777).to_a
	selected_updated_array = selected_array_to_edit - category_id_array
	selected_category_class_to_update = CategoryClass.find(selected_category.category_class.id)
	selected_category_class_to_update.opposite_category_ids = selected_updated_array.join(',')

	opposite_array_to_edit = opposite_category.category_class.opposite_category_ids.split(',',77777).to_a	
	opposite_updated_array = opposite_array_to_edit - selected_category_id_array
	opposite_category_class_to_update = CategoryClass.find(opposite_category.category_class.id)
	opposite_category_class_to_update.opposite_category_ids = opposite_updated_array.join(',')
	
	if selected_category_class_to_update.save && opposite_category_class_to_update.save
	  flash[:notice] = "save successfull"
	   redirect_to :controller => 'opposites',:action => 'define_category_class_opposite_categories' ,:category_class => selected_category.category_class_id
	else
	  flash[:notice] = "error saving"
	  redirect_to :back
	end
end	

def add_category_to_category_class
	category_to_edit = Category.find(params[:id])
	category_to_edit.category_class_id = params[:category_class_id]
	category_to_edit.save
	        render(:update) { |page| 
             page.remove "category_row_#{params[:id]}"
            }
end


def category_class_organizer
	if params[:item_keywords]
		@found_item = Item.find(:first,:conditions => ["ItemLookupCode like ?", "#{params[:item_keywords]}%"  ])
	end	
	if @found_item
		@selected_category_class_id = @found_item.category.category_class_id
	else	
		@selected_category_class_id = params[:category_class_id] || 1.to_s
	end
	@selected_category_class = CategoryClass.find(@selected_category_class_id)
	@category_classes = CategoryClass.find(:all,:conditions => ["id != ?", @selected_category_class_id], :order => "item_type ASC")#,:limit => 10)
	conditions = [ "category_class_id = ?", @selected_category_class_id ]
	@categories = Category.find(:all, :conditions => conditions,:order => "prefix ASC",:include => [:category_class]) #,:limit => 10) 

end


##------------------------------------------------------------------------------------------------------------------------
def all_categories_in_this_class
	if params[:category_class]
	 	if params[:category_class][:category_class_id]
	 		@categories = Category.find_all_by_category_class_id(params[:category_class][:category_class_id] || 1)
	 		@selected_category_class = CategoryClass.find(params[:category_class][:category_class_id] || 1 )
 		else
 			@categories = Category.find_all_by_category_class_id( params[:category_class] || 1)
 			@selected_category_class = CategoryClass.find(params[:category_class] || 1 )
 		end
 	else
 		@selected_category_class = CategoryClass.find( 1 )
 	end
end

##------------------------------------------------------------------------------------------------------------------------
##------------------------------------------------------------------------------------------------------------------------
def align_category_to_selected_category

	@category = Category.find(params[:id])
	@selected_category = Category.find(params[:selected_category_id])
	if @selected_category.category_class.item_type == 'master'
		item_prefix = @selected_category.prefix
		design_prefix = @category.prefix
		
		@all_items = Item.find(:all,:include => [:category], :conditions => ["categories.prefix = ?", item_prefix, ] ).to_set
		
		#@all_items =  @selected_category.items.to_set
		
		@first_component_items = Item.first_of_components_items_for_each_color.to_set
		@items = @all_items.intersection(@first_component_items).sort_by{|a| a.ItemLookupCode}
		@items_first_item = @selected_category.items.first
		
		
########################################################################################
		
		@designs_for_select_list = Item.find(:all, :conditions => ["category_id = ?", @category.id ])
		if params[:design_id]
			@design = @category.items.find(params[:design_id])
				if @design
					 flash[:notice] = "Design found."
				else
					 flash[:notice] = "Error Chosen Design not found."
					 @design = @category.items.first
				end	
		else	
			@design = @category.items.first
		end
########################################################################################		
		
	else	
		design_prefix = @selected_category.prefix
		item_prefix = @category.prefix
		@design = @selected_category.items.first
		@item = @category.items.first
	end	
	if item_prefix && design_prefix
		@combination = Combination.find(:first,:conditions => ["item_prefix = ? and design_prefix = ?", item_prefix, design_prefix  ])	
				if @item  && @design or @items && @design
						if @combination
					 		 flash[:notice] = "Combination found."
					 		prepare_combination_variables(@item,@design)  if @item && @design
					 		if @items
					 			prepare_combination_variables(@items.first,@design) 
				 			end
				 		else
				 			 flash[:notice] = "Combination not found, so one was created for you."
				 			Combination.create(:item_prefix => item_prefix, :design_prefix => design_prefix,:height => 240 )
				 			redirect_to(:controller => 'opposites', :action => 'align_category_to_selected_category', :id => @category.id, :selected_category_id => @selected_category ) 
				 		end	
				else
						  flash[:notice] = "error, item & design not found"
						  redirect_to :back
				end		
	else
			  flash[:notice] = "your item or design has no prefix, please be sure to create one before proceeding."
			  redirect_to :back
	end	
end
##------------------------------------------------------------------------------------------------------------------------
def list_all_items_in_this_category
	@category = Category.find(params[:id])
	@items = Item.find_all_by_category_id(params[:id])
end	
##------------------------------------------------------------------------------------------------------------------------

	
	
	

end
