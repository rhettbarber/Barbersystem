class CacheController < ApplicationController
  before_filter :redirect_unless_admin




  ###  CACHE DELETION FUNCTIONS ARE LOCATED IN STORE_ADMIN_CACHE_CLEANER AND STUBBED HERE FOR ROUTING

  def delete_category_cache_and_return
    s = "ss"
          delete_category_cache(params[:category_id])
          redirect_to :back
  end



  def delete_page_cache_and_return
        current_website unless @website
        @page = Page.find params[:id] || params[:page_id]


        redirect_to :back
  end







end
