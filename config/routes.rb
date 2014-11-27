#require 'website_routing_constraint.rb'


ThreeTwoThree::Application.routes.draw do

  match "item_reports/designs_by_department", :controller => 'item_reports', :action => 'designs_by_department'
  #

  match 'features/carousel/:feature_name' , :controller => 'features', :action => 'carousel'
  match 'features/list/:name' , :controller => 'features', :action => 'list'
  match 'features/:id/destroy/:item_id' , :controller => 'features', :action => 'destroy'
  match 'features/create/' , :controller => 'features', :action => 'create'
  match 'features/update/' , :controller => 'features', :action => 'update'
  match 'features/:id/show/:item_id' , :controller => 'features', :action => 'show'
  match 'features/new/:item_id' , :controller => 'features', :action => 'new'
  match 'features/:id/edit/:item_id' , :controller => 'features', :action => 'edit'

  match 'features/:item_id' , :controller => 'features', :action => 'index'
  match 'features' , :controller => 'features', :action => 'index'

  # resources :features


  match "promo/:promo", :to => redirect("/p/new-home")


  match "p/home", :to => 'page#show_page_on_index', :page_id  => 'new-home'

  match "featured_items/list", :to => 'featured_items#list'


  resources :featured_items


  #match '*_store', :controller => 'store', :action => 'category_items'
  match '*_store/view_details', :controller => 'specsheet', :action => 'index'
  #match '*_store/browse', :controller => 'store', :action => 'category_items'


  match '/new_designs' , :controller => 'store', :action => 'new_designs'
  match '/sale_designs' , :controller => 'store', :action => 'sale_designs'


  match 'quote_tender_entries/check', :controller => 'quote_tender_entries', :action => 'check'
  match 'quote_tender_entries/credit_card', :controller => 'quote_tender_entries', :action => 'credit_card'
  match 'quote_tender_entries/net_30', :controller => 'quote_tender_entries', :action => 'net_30'
  match 'quote_tender_entries/cod_money_order_cashiers_check', :controller => 'quote_tender_entries', :action => 'cod_money_order_cashiers_check'
  match 'quote_tender_entries/cod_check', :controller => 'quote_tender_entries', :action => 'cod_check'
  match 'ship_tos/choose_ship_to', :controller => 'ship_tos', :action => 'choose_ship_to'
  match 'ship_tos/shipping_services', :controller => 'ship_tos', :action => 'shipping_services'
  match 'ship_tos/set_shipping_charge_on_order/:shipping_service_id', :controller => 'ship_tos', :action => 'set_shipping_charge_on_order'

  match 'ship_tos/show_chosen', :controller => 'ship_tos', :action => 'show_chosen'
  resources   :ship_tos, :customers, :quote_tender_entries


  ###################################################   BEGIN  WEBSITE ROUTING CONSTRAINT
  ###################################################   BEGIN  WEBSITE ROUTING CONSTRAINT
  ###################################################   BEGIN  WEBSITE ROUTING CONSTRAINT
  ###################################################   BEGIN  WEBSITE ROUTING CONSTRAINT
  ###################################################   BEGIN  WEBSITE ROUTING CONSTRAINT
  constraints(WebsiteRoutingConstraint) do

    match '/customer_item_sales_by_years' , :controller => 'customer_item_sales_by_years', :action => 'index'
    resources :item_sales

    #match 'breast_prints/ajax_breast_prints_list', :controller => 'breast_prints', :action => 'ajax_breast_prints_list'
    #match "cache/delete_opposites_cache_for_a_category", :controller => 'cache', :action => 'delete_opposites_cache_for_a_category'
    #match "cache/delete_category_cache", :controller => 'cache', :action => 'delete_category_cache'
    #match "cache/delete_category_cache_and_return/:category_id", :controller => 'cache', :action => 'delete_category_cache_and_return'
    #match "cache/delete_opposites_cache_for_a_category", :controller => 'cache', :action => 'delete_opposites_cache_for_a_category'
    #match 'categories/ajax_category_update', :controller => 'categories', :action => 'ajax_category_update'
    #match 'categories/update', :controller => 'categories', :action => 'update'
    #match 'categories/department_properties', :controller => 'categories', :action => 'department_properties'
    #match 'categories/new_department', :controller => 'categories', :action => 'new_department'
    #match 'categories/category_properties', :controller => 'categories', :action => 'category_properties'
    #match 'categories/hide_category', :controller => 'categories', :action => 'hide_category'
    #match 'categories/unhide_category', :controller => 'categories', :action => 'unhide_category'
    #match 'categories/duplicate_category', :controller => 'categories', :action => 'duplicate_category'
    #match 'categories/new_category', :controller => 'categories', :action => 'new_category'
    #match 'category_classes/update', :controller => 'category_classes', :action => 'update'
    #match 'clone_item_requests/show_unfinished_rms_by_type' , :controller => 'clone_item_requests', :action => 'show_unfinished_rms_by_type'
    #match 'clone_item_requests/show_unfinished_files_by_type' , :controller => 'clone_item_requests', :action => 'show_unfinished_files_by_type'
    #match 'clone_item_requests/summary' , :controller => 'clone_item_requests', :action => 'summary'

    #get "crawl/index"
    #match 'crawl' => 'crawl#index'
    #get "crawl/start"
    #get "cart/test"


    #match 'quickbooks', :controller => 'quickbooks', :action => 'index'
    ########### NEED A IP BASED CONSTRAINT
    get "films/VideoCapture"
    match "/test", :controller => 'test', :action => 'index' #, :constraints => WebsiteRoutingConstraint
    match "films/search", :controller => 'films', :action => 'search'
    match "films/camerasnap", :controller => 'films', :action => 'camerasnap'
    match "films/camerasnap_update", :controller => 'films', :action => 'camerasnap_update'
    resources  :films

    #match  'javascripts/dynamic_department_categories.js', :controller => 'javascripts', :action => 'dynamic_department_categories'
    #match 'item_manager/ajax_choose_item_type' , :controller => 'item_manager', :action => 'ajax_choose_item_type'
    #match "item_manager/linked_index", :controller => 'item_manager', :action => 'linked_index'
    #match 'item_manager/item_details' , :controller => 'item_manager', :action => 'item_details'
    #match 'item_manager/rename_using_next_core_and_alias_the_old_item' , :controller => 'item_manager', :action => 'rename_using_next_core_and_alias_the_old_item'
    #match 'item_manager/request_clone_item_creation' , :controller => 'item_manager', :action => 'request_clone_item_creation'
    #match 'item_manager/update_items_listing' , :controller => 'item_manager', :action => 'update_items_listing'
    #match "item_reports/items_keyworder", :controller => 'item_reports', :action => 'items_keyworder'
    #match "item_reports/designs_numerically", :controller => 'item_reports', :action => 'designs_numerically'
    #match "item_reports/designs_by_department", :controller => 'item_reports', :action => 'designs_by_department'
    #match "items/update_and_back", :controller => 'item_reports', :action => 'update_and_back'
    #match "items/update_and_send_back", :controller => 'items', :action => 'update_and_send_back'
    #
    #match 'menus/hide_additive_categories',  :controller => 'menus', :action => 'hide_additive_categories'
    #match 'menus/show_additive_categories',  :controller => 'menus', :action => 'show_additive_categories'
    #match 'menus/hide_category_opposites',  :controller => 'menus', :action => 'hide_category_opposites'
    #match 'menus/show_category_opposites',  :controller => 'menus', :action => 'show_category_opposites'
    #match 'menus/link_opposites_using_hash', :controller => 'menus', :action => 'link_opposites_using_hash'
    #match 'menus/unlink_opposites_using_hash', :controller => 'menus', :action => 'unlink_opposites_using_hash'
    #match 'menus/menu_category_invisible', :controller => 'menus', :action => 'menu_category_invisible'
    #match 'menus/menu_category_visible', :controller => 'menus', :action => 'menu_category_visible'
    #match 'menus/remove_from_additives_from_link', :controller => 'menus', :action => 'remove_from_additives_from_link'
    #match 'menus/add_to_additives_from_link', :controller => 'menus', :action => 'add_to_additives_from_link'
    #
    #match 'opposites/add_category_into_opposites', :controller => 'opposites', :action => 'add_category_into_opposites'
    #match 'opposites/align_category_to_selected_category', :controller => 'opposites', :action => 'align_category_to_selected_category'
    #
    #
    #match "opposites/all_categories_with_same_prefix", :controller => 'opposites', :action => 'all_categories_with_same_prefix'
    #match "opposites/all_categories_in_this_class", :controller => 'opposites', :action => 'all_categories_in_this_class'
    #match "opposites/define_category_class_opposite_categories", :controller => 'opposites', :action => 'define_category_class_opposite_categories'
    #match "opposites/category_class_organizer", :controller => 'opposites', :action => 'category_class_organizer'
    #match "opposites/list_all_items_in_this_category", :controller => 'opposites', :action => 'list_all_items_in_this_category'
    #
    #match "opposites/remove_category_from_opposites", :controller => 'opposites', :action => 'remove_category_from_opposites'
    #
    #
    #match "test/last_core_number", :controller => 'test', :action => 'last_core_number'
    #match "test/sprites", :controller => 'test', :action => 'sprites'
    #get "admin_links/index"
    #match "breast_prints/ajax_change_breast_print_departments", :controller => 'breast_prints', :action => 'ajax_change_breast_print_departments'
    #match "breast_prints/select_departments", :controller => 'breast_prints', :action => 'select_departments'


    #match 'users/items_keyworder', :controller => 'users', :action => 'items_keyworder'
    #match 'users/update_item_notes', :controller => 'users', :action => 'update_item_notes'
    #match 'users/find_user_by_email/:id', :controller => 'users', :action => 'find_user_by_email'
    #match 'users/confirm_find_user_by_email', :controller => 'users', :action => 'confirm_find_user_by_email'
    #match 'users/confirm_password_reset', :controller => 'users', :action => 'confirm_password_reset'
    #match 'users/confirm_credit_card', :controller => 'users', :action => 'confirm_credit_card'
    #match 'users/edit_credit_card/:id', :controller => 'users', :action => 'edit_credit_card'
    #match 'users/reset_password_to_accountnumber/:id', :controller => 'users', :action => 'reset_password_to_accountnumber'
    #match 'users/rms_tips', :controller => 'users', :action => 'rms_tips'
    #match 'users/confirm_sort_purchase_entries_by_itemlookupcode', :controller => 'users', :action => 'confirm_sort_purchase_entries_by_itemlookupcode'
    #match 'users/finished_sorting', :controller => 'users', :action => 'finished_sorting'
    #match 'users/list_catalog_requests_for_time_period', :controller => 'users', :action => 'list_catalog_requests_for_time_period'
    #match 'users/associate_user_to_customer', :controller => 'users', :action => 'associate_user_to_customer'
    #match 'users/confirm_associate_user_to_customer', :controller => 'users', :action => 'confirm_associate_user_to_customer'
    #match 'users/create_user_from_existing_customer/:id', :controller => 'users', :action => 'create_user_from_existing_customer'
    #match 'users/new_user_from_existing_customer', :controller => 'users', :action => 'new_user_from_existing_customer'
    #match 'users/new_user_and_customer', :controller => 'users', :action => 'new_user_and_customer'
    #match 'users/show_user_and_customer', :controller => 'users', :action => 'show_user_and_customer'
    #match 'users/edit_user_and_customer', :controller => 'users', :action => 'edit_user_and_customer'
    #match 'users/items_index', :controller => 'users', :action => 'items_index'
    #match 'users/export_catalog_requests_to_csv', :controller => 'users', :action => 'export_catalog_requests_to_csv'

    #resources :advanced_combinations,:websites,:test, :item_manager, :item_reports, :designer, :record_groups, :advancements,:item_sales_reports, :breast_prints, :clone_item_types,:clone_item_requests, :category_classes, :categories
    #resources  :categories, :items, :custom_items ,:combinations, :users, :department_browser, :reports
  end
           ###################################################   END WEBSITE ROUTING CONSTRAINT
           ###################################################   END WEBSITE ROUTING CONSTRAINT
           ###################################################   END WEBSITE ROUTING CONSTRAINT
           ###################################################   END WEBSITE ROUTING CONSTRAINT
           ###################################################   END WEBSITE ROUTING CONSTRAINT





  match 'store/close_window/' => 'store#close_window'



    # http://192.168.0.125:2001/s/54/2/4378
  match 's/:item_id/:department_id/:design_id' => 'specsheet#index'



  match 'specsheet/crest_prints_list/:main_design_id' => 'specsheet#crest_prints_list'
  match 'specsheet/crest_prints_list' => 'specsheet#crest_prints_list'







  match "p/delete_static_page_cache/:page_id", :controller => "page", :action => "delete_static_page_cache"


  match "index" => 'page#show_page_on_index', :page_id  => 'new-home'


  match "search/scroll/:department_id/:page", :controller => "search", :action => "scroll"
  match "search/scroll/:department_id", :controller => "search", :action => "scroll"
  match "search/scroll", :controller => "search", :action => "scroll"
  match "specsheet/admin_crest_prints_list/:main_design_id", :controller => "specsheet", :action => "admin_crest_prints_list"
  match "specsheet/update_crest_prints_list", :controller => "specsheet", :action => "update_crest_prints_list"
  match "specsheet/crest_prints_list/:main_design_id", :controller => "specsheet", :action => "crest_prints_list"
  match "specsheet/update_specsheet", :controller => "specsheet", :action => "update_specsheet"
  match 'view_details/:item_id/:department_id' => 'specsheet#index'
  match 'view_details'  => 'specsheet#index'
  match 'specsheet/:item_id/:department_id/:category_id' => 'specsheet#index'
  match 'specsheet/:item_id' => 'specsheet#index'
  match 'specsheet' => 'specsheet#index'
  match 'store/category_items_menu' => 'store#category_items_menu'
  match 'store/department_category_list/:department_id/item_type/:item_type/show/:show' => 'store#department_category_list'
  match 'store/ajax_browse' => 'store#ajax_browse'


  match 'store/browse' => 'store#browse'
  match 'store/category_items/:department_id/:category_id' => 'store#category_items'
  match 'store/category_items' => 'store#category_items_menu'
  match 'store/category_items/:department_id/:category_id' => 'store#category_items'
  match 'store/category_items/:department_id' => 'store#category_items'
  match 'store/category_items/' => 'store#category_items'
  match 'store/departments_containing_categories' => 'store#departments_containing_categories'
  match 'store/select_category/:department_id' => 'store#select_category'
  match 'store/select_department' => 'store#select_department'
  match 'store/index' => 'store#category_items'
  match 'store/items_menu' => 'store#items_menu'
  match 'store/jquery_data' => 'store#jquery_data'
  match 'store/design' => 'store#design'
  match 'store/merchandise' => 'store#merchandise'
  match 'store/modal' => 'store#modal'
  match 'store/grid' => 'store#grid'
  match 'store/item' => 'store#item'
  match 'store/specsheet/:item_id' => 'store#specsheet'
  match 'store/update_advanced_combination/:id' => 'store#update_advanced_combination'
  match 'store/test' => 'store#test'
  match 'store' => 'store#category_items'
  match 'dixie_store/category_browser' => 'store#category_items'
  match 'dixie_store/browse' => 'store#category_items'
  match 'dixie_store' => 'store#category_items'
  match 'purchases/checkout_receipt', :controller => 'purchases', :action => 'checkout_receipt'
  match 'purchases/checkout_review', :controller => 'purchases', :action => 'checkout_review'
  match 'purchases/complete_order', :controller => 'purchases', :action => 'complete_order'
  match 'purchases/cancel_order', :controller => 'purchases', :action => 'cancel_order'
  #match 'purchases/:id', :controller => 'purchases', :action => 'update'


  resources  :purchases


  ############################################################################################
  ############################################################################################  PRIORITY CONSTRAINED ROUTES.. MUST BE ABOVE RESTFUL ROUTES.
  #constraints(WebsiteRoutingConstraint) do
  #
  #    match "page/add", :controller => "page", :action => "add"
  #    match "page/update_page_positions", :controller => "page", :action => "update_page_positions"
  #    match "page/create", :controller => "page", :action => "create"
  #    match "page/create_websites_first_page_and_revision", :controller => "page", :action => "create_websites_first_page_and_revision"
  #    match "page/edit_revision/:revision_id", :controller => "page", :action => "edit"
  #    match "page/publish", :controller => "page", :action => "publish"
  #    match "page/remove", :controller => "page", :action => "remove"
  #    match "page/revision", :controller => "page", :action => "revision"
  #    match "page/revisions", :controller => "page", :action => "revisions"
  #    match "page/remove_orphaned_page", :controller => "page", :action => "remove_orphaned_page"
  #    match "page/remove_private_user", :controller => "page", :action => "remove_private_user"
  #    match "page/show/:revision_id", :controller => "page", :action => "show"
  #    match "page/add_private_user", :controller => "page", :action => "add_private_user"
  #    match "page/reorder", :controller => "page", :action => "reorder"
  #    match "page/rollback", :controller => "page", :action => "rollback"
  #    match "page/unpublish", :controller => "page", :action => "unpublish"
  #
  #
  #end
  ############################################################################################
  ############################################################################################
  get "account/index"
  get "account/login"
  get "account/logout"
  get "account/send_message_to_selected"
  get "account/signup"
  match  'account/signup_action', :controller => 'account', :action => 'signup_action'
  match  'account/edit_password', :controller => 'account', :action => 'edit_password'
  match "account/forgot_password", :controller => 'account', :action => 'forgot_password'
  match "account/reset_password/:id", :controller => 'account', :action => 'reset_password'
  match "account/reset_password", :controller => 'account', :action => 'reset_password'
  match "account/reset_link_was_sent", :controller => 'account', :action => 'reset_link_was_sent'
  match 'account/login', :controller => 'account', :action => 'login'
  match 'account/newsletter_subscriber', :controller => 'account', :action => 'newsletter_subscriber'
  match 'account/wholesale_only_website', :controller => 'account', :action => 'wholesale_only_website'
  match  '/account', :controller => 'account', :action => 'index'
  match "add_to_cart", :controller => "cart", :action => 'add_to_cart'
  #match 'affiliates', :controller => 'affiliates', :action => 'index'
  #match "affiliates/compensation_report", :controller => "affiliates", :action => 'compensation_report'
  #match "affiliates/email_templates", :controller => "affiliates", :action => 'email_templates'
  #match "affiliates/links_and_banners", :controller => "affiliates", :action => 'links_and_banners'
  #match "affiliates/how_it_works", :controller => "affiliates", :action => 'how_it_works'
  #match "affiliates/terms_and_conditions", :controller => "affiliates", :action => 'terms_and_conditions'
  #match "affiliates/version_information", :controller => "affiliates", :action => 'version_information'
  match "search/:search_type_name/:query", :controller => 'search', :action => 'index'
  match "search", :controller => 'search', :action => 'index'
  match 'breast_prints/ajax_update_crest_print_status', :controller => 'breast_prints', :action => 'ajax_update_crest_print_status'
  match "/cart/add_to_cart", :controller => "cart", :action => 'add_to_cart'
  match 'cart/ajax_add_to_cart_combo', :controller => 'cart', :action => 'ajax_add_to_cart_combo'
  match "/cart", :controller => 'cart', :action => 'index'
  match "cart/complete_this_combination/:purchases_entry_id", :controller => 'cart', :action => 'complete_this_combination'
  match 'cart/delete_all_purchases_entries', :controller => 'cart', :action => 'delete_all_purchases_entries'
  match 'cart/delete_all_on_hold_items', :controller => 'cart', :action => 'delete_all_on_hold_items'
  match 'cart/delete_purchases_entry/:purchases_entry_id', :controller => 'cart', :action => 'delete_purchases_entry'
  get 'cart/delete_incomplete_symbiote'
  get 'cart/delete_symbiont_purchases_entry'
  match 'cart/enlarge_cart_image', :controller => 'cart', :action => 'enlarge_cart_image'
  get 'cart/next_checkout_step'
  get 'cart/place_incomplete_symbiont_on_hold'
  get 'cart/place_symbiont_on_hold'
  get 'cart/show_discount_info'
  match 'cart/show_cc_code_info', :controller => 'cart', :action => 'show_cc_code_info'
  match 'categories/departments_categories', :controller => 'categories', :action => 'departments_categories'
  match 'categories/ajax_remove_from_additives', :controller => 'categories', :action => 'ajax_remove_from_additives'
  match 'categories/ajax_add_to_additives', :controller => 'categories', :action => 'ajax_add_to_additives'
  match 'commission/report', :controller => 'commission', :action => 'report'
  match 'commission/commission_items', :controller => 'commission', :action => 'commission_items'
  match  'custom_items/create', :controller => 'custom_items', :action => 'create'
  match  'custom_items/destroy_remote/:id', :controller => 'custom_items', :action => 'destroy_remote'
  match "custom_items/create_via_ajax", :controller => 'custom_items', :action => 'create_via_ajax'
  match  'customers/show', :controller => 'customers', :action => 'show'
  get 'help/help_popup'
  get "help/opacity_help_popup"

  match "items/image_availability_noimage", :controller => 'items', :action => 'image_availability_noimage'
  match "items/image_availability_picturename", :controller => 'items', :action => 'image_availability_picturename'
  get 'javascripts/dynamic_categories(.:format)'


  match 'order_tracking', :controller => 'order_tracking', :action => 'index'
  get "order_tracking/index"
  get "order_tracking/checkout_review"
  match "order_tracking/show_order", :controller => "order_tracking", :action => 'show_order'
  get "order_tracking/this_order"
  match "cache/delete_page_cache_and_return/:page_id", :controller=>"cache", :action=>"delete_page_cache_and_return"





  match "page/test", :controller => "page", :action => "test"


  match "page/delete/:page_id", :controller => "page", :action => "delete"

  match "page/new/:parent_id", :controller => "page", :action => "new"
  #
  #
  #match "page/edit", :controller => "page", :action => "edit"
  match "page/edit/:page_id", :controller => "page", :action => "edit"

  resources :page


  match "p/test", :controller => "page", :action => "test"
  match "p/interesting-email", :controller => "page", :action => "recently_added_email"
  match "p/heritage-news", :controller => "page", :action => "recently_added_news"
  match "p/recently-added/:page", :controller => "page", :action => "recently_added_pages"
  match "p/recently-added", :controller => "page", :action => "recently_added_pages"
  match "p/resources", :controller => "page", :action => "resources"
  match "page/news", :controller => "page", :action => "recently_added_news"



  match "p/pages_navigation/:page_id", :controller => "page", :action => "pages_navigation"



  # match "p/pages_navigation/:page_id/:scope_by_page_id", :controller => "page", :action => "pages_navigation"
  # match "p/pages_navigation/:scope_by_page_id", :controller => "page", :action => "pages_navigation"


  match 'p/shopping', :to => redirect("/store/category_items")

  # match "page/:page_id/:scope_by_page_id", :controller => "page", :action => "show_page_on_index"
  match "page/:page_id", :controller => "page", :action => "show_page_on_index"

  # match "p/:page_id/:scope_by_page_id", :controller => "page", :action => "show_page_on_index"
  match "p/:page_id", :controller => "page", :action => "show_page_on_index"


  match "c/p/:page_id", :controller => "page", :action => "show_page_on_index"
  match "c/p/", :controller => "page", :action => "show_page_on_index"

  match "p/", :controller => "page", :action => "show_page_on_index"
  match 'page/recently-added', :controller => 'page', :action => 'recently_added_pages'






  ############################################################################################
  ############################################################################################



  resources  :page

  # match "/christian_store/category_browser(/department/:department_id)(/category/:category_id)", :to => "browse#index"
  # match "/christian_store(/department/:department_id)(/category/:category_id)", :to => "browse#index"
  # match "/christian_store(/department/:department_id)(/category/:category_id)", :to => "browse#index"



  root :to => 'page#show_page_on_index', :page_id  => 'new-home'

  # match "*" , :controller => 'page', :action => 'show_page_on_index'  ,  :page_id  => 'new-home'

  # match "*" , 'page/show_page_on_index/new-home'

  match '*a', :to => 'page#show_page_on_index'

end



#get "bootstrap/components"
#get "bootstrap/css"
#get "bootstrap/development"
#get "bootstrap/experiment"
#get "bootstrap/getting_started"
#match 'bootstrap' => 'bootstrap#index'
#get "bootstrap/javascript"
#get "bootstrap/production"
#match 'bootstrap' => 'bootstrap#index'

#match '/specsheet(/department/:department_id)(/item/:item_id)(/item_type/:item_type)(/purchases_entry/:purchases_entry_id)' =>'specsheet#index'
#match '/specsheet' =>  'specsheet#index'
#match "/specsheet/update_specsheet", :controller => 'specsheet'  ,:action =>    "update_specsheet"
#match "*" , :controller => 'redirect', :action => 'reroute'
#match "/application/view_details(/department/:department_id)(/category/:category_id)", :to => "specsheet#index"

#match 'designer_specsheet/ajax_administer_size_and_position' => 'designer_specsheet#ajax_administer_size_and_position'
#match 'designer_specsheet/ajax_administer_breast_prints_list' => 'designer_specsheet#ajax_administer_breast_prints_list'
#match 'designer_specsheet/ajax_administer_edit_item' => 'designer_specsheet#ajax_administer_edit_item'
#match 'designer_specsheet/ajax_change_product_choice' => 'designer_specsheet#ajax_change_product_choice'
#match 'designer_specsheet/ajax_item_details' => 'designer_specsheet#ajax_item_details'
#match 'designer_specsheet/ajax_item_update' => 'designer_specsheet#ajax_item_update'
#match 'designer_specsheet/different_department_item_chosen_update_category' => 'designer_specsheet#different_department_item_chosen_update_category'
#match 'designer_specsheet/modal' => 'designer_specsheet#modal'
#match 'designer_specsheet/select_list_update_category_back' => 'designer_specsheet#select_list_update_category_back'
#match 'designer_specsheet/select_list_update_category_product' => 'designer_specsheet#select_list_update_category_product'
#match 'designer_specsheet' => 'designer_specsheet#index'
#match 'designer_specsheet/update_categories' => 'designer_specsheet#update_categories'



#match "designer_specsheet/ajax_change_product_choice", :controller => 'designer_specsheet', :action => 'ajax_change_product_choice'
#match "designer_specsheet/ajax_item_details", :controller => 'designer_specsheet', :action => 'ajax_item_details'
#match 'designer_specsheet/ajax_item_update',  :controller => 'designer_specsheet', :action => 'ajax_item_update'
#match "designer_specsheet/different_department_item_chosen_update_category", :controller => 'designer_specsheet', :action => 'different_department_item_chosen_update_category'
#match "p/designer" => redirect( '/designer_specsheet')
#match "designer_specsheet/view_details", :controller => 'designer_specsheet', :action => 'view_details'
#match 'designer_specsheet',  :controller => 'designer_specsheet', :action => 'index'
#match 'designer_specsheet/specsheet_item_search',  :controller => 'designer_specsheet', :action => 'specsheet_item_search'
#match 'designer_specsheet' => 'designer_specsheet#update_categories'
#match  'designer_specsheet/select_list_update_category_back', :controller => 'designer_specsheet', :action => 'select_list_update_category_back'
#match  'designer_specsheet/select_list_update_category_product', :controller => 'designer_specsheet', :action => 'select_list_update_category_product'


#match 'designer/update_categories' , :controller => 'designer', :action => 'update_categories'
#match 'designer/update_items_listing' , :controller => 'designer', :action => 'update_items_listing'
#match 'designer/ajax_item_details' , :controller => 'designer', :action => 'ajax_item_details'
#match 'designer/show_completed' , :controller => 'designer', :action => 'show_completed'
#match 'designer/designer_item_details' , :controller => 'designer', :action => 'designer_item_details'
#match 'designer/designer_item_search' , :controller => 'designer', :action => 'designer_item_search'
#match  'javascripts/designer_department_categories.js', :controller => 'javascripts', :action => 'designer_department_categories'
#get 'designer/items'
#match "designer/show_preview/:item_id", :controller => "designer", :action => 'show_preview'
#match "designer/show_thumbnail/:filename", :controller => "designer", :action => 'show_thumbnail'
#match "designer/show/:filename", :controller => "designer", :action => 'show'
#match "designer/complete_selected_incomplete", :controller => "designer", :action => 'complete_selected_incomplete'
#match "designer/items_with_no_file", :controller => "designer", :action => 'items_with_no_file'
#match "designer_specsheet/ajax_administer_breast_prints_list", :controller => 'designer_specsheet', :action => 'ajax_administer_breast_prints_list'
#match "designer_specsheet/ajax_administer_edit_item", :controller => 'designer_specsheet', :action => 'ajax_administer_edit_item'
#match "designer_specsheet/ajax_administer_size_and_position", :controller => 'designer_specsheet', :action => 'ajax_administer_size_and_position'



#resources :items

# The priority is based upon order of creation:
# first created -> highest priority.

# Sample of regular route:
#   match 'products/:id' => 'catalog#view'
# Keep in mind you can assign values other than :controller and :action

# Sample of named route:
#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
# This route can be invoked with purchase_url(:id => product.id)

# Sample resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Sample resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Sample resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Sample resource route with more complex sub-resources
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', :on => :collection
#     end
#   end

# Sample resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end

# You can have the root of your site routed with "root"
# just remember to delete public/index.html.
#root :to => 'p/home'

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id(.:format)))'