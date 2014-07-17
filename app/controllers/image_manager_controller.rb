class ImageManagerController < ApplicationController
before_filter :redirect_unless_admin

  def update_missing_images
    MissingImages.destroy_all

  end



    def index
      @items = ItemsWithYearlySale.find(:all,:conditions => ["sale_year = ? and department_id in (?)", Date.current.year   ,  @website.default_item_department_ids.split(/,/) ], :limit => 200, :order => "date_difference DESC"  )
#  @items = ItemsWithYearlySales.find(:all,:conditions => ["sale_year = ? and department_id in (?)", Date.current.year   ,  @website.default_item_department_ids.split(/,/) ], :order => "date_difference DESC"  )

    end

    






























#  @items = ItemsWithYearlySales.find(:all,:conditions => ["sale_year = ? and department_id in (?)", Date.current.year   ,  @website.default_item_department_ids.split(/,/) ], :limit => 20, :order => "date_difference DESC"  )
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @items }
#    end





     def index_before
  @initial_items = ItemsWithYearlySales.find(:all,:conditions => ["sale_year = ? and department_id in (?)", Date.current.year   ,  @website.default_item_department_ids.split(/,/) ], :limit => 20, :order => "date_difference DESC"  )

  @items = []
  @initial_items.each do |the_item|
  @place_to_check = RIO.cwd + "/public/images/item_thumbnails" + the_item.png_image_name
  @path_exists = rio(@place_to_check).exist?
  #		 		if @path_exists == false
  @items << the_item
  #				end
			end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end



end
