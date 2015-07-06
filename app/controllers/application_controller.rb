class ApplicationController < ActionController::Base
  protect_from_forgery

  include AuthenticatedSystem
  include ArticlesInitializer
  include CacheableFlash
  include RubyRequirements
  include LogSystem
  include WebsiteStartup
  include UserStartup
  include CustomerStartup
  include SecurityIdentifier
  include Security
  include StartupOptimusPrime
  include ::SslRequirement
  include UserSessionStartup
  #include SimpleCaptcha::ControllerHelpers
  include StoreAdminCacheCleaner
  include StoreItemInitializer
  include StoreItemSymbiontInitializer
  include StorePurchase
  #include StoreRequirements
  include StoreAllOverShirts
  include RubyArray
  include WebsiteDirectingActions

  helper_method  :current_layout, :controller_and_action_name, :referring_action, :show_admin?, :firebug, :user_can?, :strip_path_to_domain, :admin?, :developer?, :ssl_required?, :customer_retail?, :customer_wholesale?, :customer_franchise?, :customer_preprint?, :customer_transfer?,:admin?,:cashier?, :manager?,  :logged_in?, :current_log_position, :ssl_or_admin?

  before_filter :at_guides , :params_to_session, :set_start_time
  before_filter :before_filter
  after_filter :after_filter




  def no_item_menu
             @no_item_menu = true
end


  def new_and_featured_items
           #  @featured_new_designs   ||= FeaturedItem.limit(35).where("website_id = ? and carousel_name = ? and active = ?",   @website.id, 'tshirts-new-1' , 'True'   ).all
           #
           #  unless @featured_new_designs
           #    logger.warn "@new_designs NO ITEMS FOUND ON index ACTION !!!!"
           #  else
           #    logger.warn "@new_designs.size: #{@featured_new_designs.size}"
           #    #FMCache.write  new_designs_cache_string ,   @items
           #  end
           #
           # @featured_items   ||= FeaturedItem.limit(35).where("website_id = ? and carousel_name = ?  and active = ?",   @website.id, 'home-featured-1' , 'True'   ).all
           #
           #  unless @featured_items
           #    logger.warn "@@featured_items NO ITEMS FOUND ON index ACTION !!!!"
           #  else
           #    logger.warn "@@featured_items.size: #{@featured_items.size}"
           #    #FMCache.write  new_designs_cache_string ,   @items
           #  end



            # @featured_custom_items   ||= FeaturedItem.limit(35).where("website_id = ? and carousel_name = ? and active = ?",   @website.id, 'home-custom-1' , 'True'   ).all
            #
            # unless @featured_custom_items
            #   logger.warn "@@featured_items NO ITEMS FOUND ON index ACTION !!!!"
            # else
            #   logger.warn "@@featured_items.size: #{@featured_custom_items.size}"
            #   #FMCache.write  new_designs_cache_string ,   @items
            # end

  end


  # def new_and_featured_items
  #   @new_designs   ||= FeaturedItem.limit(35).where("website_id = ? and carousel_name = ?",   @website.id, 'tshirts-new-1'  ).all
  #
  #   g = "g"
  #
  #   unless @new_designs
  #     logger.warn "@new_designs NO ITEMS FOUND ON index ACTION !!!!"
  #   else
  #     logger.warn "@new_designs.size: #{@new_designs.size}"
  #     #FMCache.write  new_designs_cache_string ,   @items
  #   end
  #
  #   # @featured_items  ||= FeaturedItem.limit(35).where("website_id = ?",   @website.id )
  #   # unless @featured_items
  #   #   logger.warn "NO @featured_items FOUND ON index ACTION !!!!"
  #   # else
  #   #   logger.warn "@featured_items.size: #{@featured_items.size}"
  #   #   #FMCache.write  new_designs_cache_string ,   @items
  #   # end
  # end


  def at_sublimation
                  # logger.debug "@category.Name: " + @category.Name
                  # logger.debug "@category.Name: " + @category.category_class.name

                                if   @parameter_item and @parameter_item_name  == "sublimation_shirts"
                                                @sublimation = true
                               elsif  @parameter_item and @parameter_item_name  == "huge_front"
                                               @sublimation = true
                                  elsif     params[:designer_item_status].to_s  == '1'
                                              @sublimation = true
                                  else
                                               @sublimation = false
                                  end
                logger.debug "@sublimation.inspect: " +  @sublimation.inspect
  end



  ###########################################################################################################
  def  at_side  #  moved to application_controller prepare_combination_variables
                # BEGIN @side code - NOTE OVERRIDE
                # BEGIN @side code - NOTE OVERRIDE
                # BEGIN @side code - NOTE OVERRIDE
                if @sublimation
                              @side = 'front'
                else
                              if @purchases_entry and @purchases_entry.Comment.size > 1
                                            @side = @purchases_entry.Comment.split("_")[0]
                              end
                              # PARAMS OVERRIDE PURCHASES_ENTRY COMMENT ABOVE
                              if params[:side] == 'front'
                                          @side = 'front'
                              elsif params[:side] == 'back'
                                          @side = 'back'
                              end

                              @side ||= 'back'
                 end
                # END  @side code - NOTE OVERRIDE
  end
  ###########################################################################################################
  def prepare_combination_variables(item,design)
              logger.debug "##############################################"
              logger.debug "##############################################"
              logger.debug "##############################################"
              logger.debug "##############################################"
              logger.debug "##############################################"
              logger.debug "BEGIN prepare_combination_variables"
              if params[:crest_id] and  params[:crest_id] != ""
                                  logger.debug "crest_id found"

                                  if  !params[:crest_id] or params[:crest_id] == '0'
                                                          @breast_print = false
                                                          @breast_print_name =    'no_crest.png'
                                  else
                                                          @breast_print = true
                                                          @breast_print =    Item.find(params[:crest_id])
                                                          @breast_print_name =    @breast_print.PictureName
                                   end
              else
                              # if design.category.breast_print == '1' && item.category.breast_print == '1'
                                             if @purchases_entry
                                                                   logger.debug "CREST PRINT ATTACHED TO PURCHASES ENTRY"

                                                                   @purchases_entry_slave = @purchases_entry.slave_of_symbiont_pair
                                                                    @purchases_entry_master = @purchases_entry.master_of_symbiont_pair

                                                                   if @purchases_entry_slave
                                                                                logger.warn "%%%%%%%%% @purchases_entry_slave    @@@@@@@@@@@@@@@"
                                                                                logger.warn "%%%%%%%%% @purchases_entry_slave.Comment :     @@@@@@@@@@@@@@@ "  + @purchases_entry_slave.Comment
                                                                                if @purchases_entry_slave.Comment.size > 1
                                                                                                                            @breast_print_name = @purchases_entry_slave.Comment.split("_")[1]
                                                                                end
                                                                   end
                                                                    if @purchases_entry_master
                                                                                logger.warn "%%%%%%%%% @purchases_entry_master    @@@@@@@@@@@@@@@"
                                                                                logger.warn "%%%%%%%%% @purchases_entry_master.Comment    @@@@@@@@@@@@@@@ "  + @purchases_entry_master.Comment
                                                                                if  @purchases_entry_master.Comment.size > 1
                                                                                                        @breast_print_name = @purchases_entry_master.Comment.split("_")[1]
                                                                                end
                                                                    end

                                                                   logger.warn "%%%%%%%%% @breast_print_name:"  +  @breast_print_name.to_s
                                                                   @breast_print =   Item.find_by_PictureName @breast_print_name

                                            else
                                                                    logger.debug "DID NOT FIND CREST PRINT ATTACHED TO PURCHASES ENTRY"
                                                                    @items_front =         design.applicable_crest_prints
                                                                    @breast_print =  @items_front.first
                                            end
                                            if  @breast_print.class == Item
                                                                  @breast_print_name =    @breast_print.PictureName
                                            else
                                                                  @breast_print_name =    @breast_print.item.PictureName    if @breast_print
                                            end
                              # end
              end

              logger.debug "###############################################"
              logger.debug "@breast_print_name: "  +  @breast_print_name.to_s
              logger.debug "###############################################"

              @combination = Combination.find_combo(item, design)
              if @combination
                            @combination_height     =  @combination.height
                            @combination_left      =  @combination.left
                            @combination_top       =  @combination.top
                            @combination_bp_height =  @combination.bp_height
                            @combination_bp_left   =  @combination.bp_left
                            @combination_bp_top    =  @combination.bp_top
                            @item_prefix_override  =  @combination.item_prefix_override
              end
              logger.debug "##############################################"
              logger.debug "##############################################"
              logger.debug "##############################################"
              logger.debug "##############################################"
              logger.debug "##############################################"
              logger.debug "END prepare_combination_variables"
  end
###########################################################################################################
  def before_filter
    @sublimation_standard_category_class_ids = ["26", "27","15", "79"]
    # $request = request
    #CUSTOM_LOGGER.error("##############################")
    #CUSTOM_LOGGER.error("##############################")
    #CUSTOM_LOGGER.info("info from custom logger before_filter")
    #CUSTOM_LOGGER.debug("debug from custom logger before_filter")
    #CUSTOM_LOGGER.error("error from custom logger before_filter")
    #if @purchase
    #             CUSTOM_LOGGER.error("@purchase.ship_to_id.to_s"  + @purchase.ship_to_id.to_s    )
    #else
    #              CUSTOM_LOGGER.error("@purchase.ship_to_id.to_s"  + @purchase.ship_to_id.to_s    )
    #end
    #CUSTOM_LOGGER.info("------------------------------------------------")
  end

  def after_filter
            #$request = request
            #CUSTOM_LOGGER.info("info from custom logger after_filter")
            #CUSTOM_LOGGER.debug("debug from custom logger")
            #CUSTOM_LOGGER.error("error from custom logger after_filter")

            #if @purchase
                              #CUSTOM_LOGGER.error("@purchase.inspect" + @purchase.inspect )
                              #CUSTOM_LOGGER.error("@purchase.ship_to_id" + @purchase.ship_to_id.to_s  )
                              #CUSTOM_LOGGER.error("@purchase.shipping_service.inspect" + @purchase.shipping_service.inspect )
            #else
                            #CUSTOM_LOGGER.error("NOT @purchase"   )
            #end

            #CUSTOM_LOGGER.error("@user.inspect" + @user.inspect )
            #if @user
            #                 CUSTOM_LOGGER.error("@user.customer_id" + @user.customer_id.to_s )
            #else
            #                 CUSTOM_LOGGER.error(" NOT AT USER.. CAN'T FIND @user.customer_id"  )
            # end
            #CUSTOM_LOGGER.error("##############################")
            #CUSTOM_LOGGER.error("##############################")
  end


  ###########################################################################################################
  def current_layout
    layout = self.send(:_layout)
    if layout.instance_of? String
           layout
    else
            File.basename(layout.identifier).split('.').first
    end
  end
  ###########################################################################################################
   def redirect_unless_purchase_in_progress
    if @purchase
    else
      redirect_to(:controller => 'cart')
    end
  end

  def redirect_if_incomplete_symbiont
      if @purchase and @purchase.incomplete_symbiont
            redirect_to(:controller => 'cart')
      else

      end
  end

  def set_start_time
    @start_time = Time.now.usec
  end


def params_to_session
          logger.debug("flash.inspect: " + flash[:notice].inspect )
end


  def at_guides
          @guides = false
          #@development = true if Rails.env.development?   unless params[:development] == "false"
  end


  def show_admin?
      true
  end


  def controller_and_action_name
          controller_name + "#" + action_name
  end



  def mobile_device?
    #if session[:mobile_param]
    #  session[:mobile_param] == "1"
    #else
    #  request.user_agent =~ /Mobile|webOS/
    #end
    true
  end
  helper_method :mobile_device?

  #def prepare_for_mobile
  #  session[:mobile_param] = params[:mobile] if params[:mobile]
  #  request.format = :mobile if mobile_device?
  #end

 ########################################

 def self.caches_public_page(*actions)
   #logger.warn 'caches_public_page'
   return unless perform_caching
   actions.each do |action|
     class_eval "after_filter { |c| c.cache_page if !c.admin? and c.action_name == '#{action}' }"
   end
 end





def initialize_variables_except_store
        logger.debug "begin initialize_variables_except_store"
          warn_caching
          startup_security
          current_website
          startup_user
          startup_customer
          #before_log
          #store_startup
        startup_fragment_names
        logger.debug "end  initialize_variables_except_store"
          end


  def initialize_variables
          warn_caching
          startup_security
          current_website
          startup_user
          startup_customer
          before_log
          store_startup
          startup_fragment_names
end


  def warn_caching



    test_cache  =   Caching::MemoryCache.instance.read  'test_cache'
    if test_cache
                  logger.warn "TEST_CACHE READ SUCESS: " + test_cache
                  logger.warn "TEST_CACHE READ SUCESS: " + test_cache
                  logger.warn "TEST_CACHE READ SUCESS: " + test_cache
                  logger.warn "TEST_CACHE READ SUCESS: " + test_cache
    else
                  logger.warn "FAILED TO READ TEST_CACHE: "
                  logger.warn "FAILED TO READ TEST_CACHE: "
                  logger.warn "FAILED TO READ TEST_CACHE: "
                  logger.warn "FAILED TO READ TEST_CACHE: "
                  logger.warn "FAILED TO READ TEST_CACHE: "
                  logger.warn "FAILED TO READ TEST_CACHE: "
                  logger.warn "FAILED TO READ TEST_CACHE: "
                  logger.warn "FAILED TO READ TEST_CACHE: "
                  Caching::MemoryCache.instance.write  'test_cache', "YES!!!"
    end




logger.warn "request.remote_ip: " + request.remote_ip

if request.remote_ip == "127.0.0.1"
          logger.warn "###########################################################"
          logger.warn "request.inspect: " + request.inspect
          logger.warn "###########################################################"
          #logger.warn "REQUEST.server_name == 127.0.0.1"
          #logger.warn "REQUEST.server_name == 127.0.0.1"
         # bad_thin_error_server_name_for_page_cache_path
    end
  end



  def cache_on?
      return Rails.configuration.action_controller.perform_caching
  end

def store_startup
                  logger.warn "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                  logger.warn "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                  logger.warn "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                  logger.warn "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                  logger.warn "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                  logger.warn 'begin full_startup'
                  #startup_user_session
                  startup_purchase
                  startup_symbiont
                  startup_browsing
                  logger.warn 'end  full_startup'
                  logger.warn "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                  logger.warn "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                  logger.warn "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                  logger.warn "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                  logger.warn "&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
end


  def production_warnings
              if cache_on? == false
                  logger.warn "MANUAL CACHING IS OFF"
                  logger.warn "MANUAL CACHING IS OFF"
                  logger.warn "MANUAL CACHING IS OFF"
                  logger.warn "MANUAL CACHING IS OFF"
                  logger.warn "MANUAL CACHING IS OFF"
              end
  end



def restricted_controller_clearance
                         message = 'SECURITY RESTRICTED CONTROLLER CLEARANCE at route '  + controller_name +   ' /  ' + action_name
                        $stdout.puts 'message' + message
                        logger.warn ' message: ' + message
end


def level_public_clearance
                         message = 'SECURITY PUBLIC CLEARANCE at route '  + controller_name +   ' /  ' + action_name
                        $stdout.puts 'message' + message
                        logger.warn ' message: ' + message
end


def let_pass_without_error
             message = 'this request was let pass without security at route '  + controller_name +   ' /  ' + action_name
            $stdout.puts 'message' + message
            logger.warn ' message: ' + message
end


def manage_session_limit
          if   session[:last_seen]
                                      logger.debug "DESTROY SESSION-DESTROY SESSION-DESTROY SESSION-DESTROY SESSION"
                                      logger.debug "DESTROY SESSION-DESTROY SESSION-DESTROY SESSION-DESTROY SESSION"
                                      logger.debug "DESTROY SESSION-DESTROY SESSION-DESTROY SESSION-DESTROY SESSION"
                                      logger.debug "DESTROY SESSION-DESTROY SESSION-DESTROY SESSION-DESTROY SESSION"
                                      logger.debug "DESTROY SESSION-DESTROY SESSION-DESTROY SESSION-DESTROY SESSION"
                                      if session[:last_seen]  <  25.seconds.ago
                                                  @s = 's'
#                                                  reset_session
#                                                   my_reset_session #Rack::Session::Abstract::ID.my_reset_session     #2.minutes.ago
                                                  session[:last_seen]  = Time.now
                                      end
          else
                         session[:last_seen] = Time.now
          end
end



#http://stackoverflow.com/questions/2121671/ssl-with-ruby-on-rails


def development_address
        if  ['localhost', '192.168.0.122', '192.168.0.116', '192.168.0.21'].include?(request.remote_ip)
                 logger.debug "#########   ##########   DEVELOPMENT ADDRESS TRUE  ############"
                  true
        else
                  logger.debug "#########   ##########   DEVELOPMENT ADDRESS FALSE  ############"
                  false

        end
end


   def redirect_to_https

     ss = 'ss'
    redirect_to "#{request.env['REQUEST_URI'].gsub("http:", "https:")}" if !request.ssl? &&  !development_address
  end



  def reset_symbiont_department_id
      session[:symbiont_department_id] = "0"
  end


  def startup_fragment_names
        delete_session_symbiont_department_id_everywhere if params[:notes]
        logger.debug "BEGIN startup_fragment_names"
        @cached_page = true
        if session[:incomplete_symbiont]
              if  session[:purchase_symbiote_item_type] == 'slave'
                      if @item
                          @local_item_id = @item.id.to_s
                      elsif params[:item_id]
                          @local_item_id = params[:item_id]
                      else
                          @local_item_id = '0'
                      end
                      @local_design_id = session[:purchase_symbiote_item_id]
              else
                      if @design
                        @local_design_id = @design.id.to_s
                      elsif params[:item_id]
                        @local_design_id = params[:item_id]
                      else
                        @local_design_id = '0'
                      end
                      @local_item_id = session[:purchase_symbiote_item_id]
              end
        else
              if  params[:item_id]
                      @local_item_id = params[:item_id]
              else
                      @local_item_id = '0'
              end

              if @design
                      @local_design_id = @design.id.to_s
              elsif params[:design_id]
                      @local_design_id = params[:design_id]
              else
                      @local_design_id = '0'
              end
       end


        if params[:department_type]
          @local_department_type = params[:department_type]
        else
          @local_department_type = '0'
        end

        if session[:symbiont_department_id]
          @local_symbiont_department_id = session[:symbiont_department_id].to_s
          logger.debug "current @local_symbiont_department_id: " + @local_symbiont_department_id
        else
          @local_symbiont_department_id = '0'
        end

        if  params[:department_id]
          @local_department_id =  params[:department_id].to_s
        elsif @department
          @local_department_id = @department.id.to_s
        else
          @local_department_id = '0'
        end

        if params[:category_id]
          @local_category_id = params[:category_id]
        else
          @local_category_id = '0'
        end

        if session[:purchase_symbiote_item_category_id]
          @local_purchase_symbiote_item_category_id = session[:purchase_symbiote_item_category_id]
        else
          @local_purchase_symbiote_item_category_id = '0'
        end

        if session[:purchase_symbiote_item_category_category_class_id]
          @local_purchase_symbiote_item_category_category_class_id = session[:purchase_symbiote_item_category_category_class_id].to_s
        else
          @local_purchase_symbiote_item_category_category_class_id = '0'
        end

        if session[:purchase_symbiote_item_id]
            @local_purchase_symbiote_item_id = session[:purchase_symbiote_item_id]
        else
            @local_purchase_symbiote_item_id = '0'
        end

        if @user_array_user_type_id
          @local_user_array_user_type_id = @user_array_user_type_id
        else
          @local_user_array_user_type_id = '4'
        end

        if @purchase_symbiote_item_shade
          @local_purchase_symbiote_item_shade = @purchase_symbiote_item_shade
        else
          @local_purchase_symbiote_item_shade = '0'
        end

        if @purchase_symbiote_item_type
          @local_purchase_symbiote_item_type = @purchase_symbiote_item_type
        else
          @local_purchase_symbiote_item_shade = '0'
        end


        if @department_introduction
          @local_department_introduction = 'true'
        else
          @local_department_introduction = 'false'
        end

        if ['browse'].include?(controller_name)
             @local_choose_symbiont_item_below = 'true'
        else
            @local_choose_symbiont_item_below = 'false'
        end


        #@browse_fragment_name = @website.name  + "/browse/department_id/" + @local_department_id + "/category_id/" + @local_category_id + "/symbiote_item_category_category_class_id/" + @local_purchase_symbiote_item_category_category_class_id  + "/purchase_symbiote_item_shade/" + @local_purchase_symbiote_item_shade
        #@menu_organized_category_fragment_name = @website.name +  "/menu_organized_category/department_id/" + @local_department_id + "/category_id/" + @local_category_id + "/symbiote_item_category_category_class_id/" + @local_purchase_symbiote_item_category_category_class_id + "/department_introduction/" + @local_department_introduction.to_s
        #@head_fragment_name = @website.name + controller_name + "_" +  action_name
        #@header_fragment_name = @website.name + "/header/symbiote_item_category_category_class_id/" + @local_purchase_symbiote_item_category_category_class_id
        #@footer_fragment_name = @website.name + "/footer"

        #http://scottiestech.info/2011/07/23/fixing-the-rails-3-fragment-cache-path/
        #EXPIRING FRAGMENTS INSTRUCTIONS - http://scottiestech.info/2009/12/04/increase-the-performance-of-fragment-caching-in-rails/
        @browse_action_cache_name =                 "user_type_id/" + @user_array_user_type_id + "/browse/category_id/" + @local_category_id + "/symbiote_item_category_id/" + @local_purchase_symbiote_item_category_id.to_s + "/department_id/" + @local_department_id  + "/local_purchase_symbiote_item_id/" + @local_purchase_symbiote_item_id +  "/website/" + @website.name + "/department_type/" + @local_department_type
        @browse_fragment_name =                     "user_type_id/" + @user_array_user_type_id + "/browse/category_id/" + @local_category_id + "/symbiote_item_category_id/" + @local_purchase_symbiote_item_category_id.to_s + "/department_id/" + @local_department_id  +  "/website/" + @website.name + "/department_type/" + @local_department_type
        @menu_organized_category_fragment_name =    "user_type_id/" + @user_array_user_type_id + "/shared_menu/menu_organized_category/category_id/" + @local_category_id + "/symbiote_item_category_id/" + @local_purchase_symbiote_item_category_id.to_s + "/department_id/" + @local_department_id + "/department_introduction/" + @local_department_introduction.to_s  + "/website/" + @website.name
        @head_fragment_name =                       "user_type_id/" + @user_array_user_type_id + "/layout_elements/" + @website.name + "/head_for_controller_action/" + controller_name + "_" +  action_name
        @header_fragment_name =                     "user_type_id/" + @user_array_user_type_id + "/layout_elements/" + @website.name + "/header/symbiote_item_category_category_class_id/" + @local_purchase_symbiote_item_category_category_class_id + "/department_type/" + @local_department_type
        @footer_fragment_name =                     "user_type_id/" + @user_array_user_type_id + "/layout_elements/" + @website.name + "/footer"
        @symbiote_wrapper_container_fragment_name = "user_type_id/" + @user_array_user_type_id + "/shared_symbiont/symbiote_wrapper_container/symbiote_item_category_id/" + @local_purchase_symbiote_item_category_id.to_s + "/local_purchase_symbiote_item_id/" + @local_purchase_symbiote_item_id + "/choose_symbiont_item_below/" + @local_choose_symbiont_item_below  + "/website_id/" + @website.name
        @new_designs_cache_name =                 "views/new_designs_"   +  @website.name     + "_week_" + Website.week_number
        @sale_designs_cache_name =                 "views/sale_designs_"   +  @website.name     + "_week_" + Website.week_number
        @scroll_cache_name =                 "scroll/view_department_id_" + @local_department_id     +   "_singular_item_customer_" + @singular_item_customer.to_s  + "_" +  @website.name     + "_week_" + Website.week_number
        @panels_fragment_name =                 "layout_elements/panels/"     + @website.name     +   "_singular_item_customer_" + @singular_item_customer.to_s  +  "_week_" + Website.week_number
        # THIS NEEDS TO SEPARATE BASED ON THE MODEL GENDER
        # SPECSHEET IS ALSO SHOWING CHANGE SIZE/ COLOR WITH WRONG PURCHASES_ENTRY

        #@specsheet_fragment_name = 'cache/false'
        if params[:purchases_entry_id]
                  @specsheet_fragment_name = 'false'
        else
                  @specsheet_fragment_name = "specsheet/symbiont_department_id/" + @local_symbiont_department_id + "/symbiote_item_category_id/" + @local_purchase_symbiote_item_category_id.to_s + "/item_id/" + @local_item_id  + "/design_id/" + @local_design_id   + "/website/" + @website.name
        end



        begin
                     @pi = params[:pi] ||= '0'
                     @ri  = params[:ri] ||= '0'
                     @ol  = params[:ol] ||= '0'

                      @pages_tree_menu_fragment_name = @website.name + "/panel_articles/user_type_id/" + @user_array_user_type_id + "/customer_type/" + @customer_array_customer_type + "/root_id/" + @ri + "/parent_id/" + @pi + "/opened_leaf/" + @ol
      rescue
                     @pages_tree_menu_fragment_name = @website.name + "/panel_articles/pages_tree_menu_fragment_name_fragment_name_unknown"
      end



        logger.warn "controller:  @specsheet_fragment_name.inspect: " +  @specsheet_fragment_name.inspect
        logger.debug "end of @controller: symbiote_wrapper_container_fragment_name:" + @symbiote_wrapper_container_fragment_name
        logger.debug "END startup_fragment_names"
  end

  ###########################################################################################################
   def reset_incomplete_symbiont_status_found
    logger.warn "reset_incomplete_symbiont_status_found"
    logger.warn "reset_incomplete_symbiont_status_found"
    logger.warn "reset_incomplete_symbiont_status_found"
    logger.warn "reset_incomplete_symbiont_status_found"
    logger.warn "reset_incomplete_symbiont_status_found"
    logger.warn "reset_incomplete_symbiont_status_found"
    session[:reset_symbiont_status] = true
    reset_symbiont_department_id
  end







end



##atomic_cache_expire(true, 'C:\tmp\cache\views\symbiote_item_category_category_class_id\0\category_id\18' )
#def atomic_cache_expire(isfile, cachepath)
#  temp_str = '_expired_' + Time.now.to_i.to_s
#  g = 'g'
#  FileUtils.mv(   cachepath    , cachepath + temp_str, :force => true)
#  if isfile then
#    # expire individual file
#    FileUtils.rm_f(cachepath + temp_str)
#  else
#    # expire whole directory
#    FileUtils.rm_rf( cachepath + temp_str)
#  end
#end

#
#  def all_systems_startup
#    logger.debug 'begin all_systems_startup'
#    @custom_system = false
#    @designer = false
##            manage_session_limit
#    current_website
#    startup_user
#    startup_customer
#    before_log
##            production_warnings
#    if  @@minimal_startup_controllers.include?(controller_name)
#      logger.debug '@@minimal_startup_controllers'
#
#    elsif (request.xhr?) or @@no_startup_controllers.include?(controller_name)
#      logger.debug '(request.xhr?) or @@no_startup_controllers.include?(controller_name)'
#      ## this request is ajax, so limit the startup to keep it fast
#      ## need to insert ajax specific functions here
#    else
#      store_startup
#    end
#    logger.debug 'end all_systems_startup'
#  end
#
#
#
