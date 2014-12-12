class ImageManagerController < ApplicationController
  before_filter :redirect_unless_admin

  before_filter  :initialize_variables
  before_filter :no_item_menu


 # changed category class id of all in department 35 from 31 to 69




    def index
                @sublimation_entries = SublimationEntry.group("purchase_id, FirstName,LastName, Company").select("purchase_id, FirstName,LastName, Company").all        #order("purchase_id")
      s =  "s"
    end



  def order_details
            @sublimation_entries = SublimationEntry.where( "purchase_id = ?",  params[:purchase_id] )
            @sublimation_entry =   @sublimation_entries.all.first
  end



  def print_all_over_ts
                          # system( 'convert W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\'  + oj.filename + '  -geometry 75 W:\AUTOMATION_DATABASE\FINISHED_WEBSITE_ITEM_THUMBNAILS\\' +  oj.filename )
                          # montage   -border 0 -geometry 7600x  -density 200 * final.jpg
                        logger.debug "5555555555555555555555555555555555"
                        logger.debug "5555555555555555555555555555555555"
                        logger.debug "5555555555555555555555555555555555"
                        @sublimation_entries = SublimationEntry.where( "purchase_id = ? and name = ?",  params[:purchase_id], "all_over_item" )
                        @montage_strings = Set.new
                        @sublimation_entries.each do |pe|
                                    # logger.debug "pe.id: " + pe.id.to_s

                                   @montage_string_front  = "montage  -border 0 -geometry 7600x  -density 200 " + pe.file_url_front + " " +  pe.hot_folder_url_front
                                    @montage_strings.add(@montage_string_front)
                                   # logger.debug "montage_string_front: " + @montage_string_front

                                   @montage_string_back  = "montage  -border 0 -geometry 7600x  -density 200 " + pe.file_url_back + " " +  pe.hot_folder_url_back
                                    @montage_strings.add(@montage_string_back)
                                   # logger.debug "montage_string_back: " + @montage_string_back

                        end
                        logger.debug "5555555555555555555555555555555555"
                        logger.debug "5555555555555555555555555555555555"
                        logger.debug "5555555555555555555555555555555555"
  end


  def print_big_fronts
                # system( 'convert W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\'  + oj.filename + '  -geometry 75 W:\AUTOMATION_DATABASE\FINISHED_WEBSITE_ITEM_THUMBNAILS\\' +  oj.filename )
                # montage   -border 0 -geometry 7600x  -density 200 * final.jpg
                logger.debug "5555555555555555555555555555555555"
                logger.debug "5555555555555555555555555555555555"
                logger.debug "5555555555555555555555555555555555"
                @sublimation_entries = SublimationEntry.where( "purchase_id = ? and name = ?",  params[:purchase_id], "huge_front" )
                @images_to_layout = []
                @sublimation_entries.each do |the_pe|
                                                 quantity_on_order =    the_pe.QuantityOnOrder.to_i
                                                   if quantity_on_order  > 1
                                                                           logger.debug "quantity_on_order > 1"
                                                                           logger.debug "quantity_on_order: " + quantity_on_order.to_s
                                                                           quantity_on_order.times do |pe|
                                                                                      @images_to_layout <<   the_pe.file_url_front
                                                                           end
                                                   else
                                                                                      logger.debug "quantity_on_order NOT > 1"
                                                                                      @images_to_layout <<   the_pe.file_url_front
                                                   end

                end
                @montage_string =  []
                iteration_number = 0.0
                @images_to_layout.in_groups_of(2).each do |the_pe|
                                  iteration_number += 1
                                  @montage_string   <<   "montage  -border 0 -geometry 3800x  -rotate 90 -density 200 " +  the_pe[0].to_s  + " "  + the_pe[1].to_s  + " "  +   "W:\\\\SUBLIMATION_HOT_FOLDER_REVIEW\\PURCHASE-" + params[:purchase_id] + "-"  + iteration_number.to_s + '.jpg'
                end
                 logger.debug "montage_string_back: " + @montage_strings.inspect
                logger.debug "5555555555555555555555555555555555"
                logger.debug "5555555555555555555555555555555555"
                logger.debug "5555555555555555555555555555555555"
  end



  def print_big_fronts_before
    # system( 'convert W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\'  + oj.filename + '  -geometry 75 W:\AUTOMATION_DATABASE\FINISHED_WEBSITE_ITEM_THUMBNAILS\\' +  oj.filename )
    # montage   -border 0 -geometry 7600x  -density 200 * final.jpg
    logger.debug "5555555555555555555555555555555555"
    logger.debug "5555555555555555555555555555555555"
    logger.debug "5555555555555555555555555555555555"
    @sublimation_entries = SublimationEntry.where( "purchase_id = ? and name = ?",  params[:purchase_id], "huge_front" )
    @montage_strings = []
    @sublimation_entries.each do |the_pe|

      quantity_on_order =    the_pe.QuantityOnOrder.to_i


      if quantity_on_order  > 1
        logger.debug "quantity_on_order > 1"
        logger.debug "quantity_on_order: " + quantity_on_order.to_s
        times_to_reiterate_float =    quantity_on_order  / 2
        logger.debug "times_to_reiterate_float: " + times_to_reiterate_float.to_s
        iteration_number = 0.0
        times_to_reiterate_float.times do |pe|
          iteration_number += 1
          @montage_string_front  = "montage  -border 0 -geometry 3800x  -rotate 90 -density 200 " +  the_pe.file_url_front + " "  + the_pe.file_url_front + " " +  the_pe.hot_folder_url_front(iteration_number)
          @montage_strings <<  @montage_string_front
        end
        if iteration_number <  quantity_on_order
          @montage_string_front  = "montage  -border 0 -geometry 3800x  -rotate 90 -density 200 " + the_pe.file_url_front + " " +  the_pe.hot_folder_url_front
          @montage_strings_to_append  <<  @montage_string_front
        end
      else
        logger.debug "quantity_on_order NOT > 1"
        @montage_string_front  = "montage  -border 0 -geometry 3800x  -rotate 90 -density 200 " + the_pe.file_url_front + " " +  the_pe.hot_folder_url_front
        @montage_strings_to_append <<  @montage_string_front
      end


    end
    logger.debug "montage_string_back: " + @montage_strings.inspect
    logger.debug "5555555555555555555555555555555555"
    logger.debug "5555555555555555555555555555555555"
    logger.debug "5555555555555555555555555555555555"
  end




  def update_missing_images
  MissingImages.destroy_all

end


#     def index
#       @items = ItemsWithYearlySale.find(:all,:conditions => ["sale_year = ? and department_id in (?)", Date.current.year   ,  @website.default_item_department_ids.split(/,/) ], :limit => 200, :order => "date_difference DESC"  )
# #  @items = ItemsWithYearlySales.find(:all,:conditions => ["sale_year = ? and department_id in (?)", Date.current.year   ,  @website.default_item_department_ids.split(/,/) ], :order => "date_difference DESC"  )
#
#     end




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
