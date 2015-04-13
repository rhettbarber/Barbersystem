class PageController < ApplicationController
  layout nil
  layout 'application', :except => :pages_navigation

  before_filter  :initialize_variables  , :only => [:create, :show_page_on_index, :update,  :edit, :show, :recently_added_pages, :test, :new  ]
  before_filter  :initialize_variables_except_store  , :only => [:pages_navigation  ]
  before_filter :redirect_unless_admin , :only => [:create, :delete, :edit, :update, :new, :delete_static_page_cache]
  skip_before_filter :verify_authenticity_token

  #before_filter  :initialize_variables  , :only => [ :search_articles,  :resources, :show, :edit, :update , :remove_orphaned_page, :remove ,:recently_added_news, :recently_added_email, :recently_added_pages,:publish, :index ,:add, :create, :revisions,:delete_page_cache ]
  #before_filter  :initialize_variables_except_store  , :only => [  :show, :edit, :update , :remove_orphaned_page, :remove ,:recently_added_news, :recently_added_pages,:publish, :index ,:add, :create, :revisions,:delete_page_cache ]
  #before_filter :redirect_unless_admin , :except => [ :search_articles, :resources, :not_found, :true_history_on_hawthorne,  :page_banner_popup, :expire_contextual_navigation_tree, :show, :page_search, :index,:recently_added_news,  :recently_added_email ,  :recently_added_pages, :search ]
  #before_filter :find_latest_revision_ids , :only => [  :page_search, :recently_added_pages ]

 def test
   no_item_menu
 end



#scope_controller_model :page, :conditions => { :website => Proc.new { |c| c.send(:current_website) } }
#scope_controller_model :page, :conditions => { :website => Proc.new { |c| c.send(:current_website) } }, :except => :true_history_on_hawthorne

  ## PROC CACHE PATH EXAMPLE
#caches_action :show, :cache_path => :show_cache_path.to_proc

#def show_cache_path
#	if @customer
#		if admin?
#			@website.name  + '/' + @customer.customer_type + '/p/' + params[:id]
#		else
#			@website.name + '/' + @customer.customer_type + '/p/admin/' + params[:id]
#		end
#	else
#		@website.name + '/Retail/p/' + params[:id]
#	end


## need to expire contextual_navigation_tree cache when pages are created for admin? and when published for non admin.
## need to expire individual page's cache when that page is published. turn off caching for unpublished pages.
#################################################################################################################
#caches_public_page :show_page_on_index   #_page
caches_page :show_page_on_index   #_page
#caches_page :pages_navigation
#################################################################################################################
#################################################################################################################
#################################################################################################################
#caches_public_page :index
#caches_page :recently_added_pages
#caches_page :recently_added_email
#caches_page :recently_added_news

  #after_filter(:only => :show_page_on_index, :if => Proc.new { |c| c.request.format.json? }) do |controller|

  #after_filter(:only => :show_page_on_index) do |controller|
  #           logger.warn "request.format: " + controller.request.format
  #           logger.warn "#############   ###########   #############"
  #            controller.class.cache_page(controller.response.body, controller.request.path, '.html')
  #end
#################################################################################################################

  def delete
    @page  = Page.find params[:page_id]
    @page.destroy
    delete_static_page_cache
     flash[:notice] = 'Removed final revision and deleted page.'
              redirect_to  "/"
  end

#################################################################################################################
  def create

            logger.debug "######################################"
            logger.debug "######################################"
            logger.debug "######################################"
            logger.debug "######################################"
            logger.debug "######################################"
            logger.debug "######################################"

            @page = Page.new(params[:page])
            @page.website_id = @website.id
            @page.page_type_id = params[:page_type][:id]
            if  params[:parent_id] == "undefined"
                    logger.debug "parent_id is undefined"
            else
                    @page.parent_id = params[:parent_id]
           end
            @revision = Revision.new( params[:revision] )
            @revision.user = @user
            @revision.published = true

            logger.debug "@page.valid?: " + @page.valid?.to_s
            if @page.save
                      logger.debug "@page.save"
                      @revision.page = @page
                      if @revision.save
                                  delete_static_page_cache
                                    logger.debug "@revision.save"
                                    flash[:notice] = 'Page was successfully created.'
                                    redirect_to :action => 'show_page_on_index', :page_id => @page.slug
                      else
                                     logger.debug "@revision.save"
                                    render :action => 'new'
                      end
            else
                            logger.debug "page.save failed"
                            @revision.page = @page
                            render :action => 'new'
            end
  end
#################################################################################################################
  def delete_static_page_cache
              find_page_and_revision   unless @page

              file_path =    Rails.root.to_s + '/public/apache_root/' +   request.host.gsub('.', '_').to_s + "/c/p/" +  @page.id.to_s  + '.html'
              FileUtils.rm( file_path  , :force => true   )


               file_path =    Rails.root.to_s + '/public/apache_root/' +   request.host.gsub('.', '_').to_s + "/p/" +  @page.id.to_s + '.html'
                FileUtils.rm( file_path , :force => true   )

              file_path =    Rails.root.to_s + '/public/apache_root/' +   request.host.gsub('.', '_').to_s + "/c/p/" +  @page.slug + '.html'
              FileUtils.rm( file_path  , :force => true   )


               file_path =    Rails.root.to_s + '/public/apache_root/' +   request.host.gsub('.', '_').to_s + "/p/" +  @page.slug + '.html'
                FileUtils.rm( file_path , :force => true   )

                 dir_path =    Rails.root.to_s + '/public/apache_root/' +   request.host.gsub('.', '_').to_s + "/p/pages_navigation"
                  FileUtils.rm_rf  dir_path        # ,  :verbose => true, :noop => true
  end


#################################################################################################################
  def new

    @page = Page.new
    @page.parent_id = params[:parent]
    @revision = Revision.new
    @revision.page = @page
  end
#################################################################################################################
  def update_before
    Website.current_website_id = @website.id
    @page = Page.find(params[:id])
    if params[:page_type]
      @page.page_type_id = params[:page_type][:id]
    else
      @page.page_type_id = 1
    end
    if params[:website_id] == "777"
      @page.website_id = 777
    else
      @page.website_id = @website.id
    end
    #@revision = @page.revisions.new(params[:revision])
    @revision = @page.most_recent_revision
    @revision.user = @user
    respond_to do |format|
      if Page.update( @page.id , params[:page])
        @page.page_cache_expire
        @revision.page = @page
        if @revision.save
                    #debugger
                    flash[:notice] = 'Page was successfully saved.'
                    #expire_show_and_contextual_navigation_tree_by_root(@page.root.id, @page.slug )
                    format.html { redirect_to  :controller => "page", :action => "show_page_on_index", :page_id => @page.id }
        else
          flash[:notice] = 'Revision save failed.'
          format.html {redirect_to  :controller => "page", :action => "edit", :page_id => @page.id }
        end
      else
        flash[:notice] = 'Page attributes failed to update.'
        format.html { redirect_to  :controller => "page", :action => "edit", :page_id => @page.id }
      end
    end
  end
#################################################################################################################
def update

  Website.current_website_id = @website.id
    @page = Page.find(params[:id])
    @page.name = params[:page][:name]



    if params[:page_type]
		@page.page_type_id = params[:page_type][:id]
	else
		@page.page_type_id = 1
	end
	if params[:website_id] == "777"
		@page.website_id = 777
	else
		@page.website_id = @website.id
	end
    #@revision = @page.revisions.new(params[:revision])
    #@revision = @page.most_recent_revision
    #@revision.user = @user

    respond_to do |format|
	    if @page.save
                    @page.page_cache_expire
                    #@revision.page = @page
                    @revision = @page.most_recent_revision

                    @revision.content  = params[:revision][:content]
                    @revision.user = @user
                      if @revision.save
                                 #debugger
                                    flash[:notice] = 'Revision was successfully saved.'
                                    #expire_show_and_contextual_navigation_tree_by_root(@page.root.id, @page.slug )

                                    format.html {redirect_to   "/p/" + @page.id.to_s   }
                      else
                                    flash[:notice] = 'Revision save failed.'
                                    format.html { redirect_to  :controller => "page", :action => "edit", :page_id => @page.id  }
                      end
	    else
                      flash[:notice] = 'Page attributes failed to update.'
                    format.html {  redirect_to  :controller => "page", :action => "edit", :page_id => @page.id  }
	    end
	end
end
#################################################################################################################
   def edit
                  @page_id =  params[:page_id]   || '0'
                   if @page_id.to_i > 0
                     @page = Page.find(  @page_id )
                     logger.debug "looking for page via id"
                   else
                     @page = Page.where(  "slug = ? ", @page_id ).first
                     logger.debug "no page_id found"
                   end
                  if @page
                    logger.warn "@page"
                    logger.debug "current @page.inspect: " + @page.inspect
                    @revision = @page.most_recent_revision
                  else
                    logger.warn "NOT @page"
                    #flash[:notice] = "No page found."
                  end
                  logger.debug "@revision: " + @revision.inspect
                render :parial => "page/edit"  #, :layout => false
   end

 def show
        show_page_on_index
      render "page/show_page_on_index"
 end


def find_page_and_revision
            #initialize_variables_except_store
          current_website
           @page_id =  params[:page_id]   || '0'

            if @page_id.to_i > 0
                        @page = Page.find(  @page_id )
                        logger.debug "looking for page via id"
            else
                        @page = Page.where(  "slug = ? ", @page_id ).first
                        logger.debug "no page_id found"
            end

            if @page
                          logger.warn "@page"
                          logger.debug "current @page.inspect: " + @page.inspect
                          @revision = @page.most_recent_revision
            else
                          logger.warn "NOT @page"
            end
end



  def show_page_on_index

                                              logger.debug("SORRY.. FRAGMENT NOT FOUND")
                                              logger.debug("SORRY.. FRAGMENT NOT FOUND")
                                              logger.debug("SORRY.. FRAGMENT NOT FOUND")
                                              logger.debug("SORRY.. FRAGMENT NOT FOUND")
                                              logger.debug("SORRY.. FRAGMENT NOT FOUND")
                                              find_page_and_revision
                                            logger.debug "@revision: " + @revision.inspect


                                            if @page and @page.slug == 'new-home'
                                                               logger.debug "page is  new-home"
                                                               @first_page = true
                                                               new_and_featured_items
                                            else
                                                              @first_page = false
                                                              logger.debug "page is not new-home"
                                              end
                                             logger.warn "##################################"
                                             logger.warn "@first_page : " + @first_page.to_s
                                              logger.warn "##################################"
  end
#################################################################################################################



#################################################################################################################
  def pages_navigation
                   logger.debug "--------####____________############"
                   logger.debug "--------####____________############"
                   logger.debug "--------####____________############"
                   logger.debug "begin pages_navigation"
                  @page_id =  params[:page_id]   || '0'

                    logger.debug("SORRY.. FRAGMENT NOT FOUND")
                  @skipped_page_ids = [ 13018, 12098, 2648, 4727, 4742,4740,4673,4728,4567,4677,10754 , 9152, 8656,12960,8655,6536,12829  ]   # this started out to eliminate a few from mobile that were needed on legacy.. need something different now.. is showing pages with no published revisions
                    if !params[:page_id]   or  params[:page_id] == "0"
                                            if params[:real_page_id]  and  params[:real_page_id] != "0"
                                                                                             #  http://192.168.0.125:2000/p/pages_navigation/0?id=%23&page_id=0&real_page_id=13106
                                                                                            logger.debug "ACCESSING DIRECTLY ACCESS PAGE-SHOW FULL MENU RECURSIVELY FROM FINAL CHILD///"
                                                                                            logger.debug "ACCESSING DIRECTLY ACCESS PAGE-SHOW FULL MENU RECURSIVELY FROM FINAL CHILD///"
                                                                                            logger.debug "ACCESSING DIRECTLY ACCESS PAGE-SHOW FULL MENU RECURSIVELY FROM FINAL CHILD///"
                                                                                            root_pages = Page.find_by_sql(["SELECT DISTINCT(p.name),p.id,  p.parent_id, p.slug, p.page_type_id, p.position from pages p LEFT JOIN revisions r ON p.id = r.page_id WHERE p.parent_id is null AND p.website_id = ? AND p.page_type_id = ? AND r.published = ? ORDER BY p.name",@website.id , 1, true   ])
                                                                                            final_child =   Page.find  params[:real_page_id]
                                                                                            @page =    final_child

                                                                                            list_string =   Page.traverse_directory( root_pages, @skipped_page_ids, final_child )
                                            else
                                                                                                logger.debug "ACCESSING ROOT PAGES///"
                                                                                                logger.debug "ACCESSING ROOT PAGES///"
                                                                                                logger.debug "ACCESSING ROOT PAGES///"
                                                                                                list_string    =  ""
                                                                                                root_pages = Page.find_by_sql(["SELECT DISTINCT(p.name),p.id,  p.parent_id, p.slug, p.page_type_id, p.position from pages p LEFT JOIN revisions r ON p.id = r.page_id WHERE p.parent_id is null AND p.website_id = ? AND p.page_type_id = ? AND r.published = ? ORDER BY p.name",@website.id , 1, true   ])
                                                                                                 root_pages.each do |the_page|
                                                                                                            if  @skipped_page_ids.include? the_page.id
                                                                                                                      logger.debug "skipped page due to id"
                                                                                                            else
                                                                                                                        if the_page.children == []
                                                                                                                                     list_string    +=       "<li data-type='page'  data-slug='#{the_page.slug}' data-page_id='#{the_page.id}'>#{the_page.name}</li>"
                                                                                                                        else

                                                                                                                                     list_string    +=       "<li data-type='folder' data-slug='#{the_page.slug}'  data-page_id='#{the_page.id}' class='jstree-closed'>#{the_page.name}</li>"
                                                                                                                        end
                                                                                                            end
                                                                                                 end
                                                                                                 list_string    +=   "</ul></li>"
                                            end
                    else
                                              logger.debug "ACCESSING SUB PAGES///"
                                              logger.debug "ACCESSING SUB PAGES///"
                                              logger.debug "ACCESSING SUB PAGES///"
                                               root = Page.find  params[:page_id]
                                               list_string = "<ul>"
                                               root.children.sort_by{ |x|  x.name }.each do |child|
                                                          unless  @skipped_page_ids.include? child.id
                                                                             if child.children == []
                                                                                            logger.debug "child.children empty "
                                                                                            list_string    +=       "<li  data-type='page' data-slug='#{child.slug}'  data-page_id='#{child.id}'  data-jstree='{'icon':'glyphicon glyphicon-leaf'}>#{child.name}</li>"
                                                                             else
                                                                                            logger.debug "child.name: " + child.name
                                                                                            list_string    +=       "<li  data-type='folder'  data-slug='#{child.slug}'  data-page_id='#{child.id}' class='jstree-closed'>#{child.name}</li>"
                                                                             end
                                                             end
                                               end
                                               list_string    +=  "</ul>"
                                                @list_string = list_string
                     end
                    @list_string = list_string
                   logger.debug "--------####____________############"
                   logger.debug "--------####____________############"
                   logger.debug "--------####____________############"
                    render :partial => 'page/pages_navigation_list', :content_type => 'text/html'
  end
##################################################################################################################################################################################################################################

#################################################################################################################
  def recently_added_pages
                    Revision.new
                   recently_added_cache_string         = "page/recently_added_pages/records_all_page_containers_week_"  + Website.week_number
                    @all_page_containers =  FMCache.read  recently_added_cache_string
                   if  @all_page_containers
                                     logger.debug "@all_page_containers found"
                   else
                                    logger.debug "@all_page_containers NOT found"
                                    @all_page_containers = Revision.limit("50").order("pages.created_at DESC").includes(:page).where( "pages.website_id = ? and revisions.published = ? ", @website.id , true  ).all
                                    FMCache.write  recently_added_cache_string ,    @all_page_containers
                   end
                   @paginated_results  =  @all_page_containers.to_a.paginate(:page => params[:page] || 1 , :per_page => 6  )
                    #logger.debug "@all_page_containers.inspect: " +      @all_page_containers.inspect
                    #logger.debug "@paginated_results.inspect: " +      @paginated_results.inspect
  end
#################################################################################################################







#def show
#  deprecate
#        logger.debug "####################################"
#        logger.debug "####################################"
#        logger.debug "####################################"
#        logger.debug "####################################"
#        logger.debug "####################################"
#        logger.debug "####################################"
#              #@customer_array_viewable_page_types = [1,8] if !@customer_array_viewable_page_types  # move to page_types_startup.rb lib
#        if params[:id]
#                      @page_id =  params[:id]   || '0'
#        else
#                      @page_id =  params[:revision_id]   || '0'
#          end
#        @pages_content_fragment_name =    "page/content/"     + @website.name     +   "_page_id_" + @page_id.to_s  +  "_week_" + Website.week_number
#        if params[:revision_id]
#                              logger.warn "params[:revision_id]"
#                              @revision = Revision.find params[:revision_id]
#                              @page = @revision.page
#        else
#                             logger.warn "NO params[:revision_id]"
#                              if params[:id].to_i > 0
#                                              @page = Page.find(  params[:id]  ).first
#                                            logger.debug "looking for page via id"
#                                            logger.debug "looking for page via id"
#                                            logger.debug "looking for page via id"
#                                            logger.debug "looking for page via id"
#                              else
#                                              @page = Page.find_by_slug params[:id]
#                                              logger.debug "####################################"
#                                               logger.debug "looking for page via slug"
#                                               logger.debug "looking for page via slug"
#                                               logger.debug "looking for page via slug"
#                                               logger.debug "looking for page via slug"
#                                               logger.debug "looking for page via slug"
#                                              logger.debug "####################################"
#                              end
#                              logger.debug "current @page.inspect: " + @page.inspect
#                              if @page
#                                            logger.warn "@page"
#                                            @revision = @page.most_recent_published_revision
#                              else
#                                               logger.warn "NOT @page"
#                                               flash[:notice] = "No page found"
#                              end
#                               logger.debug "@revision: " + @revision.inspect
#        end
#        logger.debug "####################################"
#        logger.debug "####################################"
#        logger.debug "####################################"
#        logger.debug "####################################"
#        logger.debug "####################################"
#        logger.debug "####################################"
#  end

#  def recently_added_pages
#    xxx
#    #startup_website_all_items
#    #startup_acceptable_item_ids_by_website
#    params = ''
#    #recently_added_pages_fragment_name = @website.name + "/user_type_id/" + @user_array_user_type_id + "/recently_added_pages/customer_type/" + @customer_array_customer_type
#    #logger.debug "@acceptable_item_ids: " + @acceptable_item_ids.inspect
#    #@items = Item.order("DateCreated DESC").limit(20).where("id in (?)", @acceptable_item_ids)
#    #@items = Item.find(:all, :conditions => ["id in (?)", @acceptable_item_ids ],:order => "DateCreated DESC", :limit => 20)
#    #unless read_fragment(recently_added_pages_fragment_name )
#    logger.debug "CACHING MISS - recently_added_pages"
#    @customer_array_viewable_page_types = [1,8] if !@customer_array_viewable_page_types
#    #@show_content_nav = true
#    #@page_containers = Revision.find(:all ,:include => ['page'], :conditions => ["revisions.created_at  >  ? and pages.website_id = ? and revisions.published = ? ", 60.days.ago, @website.id , -1   ], :order => "revisions.created_at DESC" )
#    @page_containers = Revision.limit("5").order("pages.created_at DESC").includes(:page).where( "pages.website_id = ? and revisions.published = ? ", @website.id , true  )
#    #@latest_revision_ids = []
#    #for revision in @page_containers
#    #	 @latest_revision_ids << revision.page.revisions.last.id.to_s
#    #end
#    #  else
#    #			logger.debug "CACHING HIT - recently_added_pages"
#    #end
#    #		render :partial => "page_container"
#  end
##################################################################################################################
#  def recently_added_news
#      bbbb
#    params = ''
#    #recently_added_news_fragment_name = @website.name + "/user_type_id/" + @user_array_user_type_id + "/recently_added_news/customer_type/" + @customer_array_customer_type
#    # unless read_fragment(recently_added_news_fragment_name )
#    logger.debug "CACHING MISS - recently_added_news"
#    @customer_array_viewable_page_types = [1,8] if !@customer_array_viewable_page_types
#    @show_content_nav = true
#    @page_containers = Revision.find(:all ,:include => ['page'], :conditions => ["pages.created_at  >  ? and pages.website_id = ? and revisions.published = ? ", 30.days.ago, @website.id , true   ], :order => "pages.created_at DESC" )
#    #@page_containers = Revision.limit("5").order("pages.created_at DESC").include(:page).where( "pages.website_id = ? and revisions.published = ? ", @website.id , -1  )
#    @latest_revision_ids = []
#
#    @news_root_id = 2649
#    @news_root_page = Page.unscoped.find 2649
#    @revision ||= Revision.find_most_recent_published(@news_root_page)
#    for revision in @page_containers
#      @latest_revision_ids << revision.page.revisions.last.id.to_s if revision.page and revision.page.root.id  ==  @news_root_id
#    end
#    #  else
#    #			logger.debug "CACHING HIT - recently_added_news"
#    #end
#    #render :partial => "page_container" ,:layout => 'page'
#  end
##################################################################################################################
#  def recently_added_email
#    cccc
#    current_website
#    params = ''
#    #recently_added_email_fragment_name = @website.name + "/user_type_id/" + @user_array_user_type_id + "/recently_added_email/customer_type/" + @customer_array_customer_type
#    # unless read_fragment(recently_added_email_fragment_name )
#    logger.debug "CACHING MISS - recently_added_email"
#    @customer_array_viewable_page_types = [1,8] if !@customer_array_viewable_page_types
#    @show_content_nav = true
#    @page_containers = Revision.order( "pages.created_at DESC").includes('page').where("pages.created_at  >  ? and pages.website_id = ? and revisions.published = ? ", 30.days.ago, @website.id , true  )
#    @latest_revision_ids = []
#
#    @email_root_id = 2650
#    @news_root_page = Page.find @email_root_id
#    @revision ||= Revision.find_most_recent_published( @news_root_page)
#    for revision in @page_containers
#      @latest_revision_ids << revision.page.revisions.last.id.to_s  if revision.page and revision.page.root.id  ==  @email_root_id
#    end
#    g = "g"
#    #  else
#    #      logger.debug "CACHING HIT - recently_added_email"
#    #end
#    #render :partial => "page_container" ,:layout => 'page'
#  end
##################################################################################################################
#
#
#
#
#
#def resources
#  @page = Page.where(  "slug = ?", 'resources').first
#  ss = "s"
#  @revision ||= Revision.find_most_recent_published(@page)
#end
#
# def not_found
#   render :text => "not found"
#end
#
#
#def page_search_msftse # IN PROGRESS
#    keywords = params[:item_keywords]
#	if !keywords.to_s.strip.empty?
#                                          tokens = keywords.split.collect {|c| "%#{c.downcase}%"}
#
#                                                  @initial_pages = ListingPage.find_with_msfte :matches_any => keywords
#                                                  @pages_with_rank = []
#                                                  keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
#
#                                                  @initial_pages.each do |page|
#
#                                                             page_words_string = page.ItemLookupCode.to_s + ' ' + page.Description.to_s + ' ' + page.ExtendedDescription.to_s + ' ' + page.Notes.to_s
#                                                             page_words_array  = page_words_string.split.collect {|c| "#{c.downcase}"}
#                                                             page_words_set = page_words_array.to_set
#
#                                                              keywords_set      = keywords.to_set
#                                                              word_count = 0
#                                                              keywords.each do  |kw|
#                                                                  matching_words = keywords_set.intersection(page_words_set)
#                                                                  if matching_words.size > 0
#                                                                        logger.debug "matching_words: " + matching_words.inspect
#                                                                  else
#                                                                         logger.debug "page_words_set because none match: " + page_words_set.inspect
#                                                                  end
#                                                                  if matching_words.size > 0
#                                                                    word_count = matching_words.size
#                                                                  end
#                                                              end
#                                                               page.SubDescription3 = word_count
#                                                                @pages_with_rank	<< page if page.SubDescription3 != 0
#                                                                @pages = @pages_with_rank.sort_by {|a| a.SubDescription3}.reverse
#                                                  end
#
#
#                                      if !conditions.nil?
#                                        @page_containers = Revision.find(:all ,:include => ['page'],:limit => 30, :conditions =>  conditions  ,:order => "revisions.created_at DESC" )
#                                      end
#
#	else
#		flash[:notice] = 'Please enter from 1 to 4 search terms'
#		redirect_to :back
#	end
#end
##################################################################################################################
#def page_search
#    keywords = params[:item_keywords]
#	if !keywords.to_s.strip.empty?
#	      tokens = keywords.split.collect {|c| "%#{c.downcase}%"}
#		if tokens.size == 1
#			conditions = ["content like ? and pages.website_id = ? or pages.name like ? and pages.website_id = ?" , tokens[0] , @website.id, tokens[0] ,     @website.id  ]
#		elsif tokens.size == 2
#			conditions = ["pages.website_id  = ? and revisions.content like ?     or pages.website_id  = ? and  pages.name like ?    or pages.website_id  = ? and revisions.content like ?    or pages.website_id  = ? and  pages.name like ?",    @website.id ,tokens[0] ,     @website.id ,tokens[0] ,    @website.id ,tokens[1] ,     @website.id ,tokens[1]  ]
#		elsif tokens.size == 3
#			conditions = ["pages.website_id  = ? and revisions.content like ?     or pages.website_id  = ? and  pages.name like ?    or pages.website_id  = ? and revisions.content like ?    or pages.website_id  = ? and  pages.name like ?    or pages.website_id  = ? and revisions.content like ?    or pages.website_id  = ? and pages.name like ?",  @website.id ,tokens[0] ,  @website.id ,tokens[0] ,  @website.id ,tokens[1],  @website.id ,tokens[1] ,  @website.id ,tokens[2] ,  @website.id ,tokens[2]  ]
#		elsif tokens.size == 4
#			conditions = ["pages.website_id  = ? and revisions.content like ?     or pages.website_id  = ? and  pages.name like ?    or pages.website_id  = ? and revisions.content like ?    or pages.website_id  = ? and  pages.name like ?    or pages.website_id  = ? and revisions.content like ?    or pages.website_id  = ? and pages.name like ?    or pages.website_id  = ? and revisions.content like ?    or pages.website_id  = ? and pages.name like ?",   @website.id ,tokens[0] ,  @website.id ,tokens[0] ,  @website.id ,tokens[1] ,  @website.id ,tokens[1],  @website.id ,tokens[2] ,  @website.id ,tokens[2] ,  @website.id ,tokens[3] ,  @website.id ,tokens[3]  ]
#		end
#		if !conditions.nil?
#			@page_containers = Revision.find(:all ,:include => ['page'],:limit => 30, :conditions =>  conditions  ,:order => "revisions.created_at DESC" )
#	 	end
##		render :partial => "page_container" ,:layout => @website.name
#	else
#		flash[:notice] = 'Please enter from 1 to 4 search terms'
#		redirect_to :back
#	end
#end
##################################################################################################################
#def true_history_on_hawthorne
#			@non_profit_domain = true #this variable is also set in libs/startup_website
#			logger.debug "BEGIN ------------------------------page/true_history_on_hawthorne"
#			@page ||= Page.find(:first, :conditions => ["slug = ? ", 'southern-history'  ])
#			@revision ||= Revision.find_most_recent_published(@page)
#			logger.debug "END --------------------------------page/true_history_on_hawthorne"
#			render "page/show"
#end
##################################################################################################################
#def page_banner_popup
#		@page ||= Page.find(:first, :conditions => ["id = ? " , params[:id]  ])
#		render :partial => "affiliates/page_banner_popup",:layout => 'popup'
#end
##################################################################################################################
#def show
#              #@customer_array_viewable_page_types = [1,8] if !@customer_array_viewable_page_types  # move to page_types_startup.rb lib
#        if params[:revision_id]
#                              logger.warn "params[:revision_id]"
#                              @revision = Revision.find params[:revision_id]
#                              @page = @revision.page
#        else
#                             logger.warn "NO params[:revision_id]"
#                              if params[:id].to_i > 0
#                                              @page = Page.find(params[:id]).first
#                                            logger.debug "looking for page via id"
#                              else                                              @page = Page.where(  "slug = ? ", params[:id]).first
#                                               logger.debug "looking for page via slug"
#                              end
#                              logger.debug "current @page.inspect: " + @page.inspect
#                              if @page
#                                            logger.warn "@page"
#                                            if admin?
#                                                        logger.warn "admin?"
#                                                        @revision = @page.most_recent_xpublished_revision
#                                            else
#                                                        logger.warn "NOT admin?"
#                                                        @revision = @page.most_recent_published_revision
#                                            end
#                              else
#                                                logger.warn "NOT @page"
#                                               flash[:notice] = "No page found"
#                              end
#                               logger.debug "@revision: " + @revision.inspect
#        end
#  end
##################################################################################################################
#def expire_show_and_contextual_navigation_tree_by_root(root, page_slug)
#	expire_fragment(%r{/views/#{@website.name}/user_type_id/.*/contextual_navigation_tree/customer_type/.*/root_id/#{root}/.*})
#	expire_fragment(%r{/views/#{@website.name}/user_type_id/.*/page/show/#{page_slug}.*})
#	logger.debug "-------------------------------------expire_show_and_contextual_navigation_tree_by_root"
#end
##################################################################################################################
#def update
#
#    @page = Page.find(params[:id])
#    if params[:page_type]
#		@page.page_type_id = params[:page_type][:id]
#	else
#		@page.page_type_id = 1
#	end
#	if params[:website_id] == "777"
#		@page.website_id = 777
#	else
#		@page.website_id = @website.id
#	end
#    @revision = @page.revisions.new(params[:revision])
#    @revision.user = @user
#    respond_to do |format|
#	    if Page.update( @page.id , params[:page])
#        @page.page_cache_expire
#	      @revision.page = @page
#		      if @revision.save
#		     #debugger
#		        flash[:notice] = 'Page was successfully saved.'
#		        expire_show_and_contextual_navigation_tree_by_root(@page.root.id, @page.slug )
#		        format.html { redirect_to page_url(@page) }
#		      else
#		        flash[:notice] = 'Revision save failed.'
#		      	format.html { redirect_to page_url(@page)  }
#		      end
#	    else
#	      	flash[:notice] = 'Page attributes failed to update.'
#	    	format.html { redirect_to page_url(@page) }
#	    end
#	end
#end
##################################################################################################################
#def publish
#    @revision = Revision.find params[:revision_id]
#    @page = @revision.page
#    @page.page_cache_expire
#    #@page = Page.find_by_slug(params[:id])
#    #@revision = Revision.find_most_recent(@page)
#    @revision.published = true #-1
#    if @revision.save
#    	#expire_show_and_contextual_navigation_tree_by_root(@page.root.id, @page.slug )
#    	expire_recently_added_pages
#      flash[:notice] = 'Revision was successfully published.'
#      redirect_to :action => 'show', :revision_id => @revision.id
#    else
#      render :action => 'show', :revision_id => @revision.id
#    end
# end
##################################################################################################################
#def add_private_user
#		return unless request.post?
#	begin
#		private_user = User.find_by_email(params[:user][:email])
#			if private_user
#				private_user.user_type_id = 5
#				if private_user.save
#					    flash[:notice] = 'Private User successfully saved.'
#		        		redirect_to :controller => 'page'
#				end
#			else
#	 			flash[:notice] = 'No user with this email address found.'
#        		redirect_to :back
#			end
#	 rescue
#	 			flash[:notice] = 'Add private user FAILED.'
#        		redirect_to :back
#	 end
#end
#
#def remove_private_user
#		return unless request.post?
#	begin
#		private_user = User.find_by_email(params[:user][:email])
#			if private_user
#				private_user.user_type_id = 4
#				if private_user.save
#					    flash[:notice] = 'Private User successfully removed.'
#		        		redirect_to :controller => 'page'
#				end
#			else
#	 			flash[:notice] = 'No user with this email address found.'
#        		redirect_to :back
#			end
#	 rescue
#	 			flash[:notice] = 'Remove private user FAILED.'
#        		redirect_to :back
#	 end
#end
#
#
#
#
#
#
#
#def create_websites_first_page_and_revision
#        @page = Page.new
#        @page.name = "home"
#        @page.slug = "home"
#        @page.website_id = @website.id
#        @page.save
#        @revision = Revision.new
#         @revision.published = true #-1
#         @revision.page_id = @page.id
#         @page.page_type_id = 1
#        @revision.content = "Home page content"
#        @revision.save
#       redirect_to :action => 'show', :id => @page.slug
#end
#
#
#
#  #def index
#  #  if User.count == 0
#  #    redirect_to :controller => "users", :action => "index"
#  #  else
#  #    @page = Page.find_by_slug("home")
#  #    if session[:user] == nil
#  #      @revision = Revision.find_most_recent_published(@page)
#  #      if @revision.redirect_to != nil
#  #        @page = Page.find(@revision.redirect_to)
#  #        @revision = Revision.find_most_recent_published(@page)
#  #      end
#  #    else
#  #      @revision = Revision.find_most_recent(@page)
#  #    end
#  #    @show_nav = false
#  #    @revision
#  #    render :action => "show"
#  #  end
#  #end
#
#
#  def add
#
#    @page = Page.new
#    @page.parent_id = params[:parent]
#    @revision = Revision.new
#    @revision.page = @page
#  end
#
#  def create
#    @page = Page.new(params[:page])
#    @page.website_id = @website.id
#    @page.page_type_id = params[:page_type][:id]
#    @page.parent_id = params[:page][:parent_id]
#    @revision = Revision.new(params[:revision])
#    @revision.user = @user
#    if @page.save
#      @revision.page = @page
#      if @revision.save
#        flash[:notice] = 'Page was successfully created.'
#        redirect_to :action => 'show', :id => @page.slug
#      else
#        render :action => 'add'
#      end
#    else
#      @revision.page = @page
#      render :action => 'add'
#    end
#  end
#
#  def edit
#    @revision = Revision.find params[:revision_id]
#    @page = @revision.page
#    #logger.debug "@page: " + @page.inspect
#    #logger.debug "@revision: " + @revision.inspect
#  end
#
#  #def edit
#  #  @page = Page.find params[:id]
#  #  logger.debug "@page: " + @page.inspect
#  #  @revision = Revision.find_most_recent(@page)
#  #  logger.debug "@revision: " + @revision.inspect
#  #end
#
#
#
#  def revisions
#
#    @page = Page.find params[:id]
#    @revision = Revision.find_most_recent(@page)
#  end
#
#  def revision
#
#    @revision = Revision.find(params[:id])
#  end
#
#  def rollback
#
#    @old_revision = Revision.find(params[:id])
#    @revision = Revision.new
#    @revision.page = @old_revision.page
#    @revision.content = @old_revision.content
#    @revision.user = @old_revision.user
#    if @revision.save
#    	expire_show_and_contextual_navigation_tree_by_root(@revision.page.root.id, @revision.page.slug )
#      flash[:notice] = 'Page was successfully rolled back'
#      redirect_to :action => 'show', :id => @revision.page.slug
#    else
#      redirect_to :action => 'revisions'
#    end
#  end
#
#  def un_publish
#
#    @revision = Revision.find(params[:id])
#    if @revision.page.slug != 'home' or (@revision.page.slug == 'home' and !@revision.only?)
#      @revision.published = 0
#      if @revision.save
#      	expire_show_and_contextual_navigation_tree_by_root(@page.root.id, @page.slug )
#        @page.page_cache_expire
#        flash[:notice] = 'Revision was successfully un-published'
#        redirect_to :action => 'revisions', :revision_id => @revision
#      else
#        redirect_to :action => 'revisions', :revision_id => @revision.id
#      end
#    else
#      flash[:notice] = "There must be at least one published revision of the 'Home' page."
#      redirect_to :action => "show"
#    end
#  end
#
#  def reorder
#
#    if params[:id] == nil
#      @parent = Page.find_by_slug('home')
#      @pages = Page.find(:all, :order => "position", :conditions => "parent_id is null")
#    else
#      @parent = Page.find(params[:id])
#      @pages = Page.find(:all, :order => "position", :conditions => ["parent_id = ?", @parent.id])
#    end
#  end
#
#  def update_page_positions
#
#    params[:sortable_list].each_with_index do |id, position|
#      #Page.update(id, :position => position+1) if id != '' ## this stopped working
#      this_page = Page.find(id)
#      this_page.update_attribute(:position, position+1) if id != ''
#    end
#    render :nothing => true
#  end
#
#
#
#  def remove_orphaned_page
#
#    @page = Page.find params[:id]
#    logger.debug "@page.revisions.size: " + @page.revisions.size.to_s
#      if @page.revisions.size == 0
#        @page.destroy
#        flash[:notice] = 'Page was successfully removed'
#        redirect_to "/"
#      else
#        flash[:notice] = 'This page is not an orphan'
#        redirect_to "/"
#      end
#  end
#
#
#
#
#  def remove
#    @revision = Revision.find params[:revision_id]
#    @page = @revision.page
#    #@page = Page.find_by_slug(params[:id])
#    #@revision = Revision.find_most_recent(@page)
#    if !@revision and @page
#              @page.destroy
#              flash[:notice] = 'Removed final revision and deleted page.'
#              redirect_to :action => "index"
#    elsif @revision
#                        if @revision.destroy
#                                  if @page.revisions.size == 0
#                                    @page.destroy
#                                    expire_show_and_contextual_navigation_tree_by_root(@page.root.id, @page.slug )
#                                    flash[:notice] = 'Page was successfully removed'
#                                    redirect_to :action => "index"
#                                  else
#                                    expire_show_and_contextual_navigation_tree_by_root(@page.root.id, @page.slug )
#                                    flash[:notice] = 'Revision was successfully removed'
#                                    redirect_to :action => 'show', :id => @page.slug
#                                  end
#                        else
#                           flash[:notice] = 'Error Removing'
#                          redirect_to :action => 'show', :id => @page.slug
#                        end
#
#    elsif !@revision and !@page
#              redirect_to :action => "index"
#              flash[:notice] = "No Revision and no page"
#    else
#      redirect_to :action => "index"
#      flash[:notice] = "error..."
#    end
#  end
#
#################### DEPRECATE ##################################
#
#def cache_test
#   # fragment_name = request.env["HTTP_HOST"].gsub(":",".") + request.env["REQUEST_URI"]
#    fragment_name = @website.name + '/' + @customer_array.customer_type + '/p/' + params[:id]
#    fragment_name = fragment_name.last == "/" ? fragment_name.chomp("/") : fragment_name
#    # Reading the fragment cache (if exists, or nil if not)...
#    fragment = read_fragment( fragment_name )
#    if !fragment.nil?
#      # Setting the content-type header to the proper content-type (in this case text/html, but it can be anything)...
##      @headers["Content-Type"] = "text/xml;"
#
#      # Delivers the content
#       render  :text => 'fragment_name' + fragment
#      # Void any further processing (do not forget this)
#      return false
#    end
#end
#
#def show_cache_path
#	if @customer
#		if admin?
#			@website.name  + '/' + @customer.customer_type + '/p/' + params[:id]
#		else
#			@website.name + '/' + @customer.customer_type + '/p/admin/' + params[:id]
#		end
#	else
#		@website.name + '/Retail/p/' + params[:id]
#	end
#end
########################################################################################################################################
#   def show_action_caching
##    unless read_fragment({:fragment_name => 'page_show', :id => params[:id]  })
#	    if @customer
#	    	@page = Page.find(:first, :conditions => ["page_type_id in (?) and slug = ? or name = ?", @customer.customer_viewable_page_types, params[:id], params[:id]  ])
#	    else
#	    	@page = Page.find(:first, :conditions => ["slug = ? or name = ? and page_type_id = ?",params[:id], params[:id], 1   ])
#		end
#	    if session[:user] == nil
#	      @revision = Revision.find_most_recent_published(@page)
#	      if @revision.redirect_to != nil
#	        @page = Page.find(@revision.redirect_to)
#	        @revision = Revision.find_most_recent_published(@page)
#	      end
#	    else
#	      @revision = Revision.find_most_recent(@page)
#	    end
#	    @show_nav = (@page.slug == "home" or (session[:user] == nil and @page.parent == nil and @page.children.size == 0)) ? false : true
#	    @revision
##	end
#  rescue
#    flash[:notice] = "Sorry, the page '#{params[:id]}' doesn't exist!"
#    redirect_to :action => "error"
#  end
########################################################################################################################################
#def show_before
##    unless read_fragment({:fragment_name => 'page_show', :id => params[:id]  })
#	    @page = Page.find(:first, :conditions => ["page_type_id in (?) and slug = ? or name = ?", @customer_array.customer_viewable_page_types, params[:id], params[:id]  ])
#	    if session[:user] == nil
#	      @revision = Revision.find_most_recent_published(@page)
#	      if @revision.redirect_to != nil
#	        @page = Page.find(@revision.redirect_to)
#	        @revision = Revision.find_most_recent_published(@page)
#	      end
#	    else
#	      @revision = Revision.find_most_recent(@page)
#	    end
#	    @show_nav = (@page.slug == "home" or (session[:user] == nil and @page.parent == nil and @page.children.size == 0)) ? false : true
#	    @revision
##	end
#  rescue
#    flash[:notice] = "Sorry, the page '#{params[:id]}' doesn't exist!"
#    redirect_to :action => "error"
#  end
########################################################################################################################################
#def expire_contextual_navigation_tree_DEPRECATE
##	 selected_node = Page.find(params[:id])
##	 ancestors = selected_node.ancestors
##	 root = selected_node.root
##	 @child_page_ids_to_expire = []
##	 root.children.each do |child|
##	 	@child_page_ids_to_expire << child.id
##	 end
#
##	expire_fragment(%r{dixie_store/contextual_navigation_tree/parent_id/264.*})
#	node_to_expire = 2649
#	expire_fragment(%r{#{@website.name}/contextual_navigation_tree/root_id/#{node_to_expire}/})
#	redirect_to :action => 'show', :id => 'heritage-news'
#end
#
#def search_other_DEPRECATE
#        keywords = params[:item_keywords]
#       #@page_containers = Revision.find_by_contents(keywords)
#       @page_containers = Revision.find(:all, :limit => 25)
#                      render :partial => "page_container", :collection => @page_containers, :spacer_template => "page_divider" ,:layout => @website.name
#end
#
#
#def search_remote_DEPRECATE
#        keywords = params[:item_keywords]
#       @page_containers = Revision.find_by_contents(keywords)
#                          render(:update) { |page|
#                    page.replace_html 'yield_container', :partial => "page_container", :collection => @page_containers, :spacer_template => "page_divider" ,:layout => 'none'
#                   }
#  #      render :partial => "page_container", :collection => @page_containers, :spacer_template => "page_divider" ,:layout => 'none'
#end
#
#
#def page_search_ferret_DEPRECATE
#        keywords = params[:item_keywords]
#	@page_containers = Revision.find_by_contents(keywords)
#		render :partial => "page_container", :collection => @page_containers, :spacer_template => "page_divider" ,:layout => @website.name
#end
#
#   def update_page_positions_BEFORE
#
#    params[params[:id]].each_with_index do |id, position|
#      Page.update(id, :position => position+1) if id != ''
#    end
#    render :nothing => true
#  end
######################## end testing
#def flash_revision_DEPRECATE
#	flash[:revision] = 45
#	params[:aff_user_id] = 23
#end
######################## end testing
#
#def test_caching_DEPRECATE
#	#	node_to_expire = params[:id]
#	#	expire_fragment(%r{"views/#{@website.name}/user_type_id/#{@user_array_user_type_id}/contextual_navigation_tree/customer_type/*/" + "/root_id/#{node_to_expire}/"})
#	#	expire_fragment(%r{/views/dixie_store/.*})	WORKS - EVERYTHING INSIDE DIXIE_STORE
#	#	expire_fragment(%r{/views/#{@website.name}/user_type_id/3/contextual_navigation_tree/customer_type/.*/root_id/2649.*})
#	#	redirect_to :action => 'show', :id => 'heritage-news'
#end


#
#   def pages_navigation_before_with_scope_without_direct_entry
#
#     logger.debug "--------####____________############"
#     logger.debug "--------####____________############"
#     logger.debug "--------####____________############"
#     logger.debug "begin pages_navigation"
#     # EXAMPLE LINK
#     # EXAMPLE LINK
#     # EXAMPLE LINK
#     # EXAMPLE LINK
#     # http://192.168.0.125:2001/p/index/4637
#
#
#     @scope_by_page_id = params[:scope_by_page_id]
#
#     @page_id =  params[:page_id]   || '0'
#     #current_website
#     #@pages_navigation_list_fragment_name =       "page/page_navigation_list/"     + @website.name     +   "_page_id_" + @page_id.to_s  +  "_week_" + Website.week_number    + "_scope_page_id_" + @scope_by_page_id.to_s
#     #if read_fragment(@pages_navigation_list_fragment_name )
#     #            logger.debug("EXCELLENT.. SKIPPING ACTION BECAUSE OF READ FRAGMENT")
#     #else
#
#     logger.debug("SORRY.. FRAGMENT NOT FOUND")
#     #initialize_variables_except_store
#     @skipped_page_ids = [ 13018, 12098, 2648, 4727, 4742,4740,4673,4728,4567,4677,10754 , 9152, 8656,12960,8655,6536,12829  ]   # this started out to eliminate a few from mobile that were needed on legacy.. need something different now.. is showing pages with no published revisions
#     if !params[:page_id]   or  params[:page_id] == "0"
#       logger.debug "ACCESSING ROOT PAGES///"
#       logger.debug "ACCESSING ROOT PAGES///"
#       logger.debug "ACCESSING ROOT PAGES///"
#       list_string    =  ""
#       if  @scope_by_page_id and  @scope_by_page_id != "0"
#         logger.debug "@scope_by_page_id"
#         logger.debug "@scope_by_page_id"
#         logger.debug "@scope_by_page_id"
#         logger.debug "@scope_by_page_id"
#         logger.debug "@scope_by_page_id"
#         logger.debug "@scope_by_page_id"
#
#         #list_string    +=   "<ul><li>"
#
#         #the_page = Page.find @scope_by_page_id
#
#         if @scope_by_page_id.to_i > 0
#           the_page = Page.find(  @scope_by_page_id )
#           logger.debug "looking for page via id"
#         else
#           the_page  = Page.where(  "slug = ? ",@scope_by_page_id ).first
#           logger.debug "no page_id found"
#         end
#
#
#
#         @root_page_name = the_page.name
#         if the_page.children == []
#           list_string    +=       "<li data-type='page' data-slug='#{the_page.slug}' data-page_id='#{the_page.id}'>#{the_page.name}</li>"
#         else
#
#           list_string    +=   "<li class='jstree-open jstree-clicked'  data-slug='#{the_page.slug}'  data-page_id='#{the_page.id}'><a href='#' class='jstree-clicked'>#{the_page.name}</a><ul>"
#
#           the_page.children.sort_by{ |x|  x.name }.each do |child|
#             unless  @skipped_page_ids.include? child.id
#               if child.children == []
#                 list_string    +=       "<li  data-type='page'   data-slug='#{child.slug}' data-page_id='#{child.id}'>#{child.name}</li>"
#               else
#                 list_string    +=       "<li  data-type='folder'  data-slug='#{child.slug}' data-page_id='#{child.id}' class='jstree-closed'>#{child.name}</li>"
#               end
#             end
#           end
#
#           #list_string    +=     "<li data-type='page' data-page_id='#{child.id}'>#{child.name}</li>"
#
#
#           list_string    +=   "</ul></li>"
#
#
#
#           #good
#           #list_string    +=       "<li><a href='#' data-type='folder' data-page_id='#{the_page.id}' class='jstree-closed'>#{the_page.name}</a></li>"
#
#           #  #list_string +=  "<li class='jstree-closed'>#{the_page.name}</li>"
#           # list_string += "<ul>"
#           #the_page.children.sort_by{ |x|  x.name }.each do |child|
#           #  if child.children == []
#           #    list_string    +=       "<li  data-type='page' data-page_id='#{child.id}'  data-jstree='{'icon':'glyphicon glyphicon-leaf'}>#{child.name}</li>"
#           #  else
#           #    list_string    +=       "<li  data-type='folder'  data-page_id='#{child.id}' class='jstree-closed'>#{child.name}</li>"
#           #  end
#           #end
#           #list_string    +=  "</ul>"
#         end
#       else
#         logger.debug "NOT @scope_by_page_id"
#         logger.debug "NOT @scope_by_page_id"
#         logger.debug "NOT @scope_by_page_id"
#         logger.debug "NOT @scope_by_page_id"
#         logger.debug "NOT @scope_by_page_id"
#         logger.debug "NOT @scope_by_page_id"
#
#         #list_string    +=   "<ul><li>"
#
#         root_pages = Page.find_by_sql(["SELECT DISTINCT(p.name),p.id,  p.parent_id, p.slug, p.page_type_id, p.position from pages p LEFT JOIN revisions r ON p.id = r.page_id WHERE p.parent_id is null AND p.website_id = ? AND p.page_type_id = ? AND r.published = ? ORDER BY p.name",@website.id , 1, true   ])
#
#         root_pages.each do |the_page|
#           if  @skipped_page_ids.include? the_page.id
#             logger.debug "skipped page due to id"
#           else
#             if the_page.children == []
#               list_string    +=       "<li data-type='page'  data-slug='#{the_page.slug}' data-page_id='#{the_page.id}'>#{the_page.name}</li>"
#             else
#
#               list_string    +=       "<li data-type='folder' data-slug='#{the_page.slug}'  data-page_id='#{the_page.id}' class='jstree-closed'>#{the_page.name}</li>"
#             end
#           end
#         end
#
#         list_string    +=   "</ul></li>"
#
#       end
#     else
#       logger.debug "ACCESSING SUB PAGES///"
#       logger.debug "ACCESSING SUB PAGES///"
#       logger.debug "ACCESSING SUB PAGES///"
#       root = Page.find  params[:page_id]
#       list_string = "<ul>"
#       root.children.sort_by{ |x|  x.name }.each do |child|
#         unless  @skipped_page_ids.include? child.id
#           if child.children == []
#             logger.debug "child.children empty "
#             list_string    +=       "<li  data-type='page' data-slug='#{child.slug}'  data-page_id='#{child.id}'  data-jstree='{'icon':'glyphicon glyphicon-leaf'}>#{child.name}</li>"
#           else
#             logger.debug "child.name: " + child.name
#             list_string    +=       "<li  data-type='folder'  data-slug='#{child.slug}'  data-page_id='#{child.id}' class='jstree-closed'>#{child.name}</li>"
#           end
#         end
#       end
#       list_string    +=  "</ul>"
#       #render :text => list_string
#       @list_string = list_string
#     end
#     @list_string = list_string
#     #end
#     logger.debug "--------####____________############"
#     logger.debug "--------####____________############"
#     logger.debug "--------####____________############"
#     render :partial => 'page/pages_navigation_list', :content_type => 'text/html'
#
#
#     #if request.xhr?
#     #          # respond to Ajax request
#     #          render  "pages_navigation.js.erb"
#     #else
#     #          # respond to normal request
#     #          render "pages_navigation.erb"
#     #end
#
#     #render :partial => 'page/pages_navigation_list', :content_type => 'text/html'
#     #if request.xhr?
#     #  # respond to Ajax request
#     #  render  "pages_navigation.js.erb"
#     #else
#     #  # respond to normal request
#     #  render "pages_navigation.erb"
#     #end
#   end
# #################################################################################################################


# if    ['/index', '/', '/p/home', '/p/new-home', 'p/index', 'p/', '/c/p/home',  '/c/p/new-home'].include?(request.path)
#                 if params[:first_page] == 'true'
#                               @first_page = 'true'
#                                new_and_featured_items
#
#                else
#                  logger.debug("request.path: " + request.path )
#                end
# else
#               logger.debug("request.path: " + request.path )
#
#   end

#initialize_variables_except_store
#if admin?
#        @pages_content_fragment_name =    "page/admin_content/"     + @website.name     +   "_page_id_" + params[:page_id].to_s  + "_scope_by_page_id_"  +   params[:scope_by_page_id].to_s  +  "_week_" + Website.week_number
#else
#        @pages_content_fragment_name =    "page/content/"     + @website.name     +   "_page_id_" + params[:page_id].to_s  + "_scope_by_page_id_"  +   params[:scope_by_page_id].to_s  +  "_week_" + Website.week_number
#end
#  if admin? == false  and read_fragment(@pages_content_fragment_name )
#                     logger.debug("EXCELLENT.. SKIPPING ACTION BECAUSE OF READ FRAGMENT")
#                     logger.debug("EXCELLENT.. SKIPPING ACTION BECAUSE OF READ FRAGMENT")
#                     logger.debug("EXCELLENT.. SKIPPING ACTION BECAUSE OF READ FRAGMENT")
#                     logger.debug("EXCELLENT.. SKIPPING ACTION BECAUSE OF READ FRAGMENT")
#                     logger.debug("EXCELLENT.. SKIPPING ACTION BECAUSE OF READ FRAGMENT")
#                     logger.debug("EXCELLENT.. SKIPPING ACTION BECAUSE OF READ FRAGMENT")
#  else



end
