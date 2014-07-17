class ProductionController < ApplicationController

before_filter :redirect_unless_admin


  def index
  end


  def create_file
    #################  FRONT
    if params[:current_front_design_type] == 'custom'
      badd1
                @front_custom_item =   CustomItem.find params[:current_front_design]
                @front_original_width  =   @front_custom_item.width      #       936
                @front_original_height =    @front_custom_item.height   #       1248
               @front_low_res_width =  params[:front_design_width].to_f              #     120
                @front_height_multiplier =  @front_low_res_width.to_f / @front_original_width.to_f
                @front_low_res_height = @front_original_height.to_f * @front_height_multiplier       #160
                 @PRODUCTION_FRONT_MULIPLIER =    27.95     # AT MIDDLE AND LOW SIZES
                @PRODUCTION_FRONT_WIDTH =    @front_low_res_width   *   @PRODUCTION_FRONT_MULIPLIER                        # 3240
                @PRODUCTION_FRONT_HEIGHT =   @front_low_res_height *   @PRODUCTION_FRONT_MULIPLIER                      #  4320
                @front_item_filename =  'W:\\AUTOMATED_WEB_CUSTOM_IMAGES\fullsize\\' + @front_custom_item.filename
    else
                @front_stock_item = Item.find params[:current_front_design]
                 @front_original_width  =   240
                @front_original_height =   240
                 @front_low_res_width =  params[:front_design_width].to_f
                  @front_low_res_height = params[:front_design_width].to_f
                @PRODUCTION_FRONT_MULIPLIER = 20
                @PRODUCTION_FRONT_WIDTH =     @front_low_res_width   *   @PRODUCTION_FRONT_MULIPLIER                        # 3240
                @PRODUCTION_FRONT_HEIGHT =   @front_low_res_height   *   @PRODUCTION_FRONT_MULIPLIER
                @front_item_filename =   'W:\\AUTOMATION_DATABASE\\ORIGINAL_PNG\\' + @front_stock_item.base_itemlookupcode + '.png'
    end
#################  BACK 
    if params[:current_back_design_type] == 'custom'
      badd2
                @back_custom_item =   CustomItem.find params[:current_back_design]
                @back_original_width  =   @back_custom_item.width      #       936
                @back_original_height =    @back_custom_item.height   #       1248
               @back_low_res_width =  params[:back_design_width].to_f              #     120
                @back_height_multiplier =  @back_low_res_width.to_f / @back_original_width.to_f
                @back_low_res_height = @back_original_height.to_f * @back_height_multiplier       #160
                 @PRODUCTION_BACK_MULIPLIER =    27.95     # AT MIDDLE AND LOW SIZES
                @PRODUCTION_BACK_WIDTH =    @back_low_res_width   *   @PRODUCTION_BACK_MULIPLIER                        # 3240
                @PRODUCTION_BACK_HEIGHT =   @back_low_res_height *   @PRODUCTION_BACK_MULIPLIER                      #  4320
                @back_item_filename =  'W:\\AUTOMATED_WEB_CUSTOM_IMAGES\fullsize\\' + @back_custom_item.filename
    else
                @back_stock_item = Item.find params[:current_back_design]
                 @back_original_width  =   240
                @back_original_height =   240
                 @back_low_res_width =  params[:back_design_width].to_f
                  @back_low_res_height = params[:back_design_width].to_f
                @PRODUCTION_BACK_MULIPLIER =   20
                @PRODUCTION_BACK_WIDTH =     @back_low_res_width   *   @PRODUCTION_BACK_MULIPLIER                        # 3240
                @PRODUCTION_BACK_HEIGHT =   @back_low_res_height   *   @PRODUCTION_BACK_MULIPLIER
                 @back_item_filename =   'W:\\PRODUCTION_SOURCE_FILES\\' + @back_stock_item.base_itemlookupcode  + '.png'
    end


















  end

end
