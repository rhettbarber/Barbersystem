class SearchController < ApplicationController

  require  'listing_design'
  require  'listing_merchandise'



  before_filter :initialize_variables  , :only => [:website_search_items, :index,:scroll]
  #before_filter :website_search_items  , :only => [:index]
  skip_filter :verify_authenticity_token, :index


          #   http://192.168.0.125:1001/search/search_heritage_news?query=edgerton+banquet
############################################################################################################




def scroll
                   if   params[:department_id]
                                        logger.debug("department_id: " + params[:department_id].to_s )
                                       website_scroll_items_cache_string =     "scroll/variables_filtered_website_scroll_items_department_" + params[:department_id].to_s  + "_category_class_" +  @purchase_symbiote_item_category_category_class_id   +   "_singular_item_customer_" + @singular_item_customer.to_s   + "_week_" +  Website.week_number
                                        logger.debug "website_scroll_items_cache_string: " + website_scroll_items_cache_string
                                       ListingAll.new
                                        @product_search_results = false
                                       @product_search_results =  FMCache.read website_scroll_items_cache_string
                                       if @product_search_results
                                                                        logger.debug("@product_search_results.inspect: " + @product_search_results.inspect )
                                                                         logger.debug "CACHE FOUND SCROLL"
                                                                         logger.debug "CACHE FOUND SCROLL"
                                                                         @paginated_results  =  @product_search_results.to_a.paginate(:page => params[:page] || 1, :per_page => 8  )
                                                                         @designs = true
                                       else

                                                                          all_items_in_department_cache_string  =        "scroll/variables_all_items_in_department_" +    params[:department_id].to_s    +   "_singular_item_customer_" + @singular_item_customer.to_s        + "_week_" +  Website.week_number
                                                                          #FMCache.delete  all_items_in_department_cache_string
                                                                          @all_items_in_department = FMCache.read    all_items_in_department_cache_string

                                                                          if @all_items_in_department
                                                                                            logger.debug "CACHE FOUND @all_items_in_department"
                                                                                            logger.debug "CACHE FOUND @all_items_in_department"
                                                                                            logger.debug "CACHE FOUND @all_items_in_department"
                                                                                            logger.debug " @all_items_in_department"
                                                                                            logger.debug "@all_items_in_department.size: " + @all_items_in_department.size.to_s

                                                                          else
                                                                                          logger.debug "CACHE DID NOT FIND  @all_items_in_department"
                                                                                          logger.debug "CACHE DID NOT FIND  @all_items_in_department"
                                                                                            if  params[:department_id]  == '2'
                                                                                              params_and_generic_department_ids = [1,2]
                                                                                            elsif params[:department_id]  == '3'
                                                                                              params_and_generic_department_ids = [1,3]
                                                                                            elsif params[:department_id]  == '6'
                                                                                              params_and_generic_department_ids = [5,6]
                                                                                            elsif   params[:department_id]  == '9'
                                                                                              params_and_generic_department_ids = [5,9]
                                                                                            else
                                                                                              #ssssss
                                                                                              params_and_generic_department_ids = params[:department_id]
                                                                                            end


                                                                                          if params[:department_id] == "all_designs"
                                                                                                        @all_items_in_department  = ListingAll.order("category_name").where("department_id in (?)", @website.default_design_department_ids.split(/,/)     ).all
                                                                                          elsif  params[:department_id] == "all_items"

                                                                                                                     if @singular_item_customer == true
                                                                                                                                         logger.debug "@singular_item_customer == true"
                                                                                                                                        @department_ids_to_show = @website.default_non_blank_item_department_ids   #.split(/,/)
                                                                                                                     else
                                                                                                                                        logger.debug "@singular_item_customer NOT == true"
                                                                                                                                        @department_ids_to_show = @website.default_item_department_ids.split(/,/)
                                                                                                                     end
                                                                                                                    @all_items_in_department  = ListingAll.order("category_name").where("department_id in (?)",   @department_ids_to_show      ).all

                                                                                          else
                                                                                                        @all_items_in_department  = ListingAll.order("category_name").where("department_id in (?)", params_and_generic_department_ids     ).all
                                                                                           end

                                                                                            FMCache.write  all_items_in_department_cache_string   , @all_items_in_department   ,   :expires_in => 300.minutes
                                                                                              logger.debug "NOT @all_items_in_department"
                                                                                              logger.debug "NOT @all_items_in_department"
                                                                                              logger.debug "NOT @all_items_in_department"
                                                                          end

                                                                          #logger.debug("@limited_records.inspect: " + @limited_records.inspect)
                                                                          website_search_item_ids      =  @website.website_search_item_ids
                                                                          @product_search_results = Set.new
                                                                          already_seen_item_picturenames = Set.new
                                                                          already_seen_item_item_class = Set.new
                                                                          @all_items_in_department.each do |ar|
                                                                                        if ar.id
                                                                                                    if  ar.sublimation_status == 'sublimation_only' and @customer_array.PriceLevel < 2
                                                                                                                logger.warn "123456 skipping  sublimation_only and not wholesale customer"
                                                                                                    else
                                                                                                                  logger.debug   "------------------------------"+ ar.item_class_number
                                                                                                                  if  website_search_item_ids.split(',').include?( ar.id.to_s  )
                                                                                                                              if already_seen_item_picturenames.include?( ar.PictureName.to_s  )
                                                                                                                                                  logger.debug "SKIPPING ITEM because already used this picturname: " +  ar.PictureName.to_s
                                                                                                                              else
                                                                                                                                                    if already_seen_item_item_class.include?( ar.item_class_number  )
                                                                                                                                                                                                       logger.warn "SKIPPING ITEM already seen item already_seen_item_item_class."   +  ar.item_class_number
                                                                                                                                                    else
                                                                                                                                                                                                        #logger.warn "BEGIN ADDING_ITEM ###############################..."
                                                                                                                                                                                                        #logger.warn "PictureName: " + ar.PictureName    + "_Description: "  +  ar.Description
                                                                                                                                                                                                        #@product_search_results.add ar
                                                                                                                                                                                                        #already_seen_item_picturenames .add  ar.PictureName.to_s
                                                                                                                                                                                                        #already_seen_item_item_class .add  ar.item_class_number
                                                                                                                                                                                                        #logger.warn "END ADDING_ITEM  ###############################..."

                                                                                                                                                                                                        #if @incomplete_symbiont and  @purchase_symbiote_item.category.category_class.opposite_category_ids.include?( ar.category_id.to_s  )
                                                                                                                                                                                                        #                     logger.warn "BEGIN ADDING_ITEM ###############################..."
                                                                                                                                                                                                        #                      logger.warn "1234 adding this record.."
                                                                                                                                                                                                        #                      @product_search_results.add ar
                                                                                                                                                                                                        #                      already_seen_item_picturenames .add  ar.PictureName.to_s
                                                                                                                                                                                                        #                      already_seen_item_item_class .add  ar.item_class_number
                                                                                                                                                                                                        #                      logger.warn "END ADDING_ITEM  ###############################..."
                                                                                                                                                                                                        #else
                                                                                                                                                                                                        #                      logger.debug "1234  skiipped because not applicable opposite"
                                                                                                                                                                                                        #end
                                                                                                                                                                                                        if @incomplete_symbiont
                                                                                                                                                                                                                            if @purchase_symbiote_item.category.category_class.opposite_category_ids.split(',').include?( ar.category_id.to_s  )
                                                                                                                                                                                                                                              logger.warn "1234 adding this record.."
                                                                                                                                                                                                                                              logger.warn "@purchase_symbiote_item.category.category_class.opposite_category_ids.include?( ar.category_id.to_s  )"
                                                                                                                                                                                                                                              logger.warn "@purchase_symbiote_item.category.category_class.opposite_category_ids:" + @purchase_symbiote_item.category.category_class.opposite_category_ids.to_s
                                                                                                                                                                                                                                              logger.warn "ar.category_id.to_s: " + ar.category_id.to_s
                                                                                                                                                                                                                                              @product_search_results.add ar
                                                                                                                                                                                                                                              already_seen_item_picturenames .add  ar.PictureName.to_s
                                                                                                                                                                                                                                              already_seen_item_item_class .add  ar.item_class_number
                                                                                                                                                                                                                            else
                                                                                                                                                                                                                                             logger.debug "1234  skipping because it is not a compatible opposite"
                                                                                                                                                                                                                            end
                                                                                                                                                                                                        else
                                                                                                                                                                                                                            logger.warn "not @incomplete_symbiont.."
                                                                                                                                                                                                                            logger.warn "1234 adding this record.."
                                                                                                                                                                                                                            @product_search_results.add ar
                                                                                                                                                                                                                            already_seen_item_picturenames .add  ar.PictureName.to_s
                                                                                                                                                                                                                            already_seen_item_item_class .add  ar.item_class_number
                                                                                                                                                                                                          end


                                                                                                                                                    end
                                                                                                                              end
                                                                                                                  else
                                                                                                                             logger.warn "1234 skipping this item..not in website_search_item_ids.."
                                                                                                                  end
                                                                                                     end
                                                                                        else
                                                                                                   logger.warn "1234 skipping not ar"
                                                                                        end
                                                                          end
                                                                         logger.debug "@product_search_results.size: " +  @product_search_results.size.to_s
                                                                         logger.debug @product_search_results.inspect
                                                                       FMCache.write  website_scroll_items_cache_string ,    @product_search_results

                                                                        if  params[:page]
                                                                                            @paginated_results  =  @product_search_results.to_a.paginate(:page => params[:page], :per_page => 8  )
                                                                                             g = "g"
                                                                        else
                                                                                            logger.debug "need_page_params"
                                                                                            @paginated_results  =  @product_search_results.to_a.paginate(:page =>  1, :per_page => 8  )
                                                                          end

                                        end
                   else
                                        #no_department_id
                                        logger.debug "scroll page no params"
                    end
                   @designs = true
                    if request.xhr?
                      # respond to Ajax request
                      render  "scroll.js.erb"
                    else
                      # respond to normal request
                      render "scroll.erb"
                    end
 end
############################################################################################################
    def index
                                      website_search_items = false
                                      logger.warn "BEGIN SEARCH INDEX  ##################################################################"
                                      logger.warn "BEGIN SEARCH INDEX  ##################################################################"
                                      logger.warn "BEGIN SEARCH INDEX  ##################################################################"
                                      logger.warn "BEGIN SEARCH INDEX  ##################################################################"
                                      logger.warn "BEGIN SEARCH INDEX  ##################################################################"
                                      logger.warn "BEGIN SEARCH INDEX  ##################################################################"
                                      @search_string =  Slug.generate(params[:query])
                                      logger.warn "search_string: " + @search_string.to_s
                                      @search_type_name  = params[:search_type_name].to_s  || ""
                                      logger.warn "@search_type_name ######################################################################"
                                      @website_search_items_cache_string =      "search/variables_filtered_" + @search_type_name  +  "_"  + @website.name + "_" + @search_string.to_s + "_week_" + Website.week_number
                                      logger.warn "website_search_items_cache_string: " + @website_search_items_cache_string.to_s
                                      @all_records_cache_string =           "search/variables_all_records_" + @search_type_name  +  "_"  + @search_string       + "_week_" + Website.week_number
                                      ListingMerchandise.new
                                      ListingDesign.new
                                      ListingRevision.new
                                      ListingGarment.new
                                      website_search_items =  FMCache.read @website_search_items_cache_string   unless @incomplete_symbiont
                                      if website_search_items   and website_search_items.class  != String
                                                                  logger.warn "CACHE FOUND SEARCH"
                                                                  logger.warn "CACHE FOUND SEARCH"
                                                                  logger.warn "CACHE FOUND SEARCH"
                                                                  logger.warn "CACHE FOUND SEARCH"
                                                                  @paginated_results  =  website_search_items.to_a.paginate(:page => params[:page] || 1, :per_page => 8  )
                                                                  @designs = true
                                      else
                                                                  if  params[:query]  and   params[:query] != ""
                                                                                                       logger.warn "########### CACHE WAS NOT FOUND FOR website_search_items_cache_string  params[:search_type_name].to_s  +  @website.name + @search_string.to_s"
                                                                                                       logger.warn "########### CACHE WAS NOT FOUND FOR website_search_items_cache_string  params[:search_type_name].to_s  +  @website.name + @search_string.to_s"
                                                                                                       logger.warn "########### CACHE WAS NOT FOUND FOR website_search_items_cache_string  params[:search_type_name].to_s  +  @website.name + @search_string.to_s"
                                                                                                       logger.warn "########### CACHE WAS NOT FOUND FOR website_search_items_cache_string  params[:search_type_name].to_s  +  @website.name + @search_string.to_s"
                                                                                                      @keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase.gsub( "\'"  , "")}"}
                                                                                                      @keywords <<    params[:query].split(" ").collect {|c| "#{c.downcase.gsub( "\'"  , "")}l"          }
                                                                                                      @keywords = @keywords.flatten
                                                                                                      logger.warn "@keywords: " +  @keywords.inspect
                                                                                                      if params[:search_type_name]  ==   'search_heritage_news'
                                                                                                                    @initial_revisions = FullTextSearchPageRevision.search_articles_with_msfte(  :matches_any => @keywords,  :root_id => 2649    )  #, :per_page => 2, :page => 1  )
                                                                                                                      article_search
                                                                                                      elsif    params[:search_type_name]  ==   'search_interesting_emails'
                                                                                                                      @initial_revisions = FullTextSearchPageRevision.search_articles_with_msfte(  :matches_any => @keywords,  :root_id =>  2650     )
                                                                                                                      article_search
                                                                                                      elsif    params[:search_type_name]  ==   'search_all'
                                                                                                                      @initial_revisions = FullTextSearchPageRevision.search_articles_with_msfte(  :matches_any => @keywords,  :website_id =>  @website.id      )
                                                                                                                      article_search
                                                                                                      elsif    params[:search_type_name]  ==   'search_southern_history'
                                                                                                                      @initial_revisions = FullTextSearchPageRevision.search_articles_with_msfte(  :matches_any => @keywords,  :root_id =>  2669      )
                                                                                                                      article_search
                                                                                                      elsif    params[:search_type_name]  ==   'search_designs'
                                                                                                                      @initial_items = ListingDesign.search_designs_with_msfte( :matches_any => @keywords )
                                                                                                                    products_search
                                                                                                      elsif    params[:search_type_name]  ==   'search_garments'
                                                                                                                    @initial_items = ListingGarment.search_designs_with_msfte( :matches_any => @keywords )
                                                                                                                    products_search
                                                                                                      elsif    params[:search_type_name]  ==   'search_merchandise'
                                                                                                                      @initial_items = ListingMerchandise.search_designs_with_msfte( :matches_any => @keywords )
                                                                                                                      products_search
                                                                                                      else
                                                                                                                      error_out
                                                                                                      end
                                                                  else
                                                                                                       logger.warn "NOT   params[:query] "
                                                                                                       logger.warn "NOT   params[:query] "
                                                                                                       logger.warn "NOT   params[:query] "
                                                                                                       logger.warn "NOT   params[:query] "
                                                                                                       logger.warn "NOT   params[:query] "
                                                                  end
                                      end

                                    if request.xhr?
                                                                       logger.warn "responding to ajax request.. using index.js.erb"
                                                                       logger.warn "responding to ajax request.. using index.js.erb"
                                                                       logger.warn "responding to ajax request.. using index.js.erb"
                                                                        render  "index.js.erb"
                                    else
                                                                        logger.warn "responding to NON ajax request.. using index.erb"
                                                                        logger.warn "responding to NON ajax request.. using index.erb"
                                                                        logger.warn "responding to NON ajax request.. using index.erb"
                                                                        logger.warn "responding to NON ajax request.. using index.erb"
                                                                        logger.warn "responding to NON ajax request.. using index.erb"
                                                                        render "index.erb"
                                    end
                                      logger.warn "END SEARCH INDEX  ##################################################################"
                                      logger.warn "END SEARCH INDEX  ##################################################################"
                                      logger.warn "END SEARCH INDEX  ##################################################################"
                                      logger.warn "END SEARCH INDEX  ##################################################################"
                                      logger.warn "END SEARCH INDEX  ##################################################################"

    end
############################################################################################################
  def article_search
                                    logger.debug "BEGIN article_search ########################################"
                                    logger.debug "@initial_revisions: " + @initial_revisions.size.to_s
                                    @all_records =   @initial_revisions
                                    logger.debug "@revisions.size: " + @revisions.size.to_s   if @revisions

                                      #@paged_revisions  = WillPaginate::Collection.create(  params[:page] || 1, 2, @revisions.size) do |pager|
                                      #  pager.replace(@revisions)
                                      #end
                                      @articles = true

                                      logger.debug "search_string: " + @search_string.to_s

                                      if @all_records
                                                     logger.debug " @all_records"
                                                    FMCache.write @all_records_cache_string   , @all_records   ,   :expires_in => 10.minutes
                                      else
                                                  logger.debug "NOT @all_records"
                                        end
                                      @paginated_results =  @all_records.paginate(:page => params[:page] || 1, :per_page =>  2 )

                                      logger.debug "ending search"
                                      logger.debug "END article_search ########################################"
  end
############################################################################################################
 def products_search
                                                logger.debug "BEGIN products_search ########################################"
                                               logger.debug "BEGIN products_search ########################################"
                                               logger.debug "BEGIN products_search ########################################"
                                               logger.debug "BEGIN products_search ########################################"
                                               logger.debug "BEGIN products_search ########################################"

                                               logger.debug "############## @incomplete_symbiont : " + @incomplete_symbiont.to_s

                                               logger.debug "---------------------------------------------------------------"
                                               logger.debug "@initial_items.inspect: " + @initial_items.inspect.to_s
                                               logger.debug "@initial_items.size.to_s: " + @initial_items.size.to_s
                                               logger.debug "---------------------------------------------------------------"
                                               @all_records = @initial_items   #.to_set.intersection(website_search_items)
                                               logger.debug "search_string: " + @search_string.to_s

                                               if @all_records
                                                 logger.debug " @all_records"
                                                 FMCache.write @all_records_cache_string   , @all_records   ,   :expires_in => 10.minutes
                                               else
                                                 logger.debug "NOT @all_revisions"
                                               end
                                               logger.debug "all_records.size: " + @all_records.size.to_s

                                               website_search_item_ids      =  @website.website_search_item_ids
                                               logger.debug "website_search_item_ids: " + website_search_item_ids.inspect

                                               @product_search_results = Set.new
                                               already_seen_item_picturenames = Set.new
                                               already_seen_item_item_class = Set.new
                                               @all_records.each do |ar|
                                                         if ar.id
                                                                      if  ar.sublimation_status == 'sublimation_only' and @customer_array.PriceLevel < 2
                                                                            logger.warn "123456  sublimation_only and not wholesale customer"
                                                                      else
                                                                               if  website_search_item_ids.split(',').include?( ar.id.to_s  )
                                                                                           if already_seen_item_picturenames.include?( ar.PictureName.to_s  )
                                                                                                       logger.debug "1234  skiipped because already used this picturname"
                                                                                           else
                                                                                                       if already_seen_item_item_class.include?(  ar.item_class_number  )
                                                                                                                 logger.warn "1234 skipping already seen item already_seen_item_item_class."
                                                                                                       else
                                                                                                                      if @incomplete_symbiont
                                                                                                                                      if @purchase_symbiote_item.category.category_class.opposite_category_ids.include?( ar.category_id.to_s  )
                                                                                                                                                 logger.warn "1234 adding this record.."
                                                                                                                                                 @product_search_results.add ar
                                                                                                                                                 already_seen_item_picturenames .add  ar.PictureName.to_s
                                                                                                                                                 already_seen_item_item_class .add  ar.item_class_number
                                                                                                                                      else
                                                                                                                                                    logger.debug "1234  skiipped because it is not a compatible opposite"
                                                                                                                                       end
                                                                                                                      else
                                                                                                                                              logger.warn "not @incomplete_symbiont.."
                                                                                                                                              logger.warn "1234 adding this record.."
                                                                                                                                              @product_search_results.add ar
                                                                                                                                              already_seen_item_picturenames .add  ar.PictureName.to_s
                                                                                                                                              already_seen_item_item_class .add  ar.item_class_number
                                                                                                                       end
                                                                                                       end
                                                                                           end
                                                                               else
                                                                                          logger.warn "1234 skipped this item..not in website_search_item_ids.."
                                                                               end
                                                                       end
                                                         else
                                                                               logger.warn "1234 not ar"
                                                          end

                                               end
                                               logger.debug "website_search_items: " + @product_search_results.inspect
                                               FMCache.write  @website_search_items_cache_string ,    @product_search_results
                                               @paginated_results  =  @product_search_results.to_a.paginate(:page => params[:page] || 1, :per_page => 8  )
                                                logger.debug "END search_garments ########################################"
                                                logger.debug "END search_garments ########################################"
                                                logger.debug "END search_garments ########################################"
                                                logger.debug "END search_garments ########################################"
end





















































































#
#  def search_designs
#            logger.debug "BEGIN search_designs ########################################"
#                                              @all_records = @initial_items   #.to_set.intersection(website_search_items)
#                                              logger.debug "search_string: " + @search_string.to_s
#
#                                              if @all_records
#                                                          logger.debug " @all_records"
#                                                          cache_string =            params[:search_type_name] +  "_"  + @search_string
#                                                          Caching::MemoryCache.instance.write cache_string   , @all_records   ,   :expires_in => 10.minutes
#                                              else
#                                                          logger.debug "NOT @all_revisions"
#                                              end
#                                              logger.debug "all_records.size: " + @all_records.size.to_s
#
#                                              website_search_item_ids      =  @website.website_search_item_ids
#                                              logger.debug "website_search_item_ids: " + website_search_item_ids.inspect
#
#
#                                              website_search_items = Set.new
#                                              already_seen_item_picturenames = Set.new
#                                              @all_records.each do |ar|
#                                                        if ar.id
#                                                                  if  website_search_item_ids.split(',').include?( ar.id.to_s  )        ######################################
#                                                                            if already_seen_item_picturenames.include?( ar.PictureName.to_s  )
#                                                                                      logger.debug "1234  skiipped because already used this picturname"
#                                                                            else
#                                                                                      logger.warn "1234 adding this record. ar.id: " + ar.id.to_s
#                                                                                      website_search_items.add ar
#                                                                                      already_seen_item_picturenames .add  ar.PictureName.to_s
#                                                                            end
#                                                                  else
#                                                                            logger.warn "1234 skipped this item..not in website_search_item_ids.."
#                                                                  end
#                                                        else
#                                                                    logger.warn "1234 not ar"
#                                                        end
#                                              end
#                                              logger.debug "website_search_items: " + website_search_items.inspect
#                                              website_search_items_cache_string =      params[:search_type_name] +  "_"  + @website.name + @search_string.to_s
#                                              Caching::MemoryCache.instance.write  website_search_items_cache_string ,    website_search_items
#
#                    @paginated_results  =  website_search_items.to_a.paginate(:page => params[:page] || 1, :per_page => 6  )
#                     @designs = true
#                    logger.debug "END search_designs ########################################"
#  end
#############################################################################################################
#############################################################################################################
#  def search_merchandise
#                             logger.debug "BEGIN search_merchandise ########################################"
#                              #@initial_items = ListingMerchandise.search_designs_with_msfte( :matches_any => @keywords )
#                              logger.debug "---------------------------------------------------------------"
#                              logger.debug "@initial_items.inspect: " + @initial_items.inspect.to_s
#                              logger.debug "@initial_items.size.to_s: " + @initial_items.size.to_s
#                              logger.debug "---------------------------------------------------------------"
#                          #s = ListingMerchandise.new
#                          #website_search_items = false
#                          #website_search_items_cache_string =      params[:search_type_name] +  "_"  +  @website.name + @search_string.to_s
#                          #website_search_items =  Caching::MemoryCache.instance.read website_search_items_cache_string
#                          #if website_search_items
#                          #  logger.debug "CACHE FOUND SEARCH"
#                          #else
#
#                                        @all_records = @initial_items   #.to_set.intersection(website_search_items)
#                                        logger.debug "search_string: " + @search_string.to_s
#
#                                        if @all_records
#                                                    logger.debug " @all_records"
#                                                    cache_string =            params[:search_type_name] +  "_"  + @search_string
#                                                    Caching::MemoryCache.instance.write cache_string   , @all_records   ,   :expires_in => 10.minutes
#                                        else
#                                                    logger.debug "NOT @all_records"
#                                        end
#                                        logger.debug "all_records.size: " + @all_records.size.to_s
#
#                                        website_search_item_ids      =  @website.website_search_item_ids
#                                        logger.debug "website_search_item_ids: " + website_search_item_ids.inspect
#
#                                        website_search_items = Set.new
#                                        already_seen_item_picturenames = Set.new
#                                        already_seen_item_item_class = Set.new
#                                        @all_records.each do |ar|
#                                                    if ar.id
#
#                                                      logger.debug   "##################:"+ ar.item_class_number
#
#                                                          if  website_search_item_ids.split(',').include?( ar.id.to_s  )
#                                                            if already_seen_item_picturenames.include?( ar.PictureName.to_s  )
#                                                                                   logger.debug "1234  skiipped because already used this picturname: " +  ar.PictureName.to_s
#                                                                     else
#                                                                                       if already_seen_item_item_class.include?( ar.item_class_number  )
#                                                                                                      logger.warn "1234 skipping already seen item already_seen_item_item_class."   +  ar.item_class_number
#                                                                                       else
#                                                                                                         logger.warn "1234 adding this record.."
#                                                                                                         website_search_items.add ar
#                                                                                                         already_seen_item_picturenames .add  ar.PictureName.to_s
#                                                                                                         already_seen_item_item_class .add  ar.item_class_number
#                                                                                       end
#                                                                       end
#                                                          else
#                                                                     logger.warn "1234 skipped this item..not in website_search_item_ids.."
#                                                          end
#                                                    else
#                                                              logger.warn "1234 not ar"
#                                                     end
#                                        end
#                                         website_search_items_cache_string =      params[:search_type_name] +  "_"  + @website.name + @search_string.to_s
#                                        Caching::MemoryCache.instance.write  website_search_items_cache_string ,    website_search_items
#                          #end
#
#                              logger.debug "website_search_items.size: " + website_search_items.size.to_s
#                              logger.debug "website_search_items: " + website_search_items.inspect
#
#                            @paginated_results  =  website_search_items.to_a.paginate(:page => params[:page] || 1, :per_page => 6  )
#
#                            @products = true
#                            logger.debug "END search_merchandise ########################################"
#  end
#############################################################################################################
#def search_garments
#    logger.debug "BEGIN search_garments ########################################"
#    logger.debug "---------------------------------------------------------------"
#    logger.debug "@initial_items.inspect: " + @initial_items.inspect.to_s
#    logger.debug "@initial_items.size.to_s: " + @initial_items.size.to_s
#    logger.debug "---------------------------------------------------------------"
#
#    @all_records = @initial_items   #.to_set.intersection(website_search_items)
#    logger.debug "search_string: " + @search_string.to_s
#
#    if @all_records
#      logger.debug " @all_records"
#      cache_string =            params[:search_type_name] +  "_"  + @search_string
#      Caching::MemoryCache.instance.write cache_string   , @all_records   ,   :expires_in => 10.minutes
#    else
#      logger.debug "NOT @all_revisions"
#    end
#    logger.debug "all_records.size: " + @all_records.size.to_s
#
#    website_search_item_ids      =  @website.website_search_item_ids
#    logger.debug "website_search_item_ids: " + website_search_item_ids.inspect
#
#    website_search_items = Set.new
#    already_seen_item_picturenames = Set.new
#    already_seen_item_item_class = Set.new
#    @all_records.each do |ar|
#                if ar.id
#                      if  website_search_item_ids.split(',').include?( ar.id.to_s  )
#                                 if already_seen_item_picturenames.include?( ar.PictureName.to_s  )
#                                               logger.debug "1234  skiipped because already used this picturname"
#                                 else
#                                                   if already_seen_item_item_class.include?(  ar.item_class_number  )
#                                                                  logger.warn "1234 skipping already seen item already_seen_item_item_class."
#                                                   else
#                                                                  logger.warn "1234 adding this record.."
#                                                                 website_search_items.add ar
#                                                                 already_seen_item_picturenames .add  ar.PictureName.to_s
#                                                                  already_seen_item_item_class .add  ar.item_class_number
#                                                     end
#                                   end
#                      else
#                                 logger.warn "1234 skipped this item..not in website_search_item_ids.."
#                      end
#                else
#                          logger.warn "1234 not ar"
#                 end
#    end
#
#
#    logger.debug "website_search_items: " + website_search_items.inspect
#
#    @paginated_results  =  website_search_items.to_a.paginate(:page => params[:page] || 1, :per_page => 6  )
#
#    @products  = true
#    logger.debug "END search_garments ########################################"
#  end
#############################################################################################################
#
#























# @initial_items = ListingItem.find_with_msfte :matches_any => ['deer', 'hunting' ]
#@initial_items = ListingDesignsAndMerchandiseOnly.find_with_msfte :matches_any => ['deer', 'hunting' ]
#  logger.debug "---------------------------------------------------------------"
#  logger.debug "@initial_items.inspect: " + @initial_items.inspect.to_s
#  logger.debug "@initial_items.size.to_s: " + @initial_items.size.to_s
#  logger.debug "---------------------------------------------------------------"
  ss = 'ss'
#@items_with_rank = []
#@item_numbers_to_distinct = Set.new
##@keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
#@initial_items.each do |item|
#            item_words_string = item.id.to_s + ' ' +  item.ItemLookupCode.to_s + ' ' + item.Description.to_s     + ' ' + item.ExtendedDescription.to_s + ' ' + item.Notes.to_s
#            item_words_array  = item_words_string.split.collect {|c| "#{c.downcase}"}
#            item_number_only    =  item.number_without_size
#            item_words_set = item_words_array.to_set
#            @keywords_set      = @keywords.to_set
#            word_count = 0
#            @keywords.each do  |kw|
#                      matching_words = @keywords_set.intersection(item_words_set)
#                      if matching_words.size > 0
#                               logger.debug "matching_words: " + matching_words.inspect
#                      else
#                               logger.debug "item_words_set because none match: " + item_words_set.inspect
#                      end
#                      if matching_words.size > 0
#                                word_count = matching_words.size
#                      end
#            end
#            item.SubDescription3 = word_count
#            @items_with_rank	<< item  unless @item_numbers_to_distinct.include?(item_number_only)   #if item.SubDescription3 != 0  #and  @website_search_item_ids.include?(item.id)
#            @item_numbers_to_distinct.add?( item_number_only)
#            @ranked_items = @items_with_rank.sort_by {|a| a.SubDescription3}.reverse
#end
#logger.debug "@ranked_items.inspect: " + @ranked_items.inspect
##logger.debug "@website_search_items: " + @website_search_items.inspect
#g = "g"
#@items = @ranked_items   #.to_set.intersection(@website_search_items)
#  website_search_items = false
  #website_search_item_ids = Caching::MemoryCache.instance.read    "website_search_item_ids_"   +    options[:website_id].to_s
  #if    website_search_items
  #  logger.debug "Found website_search_items"
  #else
  #  website_search_items =   ListingDesign.website_search_item_ids(  @website.id   )
  #  g = "g"
  #  Caching::MemoryCache.instance.write   "website_search_items_"   +    @website.id.to_s   , website_search_items   ,   :expires_in => 4000.minutes
  #end

#
#############################################################################################################
#  def general_product_search
#    deprecate_general_product_search
#    logger.debug "BEGIN search_merchandise ########################################"
#    logger.debug "---------------------------------------------------------------"
#    logger.debug "@initial_items.inspect: " + @initial_items.inspect.to_s
#    logger.debug "@initial_items.size.to_s: " + @initial_items.size.to_s
#    logger.debug "---------------------------------------------------------------"
#
#    @all_records = @initial_items   #.to_set.intersection(website_search_items)
#    logger.debug "search_string: " + @search_string.to_s
#
#    if @all_records
#      logger.debug " @all_records"
#      cache_string =            params[:search_type_name] +  "_"  + @search_string
#      Caching::MemoryCache.instance.write cache_string   , @all_records   ,   :expires_in => 10.minutes
#    else
#      logger.debug "NOT @all_revisions"
#    end
#    logger.debug "all_records.size: " + @all_records.size.to_s
#
#    website_search_item_ids      =  @website.website_search_item_ids
#    logger.debug "website_search_item_ids: " + website_search_item_ids.inspect
#
#    website_search_items = Set.new
#    already_seen_item_picturenames = Set.new
#    @all_records.each do |ar|
#                if ar.id
#                      if  website_search_item_ids.split(',').include?( ar.id.to_s  )
#                        if already_seen_item_picturenames.include?( ar.PictureName.to_s  )
#                                               logger.debug "1234  skiipped because already used this picturname"
#                                 else
#                                                  logger.warn "1234 adding this record.."
#                                                 website_search_items.add ar
#                                                 already_seen_item_picturenames .add  ar.PictureName.to_s
#                                   end
#                      else
#                                 logger.warn "1234 skipped this item..not in website_search_item_ids.."
#                      end
#                else
#                          logger.warn "1234 not ar"
#                 end
#    end
#
#
#    logger.debug "website_search_items: " + website_search_items.inspect
#
#    @paginated_results  =  website_search_items.to_a.paginate(:page => params[:page] || 1, :per_page => 6  )
#
#    @products  = true
#    logger.debug "END search_merchandise ########################################"
#  end
#############################################################################################################
#





#  def website_search_items
#
#
#    #@website_search_item_ids =  Caching::MemoryCache.instance.read @website.name + '_search_item_ids'  unless cache_on? == false
#    if !@website_search_item_ids
#                      logger.info "------------------------------------- @all_website_item_ids not found, finding by activerecord"
#                      #@website_search_items = Caching::MemoryCache.instance.read @website.name + '_search_items'  unless cache_on? == false
#                      if @website_search_items
#                                     logger.info "-------------------------------------@website_search_items found by cache"
#                      else
#                                      @website_search_items =  Item.where("items.department_id in (?)", @website.default_all_department_ids_with_generic ).all
#                                      logger.info "-------------------------------------@website_search_items NOT found by cache"
#                                      Caching::MemoryCache.instance.write @website.name + '_search_items', @website_search_items, :expires_in => 257.minutes  unless cache_on? == false
#                      end
#                      @website_search_item_ids = Set.new
#                      @website_search_items.each do |item|
#                                  @website_search_item_ids.add  item.id.to_i
#                      end
#                      Caching::MemoryCache.instance.write @website.name + '_search_item_ids', @website_search_item_ids  unless cache_on? == false
#    else
#                        logger.debug "found @website_search_item_ids by cache"
#      end
#  end
#







  #def article_search_orig
  #  logger.debug "BEGIN article_search ########################################"
  #  #@initial_revisions = ListingRevision.find_with_msfte :matches_any => @keywords
  #  @revisions_with_rank = Set.new
  #  @keywords   =  params[:query].gsub(" ", "+").split("+").collect {|c| "#{c.downcase}"}
  #  @initial_revisions[0..20].each do |revision|
  #              revision_words_string = revision.id.to_s + ' ' +  ActionView::Base.full_sanitizer.sanitize(revision.content.to_s)  #  +  revision.page.name.to_s + ' ' + revision.page.slug.to_s     + ' '
  #              revision_words_array  = revision_words_string.split.collect {|c| "#{c.downcase}"}
  #              revision_words_set = revision_words_array.flatten.to_set
  #              @keywords_set      = @keywords.to_set
  #              word_count = 0
  #              @keywords.each do  |kw|
  #                        matching_words = @keywords_set.intersection(revision_words_set)
  #                        g = "g"
  #                        if matching_words.size > 0
  #                          logger.debug "matching_words: " + matching_words.inspect
  #                        else
  #                          logger.debug "matching_words - revision_words_set because none match: " + revision_words_set.inspect
  #                        end
  #                        word_count = matching_words.size.to_i
  #              end
  #              revision.total_column = word_count
  #              @revisions_with_rank.add revision # if revision.total_column != 0
  #  end
  #  g = "g"
  #  @all_revisions = @revisions_with_rank.sort_by {|a| a.total_column}.reverse
  #  logger.debug "@revisions.size: " + @revisions.size.to_s   if @revisions
  #
  #  #@paged_revisions  = WillPaginate::Collection.create(  params[:page] || 1, 2, @revisions.size) do |pager|
  #  #  pager.replace(@revisions)
  #  #end
  #  @articles = true
  #  Caching::MemoryCache.instance.write   "all_revisions_"   +   @search_string   , @all_revisions   ,   :expires_in => 10.minutes
  #
  #  @revisions =  @all_revisions.paginate(:page => params[:page] || 1, :per_page =>  2 )
  #
  #  logger.debug "ending search"
  #  logger.debug "END article_search ########################################"
  #
  #end










































#############################################################################################################
#  def index_non_endless
#    #USE TABLE "MAX REVISION IDS" to find ids
#    if  params[:query]
#      @keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase.gsub( "\'"  , "")}"}
#      @keywords <<    params[:query].split(" ").collect {|c| "#{c.downcase.gsub( "\'"  , "")}l"          }
#      @keywords = @keywords.flatten
#      logger.debug "@keywords: " +  @keywords.inspect
#      if params[:search_type_name]  ==   'search_heritage_news'
#        @initial_revisions = FullTextSearchPageRevision.search_articles_with_msfte(  :matches_any => @keywords,  :root_id => 2649    )  #, :per_page => 2, :page => 1  )
#        article_search
#      elsif    params[:search_type_name]  ==   'search_interesting_emails'
#        @initial_revisions = FullTextSearchPageRevision.search_articles_with_msfte(  :matches_any => @keywords,  :root_id =>  2650     )
#        article_search
#      elsif    params[:search_type_name]  ==   'search_southern_history'
#        @initial_revisions = FullTextSearchPageRevision.search_articles_with_msfte(  :matches_any => @keywords,  :root_id =>  2669      )
#        article_search
#        #elsif    params[:search_type_name]  ==   'search_designs'
#        #              search_designs
#      else    params[:search_type_name]  ==   'search_items'
#      nooo
#      search_items
#      end
#    end
#  end
#############################################################################################################
#  def article_search_non_endless
#    logger.debug "BEGIN article_search ########################################"
#    #@initial_revisions = ListingRevision.find_with_msfte :matches_any => @keywords
#    @revisions_with_rank = Set.new
#    @keywords   =  params[:query].gsub(" ", "+").split("+").collect {|c| "#{c.downcase}"}
#    @initial_revisions[0..20].each do |revision|
#      revision_words_string = revision.id.to_s + ' ' +  ActionView::Base.full_sanitizer.sanitize(revision.content.to_s)  #  +  revision.page.name.to_s + ' ' + revision.page.slug.to_s     + ' '
#      revision_words_array  = revision_words_string.split.collect {|c| "#{c.downcase}"}
#      revision_words_set = revision_words_array.flatten.to_set
#      @keywords_set      = @keywords.to_set
#      word_count = 0
#      @keywords.each do  |kw|
#        matching_words = @keywords_set.intersection(revision_words_set)
#        g = "g"
#        if matching_words.size > 0
#          logger.debug "matching_words: " + matching_words.inspect
#        else
#          logger.debug "matching_words - revision_words_set because none match: " + revision_words_set.inspect
#        end
#        word_count = matching_words.size.to_i
#      end
#      revision.total_column = word_count
#      @revisions_with_rank.add revision # if revision.total_column != 0
#    end
#    g = "g"
#    @revisions = @revisions_with_rank.sort_by {|a| a.total_column}.reverse
#    logger.debug "@revisions.size: " + @revisions.size.to_s   if @revisions
#
#    #@paged_revisions  = WillPaginate::Collection.create(  params[:page] || 1, 2, @revisions.size) do |pager|
#    #  pager.replace(@revisions)
#    #end
#    @revisions =  @revisions.paginate(:page => params[:page] || 1, :per_page =>  2 )
#
#    @articles = true
#    # render :action => "search_results_list_revisions"  , :layout => false
#    # render :action => "index"  , :layout => false
#    logger.debug "ending search"
#    logger.debug "END article_search ########################################"
#  end







#  def ajax_search_articles
#
#    logger.debug "BEGIN ajax_search_articles ########################################"
#    @initial_revisions = ListingRevision.find_with_msfte :matches_any => @keywords
#    @revisions_with_rank = []
#    @keywords   =  params[:query].split("+").collect {|c| "#{c.downcase}"}
#    @initial_revisions[0..20].each do |revision|
#                  revision_words_string = revision.id.to_s + ' ' +  ActionView::Base.full_sanitizer.sanitize(revision.content.to_s)  #  +  revision.page.name.to_s + ' ' + revision.page.slug.to_s     + ' '
#                  revision_words_array  = revision_words_string.split.collect {|c| "#{c.downcase}"}
#                  revision_words_set = revision_words_array.flatten.to_set
#                  @keywords_set      = @keywords.to_set
#                  word_count = 0
#                  @keywords.each do  |kw|
#                    matching_words = @keywords_set.intersection(revision_words_set)
#                    g = "g"
#                    if matching_words.size > 0
#                      logger.debug "matching_words: " + matching_words.inspect
#                    else
#                      logger.debug "matching_words - revision_words_set because none match: " + revision_words_set.inspect
#                    end
#                    #if matching_words.size.to_i  > 0
#                             word_count = matching_words.size.to_i
#                    #else
#                    #       word_count = 77
#                    #  end
#      end
#      revision.total_column = word_count
#      @revisions_with_rank	<< revision # if revision.total_column != 0
#      @revisions = @revisions_with_rank.sort_by {|a| a.total_column}.reverse
#    end
#    @articles = true
#    #find_latest_revision_ids
#    #render :action => "search_results_list_revisions"  , :layout => false
#
#    logger.debug "ending search"
#    logger.debug "BEGIN ajax_search_articles ########################################"
#  end
#############################################################################################################
#  def ajax_search_items
#    logger.debug "BEGIN ajax_search_items ########################################"
#    @initial_items = ListingDesignsAndMerchandiseOnly.find_with_msfte :matches_any => @keywords
#    @items = @initial_items
#    logger.debug "@items.size: " + @items.size.to_s
#    logger.debug "END ajax_search_items ########################################"
#  end
#############################################################################################################
#  def ajax_search_items_before
#    logger.debug "BEGIN ajax_search_items ########################################"
#    # @initial_items = ListingItem.find_with_msfte :matches_any => ['deer', 'hunting' ]
#    #@initial_items = ListingDesignsAndMerchandiseOnly.find_with_msfte :matches_any => ['deer', 'hunting' ]
#    @initial_items = ListingDesignsAndMerchandiseOnly.find_with_msfte :matches_any => @keywords
#      logger.debug "---------------------------------------------------------------"
#      logger.debug "@initial_items.inspect: " + @initial_items.inspect.to_s
#      logger.debug "@initial_items.size.to_s: " + @initial_items.size.to_s
#      logger.debug "---------------------------------------------------------------"
#      ss = 'ss'
#      @items_with_rank = []
#      @item_numbers_to_distinct = Set.new
#      #@keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
#      @initial_items.each do |item|
#                  item_words_string = item.id.to_s + ' ' +  item.ItemLookupCode.to_s + ' ' + item.Description.to_s     + ' ' + item.ExtendedDescription.to_s + ' ' + item.Notes.to_s
#                  item_words_array  = item_words_string.split.collect {|c| "#{c.downcase}"}
#                  item_number_only    =  item.number_without_size
#
#                  #if item.aliasings
#                  #
#                  #  xxxx
#                  #      item.aliasings.each do |al|
#                  #          item_words_array <<  al.Alias.downcase
#                  #      end
#                  #end
#                  item_words_set = item_words_array.to_set
#                  @keywords_set      = @keywords.to_set
#                  word_count = 0
#                  @keywords.each do  |kw|
#                    matching_words = @keywords_set.intersection(item_words_set)
#                    if matching_words.size > 0
#                      logger.debug "matching_words: " + matching_words.inspect
#                    else
#                      logger.debug "item_words_set because none match: " + item_words_set.inspect
#                    end
#                    if matching_words.size > 0
#                      word_count = matching_words.size
#                    end
#                  end
#                  item.SubDescription3 = word_count
#                  #website_search_items
#                  #startup_acceptable_item_ids_by_website
#                  # if !@acceptable_item_ids
#                  #         not_acceptable_item_ids
#                  # end
#                  @items_with_rank	<< item  unless @item_numbers_to_distinct.include?(item_number_only)   #if item.SubDescription3 != 0  #and  @website_search_item_ids.include?(item.id)
#                  @item_numbers_to_distinct.add?( item_number_only)
#                  @ranked_items = @items_with_rank.sort_by {|a| a.SubDescription3}.reverse
#      end
#      logger.debug "@ranked_items.inspect: " + @ranked_items.inspect
#      #logger.debug "@website_search_items: " + @website_search_items.inspect
#      g = "g"
#    @items = @ranked_items   #.to_set.intersection(@website_search_items)
#    #render :action =>  "search_results_list_items"   , :layout => false
#    #render :partial  =>  "store/items"   , :layout => false
#    #render :partial  =>  "/search/items"   , :layout => false
#    logger.debug "END ajax_search_items ########################################"
#  end







#
#
#  def ajax_search_items
#          logger.debug "BEGIN ajax_search_items ########################################"
#          #@initial_items = ListingItem.find_with_msfte :matches_any => ['deer', 'hunting' ]
#          @initial_items = ListingItem.find_with_msfte :matches_any => @keywords
#          logger.debug "---------------------------------------------------------------"
#          ss = 'ss'
#          logger.debug "@initial_items.inspect: " + @initial_items.inspect.to_s
#          logger.debug "@initial_items.size.to_s: " + @initial_items.size.to_s
#          logger.debug "---------------------------------------------------------------"
#          ss = 'ss'
#          @items_with_rank = []
#          @keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
#          @initial_items.each do |item|
#                          item_words_string = item.id.to_s + ' ' +  item.ItemLookupCode.to_s + ' ' + item.Description.to_s    # + ' ' + item.ExtenededDescription.to_s + ' ' + item.Notes.to_s
#                          item_words_array  = item_words_string.split.collect {|c| "#{c.downcase}"}
#                          # if item.aliasings
#                          #      item.aliasings.each do |al|
#                          #          item_words_array <<  al.Alias.downcase
#                          #      end
#                          #end
#                          item_words_set = item_words_array.to_set
#                           @keywords_set      = @keywords.to_set
#                           word_count = 0
#                           @keywords.each do  |kw|
#                               matching_words = @keywords_set.intersection(item_words_set)
#                               if matching_words.size > 0
#                                     logger.debug "matching_words: " + matching_words.inspect
#                               else
#                                      logger.debug "item_words_set because none match: " + item_words_set.inspect
#                               end
#                               if matching_words.size > 0
#                                 word_count = matching_words.size
#                               end
#                           end
#                            item.total_column = word_count
#                            #startup_website_all_items
#                            #startup_acceptable_item_ids_by_website
#                            # if !@acceptable_item_ids
#                            #         not_acceptable_item_ids
#                            # end
#                             @items_with_rank	<< item if item.total_column != 0  #  && @acceptable_item_ids.include?(item.id)
#                             @items = @items_with_rank.sort_by {|a| a.total_column}.reverse
#          end
#          render(:update) { |page|
#                page.replace_html 'search_results',   :partial => "search/search_results_list_items"
#          }
#          logger.debug "END ajax_search_items ########################################"
#  end
#
#
#
#  def ajax_search_articles
#              logger.debug "BEGIN ajax_search_articles ########################################"
#              @initial_revisions = ListingRevision.find_with_msfte :matches_any => @keywords
#              @revisions_with_rank = []
#              @keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
#              @initial_revisions.each do |revision|
#                         revision_words_string = revision.id.to_s + ' ' + revision.content.to_s  #  +  revision.page.name.to_s + ' ' + revision.page.slug.to_s     + ' '
#                         revision_words_array  = revision_words_string.split.collect {|c| "#{c.downcase}"}
#                         revision_words_set = revision_words_array.to_set
#                          @keywords_set      = @keywords.to_set
#                          word_count = 0
#                          @keywords.each do  |kw|
#                              matching_words = @keywords_set.intersection(revision_words_set)
#                              if matching_words.size > 0
#                                    logger.debug "matching_words: " + matching_words.inspect
#                              else
#                                     logger.debug "revision_words_set because none match: " + revision_words_set.inspect
#                              end
#                              if matching_words.size > 0
#                                word_count = matching_words.size
#                              end
#                          end
#                           revision.total_column = word_count
#                            @revisions_with_rank	<< revision if revision.total_column != 0
#                            @revisions = @revisions_with_rank.sort_by {|a| a.total_column}.reverse
#              end
#          render(:update) { |page|
#                           page.replace_html 'search_results',   :partial => "search/search_results_list_revisions"
#          }
#          logger.debug "ending search"
#          logger.debug "BEGIN ajax_search_articles ########################################"
#   end
#
#
#
#
#
#
#
#
#
#  def ajax_search
#                     @keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
#                     @tokens = @keywords
#                    if params[:search_type_name] == 'articles'
#                                        ajax_search_articles
#
#                    else
#                                        ajax_search_items
#                    end
#  end
#
#
#
#
#
#def index
#end




############################################################################################################
#  def find_latest_revision_ids
#    logger.debug "-------------------------------------begin latest_revision_ids"
#    @latest_revision_ids = Caching::MemoryCache.instance.read  @website.name + '_latest_revision_ids'
#    if !@latest_revision_ids or @latest_revision_ids.nil? or @latest_revision_ids == ''
#      @latest_revision_ids =  Revision.find_latest_published_revision_ids
#      Caching::MemoryCache.instance.write( @website.name + '_latest_revision_ids' , @latest_revision_ids , :expires_in => 555.minutes)
#
#    end
#    logger.debug "-------------------------------------end latest_revision_ids"
#  end
#############################################################################################################
#
#
#
#
#


















end
