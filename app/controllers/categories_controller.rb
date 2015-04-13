class CategoriesController < ApplicationController
ssl_exceptions
before_filter :redirect_unless_admin

cache_sweeper :category_sweeper, :only => [ :duplicate, :update, :destroy, :change_category,:duplicate_category,:hide_category, :unhide_category ]
#layout 'none'

 


  def ajax_add_to_additives
          selected_category = Category.find params[:selected_category_id]
          @category = selected_category
          additive_category = Category.find params[:additive_javascript][:category_id]
          add_to_additives(selected_category, additive_category )
          render :update do |page|
                          #page.redirect_to request.referer
                           page.replace_html 'additive_categories_list'  , :partial => 'control_tabs_item_administration/additive_categories_list'
          end
end

def ajax_remove_from_additives
          selected_category = Category.find params[:selected_category_id]
          @category = selected_category
          additive_category = Category.find params[:additive_category_id]
          remove_from_additives(selected_category, additive_category )
          render :update do |page|
                          #page.redirect_to request.referer
                           page.replace_html 'additive_categories_list'  , :partial => 'control_tabs_item_administration/additive_categories_list'
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


 def ajax_category_update  #incomplete
       Category.unscoped do
                           @category = Category.find(params[:id])
                           @category.accessible = :all if admin?
                          if @category.update_attributes!(params[:category] )
                                               render(:update) { |page|
                                                                   page.replace_html 'category_saved'  ,  :text => "Save Success" # :partial => 'designer_specsheet/ajax_update_items'  , :locals => {:side => params[:side], :status => "Success" }
                                              }

                          else

                                                       render(:update) { |page|
                                                                   page.replace_html 'category_saved'  ,  :text => "Save Failed" # :partial => 'designer_specsheet/ajax_update_items'  , :locals => {:side => params[:side], :status => "Success" }
                                              }
                          end
          end
  end


  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])
     @category.accessible = :all if admin?
    respond_to do |format|
      if @category.update_attributes(params[:category])
          @category.accessible = :all if admin?
  @category.attributes = params[:category]
#        format.js {render :text => 'test'}
        format.html { redirect_to(@category, :notice => 'Category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end


  def ajax_update_category
#    ggg
  @category = Category.find( params[:id] )
  @category.accessible = :all if admin?
  @category.attributes = params[:category]

  if params[:design_specific_breast_print] 
      greattt
      @dsbp = DesignSpecificBrestPrint.find_or_create_by_item_id(  params[:item_id] )
      @dsbp.name = params[:design_specific_breast_print] 
  else
#      badd
  end

 
  if @category.save
    @category.reload

    flash[:success] = "Successfully updated category."

    render :partial => 'edit', :locals => {:category => @category}
  else
    flash[:invalid] = @category.errors.full_messages
    render :partial =>  'edit', :status => 444
  end
end


def change_category
	logger.info "-------change_category---------BEGIN"
	 if params[:category] and params[:item_id]
			new_category_id = params[:category][:id]
			@new_category = Category.find new_category_id
			@item = Item.find params[:item_id]
			@old_category = Category.find @item.category_id
		logger.warn "@old_category.id: #{@old_category.id.to_s}"
		@old_category.delete_all_caching_and_cache_of_which_this_is_an_additive

		if @new_category
					logger.warn "@new_category.id: #{@new_category.id.to_s}"
					@new_category.delete_all_caching_and_cache_of_which_this_is_an_additive
		else
						logger.warn "ERROR @new_category NULL"
		end
	end
	if @item and @new_category and @old_category
					@item.ids_to_change_category.each do |id|
								item = Item.update( id, :category_id => new_category_id  )
								item.errors.each_full do |msg|
									logger.warn "ERROR MESSAGE: #{msg}"
									flash[:notice] +=  "#{msg}"
								end
					end
					@category_ids_to_delete_cache = Set.new
					@category_ids_to_delete_cache.merge(@old_category.category_class.opposite_category_ids.split(','))
#					@category_ids_to_delete_cache.add?(@old_category.id)
#					@category_ids_to_delete_cache.add?(@new_category.id)

					current_log_position
						 		logger.warn "DEBUG---------------@category_ids_to_delete_cache: #{@category_ids_to_delete_cache.to_a.join(',').to_s}"
					current_log_position

					delete_cache_in_category_ids(@category_ids_to_delete_cache)

					flash[:notice] = "Category Changed and Caches deleted."
					redirect_to :back
	else
				flash[:notice] = "Item or Category not found"
				redirect_to :back
	end
	logger.info "-------change_category---------END"
end

def unhide_category
		@category = Category.find(params[:category_id])
		@category.visible = 1
	if @category.save
			flash[:notice] = "Category made Visible: #{@category.Code} - #{@category.Name}"
				redirect_to :back
	else
			flash[:notice] = "Category Visible failed: #{@category.Code} - #{@category.Name}"
	end
end


def hide_category
		@category = Category.find(params[:category_id])
		@category.visible = 0
	if @category.save
			flash[:notice] = "Category Hidden: #{@category.Code} - #{@category.Name}"
				redirect_to :back
	else
			flash[:notice] = "Category Hide failed: #{@category.Code} - #{@category.Name}"
	end
end


def duplicate_category
	@category = Category.find(params[:category_id])

	@opposites_categories = @category.opposite_categories
#	for opposite_category in @opposites_categories # this was not linking the duplicated category to old categories opposites so moved down
#			link_opposites(@category, opposite_category)
#	end
	@duplicate_category = @category.clone
	@duplicate_category.category_header_image = 0
	@duplicate_category.Code = @category.Code + rand(1).to_s

	if @duplicate_category.save
			@opposites_categories = @category.opposite_categories
			for opposite_category in @opposites_categories
					link_opposites(@duplicate_category, opposite_category)
			end

			flash[:notice] = "Category Duplicated: #{@duplicate_category.Code} - #{@duplicate_category.Name}"
				redirect_to :back
	else
			flash[:notice] = "Category Duplication failed: #{@category.Code} - #{@category.Name}"
	end
end


def department_properties
	render :partial => 'control_tabs_item_administration/department_properties'
end

def category_properties
	@category = Category.find params[:category_id]
	render :partial => 'control_tabs_item_administration/category_properties'
end


def departments_categories
		@departments = Department.find(:all)
#		render :partial => "administration_category/departments_categories"
end


def new_department
    @department = Department.new
		render :partial => "administration_category/new_department"
end


def new_category
    @category = Category.new
		render :partial => "administration_category/new_category"
end


  
  def index
    if params[:department_id]
          @department = Department.find params[:department_id]
          @categories = Category.order("id ASC").where("department_id = ?", params[:department_id])
    else
          @categories = Category.order("id ASC").all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to(@category, :notice => 'Category was successfully created.') }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end


  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end










































end






