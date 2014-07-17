module StoreAdminCacheCleaner
protected

############################################################################################################
def delete_page_cache(page_id)
		logger.warn "BEGIN -- lib/cache_cleaner/delete_page_cache(page_id)"
		logger.warn "-------CacheCleaner:delete_page_cache(category_id):category_id:#{page_id}:---------"
		page = Page.find(params[:page_id])
		page.delete_cache # Memory cache-
		#category.delete_fragments  # initializers/model_glob_cache_expire
		logger.warn "END -- lib/cache_cleaner/delete_page_cache(category_id)"
end


############################################################################################################
  def delete_category_cache(category_id)
    logger.warn "BEGIN -- lib/cache_cleaner/delete_category_cache(category_id)"
    logger.warn "-------CacheCleaner:delete_category_cache(category_id):category_id:#{category_id}:---------"
    category = Category.find(category_id)
    category.delete_cache # Memory cache-
    category.delete_fragments  # initializers/model_glob_cache_expire
    logger.warn "END -- lib/cache_cleaner/delete_category_cache(category_id)"
  end
############################################################################################################
def delete_cache_in_category_ids(category_ids_to_delete_cache)
		category_ids_to_delete_cache.each do |category_id|
				delete_category_cache(category_id)
		end
end
############################################################################################################
def automatically_expire_recently_added_pages
	logger.debug "BEGIN ------------------------------lib/startup_timed_sweeper/automatically_expire_recently_added_pages"
	if @next_daily_expire < Time.now.utc
		if @automatically_expire_recently_added_pages_last_date_expired != @last_daily_expire
			expire_recently_added_pages
			FMCache.write 'automatically_expire_recently_added_pages_last_date_expired', @last_daily_expire
		else
			logger.debug "------- RECENTLY ADDED PAGES CACHE ALREADY EXPIRED FOR THIS DATE ---------"
		end
	else
		logger.debug "-------------------------------------Not time to expire: recently_added_pages"
	end
		logger.debug "END --------------------------------lib/startup_timed_sweeper/automatically_expire_recently_added_pages"
end
############################################################################################################
def automatically_expire_fm_preloaded_items
	logger.debug "BEGIN ------------------------------lib/startup_timed_sweeper/automatically_expire_fm_preloaded_items"
	if @next_seven_hour_expire < Time.now.utc
				if @automatically_expire_fm_preloaded_items_last_date_expired != @last_seven_hour_expire
						expire_fm_preloaded_items
						FMCache.write 'automatically_expire_fm_preloaded_items_last_date_expired', @last_seven_hour_expire
				else
						logger.debug "------- FM PRELOADED ITEMS CACHE ALREADY EXPIRED FOR THIS DATE ---------"
				end
		else
				logger.debug "-------------------------------------Not time to expire: fm_preloaded_items ---------"
		end
		logger.debug "END --------------------------------lib/startup_timed_sweeper/automatically_expire_fm_preloaded_items"
end
############################################################################################################
def startup_session_expiry  #YOU MUST REDIRECT AFTER RESETTING SESSION OR YOU WILL GET INVAILID AUTHENTICITY TOKEN ERROR DEPRECATE THIS!!!
	logger.debug "BEGIN ----------------------------lib/startup_timed_sweeper/startup_session_expiry"
   if !session[:expiry_time].nil? and session[:expiry_time] < Time.now
      # Session has expired. Clear the current session.
      	if !session[:maximum_expiry_time].nil? and session[:maximum_expiry_time] > Time.now
      			#bypass resetting session by maximum_expiry_time
      	else
      		reset_session
  		end
   end
   # Assign a new expiry time, whether the session has expired or not.
   session[:expiry_time] = NORMAL_SESSION_TIME.seconds.from_now
   	logger.debug "END ------------------------------lib/startup_timed_sweeper/startup_session_expiry"
   return true
end
############################################################################################################

############################################################################################################
def cache_time_counting
		logger.debug "BEGIN -----------------------------lib/startup_timer/cache_time_counting"
		@next_two_week_expire = FMCache.read 'next_two_week_expire'
		FMCache.write 'next_two_week_expire', 2.weeks.from_now.utc if @next_two_week_expire.nil?
		@next_two_week_expire = 2.weeks.from_now.utc if @next_two_week_expire.nil?

		@last_two_week_expire = FMCache.read 'last_two_week_expire'
		FMCache.write 'last_two_week_expire', Time.now.utc if @last_two_week_expire.nil?
		@last_two_week_expire =  Time.now.utc if @last_two_week_expire.nil?

		@next_daily_expire = FMCache.read 'next_daily_expire'
		FMCache.write 'next_daily_expire',1.day.from_now.utc if @next_daily_expire.nil?
		@next_daily_expire = 1.day.from_now.utc if @next_daily_expire.nil?

		@last_daily_expire = FMCache.read 'last_daily_expire'
		FMCache.write 'last_daily_expire', Time.now.utc if @last_daily_expire.nil?
		@last_daily_expire =  Time.now.utc if @last_daily_expire.nil?

		@next_seven_hour_expire = FMCache.read 'next_seven_hour_expire'
		FMCache.write 'next_seven_hour_expire',7.hours.from_now.utc if @next_seven_hour_expire.nil?
		@next_seven_hour_expire = 7.hours.from_now.utc if @next_seven_hour_expire.nil?

		@last_seven_hour_expire = FMCache.read 'last_seven_hour_expire'
		FMCache.write 'last_seven_hour_expire', Time.now.utc if @last_daily_expire.nil?
		@last_seven_hour_expire =  Time.now.utc if @last_seven_hour_expire.nil?

		@automatically_expire_recently_added_pages_last_date_expired = FMCache.read 'automatically_expire_recently_added_pages_last_date_expired'
		@automatically_expire_fm_preloaded_items_last_date_expired = FMCache.read 'automatically_expire_fm_preloaded_items_last_date_expired'

		if @next_seven_hour_expire < Time.now.utc
			FMCache.write 'last_seven_hour_expire', @next_seven_hour_expire
			FMCache.write 'next_seven_hour_expire',  7.hours.from_now.utc
				if @next_daily_expire < Time.now.utc
					FMCache.write 'last_daily_expire', @next_daily_expire
					FMCache.write 'next_daily_expire',  1.day.from_now.utc
					if @next_two_week_expire < Time.now.utc
						FMCache.write 'last_two_week_expire', @next_two_week_expire
						FMCache.write 'next_two_week_expire', 2.weeks.from_now.utc
					end
				end
			end
			logger.debug "-------------------------------------Time.now: #{Time.now}"
			logger.debug "-------------------------------------@next_two_week_expire: #{@next_two_week_expire}"
			logger.debug "-------------------------------------@last_two_week_expire: #{@last_two_week_expire}"
			logger.debug "-------------------------------------@next_daily_expire:    #{@next_daily_expire}"
			logger.debug "-------------------------------------@last_daily_expire:    #{@last_daily_expire}"
			logger.debug "-------------------------------------@automatically_expire_recently_added_pages_last_date_expired: #{@automatically_expire_recently_added_pages_last_date_expired}"
			logger.debug "-------------------------------------@automatically_expire_fm_preloaded_items_last_date_expired: #{@automatically_expire_fm_preloaded_items_last_date_expired}"
			logger.debug "END --------------------------------lib/startup_timer/cache_time_counting"

end
############################################################################################################


############################################################################################################
def expire_fm_preloaded_items
	logger.warn "-------EXPIRING FILE STORE MEM CACHE ITEMS---------"
	logger.warn "-------EXPIRING FILE STORE MEM CACHE ITEMS---------"
	logger.warn "-------EXPIRING FILE STORE MEM CACHE ITEMS---------"#
	expire_fragment(%r{/views/preloaded_items/.*})
end
############################################################################################################	
def expire_recently_added_pages
	logger.warn "-------RECENTLY ADDED PAGES CACHE WAS DELETED---------"
	logger.warn "-------RECENTLY ADDED PAGES CACHE WAS DELETED---------"
	logger.warn "-------RECENTLY ADDED PAGES CACHE WAS DELETED---------"
	expire_fragment(%r{/views/#{@website.name}/user_type_id/.*/recently_added_pages/customer_type/.*})
end
############################################################################################################
##########################################  PROTECTED ####################################################
##########################################  PROTECTED ####################################################
def delete_acceptable_item_ids
 	Caching::MemoryCache.instance.delete @website.name + '_acceptable_item_ids'
 	flash[:notice] = "Acceptable Item Id's deleted"
	redirect_to :back
	logger.debug "------------------------------------- delete_acceptable_item_ids "
end
################################################################################################################# 
def delete_user_session_cache
		Caching::MemoryCache.instance.delete request.session_options[:id] + '_user_session'
end
############################################################################################################
def delete_user_cache
		Caching::MemoryCache.instance.delete request.session_options[:id] + '_user_' + @user.id.to_s if @user
end
############################################################################################################
def delete_customer_cache
		Caching::MemoryCache.instance.delete request.session_options[:id].to_s +  '_customer_' + session[:customer_id].to_s
end
############################################################################################################
def delete_purchase_cache
		Caching::MemoryCache.instance.delete request.session_options[:id] + '_purchase_' + session[:purchase_id].to_s if session[:purchase_id]
end
############################################################################################################

end



############################################################################################################
def delete_cache_in_departments(department_ids)
  deprecate
  departments = Department.find(:all, :conditions => ["id in (?)", department_ids])
  departments.each do |dept|
    dept.delete_categories_cache
    dept.delete_shared_menu_fragment
    dept.delete_department_categories_fragment
    dept.delete_department_items_fragment
  end
end
############################################################################################################