class ItemReportsController < ApplicationController
  before_filter  :initialize_variables_except_store
#ssl_exceptions
before_filter :redirect_unless_admin #,:except => [:designs_numerically,:designs_by_department]
#before_filter :rhett   #,:only => [:designs_numerically,:designs_by_department]
  before_filter :no_item_menu
#layout "pricelist"

def rhett
		if @user.email == 'rhett@barberandcompany.com'
				true
		else
				false
		end
end

def wholesale_pricelist
		 @show_all = false
		  @show_sample = false
end



def index
end


def designs_numerically
               if  params[:department_ids] 
                    @items = Item.find(:all, :conditions => ["department_id in (?)", params[:department_ids]   ], :order => "ItemLookupCode ASC")
             else
                  @items = Item.find(:all, :conditions => ["department_id in (?)", @website.default_design_department_ids.split(/,/) ], :order => "ItemLookupCode ASC")
             end     
            render(:partial => "item_reports/items_list",:layout => 'printable' )
end


def designs_by_department
                 # if  params[:department_ids]
                 #                @departments = Department.find(:all, :conditions => ["department_id in (?)", params[:department_ids]   ])
                 # else
                 #               # @departments = @website.default_design_departments
                 #               #  @departments = Department.limit(2).order("departments.Name ASC").where( "id in (?)",  @website.default_design_department_ids.split(/,/)   ).to_set
                 # end
        @original_items = Item.limit(400).joins(:department, :category, :category_class).order("departments.Name ASC,  categories.Name ASC").where( "items.department_id in (?)",  @website.default_design_department_ids.split(/,/)   ).all

         @items = Set.new
          @original_items.each do |item|
                    @items.add( item) if item.department and item.category  and item.category_class
          end

end





def items_keyworder
						conditions = ["Notes like ? and department_id in (?)", '' ,  @website.default_design_department_ids.split(/,/)   ]
            @items = Item.find(:all, :conditions => conditions, :order => "ItemLookupCode ASC",:limit => 100)
            render(:partial => "item_reports/items_keyworder_list",:layout => 'printable' )
end




def update_item_extended_descriptions
	items = params[:item]
	if Item.update(items.keys, items.values)
		flash[:notice] = "Successfully updated item descriptions"
		redirect_to :back
	else
		flash[:notice] = "Update failed"
		redirect_to :back
	end
end




end
