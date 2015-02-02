class ImageManagerController < ApplicationController
  before_filter :redirect_unless_admin

  before_filter  :initialize_variables
  before_filter :no_item_menu

  @@new_single_file_version = false



  def missing_psd_images
            @original_items = Item.limit(4000).joins(:department, :category, :category_class).order("category_classes.name, items.ItemLookupCode ASC").where( "items.WebItem = ? and Inactive = ?  and category_classes.id in (?)",  true, false,  @@sublimation_standard_category_class_ids     ).all
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
              @original_items = Item.limit(4000).joins(:department, :category, :category_class).order("category_classes.name, items.ItemLookupCode ASC").where( "items.WebItem = ? and Inactive = ?  and category_classes.id in (?)",  true, false,@@sublimation_standard_category_class_ids     ).all
               logger.debug "5555555555555555555554444444444444444444444"
               logger.debug "5555555555555555555554444444444444444444444"
               logger.debug "5555555555555555555554444444444444444444444"
                @missing_images = Set.new
                @original_items.each do |the_item|
                                        the_item_file_url =  "W:\\\\AUTOMATION_DATABASE\\ORIGINAL_JPG\\"  +  the_item.ItemLookupCode + ".jpg"
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
               find_sublimation_entries
               gather_additional_sublimation_entries
               create_imagemagick_commands
end

  def find_sublimation_entries
    @sublimation_entries = SublimationEntry.where( "purchase_id = ?",  params[:purchase_id] )
    @sublimation_entry =   @sublimation_entries.all.first
    @all_over_sublimation_entries = SublimationEntry.where( "purchase_id = ? and name = ?",  params[:purchase_id], "all_over_item" ).all
    @regular_transfer_sublimation_entries = SublimationEntry.order("ItemLookupCode ASC").where("purchase_id = ? and name not in (?)", params[:purchase_id], [ "huge_front", "all_over_item","sublimation_shirts"] ).all
    @full_front_sublimation_entries = SublimationEntry.order("ItemLookupCode ASC").where( "purchase_id = ? and name = ?",  params[:purchase_id], "huge_front" ).all
    @custom_sublimation_entries = SublimationEntry.order("ItemLookupCode ASC").where("purchase_id = ? and name= ?",  params[:purchase_id] , "sublimation_shirts"  ).all
  end

  def gather_additional_sublimation_entries
                    @@sublimation_standard_transfer_types = [ 'sublim9', 'sublim12', 'sublim14'  ]
                    @additional_regular_transfer_sublimation_entries = Set.new
                    @additional_all_over_sublimation_entries = Set.new
                    @additional_full_front_sublimation_entries = Set.new
                    if @custom_sublimation_entries

                                    @custom_sublimation_entries.each do |custom_sublimation_entry|
                                                                logger.debug "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
                                                                logger.debug "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
                                                                logger.debug "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
                                                                logger.debug "custom_sublimation_entry.purchase_id: " + custom_sublimation_entry.purchase_id.to_s
                                                                logger.debug "custom_sublimation_entry.id: " + custom_sublimation_entry.id.to_s
                                                                logger.debug "custom_sublimation_entry.name: " + custom_sublimation_entry.name.to_s
                                                                logger.debug "custom_sublimation_entry.transfer_type_name: " + custom_sublimation_entry.transfer_type_name
                                                                logger.debug "custom_sublimation_entry.Descripiton: " + custom_sublimation_entry.ItemLookupCode
                                                                logger.debug "custom_sublimation_entry.Descripiton: " + custom_sublimation_entry.Description
                                                                logger.debug "custom_sublimation_entry.Comment: " + custom_sublimation_entry.Comment
                                                                if     @@sublimation_standard_transfer_types.include?    custom_sublimation_entry.transfer_type_name
                                                                             logger.debug "custom_sublimation_entry added to @additional_regular_transfer_sublimation_entries"
                                                                             @additional_regular_transfer_sublimation_entries.add custom_sublimation_entry
                                                                elsif    custom_sublimation_entry.transfer_type_name == "sublimaot"
                                                                               logger.debug "custom_sublimation_entry added to @additional_all_over_sublimation_entries"
                                                                               @additional_all_over_sublimation_entries.add custom_sublimation_entry                                                                
                                                                elsif    custom_sublimation_entry.transfer_type_name == "sublimfull"
                                                                               logger.debug "custom_sublimation_entry added to @additional_full_front_sublimation_entries"
                                                                               @additional_full_front_sublimation_entries.add custom_sublimation_entry
                                                                else
                                                                                logger.debug "custom_sublimation_entry.id: " + custom_sublimation_entry.id.to_s  + " not added to additional"
                                                                end
                                                                logger.debug "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
                                                                logger.debug "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
                                                                logger.debug "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
                                    end
                    end
  end


def create_imagemagick_commands
             all_over_ts_commands
            regular_transfer_commands
            full_front_commands
end



def all_over_ts_commands
                logger.debug "BEGIN all_over_ts_commands"
                logger.debug "BEGIN all_over_ts_commands"
                logger.debug "BEGIN all_over_ts_commands"
                @all_over_ts_montage =  []
                iteration_number = 0.0
                @all_all_over_sublimation_entries = Set.new
                # @all_all_over_sublimation_entries.add   @all_over_sublimation_entries   if @all_over_sublimation_entries != []
                logger.debug "@all_over_sublimation_entries: " + @all_over_sublimation_entries.inspect
                logger.debug "@@additional_all_over_sublimation_entries: " +  @additional_all_over_sublimation_entries.inspect
                @all_over_sublimation_entries.each do |an_entry|
                    @all_all_over_sublimation_entries.add   an_entry
                end
                @all_all_over_sublimation_entries.merge   @additional_all_over_sublimation_entries
                @all_all_over_sublimation_entries.delete_if { | i |  i.class != SublimationEntry     }
                @all_all_over_sublimation_entries.each do | pe |
                                sublimation_width_string  =    pe.SubDescription3.split("_").first
                                logger.debug "sublimation_width_string: " + sublimation_width_string
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
                                                                                            @montage_string_front  = "convert  -flop -border 0 -geometry " +   sublimation_width   + "x  -density 200 " + pe.file_url_front + " -fill white  -undercolor black -gravity South  -splice 0x80 -annotate +0+10 " + pe.label + " " +     pe.hot_folder_url_front(iteration_number)
                                                                                            @all_over_ts_montage <<  @montage_string_front

                                                                                            @montage_string_back  = "convert  -flop -border 0 -geometry " +   sublimation_width   + "x  -density 200 " + pe.file_url_back + " -fill white  -undercolor black -gravity South  -splice 0x80 -annotate +0+10 " + pe.label + " " +     pe.hot_folder_url_back(iteration_number)
                                                                                            @all_over_ts_montage <<   @montage_string_back
                                                                  end
                                                else
                                                                  logger.debug "quantity on order is not greater than zero"
                                                end
                                end
                end
                logger.debug "END all_over_ts_commands"
                logger.debug "END all_over_ts_commands"
                logger.debug "END all_over_ts_commands"
end



    def index
                @sublimation_entries = SublimationEntry.group("purchase_id,FirstName, LastName, Company").select("purchase_id, FirstName,LastName, Company").all
    end



  def order_details
                find_sublimation_entries
  end







  #
  # def print_all_over_ts
  #           logger.debug "5555555555555555555555555555555555"
  #           logger.debug "5555555555555555555555555555555555"
  #           logger.debug "5555555555555555555555555555555555"
  #
  #           @all_over_ts_montage =  []
  #           iteration_number = 0.0
  #           @all_all_over_sublimation_entries = Set.new
  #           @all_all_over_sublimation_entries.add   @all_over_sublimation_entries
  #           @all_all_over_sublimation_entries.merge   @additional_regular_transfer_sublimation_entries
  #           @all_all_over_sublimation_entries.delete_if { | i |  i.class != SublimationEntry     }
  #           @all_all_over_sublimation_entries.each do | pe |
  #
  #                                               sublimation_width_string  =    pe.SubDescription3.split("_").first
  #                                               if sublimation_width_string.is_number?
  #                                                 sublimation_width   =       sublimation_width_string
  #                                               end
  #
  #                                               if  sublimation_width    and sublimation_width != 0
  #                                                                 quantity_on_order =    pe.QuantityOnOrder.to_i
  #                                                                 if quantity_on_order  > 0
  #                                                                             logger.debug "quantity_on_order > 1"
  #                                                                             logger.debug "quantity_on_order: " + quantity_on_order.to_s
  #                                                                             quantity_on_order.times do |this_time|
  #
  #                                                                                           iteration_number += 1
  #                                                                                           @montage_string_front  = "convert  -border 0 -geometry " +   sublimation_width   + "x  -density 200 " + pe.file_url_front + " -  | convert label:" + pe.label + " - -append " +     pe.hot_folder_url_front(iteration_number)
  #                                                                                           @all_over_ts_montage <<  @montage_string_front
  #
  #                                                                                           @montage_string_back  = "convert  -border 0 -geometry " +   sublimation_width   + "x  -density 200 " + pe.file_url_back + " -  | convert label:" + pe.label + " - -append " +     pe.hot_folder_url_back(iteration_number)
  #                                                                                           @all_over_ts_montage <<   @montage_string_back
  #                                                                               end
  #                                                               else
  #                                                                                 logger.debug "quantity on order is not greater than zero"
  #                                                               end
  #                                                 end
  #                                                 # @all_over_ts_montage  <<   "GARMENT missing Opacity_Sub-Dimension data.  ItemLookupCode:"   +  pe.ItemLookupcode
  #
  #           end
  #           logger.debug "5555555555555555555555555555555555"
  #           logger.debug "5555555555555555555555555555555555"
  #           logger.debug "5555555555555555555555555555555555"
  # end









  def regular_transfer_commands
            # system( 'convert W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\'  + oj.filename + '  -geometry 75 W:\AUTOMATION_DATABASE\FINISHED_WEBSITE_ITEM_THUMBNAILS\\' +  oj.filename )
            # montage   -border 0 -geometry 7600x  -density 200 * final.jpg
            logger.debug "5555555555555555555555555555555555"
            logger.debug "5555555555555555555555555555555555"
            logger.debug "5555555555555555555555555555555555"
            @regular_transfer_images_to_layout = []

            @all_all_regular_transfer_sublimation_entries = Set.new
            @regular_transfer_sublimation_entries.each do |an_entry|
                       @all_all_regular_transfer_sublimation_entries.add   an_entry
             end
            @all_all_regular_transfer_sublimation_entries.merge   @additional_regular_transfer_sublimation_entries
            @all_all_regular_transfer_sublimation_entries.delete_if { | i |  i.class != SublimationEntry     }

              @all_all_regular_transfer_sublimation_entries.each do | the_pe |
                                logger.debug "##################################"
                                logger.debug "the_pe.id.to_s: " + the_pe.id.to_s
                                logger.debug "the_pe.ItemLookupCode.to_s: " + the_pe.ItemLookupCode.to_s
                                logger.debug "the_pe.Description.to_s: " + the_pe.Description.to_s
                                logger.debug "##################################"
                                logger.debug "##################################"


                                quantity_on_order =    the_pe.QuantityOnOrder.to_i
                                if quantity_on_order  > 1
                                  logger.debug "quantity_on_order > 1"
                                  logger.debug "quantity_on_order: " + quantity_on_order.to_s
                                  quantity_on_order.times do |pe|
                                    @regular_transfer_images_to_layout <<   the_pe
                                  end
                                else
                                  logger.debug "quantity_on_order NOT > 1"
                                  @regular_transfer_images_to_layout <<   the_pe
                                end

                              end
                              @regular_transfers_montage =  []
                              iteration_number = 0.0
                              @regular_transfer_images_to_layout.in_groups_of(3).each do |the_pe|
                                iteration_number += 1

                                the_file_1 =   the_pe[0].to_s
                                the_file_1_name  =   the_pe[0].file_url_front
                                the_file_1_id  =   the_pe[0].id.to_s
                                the_file_1_width  =   the_pe[0].regular_transfer_width
                                the_file_1_purchase_id  =   the_pe[0].purchase_id
                                the_file_1_label = the_pe[0].label
                                logger.debug "##################################"


                                if  the_pe[1]
                                  the_file_2 =   the_pe[1].to_s
                                  the_file_2_name  =   the_pe[1].file_url_front
                                  the_file_2_id  =   the_pe[1].id.to_s
                                  the_file_2_width  =   the_pe[1].regular_transfer_width
                                  the_file_2_purchase_id  =   the_pe[1].purchase_id
                                  the_file_2_label = the_pe[1].label
                                end

                                if  the_pe[2]
                                  the_file_3 =   the_pe[2].to_s
                                  the_file_3_name  =   the_pe[2].file_url_front
                                  the_file_3_id  =   the_pe[2].id.to_s
                                  the_file_3_width  =   the_pe[2].regular_transfer_width
                                  the_file_3_purchase_id  =   the_pe[2].purchase_id
                                  the_file_3_label = the_pe[2].label
                                end

                                logger.debug "the_file_1: " +  the_file_1.to_s
                                logger.debug "the_file_1_name: " +  the_file_1_name.to_s
                                logger.debug "the_file_1_id: " +  the_file_1_id.to_s
                                logger.debug "the_file_1_width: " +  the_file_1_width.to_s

                                logger.debug "the_file_2: " +  the_file_2.to_s
                                logger.debug "the_file_2_name: " +  the_file_2_name.to_s
                                logger.debug "the_file_2_id: " +  the_file_2_id.to_s
                                logger.debug "the_file_2_width: " +  the_file_2_width.to_s

                                logger.debug "the_file_3: " +  the_file_3.to_s
                                logger.debug "the_file_3_name: " +  the_file_3_name.to_s
                                logger.debug "the_file_3_id: " +  the_file_3_id.to_s
                                logger.debug "the_file_3_width: " +  the_file_3_width.to_s

                                logger.debug "##################################"
                                the_output_filename =    @@OUTPUT_LOCATION + "PURCHASE-" + params[:purchase_id] + "-"   + iteration_number.to_s + '.jpg'



                                if the_file_3
                                              @regular_transfers_montage   <<    "convert " + the_file_1_name + " -density 200 -units PixelsPerInch -resize " + the_file_1_width + " -rotate -90 -flop -bordercolor White  -border 50x50  -fill white  -undercolor black -gravity South   -background White  -splice 0x80 -annotate +0+10 " + the_file_1_label + "  - | convert " + the_file_2_name + " -density 200 -units PixelsPerInch -resize " + the_file_2_width + " -rotate -90 -flop -bordercolor White  -border 50x50 -fill white  -undercolor black -gravity South  -splice 0x80 -annotate +0+10 " + the_file_2_label + " - +append  - | convert " + the_file_3_name + " -density 200 -units PixelsPerInch -resize " + the_file_3_width + " -rotate -90 -flop -bordercolor White  -border 50x50 -fill white  -undercolor black -gravity South  -splice 0x80 -annotate +0+10 " + the_file_3_label + " - +append "  + the_output_filename
                                elsif the_file_2
                                              @regular_transfers_montage   <<    "convert " + the_file_1_name + " -density 200 -units PixelsPerInch -resize " + the_file_1_width + " -rotate -90 -flop -bordercolor White  -border 50x50  -fill white  -undercolor black -gravity South   -background White  -splice 0x80 -annotate +0+10 " + the_file_1_label + "  - | convert " + the_file_2_name + " -density 200 -units PixelsPerInch -resize " + the_file_2_width + " -rotate -90 -flop -bordercolor White  -border 50x50 -fill white  -undercolor black -gravity South  -splice 0x80 -annotate +0+10 " + the_file_2_label + " - +append "  + the_output_filename
                                else
                                             @regular_transfers_montage   <<    "convert " + the_file_1_name + " -density 200 -units PixelsPerInch -resize " + the_file_1_width + " -rotate -90 -flop -bordercolor White  -border 50x50  -fill white  -undercolor black -gravity South   -background White  -splice 0x80 -annotate +0+10 " + the_file_1_label +  " " + the_output_filename
                                end


            end
            logger.debug "montage_string_back: " + @regular_transfers_montages.inspect
            logger.debug "5555555555555555555555555555555555"
            logger.debug "5555555555555555555555555555555555"
            logger.debug "5555555555555555555555555555555555"
  end









  def full_front_commands
                # system( 'convert W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\'  + oj.filename + '  -geometry 75 W:\AUTOMATION_DATABASE\FINISHED_WEBSITE_ITEM_THUMBNAILS\\' +  oj.filename )
                # montage   -border 0 -geometry 7600x  -density 200 * final.jpg
                logger.debug "full_front_commandsfull_front_commandsfull_front_commands"
                logger.debug "full_front_commandsfull_front_commandsfull_front_commands"
                logger.debug "full_front_commandsfull_front_commandsfull_front_commands"
                @full_front_images_to_layout = []
                @all_full_front_sublimation_entries = Set.new
                @full_front_sublimation_entries.each do |an_entry|
                              @all_full_front_sublimation_entries.add   an_entry
                  end
                @all_full_front_sublimation_entries.merge   @additional_full_front_sublimation_entries     if @additional_full_front_sublimation_entries
                @all_full_front_sublimation_entries.delete_if { | i |  i.class != SublimationEntry     }
                logger.debug "@all_full_front_sublimation_entries.size: " + @all_full_front_sublimation_entries.size.to_s
                @all_full_front_sublimation_entries.each do |the_pe|
                                            logger.debug "##################################"
                                              logger.debug "the_pe.id.to_s: " + the_pe.id.to_s
                                              logger.debug "##################################"
                                              logger.debug "##################################"


                                                quantity_on_order =    the_pe.QuantityOnOrder.to_i
                                                   if quantity_on_order  > 1
                                                                           logger.debug "quantity_on_order > 1"
                                                                           logger.debug "quantity_on_order: " + quantity_on_order.to_s
                                                                           quantity_on_order.times do |pe|
                                                                                      @full_front_images_to_layout <<   the_pe
                                                                           end
                                                   else
                                                                                      logger.debug "quantity_on_order NOT > 1"
                                                                                      @full_front_images_to_layout <<   the_pe
                                                   end

                end
                logger.debug "##################################"
                  logger.debug "@full_front_images_to_layout.size: " + @full_front_images_to_layout.size.to_s
                logger.debug "##################################"
                @full_fronts_montage =  []
                iteration_number = 0.0
                @full_front_images_to_layout.in_groups_of(2).each do |the_pe|
                              iteration_number += 1
            
                              the_file_1 =   the_pe[0].to_s
                              the_file_1_name  =   the_pe[0].file_url_front
                              the_file_1_id  =   the_pe[0].id.to_s
                              the_file_1_width  =   the_pe[0].big_front_width
                              the_file_1_purchase_id  =   the_pe[0].purchase_id
                              the_file_1_label = the_pe[0].label
                              logger.debug "##################################"
                              logger.debug "iteration_number: " + iteration_number.to_s
                              logger.debug "##################################"

            
                              if  the_pe[1]
                                the_file_2 =   the_pe[1].to_s
                                the_file_2_name  =   the_pe[1].file_url_front
                                the_file_2_id  =   the_pe[1].id.to_s
                                the_file_2_width  =   the_pe[1].big_front_width
                                the_file_2_purchase_id  =   the_pe[1].purchase_id
                                the_file_2_label = the_pe[1].label
            
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
                                           @full_fronts_montage   <<  "convert " + the_file_1_name + " -flatten -density 200 -rotate -90 -flop -bordercolor white -border 50x50 -gravity West -annotate 90x90+10+0 " + the_file_1_label + "  -units PixelsPerInch -resize " + the_file_1_width + " - | convert " + the_file_2_name + " -flatten -flop -rotate 90 -density 200 -bordercolor white -border 50x50 -gravity West -annotate 90x90+10+0 " + the_file_2_label + " -units PixelsPerInch -resize " + the_file_2_width + " -bordercolor white -border 50x50 - +append " + the_output_filename
                              else
                                             @full_fronts_montage   <<  "convert " + the_file_1_name  + " -flatten -flop  -density 200 -rotate 90 -units PixelsPerInch -resize  "  + the_file_1_width   + "   -bordercolor white  -border 50x50  -gravity West -annotate 90x90+10+0 " +  the_file_1_label  + " " +  the_output_filename
                              end
                end

                 logger.debug "montage_string_back: " + @full_fronts_montages.inspect
                logger.debug "full_front_commandsfull_front_commandsfull_front_commands"
                logger.debug "full_front_commandsfull_front_commandsfull_front_commands"
                logger.debug "full_front_commandsfull_front_commandsfull_front_commands"
  end












































  def print_full_fronts_before
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
