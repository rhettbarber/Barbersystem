class PurchasesEntriesController < ApplicationController
  ssl_exceptions
  before_filter :redirect_unless_manager
  before_filter :set_customer_session


       def set_customer_session
                  if  params[:layout_customer_id]
                               session[:layout_customer_id] = params[:layout_customer_id]
                  elsif  !session[:layout_customer_id]
                               session[:layout_customer_id] = 217029
                  end
       end

  def choose_customer
          @work_order_customers  = Set.new
           work_orders =  Purchase.find(:all, :conditions => ["Type = ? and Closed = ?", 2, false ] )
           work_orders.each do |wo|
                      @work_order_customers.add(wo.customer ) if wo.customer_id
           end
              render  :partial => 'purchases_entries/choose_customer'
   end


   def post_customer_changes
                set_customer_session
                 find_purchases_entries
                  render :partial => 'purchases_entries/list'
   end



  def edit_purchases_entry_details
          @purchases_entry_detail = PurchasesEntryDetail.find(params[:id]  )
          render :partial => "control_sheet/edit_purchases_entry_details"
  end


  def list_declared_fulfilled
                 conditions = [ "purchases.customer_id = ? and purchases.Type = ? and Closed = ? and fulfilled = 1",  session[:layout_customer_id], 2 , false ]
              #LEFT OUTER JOIN dbo.layouts ON dbo.layouts.purchases_entry_id = dbo.purchases_entries.id
               @purchases_entries = PurchasesEntry.find(:all, :joins =>  "INNER JOIN [purchases] ON [purchases].id = [purchases_entries].purchase_id INNER JOIN [items] ON [items].id = [purchases_entries].item_id LEFT OUTER JOIN [layouts] ON layouts.purchases_entry_id = purchases_entries.id"  ,  :conditions => conditions, :order => "CASE WHEN layouts.number IS NULL THEN - 1 ELSE layouts.number END Desc"  )
                 unless  session[:sort_by_layouts]
                       @purchases_entries =  @purchases_entries.sort_by{ |a| a.purchase.ReferenceNumber  }
                 end
                 render :partial => 'purchases_entries/list'   , :layout => "purchases_entries"
  end


  def list_completed
                 conditions = [ "purchases.customer_id = ? and purchases.Type = ?  and QuantityOnOrder <= QuantityRTD or purchases.customer_id = ? and purchases.Type = ?  and fulfilled = 1",  session[:layout_customer_id], 2 ,  session[:layout_customer_id], 2  ]
              #LEFT OUTER JOIN dbo.layouts ON dbo.layouts.purchases_entry_id = dbo.purchases_entries.id
               @purchases_entries = PurchasesEntry.find(:all, :joins =>  "INNER JOIN [purchases] ON [purchases].id = [purchases_entries].purchase_id INNER JOIN [items] ON [items].id = [purchases_entries].item_id LEFT OUTER JOIN [layouts] ON layouts.purchases_entry_id = purchases_entries.id"  ,  :conditions => conditions, :order => "CASE WHEN layouts.number IS NULL THEN - 1 ELSE layouts.number END Desc"  )
                 unless  session[:sort_by_layouts]
                       @purchases_entries =  @purchases_entries.sort_by{ |a| a.purchase.ReferenceNumber  }
                 end
                 render :partial => 'purchases_entries/list'   , :layout => "purchases_entries"
  end


  def list_incomplete
                 conditions = [ "purchases.customer_id = ? and purchases.Type = ?  and QuantityOnOrder > QuantityRTD and fulfilled != 1",  session[:layout_customer_id], 2  ]
              #LEFT OUTER JOIN dbo.layouts ON dbo.layouts.purchases_entry_id = dbo.purchases_entries.id
               @purchases_entries = PurchasesEntry.find(:all, :joins =>  "INNER JOIN [purchases] ON [purchases].id = [purchases_entries].purchase_id INNER JOIN [items] ON [items].id = [purchases_entries].item_id LEFT OUTER JOIN [layouts] ON layouts.purchases_entry_id = purchases_entries.id"  ,  :conditions => conditions, :order => "CASE WHEN layouts.number IS NULL THEN - 1 ELSE layouts.number END Desc"  )
                 unless  session[:sort_by_layouts]
                       @purchases_entries =  @purchases_entries.sort_by{ |a| a.purchase.ReferenceNumber  }
                 end
                 render :partial => 'purchases_entries/list'   , :layout => "purchases_entries"
  end


def control_sheet
          conditions = [ "customer_id = ? and Type = ? and Closed = ? and QuantityOnOrder > QuantityRTD ",  session[:layout_customer_id], 2 , false ]
          @purchases_entries = ListingPurchasesEntry.find(:all  ,  :conditions => conditions, :order => "CASE WHEN number IS NULL THEN - 1 ELSE  number END Desc"  )

          respond_to do |format|
                format.html # index.html.erb
                format.xml  { render :xml => @purchases_entries }
          end
end


def ajax_search_control_sheet
                            logger.debug "BEGIN ajax_search_purchases_entries ########################################"
                            # @initial_items = ListingItem.find_with_msfte :matches_any => ['deer', 'hunting' ]
                            #@initial_items = ListingDesignsAndMerchandiseOnly.find_with_msfte :matches_any => ['deer', 'hunting' ]
                            @initial_items = ListingPurchasesEntry.find_with_msfte :matches_any => @keywords
                            logger.debug "---------------------------------------------------------------"
                            ss = 'ss'
                            logger.debug "@initial_items.inspect: " + @initial_items.inspect.to_s
                            logger.debug "@initial_items.size.to_s: " + @initial_items.size.to_s
                            logger.debug "---------------------------------------------------------------"
                            ss = 'ss'
                            @items_with_rank = []
                            #@keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
                            @initial_items.each do |item|
                                            item_words_string = item.id.to_s + ' ' +  item.ItemLookupCode.to_s + ' ' + item.Description.to_s     + ' ' + item.ExtendedDescription.to_s + ' ' + item.Notes.to_s
                                            item_words_array  = item_words_string.split.collect {|c| "#{c.downcase}"}
                                            item_words_set = item_words_array.to_set
                                             @keywords_set      = @keywords.to_set
                                             word_count = 0
                                             @keywords.each do  |kw|
                                                 matching_words = @keywords_set.intersection(item_words_set)
                                                 if matching_words.size > 0
                                                       logger.debug "matching_words: " + matching_words.inspect
                                                 else
                                                        logger.debug "item_words_set because none match: " + item_words_set.inspect
                                                 end
                                                 if matching_words.size > 0
                                                   word_count = matching_words.size
                                                 end
                                             end
                                              item.SubDescription3 = word_count
                                              #website_search_items
                                              #startup_acceptable_item_ids_by_website
                                              # if !@acceptable_item_ids
                                              #         not_acceptable_item_ids
                                              # end
                                               @items_with_rank	<< item #if item.SubDescription3 != 0  #and  @website_search_item_ids.include?(item.id)
                                               @ranked_items = @items_with_rank.sort_by {|a| a.SubDescription3}.reverse
                            end
                            website_search_items
                            logger.debug "@ranked_items.inspect: " + @ranked_items.inspect
                            #logger.debug "@website_search_items: " + @website_search_items.inspect
                           @items = @ranked_items    #.to_set.intersection(@website_search_items)
                            render  :partial => 'purchases_entries/control_sheet_purchases'
                            #render(:update) { |page|
                            #      page.replace_html 'yield_container',   :partial => "search/search_results_list_items"
                            #}
          logger.debug "END ajax_search_purchases_entries ########################################"
  end



  def show_layout
            @layout = Layout.find_by_number(params[:id])
             conditions = [ "layouts.number = ?", @layout.number  ]
             @purchases_entries = PurchasesEntry.find(:all, :joins =>  "INNER JOIN [purchases] ON [purchases].id = [purchases_entries].purchase_id INNER JOIN [items] ON [items].id = [purchases_entries].item_id LEFT OUTER JOIN [layouts] ON layouts.purchases_entry_id = purchases_entries.id"  ,  :conditions => conditions, :order => "CASE WHEN layouts.number IS NULL THEN - 1 ELSE layouts.number END Desc"  )
            render  :partial => 'purchases_entries/edit_layout'
  end



  def find_purchases_entries
            session[:customer_id] || session[:layout_customer_id]
              keyword = params[:query]
                      if session[:show_completed]
                                  conditions = [ "purchases.customer_id = ? and purchases.Type = ? and Closed = ? ",   session[:layout_customer_id] , 2 , false ]
                      else
                                   if keyword
                                             #conditions = [ "purchases.customer_id = ? and purchases.Type = ? and Closed = ? and QuantityOnOrder > QuantityRTD and purchases.ReferenceNumber  = ? or items.ItemLookupCode = ?  or layouts.number =  ? or items.ExtendedDescription like ? ",  session[:layout_customer_id], 2 , false, keyword, keyword, keyword,  "%#{keyword}%"    ]
                                             conditions = [ "fulfilled != 1 and purchases.customer_id = ? and purchases.Type = ? and Closed = ? and QuantityOnOrder > QuantityRTD and purchases.ReferenceNumber  = ? or items.ItemLookupCode = ?  or layouts.number =  ? ",  session[:layout_customer_id], 2 , false, keyword, keyword, keyword  ]
                                   else
                                            conditions = [ "fulfilled != 1 and purchases.customer_id = ? and purchases.Type = ? and Closed = ? and QuantityOnOrder > QuantityRTD ",  session[:layout_customer_id], 2 , false ]
                                   end
                      end
              #LEFT OUTER JOIN dbo.layouts ON dbo.layouts.purchases_entry_id = dbo.purchases_entries.id
               @purchases_entries = PurchasesEntry.find(:all, :joins =>  "INNER JOIN [purchases] ON [purchases].id = [purchases_entries].purchase_id INNER JOIN [items] ON [items].id = [purchases_entries].item_id LEFT OUTER JOIN [layouts] ON layouts.purchases_entry_id = purchases_entries.id"  ,  :conditions => conditions, :order => "CASE WHEN layouts.number IS NULL THEN - 1 ELSE layouts.number END Desc"  )
                 unless  session[:sort_by_layouts]
                       @purchases_entries =  @purchases_entries.sort_by{ |a| a.due_date  }
                   end
  end




  def sort_by_due_date
            session[:sort_by_layouts] = false
         redirect_to :back
  end

def sort_by_layouts
          session[:sort_by_layouts] = true
       redirect_to :back
end

  def dont_show_completed
            session[:show_completed] = false
            redirect_to  :action => "layout_manager"
  end

def show_completed
          session[:show_completed] = true
       redirect_to  :action => "layout_manager"
end

def show_thumbnails
        session[:show_thumbnails]  = true
        redirect_to :back
end

  def hide_thumbnails
          session[:show_thumbnails] = false
          redirect_to :back
  end


def change_layout

        @purchases_entry_ids = params[:purchases_entry_ids]
           render  :partial => 'purchases_entries/change_layout'
end


def post_layout_changes
      ss = "ss"
           params[:purchases_entry_ids].split(",").each do |pe_id|
                  layout = Layout.find_or_create_by_purchases_entry_id(pe_id)
                 layout.number  = params[:number]
                 layout.save
           end
            @the_item = Item.find   25200
              find_purchases_entries
                  render :partial => 'purchases_entries/list'
end



  def layout_manager
                     all_colors
            respond_to do |format|
              format.html # index.html.erb
              format.xml  { render :xml => @purchases_entries }
            end
  end


def start_layout
     @the_item = Item.find   25200
      find_purchases_entries
        session[:chosen_colors] =  SortedSet.new.merge(params[:colors].split(",").to_set)
         all_colors =  SortedSet.new.merge(session[:all_colors])
         session[:more_colors]  =  all_colors.subtract(  session[:chosen_colors] )
          render :partial => 'purchases_entries/list'
end



def all_colors
        #@the_item = Item.find   25200
        find_purchases_entries

       unless   session[:all_colors]
                    @all_colors =SortedSet.new
                    @items = SortedSet.new
                     @purchases_entries.each do |the_pe|
                             @items.add?( the_pe.item)
                             the_pe.item.colors.each do |cl|
                                      @all_colors.add?( cl )
                             end
                     end
                        session[:all_colors] = @all_colors
          end
          session[:chosen_colors] = SortedSet.new   ["pms801"]   unless session[:chosen_colors]
         all_colors =  SortedSet.new.merge(session[:all_colors])
           session[:more_colors]  =  all_colors.subtract(  session[:chosen_colors] )  unless session[:more_colors]
  s = "s"
end


def show_all
                @the_item = Item.find   25200
                find_purchases_entries
                session[:show_completed]   = true
                    session[:chosen_colors] =   session[:all_colors]
                find_purchases_entries
                   session[:more_colors]  =  SortedSet.new
                redirect_to  :action => "layout_manager"
end

  def hide_all
                  @the_item = Item.find   25200
                  find_purchases_entries
                     session[:chosen_colors] =  SortedSet.new
                      session[:more_colors]  =     session[:all_colors]
                  ss = "ss"
                  redirect_to  :action => "layout_manager"
  end


  def add_color
                all_colors
                session[:chosen_colors].add?(params[:color])
                all_colors = SortedSet.new.merge(session[:all_colors] )
               session[:more_colors] =  all_colors.subtract(session[:chosen_colors])
                render :partial => 'purchases_entries/list'
  end


def remove_color
             all_colors
              session[:chosen_colors].subtract(params[:color])
              session[:more_colors].add(params[:color])
             s = "s"
              render :partial => 'purchases_entries/list'
end


#def delete_color
#               session[:colors].delete(params[:color])
#               redirect_to  params.merge!(:action => :layout_manager, :redirected => "true" )
# end


  def index
    all_colors

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @purchases_entries }
    end
  end









  # GET /purchases_entries/1
  # GET /purchases_entries/1.xml
  def show
    @purchases_entry = PurchasesEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @purchases_entry }
    end
  end

  # GET /purchases_entries/new
  # GET /purchases_entries/new.xml
  def new
    @purchases_entry = PurchasesEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @purchases_entry }
    end
  end

  # GET /purchases_entries/1/edit
  def edit
    @purchases_entry = PurchasesEntry.find(params[:id])
  end

  # POST /purchases_entries
  # POST /purchases_entries.xml
  def create
    @purchases_entry = PurchasesEntry.new(params[:purchases_entry])

    respond_to do |format|
      if @purchases_entry.save
        flash[:notice] = 'PurchasesEntry was successfully created.'
        format.html { redirect_to(@purchases_entry) }
        format.xml  { render :xml => @purchases_entry, :status => :created, :location => @purchases_entry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @purchases_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /purchases_entries/1
  # PUT /purchases_entries/1.xml
  def update
    @purchases_entry = PurchasesEntry.find(params[:id])

    respond_to do |format|
      if @purchases_entry.update_attributes(params[:purchases_entry])
        flash[:notice] = 'PurchasesEntry was successfully updated.'
        format.html { redirect_to(@purchases_entry) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchases_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases_entries/1
  # DELETE /purchases_entries/1.xml
  def destroy
    @purchases_entry = PurchasesEntry.find(params[:id])
    @purchases_entry.destroy

    respond_to do |format|
      format.html { redirect_to(purchases_entries_url) }
      format.xml  { head :ok }
    end
  end
end
