class ImageManagerController < ApplicationController
  before_filter :redirect_unless_admin

  before_filter  :initialize_variables
  before_filter :no_item_menu


      # changed category class id of all in department 35 from 31 to 69


  def missing_psd_images
            # @original_items = Item.limit(400).joins(:department, :category, :category_class).where( "category_classes.name in (?)",    ['all_over_item',   'huge_front'      ]     ).all
            @original_items = Item.limit(4000).joins(:department, :category, :category_class).order("category_classes.name, items.ItemLookupCode ASC").where( "items.WebItem = ? and Inactive = ?  and category_classes.item_type = ?",  true, false, "slave"     ).all
            logger.debug "5555555555555555555554444444444444444444444"
            logger.debug "5555555555555555555554444444444444444444444"
            logger.debug "5555555555555555555554444444444444444444444"
            @missing_images = Set.new
            @original_items.each do |the_item|
                          # @items.add( item) if item.department and item.category  and item.category_class

                          the_item_file_url =  "W:\\\\AUTOMATION_DATABASE\\ORIGINAL_PSD\\"  +  the_item.ItemLookupCode + ".psd"

                          logger.debug "the_item_file_url: " +  the_item_file_url

                          if File.file?( the_item_file_url  )
                                     logger.debug "file did  exist"
                          else
                                      logger.debug "file did not exist"
                                      @missing_images.add( the_item )
                          end
            end
            logger.debug "5555555555555555555554444444444444444444444"
            logger.debug "5555555555555555555554444444444444444444444"
            logger.debug "5555555555555555555554444444444444444444444"
  end




def missing_sublimation_images
                # @original_items = Item.limit(400).joins(:department, :category, :category_class).where( "category_classes.name in (?)",    ['all_over_item',   'huge_front'      ]     ).all
              @original_items = Item.limit(4000).joins(:department, :category, :category_class).order("category_classes.name, items.ItemLookupCode ASC").where( "items.WebItem = ? and Inactive = ?  and category_classes.item_type = ?",  true, false, "slave"     ).all
               logger.debug "5555555555555555555554444444444444444444444"
               logger.debug "5555555555555555555554444444444444444444444"
               logger.debug "5555555555555555555554444444444444444444444"
                @missing_images = Set.new
                @original_items.each do |the_item|
                                       # @items.add( item) if item.department and item.category  and item.category_class

                                        the_item_file_url =  "W:\\\\AUTOMATION_DATABASE\\ORIGINAL_PNG\\"  +  the_item.ItemLookupCode + ".png"

                                       logger.debug "the_item_file_url: " +  the_item_file_url

                                        if File.file?( the_item_file_url  )
                                                              logger.debug "file did  exist"
                                        else
                                                               logger.debug "file did not exist"
                                                               @missing_images.add( the_item )
                                         end
                end
              logger.debug "5555555555555555555554444444444444444444444"
              logger.debug "5555555555555555555554444444444444444444444"
              logger.debug "5555555555555555555554444444444444444444444"
end









  
  
 def print_all
                 print_all_over_ts
                 print_big_fronts
end
  
  
  
  
  


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
                        @all_over_ts_montage =  []
                        iteration_number = 0.0
                        @sublimation_entries.each do | pe |

                                    sublimation_width_string  =    pe.SubDescription3.split("_").first
                                     if sublimation_width_string.is_number?
                                               sublimation_width   =       sublimation_width_string
                                     end

                                      if  sublimation_width    and sublimation_width != 0
                                                                quantity_on_order =    pe.QuantityOnOrder.to_i
                                                                if quantity_on_order  > 0
                                                                              logger.debug "quantity_on_order > 1"
                                                                              logger.debug "quantity_on_order: " + quantity_on_order.to_s
                                                                              quantity_on_order.times do |this_time|

                                                                                                 iteration_number += 1
                                                                                                 @montage_string_front  = "convert  -border 0 -geometry " +   sublimation_width   + "x  -density 200 " + pe.file_url_front + " -  | convert label:" + pe.label + " - -append " +     pe.hot_folder_url_front(iteration_number)
                                                                                                  @all_over_ts_montage <<  @montage_string_front

                                                                                                 @montage_string_back  = "convert  -border 0 -geometry " +   sublimation_width   + "x  -density 200 " + pe.file_url_back + " -  | convert label:" + pe.label + " - -append " +     pe.hot_folder_url_back(iteration_number)
                                                                                                 @all_over_ts_montage <<   @montage_string_back
                                                                              end
                                                                else
                                                                                 logger.debug "quantity on order is not greater than zero"
                                                                  end

                                      else
                                                        @all_over_ts_montage  <<   "GARMENT missing Opacity_Sub-Dimension data.  ItemLookupCode:"   +  pe.ItemLookupcode
                                        end
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
                @big_front_images_to_layout = []
                @sublimation_entries.each do |the_pe|
                                            logger.debug "##################################"
                                              logger.debug "the_pe.id.to_s: " + the_pe.id.to_s
                                              logger.debug "##################################"
                                              logger.debug "##################################"


                                                quantity_on_order =    the_pe.QuantityOnOrder.to_i
                                                   if quantity_on_order  > 1
                                                                           logger.debug "quantity_on_order > 1"
                                                                           logger.debug "quantity_on_order: " + quantity_on_order.to_s
                                                                           quantity_on_order.times do |pe|
                                                                                      @big_front_images_to_layout <<   the_pe
                                                                           end
                                                   else
                                                                                      logger.debug "quantity_on_order NOT > 1"
                                                                                      @big_front_images_to_layout <<   the_pe
                                                   end

                end
                @big_fronts_montage =  []
                iteration_number = 0.0
                @big_front_images_to_layout.in_groups_of(2).each do |the_pe|
                                  iteration_number += 1

                                  the_file_1 =   the_pe[0].to_s
                                  the_file_1_name  =   the_pe[0].file_url_front
                                  the_file_1_id  =   the_pe[0].id.to_s
                                  the_file_1_width  =   the_pe[0].big_front_width
                                  the_file_1_purchase_id  =   the_pe[0].purchase_id
                                  logger.debug "##################################"


                                  if  the_pe[1]
                                        the_file_2 =   the_pe[1].to_s
                                        the_file_2_name  =   the_pe[1].file_url_front
                                        the_file_2_id  =   the_pe[1].id.to_s
                                        the_file_2_width  =   the_pe[1].big_front_width
                                        the_file_2_purchase_id  =   the_pe[1].purchase_id

                                  end
                                  
                                  logger.debug "the_file_1: " +  the_file_1.to_s
                                  logger.debug "the_file_1_name: " +  the_file_1_name.to_s
                                  logger.debug "the_file_1_id: " +  the_file_1_id.to_s
                                  logger.debug "the_file_1_width: " +  the_file_1_width.to_s  
                                  
                                  logger.debug "the_file_2: " +  the_file_2.to_s
                                  logger.debug "the_file_2_name: " +  the_file_2_name.to_s
                                  logger.debug "the_file_2_id: " +  the_file_2_id.to_s
                                  logger.debug "the_file_2_width: " +  the_file_2_width.to_s
                                  logger.debug "##################################"
                                  the_output_filename =    @@OUTPUT_LOCATION + "PURCHASE-" + params[:purchase_id] + "-"  + iteration_number.to_s + '.jpg'

                                 if the_file_2
                                            @big_fronts_montage   <<  "convert " + the_file_1_name  + " -flatten -flop -density 200 -rotate 90 -units PixelsPerInch -resize  "  + the_file_1_width +   "  -bordercolor white  -border 50x50 - | convert " + the_file_2_name + " -flatten -flop  -rotate 90 -density 200 -units PixelsPerInch -resize "  + the_file_2_width +   "   -bordercolor white -border 50x50  - +append " + the_output_filename
                                 else
                                            @big_fronts_montage   <<  "convert " + the_file_1_name  + " -flatten -flop  -density 200 -rotate 90 -units PixelsPerInch -resize  "  + the_file_1_width   + "   -bordercolor white  -border 50x50  " +  the_output_filename
                                 end

                end
                 logger.debug "montage_string_back: " + @big_fronts_montages.inspect
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
                @big_front_images_to_layout = []
                @sublimation_entries.each do |the_pe|

                                            logger.debug "##################################"
                                            logger.debug "##################################"
                                            logger.debug "  the_pe.PriceLevel: " +   the_pe.PriceLevel.to_s
                                            if    ["0", "1"].include?  the_pe.PriceLevel.to_s
                                                        logger.debug "##################################"
                                                        logger.debug "Customer has 0,1 PriceLevel. Check Opposite for dimension"
                                                        the_real_pe = PurchasesEntry.find(the_pe.id)
                                                        the_master_pe = the_real_pe.master_of_symbiont_pair
                                            else
                                                            logger.debug "##################################"
                                                            logger.debug "Customer has singular type PriceLevel. Do not  Check Opposite for dimension"

                                             end
                                            if the_master_pe
                                                          logger.debug "##################################"
                                                          logger.debug "the_master_pe.id: " + the_master_pe.id.to_s
                                                          sublimation_width_string  =    the_master_pe.item.SubDescription3     #.split("_").second
                                                          if sublimation_width_string and sublimation_width_string.is_number?
                                                            sublimation_width   =       sublimation_width_string
                                                          end
                                            else
                                                            sublimation_width_string  =    the_pe.subl_dimensions.split("_").first
                                                            if sublimation_width_string and sublimation_width_string.is_number?
                                                                      sublimation_width   =       sublimation_width_string
                                                            end
                                             end

                                              logger.debug "the_pe.id.to_s: " + the_pe.id.to_s
                                              logger.debug "sublimation_width: " + sublimation_width.to_s
                                              logger.debug "##################################"
                                              logger.debug "##################################"


                                                quantity_on_order =    the_pe.QuantityOnOrder.to_i
                                                   if quantity_on_order  > 1
                                                                           logger.debug "quantity_on_order > 1"
                                                                           logger.debug "quantity_on_order: " + quantity_on_order.to_s
                                                                           quantity_on_order.times do |pe|
                                                                                      @big_front_images_to_layout <<   the_pe.file_url_front + "_" +  the_pe.id.to_s  + "_" +  sublimation_width
                                                                           end
                                                   else
                                                                                      logger.debug "quantity_on_order NOT > 1"
                                                                                      @big_front_images_to_layout <<   the_pe.file_url_front + "_" +   the_pe.id.to_s   + "_" +  sublimation_width
                                                   end

                end
                @big_fronts_montage =  []
                iteration_number = 0.0
                @big_front_images_to_layout.in_groups_of(2).each do |the_pe|
                                  iteration_number += 1
                                  # @big_fronts_montage   <<   "montage  -border 0 -geometry 3800x  -rotate 90 -density 200 " +  the_pe[0].to_s  + " "  + the_pe[1].to_s  + " "  +   "W:\\\\SUBLIMATION_HOT_FOLDER_REVIEW\\PURCHASE-" + params[:purchase_id] + "-"  + iteration_number.to_s + '.jpg'
                                  # @big_fronts_montage   <<   "montage  -border 0 -geometry 3800x  -rotate 90 -density 200 " + the_file_1  + " "  + the_file_2  + " "  +     the_output_filename

                                  the_file_1 =   the_pe[0].to_s
                                  the_file_1_name  =   the_pe[0].to_s.split("_").first
                                  the_file_1_id  =   the_pe[0].to_s.split("_").second
                                  the_file_1_width  =   the_pe[0].to_s.split("_").last

                                  the_file_2 =   the_pe[1].to_s
                                  the_file_2_name  =   the_pe[1].to_s.split("_").first
                                  the_file_2_id  =   the_pe[1].to_s.split("_").second
                                  the_file_2_width  =   the_pe[1].to_s.split("_").last

                                 the_output_filename =   "W:\\\\SUBLIMATION_HOT_FOLDER_REVIEW\\PURCHASE-" + params[:purchase_id] + "-"  + iteration_number.to_s + '.jpg'

                                  logger.debug "##################################"
                                  logger.debug "the_file_1: " +  the_file_1.inspect
                                  logger.debug "the_file_2: " +  the_file_2.inspect
                                  logger.debug "##################################"


                                 if the_file_2 and the_file_2 != ""
                                            @big_fronts_montage   <<  "convert " + the_file_1_name  + " -flatten -density 200 -rotate 90 -units PixelsPerInch -resize  "  + the_file_1_width +   " - | convert " + the_file_2_name + " -flatten -rotate 90 -density 200 -units PixelsPerInch -resize "  + the_file_2_width +   " - +append " + the_output_filename
                                 else
                                            @big_fronts_montage   <<  "convert " + the_file_1_name  + " -flatten -density 200 -rotate 90 -units PixelsPerInch -resize  "  + the_file_1_width   + " " +  the_output_filename
                                 end

                end
                 logger.debug "montage_string_back: " + @big_fronts_montages.inspect
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
                                          @montage_string_front  = "montage  -border 0 -geometry 3800x  -rotate 90 -density 200 " + the_pe.file_url_front + " " +  the_pe.hot_folder_url_front(iteration_number)
                                          @montge_strings_to_append  <<  @montage_string_front
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
