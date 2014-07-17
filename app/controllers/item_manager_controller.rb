class ItemManagerController < ApplicationController
before_filter :redirect_unless_admin


def rename_using_next_core_and_alias_the_old_item
        @item = Item.find params[:item_id]
        @item_new_number_made_from_last_core_value = @item.new_number_made_from_last_core_value
        @rp_clone_item_id = CloneItemType.find_by_name("RP-TRAN").original_item_id
        @clone_item_to_copy = Item.find   @rp_clone_item_id
        @new_rp_core_item = @clone_item_to_copy.clone
        @new_rp_core_item.Description = @item.Description
        @old_item_lookup_code = @item.ItemLookupCode
        @item.ItemLookupCode =     @item.new_number_made_from_last_core_value
        @item.save
        @alias = Alias.new
        @alias.Alias = @old_item_lookup_code
        @alias.save
        redirect_to request.referer
end




 def find_clone_item_type_categories
          @clone_item_type_categories = Category.where('clone_item_type_id > ?', 0)

 end

  def ajax_choose_item_type
            @category = Category.find params[:category_id]
            @category.clone_item_type_id = params[:clone_item_type_id]
             @category.save
             find_clone_item_type_categories
            @items = Item.where("category_id = ?", params[:category_id] ).order("ItemLookupCode ASC").limit('10').all
              find_missing
                                if @clone_item_type_categories.include?(@category)
                                           render :partial => 'item_manager/item_manager_items' , :locals => { :params => params  }
                                else
                                             render :partial => 'item_manager/item_manager_unmanaged_items' , :locals => { :params => params  }
                                end

#              render(:update) { |page|
#                                if @clone_item_type_categories.include?(@category)
#                                           page.replace_html 'item_manager_items'  , :partial => 'item_manager/item_manager_items' , :locals => { :params => params  }
#                                else
#                                             page.replace_html 'item_manager_items'  , :partial => 'item_manager/item_manager_unmanaged_items' , :locals => { :params => params  }
#                                end
#              }
  end




def update_items_listing
              current_website
              find_clone_item_type_categories
              @category = Category.find  params[:current_category_id]


              @items = Item.where("category_id = ?", params[:current_category_id] ).order("ItemLookupCode ASC").limit('10').all
              find_missing
              render(:update) { |page|
                                if @clone_item_type_categories.include?(@category)
                                           page.replace_html 'item_manager_items'  , :partial => 'item_manager/item_manager_items' , :locals => { :params => params  }
                                else
                                             page.replace_html 'item_manager_items'  , :partial => 'item_manager/item_manager_unmanaged_items' , :locals => { :params => params  }
                                end
              }
end


def item_search
      current_website
       if params[:item_keywords] != ""
                    @items =   Item.where(" ItemLookupCode like ? or Description like ?",  "%#{params[:item_keywords]}%","%#{params[:item_keywords]}%"   ).where("department_id in (?)", @website.default_design_department_ids.split(/,/)  ).limit('20')
      end
                  find_missing
                  render  :partial => 'item_manager/item_manager_items'   #, :object => @items
end


def linked_index
        current_website
        @initial_items = Item.where("department_id in (?)", @website.default_design_department_ids.split(/,/) ).order("ItemLookupCode ASC")   #.limit('100')
        @item_ids_with_linked_derivatives = []
        @initial_items.each do |the_item|
                    CloneItemType.all.each do | the_clone_item_type|
                                if   ['.gif', '.jpg', '.png'].include?( the_clone_item_type.production_extension )
                                          if   File.file?( 'W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\' + the_clone_item_type.name + '\\' + the_clone_item_type.prefix_code + '-' +   the_item.ItemLookupCode.gsub('L', '')  + the_clone_item_type.production_extension )
                                                 @item_ids_with_linked_derivatives << the_item.id
                                          end
                                end
                    end
        end
        $stdout.puts "@item_ids_with_linked_derivatives: " + @item_ids_with_linked_derivatives.inspect.to_s
        @items = Item.where( "id in (?)", @item_ids_with_linked_derivatives )
end


def show_thumbnail  #### DANGEROUS METHOD, MUST BE WHITELISTED
        send_file "W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\#{params[:filename]}.jpg", :type => 'image/jpeg', :disposition => 'inline'
end

  def index
               current_website
#                 @items = Item.where( "items.category_id = ?", params[:current_category_id] || 52  ).order("ItemLookupCode ASC").limit('10')
          if params[:itemlookupcode]
                @items = Item.where("ItemLookupCode = ?",  params[:itemlookupcode] )    #includes(:item_class ,:clone_item_request  ).
          elsif   params[:search_type_name] == 'show_all'
                @items = Item.includes('category','department','aliasings','item_class_component', 'item_class', 'item_sales_this_year', 'item_sales_last_year','clone_item_requests'    ).where("department_id in (?)", @website.default_design_department_ids.split(/,/) ).order("ItemLookupCode ASC")
          else
#                 @items = Item.includes('category','department','aliasings','item_class_component', 'item_class', 'item_sales_this_year', 'item_sales_last_year','clone_item_requests'    ).where("department_id in (?)", @website.default_design_department_ids.split(/,/) ).order("ItemLookupCode ASC").limit('10')
          end
#               find_missing
  end


  def find_missing
              @missing_original_psd = Set.new
              @missing_original_png = Set.new
              @missing_separation = Set.new
              @missing_specsheet = Set.new
               @missing_thumbnail = Set.new
              @items.each do |item|
                begin
                      if item.ItemLookupCode

                        $stdout.puts  'W:\\AUTOMATION_DATABASE\\ORIGINAL_PSD\\' + item.ItemLookupCode.to_s + '.psd '

                              @missing_original_psd.add( item.ItemLookupCode   ) unless File.file?(  'W:\\AUTOMATION_DATABASE\\ORIGINAL_PSD\\' + item.ItemLookupCode.to_s + '.psd ' )
                              @missing_original_png.add( item.ItemLookupCode   ) unless File.file?(  'W:\\AUTOMATION_DATABASE\\ORIGINAL_PNG\\' + item.ItemLookupCode + '.png ' )
                              @missing_separation.add( item.ItemLookupCode   ) unless File.file?(  'W:\\AUTOMATION_DATABASE\\SEPARATION\\' + item.ItemLookupCode + '.psd ' )
                              @missing_specsheet.add( item.ItemLookupCode   ) unless File.file?(  'C:\\Users\\Rhett Barber\\rails\\barbersystem_three\\public\\images\\designer_item_specsheets\\' + item.ItemLookupCode + '.png ' )
                              @missing_thumbnail.add( item.ItemLookupCode   ) unless File.file?(  'C:\\Users\\Rhett Barber\\rails\\barbersystem_three\\public\\images\\designer_item_thumbnails\\' + item.ItemLookupCode + '.png ' )
                      end
                rescue
                    $stdout.puts "item error"
                end
              end
  end



def item_details
            @item = Item.where("id = ?", params[:item_id]  ).first
            @items = Item.where("id = ?", params[:item_id]  ).all
            find_missing
end



  def request_clone_item_creation
     @clone_item_type = CloneItemType.find params[:clone_item_type_id]
     @item = Item.find( :first, :conditions => [ "id = ?",  params[:item_id ] ] )
     @the_clone_item_request = CloneItemRequest.where([ "clone_item_type_id = ? and item_id = ?", params[:clone_item_type_id] , params[:item_id ]  ] ).first
     if @the_clone_item_request
                @the_clone_item_request.delete
                  @rms_status_color =  '#A00000'
                  @file_status_color =  '#A00000'
                  render :partial => 'item_manager/item_clone', :locals => {:item => @item, :clone_item_type => @clone_item_type  }
     else

                @clone_item_request = CloneItemRequest.new
                @clone_item_request.clone_item_type_id = params[:clone_item_type_id]
                @clone_item_request.item_id =  params[:item_id ]
                  if @clone_item_request.save
                                 rms_status = Item.exists?([ "ItemLookupCode = ?", @clone_item_type.prefix_code + '-'  +  @item.ItemLookupCode.gsub('L', '')  ] ) or ItemClass.exists?([ "ItemLookupCode = ?", @clone_item_type.prefix_code + '-'  +  @item.ItemLookupCode.gsub('L', '')  ] )
                                 if  rms_status == true
                                      @rms_status_color =  'green'
                                 else
                                      @rms_status_color =  'orange'
                                 end

                                 file_status =   File.file?( 'W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\' + @clone_item_type.name + '\\' + @clone_item_type.prefix_code + '-' +   @item.ItemLookupCode.gsub('L', '')  + @clone_item_type.production_extension )
                                 if file_status == true
                                      @file_status_color =  'green'
                                 else
                                      @file_status_color =  'orange'
                                 end
                                render :partial => 'item_manager/item_clone', :locals => {:item => @item, :clone_item_type => @clone_item_type  }

                  else
                               render :partial => 'item_manager/item_clone_save_failed', :locals => {:item => @item, :clone_item_type => @clone_item_type  }
                  end
       end
  end

  def item_search_with_rank(items_to_search_and_rank, keywords)
				logger.debug "-------------------------------------item_search_with_rank BEGIN "
        $stdout.puts "keywords: " + keywords
			  keywords   =  keywords.split(" ").collect {|c| "#{c.downcase}"}
        @items_with_rank = []
        @items_to_search_and_rank = items_to_search_and_rank
        if @items_to_search_and_rank
        		logger.debug "-------------------------------------keywords: #{keywords} "
						logger.debug "-------------------------------------@items_to_search_and_rank.size: #{@items_to_search_and_rank.size} "

				else
						logger.debug "-------------------------------------keywords: #{keywords} "
						logger.debug "-------------------------------------@items_to_search_and_rank.size is NIL "
				end
        @items_to_search_and_rank.each do |item|
                  if item.category
                          ############################################################
#                            $stdout.puts "item_aliasings_set: " + item_aliasings_set.inspect
                            item_notes = item.Notes || ''
                            item_words_string = item.ItemLookupCode + ' ' +  item.Description.downcase + ' ' + item.category.Name.downcase + ' ' + item.number_only + ' ' + item_notes.downcase
                            item_words_array  = item_words_string.split.collect {|c| "#{c.downcase}"}
                             if item.aliasings
                                  item.aliasings.each do |al|
                                      item_words_array <<  al.Alias.downcase
                                  end
                            end
                            item_words_set    = item_words_array.to_set
                            ############################################################
                            keywords_set      = keywords.to_set
                            word_count = 0
                            keywords.each do  |kw|
                                matching_words = keywords_set.intersection(item_words_set)
#                                if matching_words.size > 0
#                                    $stdout.puts "matching_words: " + matching_words.inspect
#                                else
#                                       logger.debug "item_words_set because none match: " + item_words_set.inspect
#                                end
                                if matching_words.size > 0
                                  word_count = matching_words.size
                                end
                            end
                             item.SubDescription3 = word_count
                      if controller_name == "users"
                              @items_with_rank	<< item if item.SubDescription3 != 0
                      else
                              if  @acceptable_item_ids
                                      @items_with_rank	<< item if item.SubDescription3 != 0  && @acceptable_item_ids.include?(item.id)
                              else
                                       @items_with_rank	<< item if item.SubDescription3 != 0
                              end
                      end
                  end
          end
         @items_only_ranked_for_this_website_only = @items_with_rank.sort_by {|a| a.SubDescription3}.reverse
          @items = @items_only_ranked_for_this_website_only.first(50)
      logger.debug "-------------------------------------item_search_with_rank END "
end
############################################################################################################

#Item.find(:all,:conditions => ["department_id in (?)", @website.default_all_department_ids_with_generic ],:include => ['category','department','aliasings','item_class_component']

  #                  @items = Item.where(" department_id in (?) and ItemLookupCode like ? or Description like ?" , @website.default_design_department_ids.split(/,/), "%#{params[:item_keywords]}%","%#{params[:item_keywords]}%"  ).limit(30)

#                   @items =   Item.find(:all,:conditions => ["department_id in (?)  and ItemLookupCode like ? or Description like ?", @website.default_all_department_ids_with_generic  , "%#{params[:item_keywords]}%","%#{params[:item_keywords]}%"  ] ,:include => ['category','department','aliasings','item_class_component', 'item_class', 'item_sales_this_year', 'item_sales_last_year']  )


#          render :text => @items.inspect.to_s + params[:item_keywords]
            #      render(:update) { |page|
            #               page.replace_html 'item_manager_items'  , :partial => 'item_manager/item_manager_items' , :object => @items
            #      }

#               @items = Item.find_all_by_category_id( params[:current_category_id] || [  682, 18 ] )
#               @items = Item.find_all_by_category_id( [18,23, 25,31,54,59 ], :order => 'ItemLookupCode ASC'    )  #testing
#                 @items = Item.includes(:clone_items).where( "items.category_id = ?", 25  )     # view based
#$stdout.puts "W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\COASTER\\#{params[:filename]}.jpg"
# send_file "W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\COASTER\\17063-02.jpg", :type => 'image/jpeg', :disposition => 'inline'
#  send_file "W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\COASTER\\#{params[:filename]}", :type => 'image/jpeg', :disposition => 'inline'
#         send_file "#{params[:filename]}", :type => 'image/jpeg', :disposition => 'inline'
#          send_file "W:\\AUTOMATION_DATABASE\\PRODUCTION_FILES\\COOZIE\\17085-4965.jpg", :type => 'image/jpeg', :disposition => 'inline' #
#          send_file "W:\\AUTOMATION_DATABASE\\FINISHED_WEBSITE_ITEM_THUMBNAILS\\#{params[:filename]}.jpg", :type => 'image/jpeg', :disposition => 'inline'
#           send_file "W:\\AUTOMATION_DATABASE\\FINISHED_WEBSITE_ITEM_SPECSHEETS\\11085-SKULL-PISTOLS-0.jpg", :type => 'image/jpeg', :disposition => 'inline'

def item_search_long
      current_website
      if params[:search_type_name] == 'search_keywords'
              if params[:item_keywords] != ""

                         @website_designs = FMCache.read @website.name + '_designs'  unless cache_on? == false
                          if @website_designs
                              logger.info "-------------------------------------@website_designs found by cache"
                          else
                              @website_designs = Item.find(:all,:conditions => ["department_id in (?)", @website.default_design_department_ids.split(/,/) ],:include => ['category','aliasings', 'item_class', 'item_class_component', 'clone_item_requests'  ])
                              logger.info "-------------------------------------@website_designs NOT found by cache"
                              FMCache.write @website.name + '_designs', @website_designs, :expires_in => 227.minutes  unless cache_on? == false
                          end
                        item_search_with_rank( @website_designs , params[:item_keywords] )
              else
                        @items =   Item.where("department_id in (?) ", @website.default_all_department_ids_with_generic  ).includes(:category , :department, :aliasings, :item_class_component, :item_class, :item_sales_this_year, :item_sales_last_year, :clone_item_requests   ).limit('20')
              end
      elsif  params[:search_type_name] == 'show_all'
                   @items =   Item.includes(:category , :department, :aliasings, :item_class_component, :item_class, :item_sales_this_year, :item_sales_last_year, :clone_item_requests   ).where("department_id in (?)", @website.default_all_department_ids_with_generic     )
      else
                    @items =   Item.includes(:category , :department, :aliasings, :item_class_component, :item_class, :item_sales_this_year, :item_sales_last_year, :clone_item_requests   ).where("department_id in (?)  and ItemLookupCode like ? or Description like ?", @website.default_all_department_ids_with_generic  , "%#{params[:item_keywords]}%","%#{params[:item_keywords]}%"    ).limit('20')

      end
                  find_missing
                  render  :partial => 'item_manager/item_manager_items' , :object => @items
end



end
