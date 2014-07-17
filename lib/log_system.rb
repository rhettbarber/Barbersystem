module LogSystem
  protected	


  def firebug(message,type = :debug)
    request.env['firebug.logs'] ||= []
    request.env['firebug.logs'] << [type.to_sym, message.to_s]
  end
############################################################################################################
def before_log
        logger.debug "NOTE: RAILS.cache remembers error like undefined class/module UserSession and must be restarted or that variable cleared. Very confusing error."
        logger.debug "BEGIN ---------------------------lib/log_system/before_log"
        logger.debug "-------------------------------------Rails.cache: #{Rails.cache}"
        logger.debug "-------------------------------------ENV[RAILS_ENV]: #{ENV["RAILS_ENV"]}"

        logger.debug "-------------------------------------session[:user].nil?: #{session[:user].nil?} "
        logger.debug '--------------------------------------request.remote_ip:  ' + request.remote_ip
        logger.debug '--------------------------------------cache_on?:   ' + cache_on?.to_s
        logger.debug '-------------------------------------- params[:cache_off]   ' +  params[:cache_off].to_s
        logger.debug "END -------------------------------lib/log_system/before_log"
end
############################################################################################################
def before_view_log
          logger.debug "BEGIN ---------------------------lib/log_system/before_view_log"
          logger.debug "-------------------------------------@website:#{@website}"
          logger.debug "-------------------------------------@website.name:#{@website.name}"     if @website
          logger.debug "-------------------------------------cache_on?: #{cache_on?}"
          logger.debug "-------------------------------------@departments.size: #{@departments.size}" if @departments
          logger.debug "-------------------------------------@categories.size: #{@categories.size}" if @categories
          logger.debug "-------------------------------------@items.size: #{@items.size}" if @items
          logger.debug "-------------------------------------@department: #{@department}"
          logger.debug "-------------------------------------@category: #{@category}"
          logger.debug "-------------------------------------@item: #{@item}"
          logger.debug "-------------------------------------@customer.PriceLevel: #{@customer.PriceLevel}" if @customer
          logger.debug "-------------------------------------@purchase: #{@purchase}"
          logger.debug "-------------------------------------@incomplete_symbiont: #{@incomplete_symbiont}"
          logger.debug "-------------------------------------@user_array_user_type_id: #{@user_array_user_type_id }"
          logger.debug "-------------------------------------@purchase_symbiote_item_category_category_class_id: #{@purchase_symbiote_item_category_category_class_id }"
          logger.debug "-------------------------------------@purchase_symbiote_item_shade: #{@purchase_symbiote_item_shade }"
          logger.debug "-------------------------------------@customer_array: #{@customer_array}"
          logger.debug "-------------------------------------@customer_array.CustomText4: #{@customer_array.CustomText4 }"
          logger.debug "-------------------------------------@customer_array.PriceLevel: #{@customer_array.PriceLevel}"
          logger.debug "-------------------------------------@customer_array_viewable_page_types: #{@customer_array_viewable_page_types}"
          logger.debug "-------------------------------------@customer_array_customer_type: #{@customer_array_customer_type}"
          logger.debug "-------------------------------------@customer_price_level: #{@customer_price_level}"
          logger.debug "-------------------------------------@customer_current_discount: #{@customer_current_discount}"
          logger.debug "-------------------------------------@customer_type: #{@customer_type}"
          logger.debug "-------------------------------------@customer.PriceLevel: #{@customer.PriceLevel }" if @customer
          logger.debug "-------------------------------------@licensed_for: #{@licensed_for}"
          logger.debug "-------------------------------------@customer_array: #{@customer_array}"
          logger.debug "-------------------------------------@singular_item_customer: #{@singular_item_customer}"
          logger.debug "END ------------------------------lib/log_system/before_view_log"
end
############################################################################################################
############################################################################################################
#def after_log  # THIS WOULD MESS UP INSTANCE VARIABLES AS-NEEDED
#          logger.debug "BEGIN ---------------------------lib/log_system/after_log"
#          logger.debug "-------------------------------------cache_on?: #{cache_on?}"
#          logger.debug "-------------------------------------@departments.size: #{@departments.size}" if @departments
#          logger.debug "-------------------------------------@categories.size: #{@categories.size}" if @categories
#          logger.debug "-------------------------------------@items.size: #{@items.size}" if @items
#          logger.debug "-------------------------------------@department: #{@department}"
#          logger.debug "-------------------------------------@category: #{@category}"
#          logger.debug "-------------------------------------@item: #{@item}"
#          logger.debug "-------------------------------------@customer.PriceLevel: #{@customer.PriceLevel}" if @customer
#          logger.debug "-------------------------------------@purchase: #{@purchase}"
#          logger.debug "-------------------------------------@incomplete_symbiont: #{@incomplete_symbiont}"
#          logger.debug "-------------------------------------@user_array_user_type_id: #{@user_array_user_type_id }"
#          logger.debug "-------------------------------------@purchase_symbiote_item_category_category_class_id: #{@purchase_symbiote_item_category_category_class_id }"
#          logger.debug "-------------------------------------@purchase_symbiote_item_shade: #{@purchase_symbiote_item_shade }"
#          logger.debug "END ------------------------------lib/log_system/after_log"
#end
############################################################################################################




############################################################################################################
def  current_log_position
          logger.warn "||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR ||"
          logger.warn "||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR ||"
          logger.warn "||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR ||"
          logger.warn "||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR ||"
          logger.warn "||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR ||"
          logger.warn "||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR ||"
          logger.warn "||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR || ||CURRENT ERROR ||"
end
#############################################################################################################
def  large_error_block
          logger.warn "||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! ||"
          logger.warn "||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! ||"
          logger.warn "||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! ||"
          logger.warn "||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! ||"
          logger.warn "||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! ||"
          logger.warn "||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! ||"
          logger.warn "||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! || ||ATTENTION! ||"
end
#############################################################################################################
#############################################################################################################
def  red_alert
          logger.warn "||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! ||"
          logger.warn "||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! ||"
          logger.warn "||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! ||"
          logger.warn "||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! ||"
          logger.warn "||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! ||"
          logger.warn "||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! ||"
          logger.warn "||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! || ||RED ALERT! ||"
end
#############################################################################################################




end
