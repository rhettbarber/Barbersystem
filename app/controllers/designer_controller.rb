class DesignerController < ApplicationController
before_filter :redirect_unless_admin
#require 'RMagick'
#include Magick
#require 'win32/open3'
#  helper_method  :send_file
#before_filter :startup_designer_variables  , :only => [ :complete_selected_incomplete ,:index, :update_items_listing, :designer_item_search ]
before_filter :developer_stdout
#skip_before_filter :verify_authenticity_token, :only => [:update_items_listing ]

@@category_items_per_page = 5


#   helper_method  :show_preview





  def ajax_item_details
          if params[:side] == 'front'
                    @front = true
          end
          @item = Item.find params[:item_id]
           render  :partial => 'designer/ajax_item_details'
  end


def show_preview
          @item = Item.find params[:item_id]
          if params[:side] == 'back'
                  send_file @item.designer_back_file_url, :type => 'image/jpeg', :disposition => 'inline'
          else
                   send_file @item.designer_front_file_url, :type => 'image/jpeg', :disposition => 'inline'
          end
#          send_file "W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\ALL-OVER-T\\#{params[:filename]}", :type => 'image/jpeg', :disposition => 'inline'
#           send_file "W:\\AUTOMATION_DATABASE\\AUTOMATED_ITEM_SPECSHEETS\\11085-3880.png", :type => 'image/jpeg', :disposition => 'inline'
  end


def show_thumbnail
#### DANGEROUS METHOD, MUST BE WHITELISTED
#    if params[:side] == 'front'
          send_file "W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\ALL-OVER-T\\#{params[:filename]}", :type => 'image/jpeg', :disposition => 'inline'

#           send_file "W:\\AUTOMATION_DATABASE\\AUTOMATED_ITEM_SPECSHEETS\\11085-3880.png", :type => 'image/jpeg', :disposition => 'inline'
  end




def index
  @categories = Category.includes(:category_class, :items).where("category_classes.item_type = ?", 'all_over_design')
  @items = Set.new
  @categories.each do |category|
        category.items.each do |item|
                @items.add( item )
        end
  end

#  @items = Item.includes(:category, :category_class ).where("category_classes.item_type " ,  'all_over_design' )
#  @items = Item.includes(:category ).where("category.category_id in (?) " ,  Item.all_over_design_category_ids )

end




def index_old
              @thumbnail_pngs =  rio('W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\ALL-OVER-T\\').files['11085-*.jpg']
              if @thumbnail_pngs.size > 0
                    #great
                     startup_item_variables
              else
                    bad
#                    flash[:notice] = "Alert! No Connection to AUTOMATION_SYSTEM_DATABASE.  W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\ALL-OVER-T\\"
              end
end


def show_completed
         @final_jpgs =  rio('W:\\AUTOMATION_DATABASE\\AUTOMATED_ITEM_SPECSHEETS\\').files['*.png']

end

def update_items_listing
#  why_update_items_listing
          developer_stdout
#         @items =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', params[:current_category_id]  ]  , :order => 'ItemLookupCode'
            startup_item_variables
              render(:update) { |page|
                       if params[:search_type_name] == 'search_item_details'
                            page.replace_html 'designer_items_listing'  , :partial => 'designer/items' , :locals => { :params => params  }

                        elsif params[:search_type_name] == 'search_sales_details'
                            page.replace_html 'designer_items_listing'  , :partial => 'designer/sales' , :locals => { :params => params  }
                      elsif params[:search_type_name] == 'search_derivative_details'
                            page.replace_html 'designer_items_listing'  , :partial => 'designer/derivatives' , :locals => { :params => params  }
                      elsif params[:search_type_name] == 'search_clone_item_types'
                            page.replace_html 'designer_items_listing'  , :partial => 'designer/clone_item_types' , :locals => { :params => params  }
                       else
                            page.replace_html 'designer_items_listing'  , :partial => 'designer/items' , :locals => { :params => params  }
                       end
              }
end



  def startup_item_variables
#              $stdout.puts " params[:derivative_details]: " +  params[:derivative_details].to_s
             @items_requiring_production = Set.new
#              @website =     Website.find 3     #Website.current_website(request.env["HTTP_HOST"])   # Website.find 3
              @departments_for_department_select = @website.designer_departments
              @production_category_ids = [ 682 ]
              @items = Item.find_all_by_category_id( params[:current_category_id] || [  682, 18 ] )
               itemlookupcodes_as_set
               ###########################################################################################
              original_psds
              ###########################################################################################
              original_pngs
              ###########################################################################################
              #                                   separations
              ###########################################################################################
              specsheet_pngs
              ############################################################################################
#              thumbnail_pngs
              ###########################################################################################
              original_psds
              ###########################################################################################
              production_jpgs
              ###########################################################################################
  end

def developer_stdout
              $stdout.puts " BEGIN REQUEST ------------------------------------- "
              $stdout.puts " referring_action: " +  referring_action.to_s
              $stdout.puts " params " +  params.inspect.to_s
              $stdout.puts " params[:derivative_details].inspect: " +  params[:derivative_details].inspect.to_s
              $stdout.puts " END REQUEST ------------------------------------- "
end  

  def thumbnail_pngs
                        @thumbnail_pngs =  rio('C:\\Users\\Rhett Barber\\rails\\barbersystem_three\\public\\images\\designer_item_thumbnails\\').files['11085-*.png']
                        @thumbnail_zero_png_filenames_no_extension = Set.new
                        @thumbnail_one_png_filenames_no_extension = Set.new
                        @thumbnail_pngs.each do |destination_png|
                                    @thumbnail_zero_png_filenames_no_extension.add(destination_png.filename.gsub(/-0.png/, '').gsub(/.png/, '').to_s    )
                                    @thumbnail_one_png_filenames_no_extension.add(destination_png.filename.gsub(/-1.png/, '').gsub(/.png/, '').to_s    )
                                    @thumbnail_both_png_filenames_no_extension = @thumbnail_one_png_filenames_no_extension.intersection(@thumbnail_zero_png_filenames_no_extension)
                        end
                        @missing_thumbnail_pngs = @item_picturenames_no_extension -  @thumbnail_both_png_filenames_no_extension
  end



def itemlookupcodes_as_set
                            unless @items
                                  itemlookupcodes_as_set_was_not_given_items
                            end
                            @item_picturenames_no_extension = Set.new
                            @items.each do |the_item|
                                         @item_picturenames_no_extension.add(the_item.ItemLookupCode   )
                                         if    @production_category_ids.include?( the_item.category_id )
                                              @items_requiring_production.add( the_item.ItemLookupCode   )
                                         end
                            end
end


  def original_psds
                            @original_psds =  rio('W:\\AUTOMATION_DATABASE\\ORIGINAL_PSD\\').files['11085-*.psd']
                            @original_psd_filenames = Set.new
                            @original_psd_filenames_no_extension = Set.new
                            @original_psds.each do |original_psd|
                                         @original_psd_filenames.add(original_psd.filename)
                                         @original_psd_filenames_no_extension.add(original_psd.filename.gsub(/.psd/, '').to_s   )
                             end
                             @missing_original_psds = @item_picturenames_no_extension -  @original_psd_filenames_no_extension # if @item_picturenames_no_extension and @original_psd_filenames_no_extension
  end


def specsheet_pngs
                        @specsheet_pngs =  rio('C:\\Users\\Rhett Barber\\rails\\barbersystem_three\\public\\images\\designer_item_specsheets\\').files['11085-*.png']
                        @specsheet_zero_png_filenames_no_extension = Set.new
                        @specsheet_one_png_filenames_no_extension = Set.new
                        @specsheet_pngs.each do |destination_png|
                                    @specsheet_zero_png_filenames_no_extension.add(destination_png.filename.gsub(/-0.png/, '').to_s    )
                                    @specsheet_one_png_filenames_no_extension.add(destination_png.filename.gsub(/-1.png/, '').to_s    )
                                    @specsheet_both_png_filenames_no_extension = @specsheet_one_png_filenames_no_extension.intersection(@specsheet_zero_png_filenames_no_extension)
                        end
                         @missing_specsheet_pngs = @item_picturenames_no_extension -  @specsheet_both_png_filenames_no_extension
end


def original_pngs
                            @original_pngs =  rio('W:\\AUTOMATION_DATABASE\\ORIGINAL_PNG\\').files['11085-*.png']
                            @original_png_filenames = Set.new
                            @original_png_filenames_no_extension = Set.new
                            @original_pngs.each do |original_png|
                                         @original_png_filenames.add(original_png.filename)
                                         @original_png_filenames_no_extension.add(original_png.filename.gsub(/.png/, '').to_s   )
                             end
                              @missing_original_pngs = @item_picturenames_no_extension -  @original_png_filenames_no_extension
end

def production_jpgs
                            @production_jpgs =  rio('W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\ALL-OVER-T\\').files['11085-*.jpg']
                            @production_zero_jpg_filenames_no_extension = Set.new
                            @production_one_jpg_filenames_no_extension = Set.new
                            @production_jpgs.each do |destination_jpg|
                                    @production_zero_jpg_filenames_no_extension.add(destination_jpg.filename.gsub(/-0.jpg/, '').to_s  )
                                    @production_one_jpg_filenames_no_extension.add(destination_jpg.filename.gsub(/-1.jpg/, '').to_s  )
                                    @production_both_jpg_filenames_no_extension = @production_zero_jpg_filenames_no_extension.intersection(@production_one_jpg_filenames_no_extension)
                              end
                              @missing_production_jpgs =  @item_picturenames_no_extension -  @production_both_jpg_filenames_no_extension
end



def update_items_listing_alternate
         @items =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', params[:current_category_id]  ]  , :order => 'ItemLookupCode'

         if  params[:page]
           params_page_exists
              render(:update) { |page|
                       page.replace_html 'designer_items_listing'  , :partial => 'designer/designer_items' , :object => @items, :locals => { :choice_type => 'design'  }
              }
         else
              render(:update) { |page|
                       page.replace_html 'designer_items_listing'  , :partial => 'designer/designer_items'
              }
         end
end


def designer_item_search
      ## @website_items and the others are cached collections of all items for each website created at: lib/startup_browsing - startup_specific_items
      @items = Item.where("ItemLookupCode = ?" ,  params[:item_keywords]   ).all
      @items = @items.paginate(  :per_page => @@category_items_per_page, :page => params[:page] )
      @items_background = @items
      @items_front = @items
      @items_back = @items
      @items_shirt_style = @items
      render(:update) { |page|
               page.replace_html 'designer_items_listing'  , :partial => 'designer/designer_items' , :object => @items, :locals => { :choice_type =>  params[:choice_type] }
      }
      #render :partial => "specsheet_advanced/category_items" ,:layout => 'none', :object => @items , :locals => { :choice_type =>  params[:choice_type] }
end



def create_thumbnails
    rio('W:\\AUTOMATION_DATABASE\\AUTOMATED_ITEM_SPECSHEETS\\').files['*.jpg'].each do |oj|
#         if @incomplete_designs.include?(oj.basename)
              if oj.filename.to_s.split(' ').size <= 1
#                  system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -fill white -draw "rectangle 0,3000 1500,9000" -draw "rectangle 7300,3000 10300,9000" -draw "rectangle 16000,3000 17600,9000" -crop 8800  -flop W:\AUTOMATION_DATABASE\FINISHED_PRODUCTION_JPGS\\' + oj.filename  )
#                  system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328  -crop 425  W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\' + oj.filename  )
#                   system(   'convert W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\' + oj.filename + '.jpg -geometry 75 W:\AUTOMATION_DATABASE\FINISHED_WEBSITE_ITEM_THUMBNAILS\\' + oj.filename + '.jpg' )
                   system( 'convert W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\'  + oj.filename + '  -geometry 75 W:\AUTOMATION_DATABASE\FINISHED_WEBSITE_ITEM_THUMBNAILS\\' +  oj.filename )
              end
#        end
    end
    redirect_to :controller => 'designer',  :action => "index"
end


def complete_selected_incomplete
  convert_to_jpggggg
  @original_pngs.each do |oj|
         if @incomplete_designs.include?(oj.basename)
              if oj.filename.to_s.split(' ').size <= 1
                  system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -fill white -draw "rectangle 0,3000 1500,9000" -draw "rectangle 7300,3000 10300,9000" -draw "rectangle 16000,3000 17600,9000" -crop 8800  -flop W:\AUTOMATION_DATABASE\FINISHED_PRODUCTION_JPGS\\' + oj.filename  )
                  system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328  -crop 425  W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\' + oj.filename  )
              end
        end
    end
    redirect_to :controller => 'designer',  :action => "index"
end




def request_separator_update_jpgs
#      system( 'putty -ssh -pw SCANNER artist_one@192.168.0.14 -m ".ssh/make_source_jpgs.sh"'  )
      @system_response = []
      @system_response << `cd C:/Users/Rhett Barber && putty -ssh -pw SCANNER artist_one@192.168.0.14 -m ".ssh/make_source_jpgs.sh`
      @system_response << "New source jpgs requested from the Separator. Refresh this page after giving some time to create the Source Jpgs"
      flash[:notice] = @system_response
      redirect_to :back
end













###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################


#  def legacy_item_thumbnails
#                            @legacy_item_thumbnails =   rio('C:\\Users\\Rhett Barber\\rails\\barbersystem_three\\public\\images\\item_thumbnails\\').files['*.g']
#                            @legacy_item_thumbnail_filenames = Set.new
#                            @legacy_item_thumbnail_filenames_no_extension = Set.new
#                            @legacy_item_thumbnails.each do |legacy_item_thumbnail|
#                                         @legacy_item_thumbnail_filenames.add(legacy_item_thumbnail.filename)
#                                         @legacy_item_thumbnail_filenames_no_extension.add(legacy_item_thumbnail.filename.gsub(/.psd/, '').to_s   )
#                             end
#                             @missing_legacy_item_thumbnails = @item_picturenames_no_extension -  @legacy_item_thumbnail_filenames_no_extension # if @item_picturenames_no_extension and @legacy_item_thumbnail_filenames_no_extension
#  end


# #### DANGEROUS METHOD, MUST BE WHITELISTED
# #### DANGEROUS METHOD, MUST BE WHITELISTED
#def show  #### DANGEROUS METHOD, MUST BE WHITELISTED
#          send_file "W:\\AUTOMATION_DATABASE\\AUTOMATED_ITEM_SPECSHEETS\\#{params[:filename]}.jpg", :type => 'image/jpeg', :disposition => 'inline'
##           send_file "W:\\AUTOMATION_DATABASE\\AUTOMATED_ITEM_SPECSHEETS\\11085-SKULL-PISTOLS-0.jpg", :type => 'image/jpeg', :disposition => 'inline'
#end


#def separations
#                            @separations =  rio('W:\\AUTOMATION_DATABASE\\SEPARATION\\').files['*.psd']
#                            @separation_filenames = Set.new
#                            @separation_filenames_no_extension = Set.new
#                            @separations.each do |separation|
#                                         @separation_filenames.add(separation.filename)
#                                         @separation_filenames_no_extension.add(separation.filename.gsub(/.psd/, '').to_s   )
#                             end
#                             @missing_separation = @item_picturenames_no_extension -  @separation_filenames_no_extension
#end


#     if referring_action.to_s == 'designer'
#       xx
#              @items = Item.where("department_id in (?)", @website.default_design_department_ids.split(/,/)   )
#    else
#              @items = Item.find_all_by_category_id( params[:current_category_id] || [  682, 18 ] )
#    end
#
#    @website_default_design_department_ids = [ @website.default_design_department_ids, 42, 38 ]
#    @departments = @website.default_design_departments
# @departments = Department.where( "department_id in (?)", ['42','38'   ]  )

#def complete_selected_incomplete
#  convert_to_jpggggg
#  @original_pngs.each do |oj|
#         if @incomplete_designs.include?(oj.basename)
#              if oj.filename.to_s.split(' ').size <= 1
#                  system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -fill white -draw "rectangle 0,3000 1500,9000" -draw "rectangle 7300,3000 10300,9000" -draw "rectangle 16000,3000 17600,9000" -crop 8800  -flop W:\AUTOMATION_DATABASE\FINISHED_PRODUCTION_JPGS\\' + oj.filename  )
#                  system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328  -crop 425  W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\' + oj.filename  )
#              end
#        end
#    end
#    redirect_to :controller => 'designer',  :action => "index"
#end

#def update_items_listing_old
##          params[:page] = 1
#         @items =  Item.paginate :per_page => @@category_items_per_page, :page => params[:page],  :conditions => ['category_id like ?', params[:current_category_id]  ]  , :order => 'ItemLookupCode'
#
#         if  params[:page]
#           params_exist
#              render(:update) { |page|
#                       page.replace_html 'designer_items_listing'  , :partial => 'designer/designer_items' , :object => @items, :locals => { :choice_type => 'design'  }
#              }
#         else
#                                   render  :partial => 'designer/designer_items'
#         end
#end


#      @items = Item.find_all_by_department_id( ['35']  )
#      @items = Item.includes(:item_class).limit(20)
#      @items = Item.limit(20)
#          @items = FMCache.read  'state_calculation_browse'   unless cache_on? == false
#          if @items
#                $stdout.puts "ALREADY @ITEMS"
#          else
#                  @state_calculation_browse = '3434'   # Hash.new(  Website.current_website(request.env["HTTP_HOST"]).name + '_designs' )
#                  @items = Item.item_class_included
#        #          @parameters  << 'browse...'
#                   # DYNAMIC DELEGATOR...
#                FMCache.write 'state_calculation_browse', @items    unless cache_on? == false
#          end

#                  @items = Item.item_class_included

#          @items = Item.find_all_by_category_id(  682 )




#def startup_variables
#        @original_psds =  rio('W:\\AUTOMATION_DATABASE\\ORIGINAL_PSD\\').files['*.psd']
#                  @original_psd_filenames = Set.new
#                  @original_psd_filenames_no_extension = Set.new
#                  @original_psds.each do |original_psd|
#                          @original_psd_filenames.add(original_psd.filename)
#                          @original_psd_filenames_no_extension.add(original_psd.filename.gsub(/.psd/, '') )
#                   end
#          @original_pngs =  rio('W:\\AUTOMATION_DATABASE\\ORIGINAL_PNG\\').files['*.png']
#          @original_png_filenames = Set.new
#          @original_png_filenames_no_extension = Set.new
#          @original_pngs.each do |original_png|
#                       @original_png_filenames.add(original_png.filename)
#                       @original_png_filenames_no_extension.add(original_png.filename.gsub(/.png/, '')   )
#
#               end
#          @destination_production_pngs =  rio('W:\\AUTOMATION_DATABASE\\FINISHED_PRODUCTION_JPGS\\').files['*.png']
#          @destination_production_zero_png_filenames_no_extension = Set.new
#          @destination_production_one_png_filenames_no_extension = Set.new
#          @destination_production_pngs.each do |destination_png|
#                      @destination_production_zero_png_filenames_no_extension.add(destination_png.filename.gsub(/-0.png/, '')  )
#                      @destination_production_one_png_filenames_no_extension.add(destination_png.filename.gsub(/-1.png/, '')  )
#                      @destination_production_both_png_filenames_no_extension = @destination_production_zero_png_filenames_no_extension.intersection(@destination_production_one_png_filenames_no_extension)
#          end
#
#          @destination_item_specsheet_pngs =  rio('W:\\AUTOMATION_DATABASE\\AUTOMATED_ITEM_SPECSHEETS\\').files['*.png']
#          @destination_item_specsheet_zero_png_filenames_no_extension = Set.new
#          @destination_item_specsheet_one_png_filenames_no_extension = Set.new
#          @destination_item_specsheet_pngs.each do |destination_png|
#                      @destination_item_specsheet_zero_png_filenames_no_extension.add(destination_png.filename.gsub(/-0.png/, '')    )
#                       @destination_item_specsheet_one_png_filenames_no_extension.add(destination_png.filename.gsub(/-1.png/, '')    )
#                       @destination_item_specsheet_both_png_filenames_no_extension = @destination_item_specsheet_one_png_filenames_no_extension.intersection(@destination_item_specsheet_zero_png_filenames_no_extension)
#          end
#          @unfinished_original_pngs = @original_psd_filenames_no_extension.difference(@original_png_filenames_no_extension)
#          @finished_original_pngs =  @original_psd_filenames_no_extension.intersection(@original_png_filenames_no_extension)
#          if @destination_item_specsheet_both_png_filenames_no_extension
#              @completed_item_specsheets = @destination_item_specsheet_both_png_filenames_no_extension.intersection(@original_png_filenames_no_extension)
#          else
#              @completed_item_specsheets =  @original_png_filenames_no_extension
#          end
#          @incomplete_item_specsheets = @original_png_filenames_no_extension.difference(@completed_item_specsheets)
#          if @destination_production_both_png_filenames_no_extension
#               @available_production_pngs = @destination_production_both_png_filenames_no_extension.intersection(@original_png_filenames_no_extension)
#          else
#               @available_production_pngs = @original_png_filenames_no_extension
#          end
#           @unavailable_production_pngs = @original_png_filenames_no_extension.difference(@available_production_pngs)
#           @incomplete_designs = @unavailable_production_pngs.merge(@unfinished_original_pngs).merge(@incomplete_item_specsheets)
##           @incomplete_all_over = @incomplete_designs.intersection(@all_over_designs_no_extension)
#
#end


#def items_with_no_file
#end



#def complete_selected_incomplete_off
#  @original_pngs.each do |oj|
#         if @incomplete_item_specsheets.include?(oj.filename)
#              if oj.filename.to_s.split(' ').size <= 1
#                  system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -fill white -draw "rectangle 0,3000 1500,9000" -draw "rectangle 7300,3000 10300,9000" -draw "rectangle 16000,3000 17600,9000" -crop 8800  W:\AUTOMATION_DATABASE\FINISHED_PRODUCTION_JPGS\\' + oj.filename  )
#                  system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328  -crop 425  W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\' + oj.filename  )
#              end
#        end
#    end
#    redirect_to :controller => 'sublimation_shirt',  :action => "index"
#end



#                  system(   'convert W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\'  +  oj.filename +    '-flop  W:\AUTOMATION_DATABASE\AUTOMATED_ITEM_SPECSHEETS\\' + oj.filename  )


#                  system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328  W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename  )
#                 system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -crop 8800  W:\AUTOMATION_DATABASE\FINISHED_PRODUCTION_JPGS\\' + oj.filename  )   #WORKS WITH NO WHITE SQUARES
#
#def complete_selected_incomplete
#  @original_pngs.each do |oj|
#         if @incomplete_item_specsheets.include?(oj.filename)
#                system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328  W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename  )
#                system(   'convert W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename +    ' -crop 425  W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename  )
#        end
#    end
#    redirect_to :action => "incomplete_item_specsheets"
#end


#  point           x,y
#  line            x0,y0 x1,y1
#  rectangle       x0,y0 x1,y1
#  roundRectangle  x0,y0 x1,y1 wc,hc
#  arc             x0,y0 x1,y1 a0,a1
#  ellipse         x0,y0 rx,ry a0,a1
#  circle          x0,y0 x1,y1
#  polyline        x0,y0  ...  xn,yn
#  polygon         x0,y0  ...  xn,yn
#  bezier          x0,y0  ...  xn,yn
#  path            path specification
#  image           operator x0,y0 w,h filename
#
#  convert W:\AUTOMATION_DATABASE\ORIGINAL_PNG\11085-BORDER-PATROL.jpg  -fill white -draw "rectangle 0,3000 1500,9000" -draw "rectangle 16000,3000 17600,9000" W:\AUTOMATION_DATABASE\FINISHED_PRODUCTION_JPGS\TESTING-11085-BORDER-PATROL.jpg





#def index_old
#  @original_pngs =  rio('W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\').files['*.jpg']
#  @original_png_filenames = Set.new
#  @original_pngs.each do |original_png|
#      @original_png_filenames.add(original_png.filename)
#  end
#  @destination_jpgs =  rio('W:\\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\').files['*.jpg']
#  @destination_jpg_filenames = Set.new
#  @destination_jpgs.each do |destination_jpg|
#      @destination_jpg_filenames.add(destination_jpg.filename)
#  end
#  @completed_item_specsheets = @destination_jpg_filenames.intersection(@original_png_filenames)
#  @incomplete_item_specsheets = @original_png_filenames.difference(@completed_item_specsheets)
#  @original_pngs.each do |oj|
#       if @incomplete_item_specsheets.include?(oj.filename)
#                system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328  W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename  )
#                system(   'convert W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename +    ' -crop 425  W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename  )
#     end
#  end
#end


#def index_test
#          output = `ls`
#        render :text =>  output
#end
#
#
#def show
#          send_file "W:\\AUTOMATION_DATABASE\\ITEM_SPECSHEETS\\#{params[:filename]}.jpg", :type => 'image/jpeg', :disposition => 'inline'
#  end


#         @missing_images    = @original_pngs - @destination_jpgs
# render :text => @missing_images
#        render :text => @original_pngs     #.to_set.intersection(@destination_jpgs.to_set).to_a.inspect
#         render :text => @original_pngs.to_set.intersection(@destination_jpgs.to_set).to_a.inspect



#  def index_old
#             flash[:notice] = ['nothing']
#            @original_pngs =  rio('W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\').files['*.jpg']
#            @destination_directory = 'W:\\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\'
#            @original_pngs.each do |oj|
#                     if   rio(  'W:\\AUTOMATION_DATABASE\\ITEM_SPECSHEETS\\' + oj.basename + '-0.jpg' ).exist?
#                            flash[:notice] <<  '    '  +  oj.basename + '-0.jpg EXISTS!  '
#                     else
##                            logger.warn    "convert 'W:\\AUTOMATION_DATABASE\\ORIGINAL_PNG\\#{oj.filename}' -geometry x328 -crop 425 W:\\AUTOMATION_DATABASE\\ITEM_SPECSHEETS\\#{oj.filename}"
##                              system(  "convert 'W:\\AUTOMATION_DATABASE\\ORIGINAL_PNG\\#{oj.filename}' -geometry x328 -crop 425 W:\\AUTOMATION_DATABASE\\ITEM_SPECSHEETS\\#{oj.filename}"  )
##                               system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328 -crop 425 W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\11085-I-HUNT-ON-THE-FIRST-DATE.jpg'  )  # THIS WORKS !!
##                              system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328 -crop 425 W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\11085-I-HUNT-ON-THE-FIRST-DATE.jpg'  )
##                              system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328 -crop 425 W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename  )
##                              system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328 -crop 425x328+425+0  W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename  )
##      system(   "convert W:\AUTOMATION_DATABASE\ORIGINAL_PSD\11085-PEACE-LOVE-SOFTBALL.psd  -geometry 17600x6800  W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\11085-PEACE-LOVE-SOFTBALL.jpg"  )  #converting full size .psd is too slow
#
#                        system(   'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename +    ' -geometry x328  W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename  )
#                        system(   'convert W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename +    ' -crop 425  W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\' + oj.filename  )
#
#
#                     end
#             end
##             render :text => flash[:notice]
#  end


#  def index
#            @original_pngs =  rio('W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\').files['*.jpg']
#            @destination_directory = 'W:\\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\'
#                     if   rio(  'C:/test/pattern.jpg' ).exist?
#                                   send_data(  'C:/test/pattern.jpg' , {:disposition => 'inline', :type => 'image/jpeg'}   )
#                     end
#  end

#            @original_pngs.each do |oj|
#                 if   rio(  'W:\\AUTOMATION_DATABASE\\ITEM_SPECSHEETS\\' + oj.basename + '-0.jpg' ).exist?
#                               send_data(  'W:\\AUTOMATION_DATABASE\\ITEM_SPECSHEETS\\' + oj.basename + '-0.jpg' , {:disposition => 'inline', :type => 'image/jpeg'}   )
#                 end
#          end
#
#                          <tr><td> <%=     oj.filename   %></td> </tr>
#                       <tr title#="ImageMagic Command"><td style="display: none;"> <%=   'convert ' +  oj.dirname  + '\\' +  oj.filename  + ' -geometry x328 -crop 425 ' +  @destination_directory + oj.filename  %></td></tr>
#                       <tr title#="Thumbnail File Name">  <td style="display: none;"> <%=  '/images/production_thumbnails/' + oj.filename  %></td></tr>
#                        <tr title#="Thumbnail File Name">  <td style="display: none;"> <%=  '/images/production_thumbnails/' + oj.filename  %></td></tr>




#               <%   if    rio( RIO.cwd +  'W:\\AUTOMATION_DATABASE\\ITEM_SPECSHEETS\\' + oj.basename + '-0.jpg' ).exist? %>
#                        <tr#><td>its there</td> </tr>
#               <% else %>
#
#                    system(  'convert W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\' +  oj.filename  +    ' -geometry x328 -crop 425 W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\' + oj.filename} ' ) <br/>
#
#
#
#                <% end  %>



#  def process_un


#cmd3 =  'convert W:\AUTOMATION_DATABASE\ORIGINAL_PNG\11085-I-HUNT-ON-THE-FIRST-DATE.jpg -geometry x328 -crop 425 W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\11085-I-HUNT-ON-THE-FIRST-DATE.jpg'
#system(cmd3)


#Open3.popen3(cmd3){ |io_in, io_out, io_err|
#   error = io_err.read
#   if error && error.length > 0
#       render :text => 'Error: ' + error
#      break
#   else
#      output = io_out.read
#      render :text =>  'Output: ' + output if output
#   end
#}
#    Open3.popen3( 'convert W:\AUTOMATION_DATABASE\ORIGINAL_PNG\11085-I-HUNT-ON-THE-FIRST-DATE.jpg -geometry x328 -crop 425 W:\AUTOMATION_DATABASE\ITEM_SPECSHEETS\11085-I-HUNT-ON-THE-FIRST-DATE.jpg' )


#             @original_pngs =  rio('W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\').files['*.jpg']
#             @destination_directory = 'W:\\AUTOMATION_DATABASE\ITEM_SPECSHEETS\\'

#            cat = ImageList.new 'W:\\AUTOMATION_DATABASE\ORIGINAL_PNG\\11085-I-HUNT-ON-THE-FIRST-DATE.jpg'
#            cat.resize( 850  , 352 )
#            cat.write('W:\\AUTOMATION_DATABASE\\ITEM_SPECSHEETS\\11085-I-HUNT-ON-THE-FIRST-DATE.jpg')
#             @original_pngs.each do |oj|





#                   @whois = Thread.new { 'convert ' +  oj.dirname  + '\\' +  oj.filename  + ' -geometry x328 -crop 425 ' +  @destination_directory + oj.filename }
#                      @cmd =  'convert ' +  oj.dirname  + '\\' +  oj.filename  + ' -geometry x328 -crop 425 ' +  @destination_directory + oj.filename
#                      $stdout.puts @cmd

#             end
#        @whois = Thread.new {  "convert W:\\AUTOMATION_DATABASE\\ORIGINAL_PNG\\11085-I-HUNT-ON-THE-FIRST-DATE.jpg -geometry x328 -crop 425 W:\\AUTOMATION_DATABASE\\ITEM_SPECSHEETS\\11085-I-HUNT-ON-THE-FIRST-DATE.jpg" }
#render :text => 'stuff'
#              puts l while l = stdout.gets
#              puts l while l = stderr.gets

#  end




end
