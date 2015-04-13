class ItemManagementController < ApplicationController
before_filter :redirect_unless_admin
  before_filter :load_variables

   def load_variables
         @verification_file = 'Y://STORAGE_DISK_1/MAIN_FILES_STORAGE/ITEM_MANAGEMENT/STOCK_DESIGNS_BY_NUMBER/4264L_t_rp.psd'
         @asset_server = 'localhost:7000'
  end


  def index

          @original_pngs =  rio('W:\\AUTOMATION_DATABASE\\ORIGINAL_PNG\\').files['*.png']
          @original_png_filenames = Set.new
          @original_png_filenames_no_extension = Set.new
          @original_pngs.each do |original_jpg|
                       @original_png_filenames.add(original_jpg.filename)
                       @original_png_filenames_no_extension.add(original_jpg.filename.gsub(/.png/, '')   )
               end

         if params[:category_id]
               @items = Item.find(:all, :conditions => [ 'category_id in (?)',   params[:category_id]   ]  )
         else
              @items = Item.find(:all, :conditions => [ 'department_id in (?)',  @website.default_design_department_ids.split(/,/)  ]  )
         end
        @items = @items.paginate(  :per_page => 5, :page => params[:page] )
  end



def startup_variables
  badness
        # GATHER ALL ORIGINAL_JPG NAMES
        # GATHER ALL ITEM_PICTURE_NAMES
        # RESTRICT BY DEPARTMENT AT LEAST
        # RESTRICT BY CATEGORY IF CHOSEN
        # MISSING_ORIGINAL_JPGS
        # MISSING_ITEMS


      @all_items = Item.where("department_id = ? and category_id = ?")

end




def startup_variables_junk
        @original_psds =  rio('W:\\AUTOMATION_DATABASE\\ORIGINAL_PSD\\').files['*.psd']
                  @original_psd_filenames = Set.new
                  @original_psd_filenames_no_extension = Set.new
                  @original_psds.each do |original_psd|
                          @original_psd_filenames.add(original_psd.filename)
                          @original_psd_filenames_no_extension.add(original_psd.filename.gsub(/.psd/, '') )
                   end
          @original_jpgs =  rio('W:\\AUTOMATION_DATABASE\\ORIGINAL_JPG\\').files['*.jpg']
          @original_jpg_filenames = Set.new
          @original_jpg_filenames_no_extension = Set.new
          @original_jpgs.each do |original_jpg|
                       @original_jpg_filenames.add(original_jpg.filename)
                       @original_jpg_filenames_no_extension.add(original_jpg.filename.gsub(/.jpg/, '')   )
               end
          @destination_production_jpgs =  rio('W:\\AUTOMATION_DATABASE\\FINISHED_PRODUCTION_JPGS\\').files['*.jpg']
          @destination_production_zero_jpg_filenames_no_extension = Set.new
          @destination_production_one_jpg_filenames_no_extension = Set.new
          @destination_production_jpgs.each do |destination_jpg|
                      @destination_production_zero_jpg_filenames_no_extension.add(destination_jpg.filename.gsub(/-0.jpg/, '')  )
                      @destination_production_one_jpg_filenames_no_extension.add(destination_jpg.filename.gsub(/-1.jpg/, '')  )
                      @destination_production_both_jpg_filenames_no_extension = @destination_production_zero_jpg_filenames_no_extension.intersection(@destination_production_one_jpg_filenames_no_extension)
          end

          @destination_item_specsheet_jpgs =  rio('W:\\AUTOMATION_DATABASE\\FINISHED_WEBSITE_ITEM_SPECSHEETS\\').files['*.jpg']
          @destination_item_specsheet_zero_jpg_filenames_no_extension = Set.new
          @destination_item_specsheet_one_jpg_filenames_no_extension = Set.new
          @destination_item_specsheet_jpgs.each do |destination_jpg|
                      @destination_item_specsheet_zero_jpg_filenames_no_extension.add(destination_jpg.filename.gsub(/-0.jpg/, '')    )
                       @destination_item_specsheet_one_jpg_filenames_no_extension.add(destination_jpg.filename.gsub(/-1.jpg/, '')    )
                       @destination_item_specsheet_both_jpg_filenames_no_extension = @destination_item_specsheet_one_jpg_filenames_no_extension.intersection(@destination_item_specsheet_zero_jpg_filenames_no_extension)
          end
          @unfinished_original_jpgs = @original_psd_filenames_no_extension.difference(@original_jpg_filenames_no_extension)
          @finished_original_jpgs =  @original_psd_filenames_no_extension.intersection(@original_jpg_filenames_no_extension)
          @completed_item_specsheets = @destination_item_specsheet_both_jpg_filenames_no_extension.intersection(@original_jpg_filenames_no_extension)
          @incomplete_item_specsheets = @original_jpg_filenames_no_extension.difference(@completed_item_specsheets)
          @available_production_jpgs = @destination_production_both_jpg_filenames_no_extension.intersection(@original_jpg_filenames_no_extension)
           @unavailable_production_jpgs = @original_jpg_filenames_no_extension.difference(@available_production_jpgs)
           @incomplete_designs = @unavailable_production_jpgs.merge(@unfinished_original_jpgs).merge(@incomplete_item_specsheets)


           @production_missing_from_items = 'dd'
           @items_missing_from_production = 'ee'
  
end


        #@items = Item.paginate_all_by_category_id( [18,23, 25,31,54,59 ], :page => params[:page], :order => 'ItemLookupCode ASC'    )
        #@items = Item.paginate_all_by_category_id( [18,23, 25,31,54,59 ] , :include =>  [ 'item_sales_this_year' ]  , :page => params[:page], :order => 'item_sales_this_years.sum_of_quantity DESC'    )
        #@items = Item.find(:all, :conditions => [ 'category_id in (?)',  [18,23, 25,31,54,59]  ] , :include =>  [ 'item_sales_this_year' ]  , :order => 'item_sales_this_years.sum_of_quantity DESC'    )  # #
#        @items = Item.find(:all, :conditions => [ 'department_id in (?)',  @website.default_design_department_ids.split(/,/)  ]  )
#        render :text => @items.to_xml






 


def complete_status_popup
    @item = Item.find params[:item_id]
    @clone_item = CloneItem.find(:first, :conditions => ["clone_item_type_id = ? and item_id = ?", params[:clone_item_type_id] , params[:item_id]  ]) if params[:clone_item_type_id]
    @the_clone = Item.find @clone_item.clone_id  if @clone_item
       render :partial => 'item_management/complete_status_popup' ,:layout => 'item_management'
end

 def status_legend_popup
          render :partial => 'item_management/legend_popup'  ,:layout => 'item_management'
 end



 def management_options
      @clone_item_type = CloneItemType.find params[:clone_item_type_id]  if params[:clone_item_type_id]
      @item = Item.find params[:item_id]
 end

  def item_index_infinite
        #@items = Item.paginate_by_department_id( 10 , :page => params[:page], :order => 'ItemLookupCode ASC'    )
        @items = Item.paginate_all_by_category_id( [18,23, 25,31,54,59 ], :page => params[:page], :order => 'ItemLookupCode ASC'    )
        if request.xhr?
                 render :partial => "item_management/items_infinite"
        else
                render(:partial => "item_management/item_index_infinite"    ,:layout => controller_name )
        end
  end

def create_clones_for_checked
        if  params[:clone_item_type]
              clone_item_type_ids_to_create = params[:clone_item_type][:clone_item_type_ids]
              clone_item_type_ids_to_create.each do |citid |
                      create_clone_item(  params[:original_item_id] ,  citid  )
              end
            flash[:notice] = "Clones were successfully created as the table shows below"
            redirect_to :controller => "item_management", :action => "index"
        else
            flash[:notice] = "Please check some clone item types to create!"
            redirect_to :controller => "item_management", :action => "management_options", :item_id => params[:original_item_id]
        end
end

def create_clone_item( original_item_id , clone_item_type_id  )
         logger.warn '###################'
         @original_item = Item.find original_item_id
         clone_item_type_to_create = CloneItem.find clone_item_type_id
         clone_item_example_id = clone_item_type_to_create.clone_item_type.original_item_id
         @original_item.new_clone_with_default_attributes( clone_item_example_id , clone_item_type_id  )
  
         logger.warn '###################' 
end









end
