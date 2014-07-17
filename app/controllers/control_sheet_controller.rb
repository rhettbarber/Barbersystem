class ControlSheetController < ApplicationController
  ssl_exceptions
  before_filter :redirect_unless_manager
  require 'fileutils'

  def search
            #@initial_films = ListingFilm.find_with_msfte :matches_any => ['deer', 'hunting' ]
             @keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}

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
                             item_words_string = item.id.to_s + ' ' +  item.ItemLookupCode.to_s + ' ' + item.purchases_entries_Description.to_s     + ' ' + item.detail_description.to_s + ' ' + item.Notes.to_s      + ' ' + item.items_Description.to_s
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
                                @items_with_rank	<< item if item.SubDescription3 != 0  #and  @website_search_item_ids.include?(item.id)
                                @ranked_items = @items_with_rank.sort_by {|a| a.SubDescription3}.reverse
             end
            # website_search_items
             logger.debug "@ranked_items.inspect: " + @ranked_items.inspect
             #logger.debug "@website_search_items: " + @website_search_items.inspect
            @purchases_entries  = @ranked_items    #.to_set.intersection(@website_search_items)
             #render  :partial => 'control_sheet/purchases'
             #render(:update) { |page|
             #      page.replace_html 'yield_container',   :partial => "search/search_results_list_items"
             #}
             #redirect_to :controller => "control_sheet", :action =>  "index"
             render :controller => "control_sheet", :action =>  "index"
logger.debug "END ajax_search_purchases_entries ########################################"
  end



  def index

                             if   params[:query]
                                                        search
                            else
                                                          if params[:sort_type]
                                                                  @sort_type = params[:sort_type]
                                                                  @sort_order = params[:sort_order]
                                                          else
                                                                    @sort_type = "id"
                                                                    @sort_order = "desc"
                                                          end

                                                          if params[:closed_status]
                                                                  @closed_status = params[:closed_status]
                                                                  @overdue_status = params[:overdue_status]
                                                          else
                                                                    @closed_status  = "0"
                                                                    @overdue_status = "all"
                                                          end
                              end

                            if @overdue_status == "art_overdue"    # limit to art_due_date  greater than today's date to limit the records being returned        ALSO   limit to open records because closed dont matter when overdue.
                                                 if params[:customer_id]
                                                             @customer = Customer.find    params[:customer_id]
                                                             conditions = [ "customer_id = ? and Type = ? and Closed = ? and Time < ? " , params[:customer_id] ,  2 , false  ,  Time.now ]
                                                             @purchases_entries = ListingPurchasesEntry.find(:all  ,  :conditions => conditions, :order =>   @sort_type  + " "  +  @sort_order   )
                                                 else

                                                               conditions = [ "Type = ? and Time < ?  and Closed = ? " ,  2   ,  Time.now, false ]
                                                               @purchases_entries = ListingPurchasesEntry.find(:all  ,  :conditions => conditions, :order =>  @sort_type    + " "  +    @sort_order   )
                                                 end
                            else
                                                if   params[:closed_status] == "all"
                                                             if params[:customer_id]
                                                                         @customer = Customer.find    params[:customer_id]
                                                                         if @overdue_status == "ship_overdue"
                                                                                  conditions = [ "customer_id = ? and Type = ? and QuantityRTD < QuantityOnOrder and ship_due_date  <  ?" , params[:customer_id] ,  2 , Time.now  ]
                                                                         else
                                                                                  conditions = [ "customer_id = ? and Type = ? " , params[:customer_id] ,  2  ]
                                                                           end
                                                                         @purchases_entries = ListingPurchasesEntry.find(:all  ,  :conditions => conditions, :order =>   @sort_type  + " "  +  @sort_order   )
                                                             else
                                                                          if @overdue_status == "ship_overdue"
                                                                                    conditions = [ "Type = ?  and QuantityRTD < QuantityOnOrder  and ship_due_date  <  ?" ,  2 , Time.now  ]
                                                                          else
                                                                                  conditions = [ "Type = ?" ,  2  ]
                                                                            end
                                                                           @purchases_entries = ListingPurchasesEntry.find(:all  ,  :conditions => conditions, :order =>  @sort_type    + " "  +    @sort_order   )
                                                             end
                                                else
                                                             if params[:customer_id]
                                                                         @customer = Customer.find    params[:customer_id]
                                                                         if @overdue_status == "ship_overdue"
                                                                                  conditions = [ "customer_id = ? and Type = ? and Closed = ?   and QuantityRTD < QuantityOnOrder  and ship_due_date  <  ?" , params[:customer_id] ,  2 , @closed_status , Time.now ]
                                                                         else
                                                                                  conditions = [ "customer_id = ? and Type = ? and Closed = ?" , params[:customer_id] ,  2 , @closed_status ]
                                                                           end
                                                                         @purchases_entries = ListingPurchasesEntry.find(:all  ,  :conditions => conditions, :order =>   @sort_type  + " "  +  @sort_order   )
                                                             else
                                                                          if @overdue_status == "ship_overdue"
                                                                                  conditions = [ "Type = ? and Closed = ?    and QuantityRTD < QuantityOnOrder  and ship_due_date <  ?" ,  2 , @closed_status , Time.now ]
                                                                          else
                                                                                  conditions = [ "Type = ? and Closed = ? " ,  2 , @closed_status ]
                                                                            end
                                                                           @purchases_entries = ListingPurchasesEntry.find(:all  ,  :conditions => conditions, :order =>  @sort_type    + " "  +    @sort_order   )
                                                             end
                                                end
                            end

                            respond_to do |format|
                                  format.html # index.html.erb
                                  format.xml  { render :xml => @purchases_entries }
                            end
  end


def create_folder
           pe = ListingPurchasesEntry.find params[:id]
            if params[:type] == 'supplied'
                             #Dir::mkdir( pe.supplied_art_filename )
                             FileUtils.mkdir_p   pe.supplied_art_filename
            elsif params[:type] == 'production'
                                              #Dir::mkdir( pe.supplied_art_filename )
                                              FileUtils.mkdir_p   pe.production_filename
            elsif params[:type] == 'layered_art'
                            #Dir::mkdir( pe.production_filename )
                            FileUtils.mkdir_p  pe.layered_art_filename
            end
          redirect_to :action => "work_order_details"  ,  :id => params[:purchase_id]
end



def control_js
     respond_to do |format|
       format.js {}
     end
   end



def dont_show_filenames
            session[:show_filenames] = false
            redirect_to  params.merge!(:action => :index, :overdue_status => params[:overdue_status], :closed_status => params[:closed_status], :customer_id => params[:customer_id] )
end

  def show_filenames
              session[:show_filenames] = true
              #redirect_to :controller => "control_sheet", :action => "index"
              redirect_to  params.merge!(:action => :index, :overdue_status => params[:overdue_status], :closed_status => params[:closed_status], :customer_id => params[:customer_id] )
  end


def delete_request
            @purchases_entry = PurchasesEntry.find   params[:purchases_entry_id]
            @purchase = @purchases_entry.purchase
            purchases_entries_count = @purchase.purchases_entries.size
            @purchases_entry_detail = @purchases_entry.purchases_entry_detail
            @purchases_entry_detail.destroy if @purchases_entry_detail
            @purchases_entry.destroy
            if purchases_entries_count == 1
                    @purchase.Closed = true
                    @purchase.save
            end
            redirect_to :controller => "control_sheet", :action => "work_order_details", :id => @purchases_entry.purchase_id   , :post => true
end


def edit_purchases_entry_details
                @purchase = Purchase.find params[:purchase_id]
                @purchases_entry = PurchasesEntry.find params[:purchases_entry_id]       if params[:purchases_entry_id]
                if   params[:purchases_entry_detail_id]
                          @purchases_entry_detail = PurchasesEntryDetail.find params[:purchases_entry_detail_id]
                else
                            @purchases_entry_detail = PurchasesEntryDetail.new
                            @purchases_entry_detail.layered_art = true
                  end
end



def update_purchases_entry_details
         if  params[:purchases_entry_id]   and  params[:purchases_entry_detail_id]
                      @purchases_entry_detail = PurchasesEntryDetail.find   params[:purchases_entry_detail_id]
                      @purchases_entry = PurchasesEntry.find params[:purchases_entry_id]
                    params[:purchases_entry] =  params[:purchases_entry].replace_value "", 1
                        if @purchases_entry_detail.update_attributes(params[:purchases_entry_detail])   and @purchases_entry.update_attributes(params[:purchases_entry])
                                   flash[:notice] = "update saved"
                        else
                                  flash[:notice] = "update failed"
                        end
         elsif  params[:purchases_entry_id]  and  !params[:purchases_entry_detail_id]
                          b = "b"
                          @purchases_entry = PurchasesEntry.find params[:purchases_entry_id]
                          @purchases_entry.Description = params[:purchases_entry][:Description]
                          @purchases_entry.QuantityOnOrder = params[:purchases_entry][:QuantityOnOrder] || 1
                          @purchases_entry.Price = params[:purchases_entry][:Price]

                            @purchases_entry_detail  = PurchasesEntryDetail.new(params[:purchases_entry_detail])
                            @purchases_entry_detail.purchase_id = params[:purchase_id]
                            @purchases_entry_detail.listing_purchases_entry_id =  params[:purchases_entry_id]
                            if @purchases_entry.save and @purchases_entry_detail.save
                                           flash[:notice] = "new entry saved"
                            else
                                            flash[:notice] = "new entry failed"
                            end
         elsif  ! params[:purchases_entry_id]  and  !params[:purchases_entry_detail_id]
                       @purchases_entry_detail = PurchasesEntryDetail.new(params[:purchases_entry_detail])
                       @purchases_entry_detail.purchase_id = params[:purchase_id]

                       @purchases_entry = PurchasesEntry.new    #(params[:purchases_entry])
                       @purchases_entry.item_id = 25319
                       @purchases_entry.purchase_id = params[:purchase_id]
                       @purchases_entry.on_hold = 0
                       @purchases_entry.ItemLookupCode  =  "CUSTOM WORK ORDER ENTRY"
                       @purchases_entry.master_department_id  = 0
                       @purchases_entry.QuantityRTD = 0
                       @purchases_entry.QuantityOnOrder  = 1
                       @purchases_entry.DetailID = 0
                       @purchases_entry.SalesRepID = 0
                       @purchases_entry.PriceSource = 1
                       @purchases_entry.discount_reason_code_id = 0
                       @purchases_entry.return_reason_code_id = 0
                       @purchases_entry.FullPrice = 0
                       @purchases_entry.store_id = 7
                       @purchases_entry.Cost = 0
                       @purchases_entry.Comment = 0
                       @purchases_entry.Description = params[:purchases_entry][:Description]
                       @purchases_entry.Price = 0
                       @purchases_entry.Taxable = 1
                       @purchases_entry.LastUpdated = Time.now
                       @purchases_entry.symbiote_purchases_entry_id = 0

                        if @purchases_entry.save and     @purchases_entry_detail.save
                          @purchases_entry_detail.listing_purchases_entry_id = @purchases_entry.id
                          @purchases_entry_detail.save

                                       flash[:notice] = "new entry saved"
                        else
                                        flash[:notice] = "new entry failed"
                        end
         else
                    ddd
                     flash[:notice] = "something went wrong"
         end

            redirect_to :controller => "control_sheet", :action => "work_order_details", :id => params[:purchase_id]       , :post => true
end




def work_order_details
            @purchase = Purchase.find  params[:id]
            @listing_purchases_entries =   @purchase.control_sheet_entries

            @customer = @purchase.customer
            @ship_to = @purchase.ship_to
           g = "g"

            #@purchases_entry_details = @purchase.purchases_entry_details
            #@purchases_entry_detail = PurchasesEntryDetail.new
end


 #def create_purchases_entry_detail
 #              @purchases_entry = PurchasesEntry.new(params[:purchases_entry])
 #              @purchases_entry_detail = PurchasesEntryDetail.new(params[:purchases_entry_detail])
 #
 #                if @purchases_entry.save
 #                          flash[:notice] = 'PurchasesEntry was successfully created.'
 #                          redirect_to :back
 #                else
 #                            redirect_to :back
 #                end
 #end






#def edit_individual
#  @purchases_entries = PurchasesEntry.find(params[:product_ids])
#end

#def update_individual_work_orders
#  @purchases_entries = PurchasesEntryDetail.update(params[:purchases_entry_details].keys, params[:purchases_entry_details].values).reject { |p| p.errors.empty? }
#  if @purchases_entries.empty?
#            flash[:notice] = "@purchases_entries updated"
#  else
#              flash[:notice] = "@purchases_entries update failed"
#    end
#    redirect_to :controller => "control_sheet", :action  => "work_order_details"
#    end
#
#
#  def confirm_new_work_order
#  end



  #def status
  #end

end
