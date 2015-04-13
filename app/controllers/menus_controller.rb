class MenusController < ApplicationController
	
before_filter :redirect_unless_admin
cache_sweeper :category_sweeper , 
							:only => [ :unlink_opposites_using_hash, :link_opposites_using_hash, 
							:menu_category_visible, :menu_category_invisible, :remove_from_additives_from_link, :add_to_additives_from_link,
							:add_to_additives, :remove_from_additives ]

def show_additive_categories
    session[:show_additive_categories] = true
    redirect_to :back
end

def hide_additive_categories
  session[:show_additive_categories] = false
  redirect_to :back
end

def show_category_opposites
  session[:show_category_opposites] = true
  redirect_to :back
end

def hide_category_opposites
  session[:show_category_opposites] = false
  redirect_to :back
end


def add_to_additives_from_link
	selected_category = Category.find params[:selected_category_id]
	additive_category = Category.find params[:additive_category_id]
	add_to_additives(selected_category, additive_category )
	render :update do |page|
		page.redirect_to request.referer
	end
end

def remove_from_additives_from_link
	selected_category = Category.find params[:selected_category_id]
	additive_category = Category.find params[:additive_category_id]
	remove_from_additives(selected_category, additive_category )
	render :update do |page|
		page.redirect_to request.referer
	end
end

def add_to_additives(selected_category, additive_category )
	category_to_add_set = Set.new [] 
	category_to_add_set.add(additive_category.id.to_s)
	selected_category_set = category_to_add_set + selected_category.additive_category_ids.split(',',77777).to_a.flatten.to_set
	selected_category.additive_category_ids = selected_category_set.to_a.join(',')
	selected_category.prefix_will_change!
	additive_category.prefix_will_change!
	selected_category.save
	additive_category.save
end

def remove_from_additives( selected_category, additive_category )
	category_to_delete_set = Set.new [] 
	category_to_delete_set.add(additive_category.id.to_s)
	selected_category_set =  selected_category.additive_category_ids.split(',',77777).to_a.flatten.to_set - category_to_delete_set
	selected_category.additive_category_ids = selected_category_set.to_a.join(',')
	selected_category.prefix_will_change!
	additive_category.prefix_will_change!
	selected_category.save
	additive_category.save
end


def duplicate_category_confirm
	startup_browsing
	render(:partial => "menus/duplicate_category_confirm", :layout => controller_name )
end


def change_category_class
	@category = Category.find params[:category_id]
	@category.category_class_id = params[:category_class][:id]
	@category.save
	redirect_to request.referer 
end

def menu_category_duplicate
	@category = Category.find params[:category_id]  if params[:category_id]
	@opposites_categories = @category.opposite_categories
	for opposite_category in @opposites_categories
		link_opposites(@category, opposite_category)
	end		
	redirect_to :back
end	

def link_opposites_from_link
	selected_category = Category.find params[:selected_category_id]
	opposite_category = Category.find params[:opposite_category_id]
	 link_opposites(selected_category, opposite_category )
	 redirect_to request.referer 
end

def unlink_opposites_using_hash
	selected_category = Category.find params[:selected_category_id]
	opposite_ids_to_remove = params[:product][:category_ids]
	opposite_categories_to_remove = Category.find(:all, :conditions => ["id in (?)", opposite_ids_to_remove  ])
	opposite_categories_to_remove.each do |octr|
		unlink_opposites(selected_category, octr )
	end
	redirect_to request.referer 
end

def link_opposites_using_hash
	selected_category = Category.find params[:selected_category_id]
	opposite_ids_to_add = params[:product][:category_ids]
	opposite_categories_to_add = Category.find(:all, :conditions => ["id in (?)", opposite_ids_to_add  ])
	opposite_categories_to_add.each do |octa|
		link_opposites(selected_category, octa )
	end
	redirect_to request.referer 
end



def find_category_by_param
	if params[:category_id]
		@category = Category.find params[:category_id] 
	end
		flash[:notice] = 'no category was found' if !@category
end

def menu_category_visible
	find_category_by_param
	@category.visible = 1
	@category.save
	render :update do |page|
		page.replace_html 'category_' + @category.id.to_s + '_name' ,@category.Name
		page.replace_html 'status_area','category was made visible'
	end
end

def menu_category_invisible
	find_category_by_param
	@category.visible = 0
	@category.save
	render :update do |page|
		page.replace_html 'category_' + @category.id.to_s + '_name' ,'..' + @category.Name
		page.replace_html 'status_area','category was made invisible'
	end
end

def unlink_opposites(selected_category, opposite_category )
	selected_category_set = Set.new []
	opposite_category_set = Set.new []
	selected_category_set.add?(opposite_category.id.to_s)
	opposite_category_set.add?(selected_category.id.to_s)

	selected_category_set = selected_category.category_class.opposite_category_ids.split(',',77777).to_a.flatten.to_set.subtract(selected_category_set)
	opposite_category_set = opposite_category.category_class.opposite_category_ids.split(',',77777).to_a.flatten.to_set.subtract(opposite_category_set)

	selected_category.category_class.opposite_category_ids = selected_category_set.to_a.join(',')
	opposite_category.category_class.opposite_category_ids = opposite_category_set.to_a.join(',')

	selected_category.category_class.save
	opposite_category.category_class.save
end

def link_opposites(selected_category, opposite_category )
	#logger.info "-----selected_category#{selected_category}"
	#logger.info "-----selected_category#{opposite_category}"
	selected_category_set = Set.new []
	opposite_category_set = Set.new []
	selected_category_set.add?(opposite_category.id.to_s)
	opposite_category_set.add?(selected_category.id.to_s)


	selected_category_set =  selected_category.category_class.opposite_category_ids.split(',',77777).to_a.flatten.to_set.merge(selected_category_set)
	opposite_category_set =  opposite_category.category_class.opposite_category_ids.split(',',77777).to_a.flatten.to_set.merge(opposite_category_set)

	selected_category.category_class.opposite_category_ids = selected_category_set.to_a.join(',')
	opposite_category.category_class.opposite_category_ids = opposite_category_set.to_a.join(',')

	selected_category.category_class.save
	opposite_category.category_class.save
end

#def link_opposites(selected_category, opposite_category )
#	#logger.info "-----selected_category#{selected_category}"
#	#logger.info "-----selected_category#{opposite_category}"
#	selected_category_set = Set.new []
#	opposite_category_set = Set.new []
#	selected_category_set.add?(opposite_category.id.to_s)
#	opposite_category_set.add?(selected_category.id.to_s)
#
#
#	selected_category_set = selected_category_set + selected_category.category_class.opposite_category_ids.split(',',77777).to_a.flatten.to_set
#	opposite_category_set = opposite_category_set + opposite_category.category_class.opposite_category_ids.split(',',77777).to_a.flatten.to_set
#
#	selected_category.category_class.opposite_category_ids = selected_category_set.to_a.join(',')
#	opposite_category.category_class.opposite_category_ids = opposite_category_set.to_a.join(',')
#
#	selected_category.category_class.save
#	opposite_category.category_class.save
#end


end
