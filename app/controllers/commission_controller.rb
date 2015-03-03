class CommissionController < ApplicationController

before_filter :initialize_variables
before_filter :redirect_unless_logged_in
before_filter :load_variables
before_filter :redirect_unless_manager, :except => [:load_variables, :report , :report_by_department_category  , :commission_items     ]

 # BIGCOCKE.NET CUSTOMER ID: 203658


   def load_variables
                if manager?

                              customer_ids = Set.new
                             customers_with_items = CustomersWithItem.find(:all  )
                              customers_with_items.each do |cs|
                                        customer_ids.add(  cs.customer_id.to_s  )
                              end
                               logger.warn 'customer_ids.inspect: '  + customer_ids.inspect
                                  @commission_customers = Customer.find( customer_ids.to_a )
                                  @commission_customer_id = params[:customer][:id]  if params[:customer]
                                 @commission_customer_id = params[:customer_id]  if params[:customer_id]
                                  @commission_customer_id    ||=     '216936' # bigcocke  '173235' #rhettro
                                  @commission_customer_id = @commission_customer_id.to_i
                else

                                   @commission_customer_id =   @user.customer_id
                end

                @commission_customer = Customer.find   @commission_customer_id
                  logger.debug "@commission_customer.inspect: " + @commission_customer.inspect
               Item.commission_customer_id    = @commission_customer_id
              @commissioned_customer_percentage   =   @commission_customer.CustomNumber1   *    0.01           #    0.10

             @commission_customer_website_ids  =  [ '' ]
             @commission_customer.websites.each do |ccwi|
                      @commission_customer_website_ids << ccwi.id.to_s
             end

              logger.warn "@@commission_customer_website_ids.inspect: " + @commission_customer_website_ids.inspect


                  session[:year_difference] ||= 0
                  if  params[:year_difference].class == String
                            if  params[:year_difference]  !=  0
                            session[:year_difference]  += params[:year_difference].to_f
                            end
                  end

                  @year_difference = session[:year_difference]
                  logger.debug "@year_difference: " + @year_difference.to_s

                      find_quarters(session[:year_difference])                 # lib/startup_dates.rb
                      if  params[:timeframe]  == 'quarterly'
                                   @the_year =    params[:date][:year]

                                    logger.debug "params[:quarter]: " + params[:quarter].to_s
                                    case params[:quarter].to_s
                                      when '1'
                                              @begin_date = @first_quarter_begin.change(:year => @the_year)
                                              @end_date = @first_quarter_end.change(:year => @the_year)
                                      when '2'
                                              @begin_date = @second_quarter_begin.change(:year => @the_year)
                                              @end_date = @second_quarter_end.change(:year => @the_year)
                                      when '3'
                                              @begin_date = @third_quarter_begin.change(:year => @the_year)
                                              @end_date = @third_quarter_end.change(:year => @the_year)
                                      when '4'
                                                @begin_date = @fourth_quarter_begin.change(:year => @the_year)
                                                @end_date = @fourth_quarter_end.change(:year => @the_year)
                                      else
                                                @begin_date = @first_quarter_begin.change(:year => @the_year)
                                                @end_date = @first_quarter_end.change(:year => @the_year)

                                    end
                      elsif params[:date]
                                 	#@begin_date = Time.new.beginning_of_year +   params[:date][:month].to_i.month   -  1.month
                                    #params[:date][:month].to_i.month   -  1.month  , 1,   params[:date][:year]
                                    @the_year =    params[:date][:year]
                                    @the_month =    params[:date][:month]
                                    @parsed_time_first_day = Time.parse(  @the_month +  "/1/" +  @the_year     )
                                    @last_day_of_month =     @parsed_time_first_day.end_of_month.day.to_s

                                    xxxxxxxx
                                    #http://stackoverflow.com/questions/800118/ruby-time-parse-gives-me-out-of-range-error

                                    @parsed_time_last_day = Time.parse(  @the_month +  "/" + @last_day_of_month + "/" +  @the_year     )
                                    logger.warn "@the_year: " + @the_year.to_s
                                    logger.warn "@the_month: " + @the_month.to_s
                                    @begin_date =  @parsed_time_first_day
	                                  @end_date =   @parsed_time_last_day
                      else
                                   logger.warn "SHOW ALL - NO TIME PERIOD"
                      end

                     @begin_date ||= Date.today
                      logger.warn "@begin_date: " + @begin_date.to_s
                      logger.warn "@end_date: " + @begin_date.to_s

   end



def mark_unpaid
                      logger.warn "params.inspect: " + params.inspect
                      if  PurchasesEntry.update_all(  ["commission_paid=?", 0  ]    , :id => params[:purchases_entry_ids].split(',')   )
                                  flash[:notice] = "Update succeeded."
                      else
                                 flash[:notice] = "Update failed."
                        end
                      # render '/commission/report'
                      # redirect_to :back ,  :params => params
                      #logger.warn "my_params: " + params.inspect
                      redirect_to  params.merge!(:action => :report, :paid => 2 )
end



def pay_now
                      logger.warn "params.inspect: " + params.inspect
                      if  PurchasesEntry.update_all(  ["commission_paid=?", 1 ]    , :id => params[:purchases_entry_ids].split(',')   )
                                  flash[:notice] = "Update succeeded."
                      else
                                 flash[:notice] = "Update failed."
                        end
                       # render '/commission/report'
                       #redirect_to :back  , :params => params
                       redirect_to  params.merge!(:action => :report, :paid => 2 )
end



  def report
                if  params[:paid].to_i == 2
                          @paid_status =  "all"
                else
                           @paid_status =  params[:paid].to_i
                  end


                  if    ['quarterly', 'monthly'].include?(   params[:timeframe]  )
                                      if @paid_status ==  "all"
                                                conditions = [ "customer_items_customer_id = ? and QuantityRTD > 0  and Time > ? and Time < ? ", @commission_customer_id, @begin_date, @end_date   ]
                                      else
                                                   conditions = [ "customer_items_customer_id = ? and QuantityRTD > 0  and Time > ? and Time < ? and commission_paid = ? ", @commission_customer_id, @begin_date, @end_date, @paid_status   ]
                                        end
                  else
                                     logger.debug "@paid_status: " + @paid_status.inspect
                                       if @paid_status ==  "all"
                                                  conditions = [ "customer_items_customer_id = ? and QuantityRTD > 0", @commission_customer_id    ]
                                       else
                                                    conditions = [ "customer_items_customer_id = ? and QuantityRTD > 0 and commission_paid = ? ", @commission_customer_id , @paid_status   ]
                                         end
                  end
                  #logger.warn "@begin_date: " + @begin_date.to_s
                  #logger.warn "@end_date: " +  @end_date.to_s

                @purchases_entries_for_commissions = PurchasesEntriesForCommission.find(:all, :conditions => conditions, :order => "Time ASC" )


                # REMOVE RETURNED PURCHASES_ENTRIES
                @purchases_entries_returns_item_ids = PurchasesEntriesReturn.find(:all,:select=>'purchase_returned_item_id').map {|x| x.purchase_returned_item_id}
                logger.warn "@purchases_entries_returns_item_ids.inspect: " + @purchases_entries_returns_item_ids.inspect

  end


def report_by_department_category
              if  params[:paid].to_i == 2
                        @paid_status =  "all"
              else
                         @paid_status =  params[:paid].to_i
                end


                if    ['quarterly', 'monthly'].include?(   params[:timeframe]  )
                                    if @paid_status ==  "all"
                                              conditions = [ "customer_items_customer_id = ? and QuantityRTD > 0  and Time > ? and Time < ? ", @commission_customer_id, @begin_date, @end_date   ]
                                    else
                                                 conditions = [ "customer_items_customer_id = ? and QuantityRTD > 0  and Time > ? and Time < ? and commission_paid = ? ", @commission_customer_id, @begin_date, @end_date, @paid_status   ]
                                      end
                else
                                   logger.debug "@paid_status: " + @paid_status.inspect
                                     if @paid_status ==  "all"
                                                conditions = [ "customer_items_customer_id = ? and QuantityRTD > 0", @commission_customer_id    ]
                                     else
                                                  conditions = [ "customer_items_customer_id = ? and QuantityRTD > 0 and commission_paid = ? ", @commission_customer_id , @paid_status   ]
                                       end
                end
                #logger.warn "@begin_date: " + @begin_date.to_s
                #logger.warn "@end_date: " +  @end_date.to_s

              @purchases_entries_for_commissions = PurchasesEntriesForCommission.find(:all,  :conditions => conditions )


              # REMOVE RETURNED PURCHASES_ENTRIES
              @purchases_entries_returns_item_ids = PurchasesEntriesReturn.find(:all,:select=>'purchase_returned_item_id').map {|x| x.purchase_returned_item_id}
              logger.warn "@purchases_entries_returns_item_ids.inspect: " + @purchases_entries_returns_item_ids.inspect

end





  def commission_items
               @commissioned_items  = CustomerItem.find_all_by_customer_id( @commission_customer_id  )
  end




def test
       #@customer_departments  = CustomerDepartment.find(:all, :conditions => ["customer_id = ?",  @commission_customer_id    ], :include => ['department'] )
end




     def commissions_by_item
            session[:year_difference] ||= 0
            if  params[:year_difference].class == String
                      if  params[:year_difference]  !=  0
                      session[:year_difference]  += params[:year_difference].to_f
                      end
            end

		        @year_difference = session[:year_difference]

                find_quarters(session[:year_difference])                 # lib/startup_dates.rb
                case params[:quarter]
                  when '1'
                          @begin_date = @first_quarter_begin
                          @end_date = @first_quarter_end
                  when '2'
                          @begin_date = @second_quarter_begin
                          @end_date = @second_quarter_end
                  when '3'
                          @begin_date = @third_quarter_begin
                          @end_date = @third_quarter_end
                  when '4'
                            @begin_date = @fourth_quarter_begin
                            @end_date = @fourth_quarter_end
                  else
                            @begin_date = @first_quarter_begin
                            @end_date = @first_quarter_end
                end

                @all_customer_items_ids  = Set.new
                @customer_categories_items_ids = Set.new
                @customer_departments_items_ids = Set.new
                @customer_items_ids  = Set.new
                @customer_items = Set.new

                @customer_items  = CustomerItem.find_all_by_customer_id( @commission_customer_id  )
                @customer_items. each do |citm|
                                      logger.warn " citm.item.id: " +  citm.item.id.to_s
                                      @customer_items_ids.add( citm.item.id.to_s    )
                end

               conditions = [ "id in (?)", @customer_items_ids  ]
               @commissioned_items = Item.find(:all ,  :conditions => conditions, :order => "ItemLookupCode ASC" ) if @customer_items_ids
                @total_commission = 0.0
                if @commissioned_items
                            @commissioned_items.each do |item|
                                        @total_commission +=  item.commission_in_dollars(@begin_date,@end_date)
                            end
                end
     end










######################################################################################
def item_commission_details
		@item = Item.find params[:item_id]
		@begin_date = Date.parse params[:begin_date]
		@end_date = Date.parse  params[:end_date]
		@purchases_entries = @item.purchases_entry_records(@begin_date,@end_date)
		@total_sales_at_commissioned_price = 0.0
		@total_commissions_at_commissioned_price = 0.0
	  	if @purchases_entries
					  @purchases_entries.each do |se|
					  			@total_sales_at_commissioned_price                +=    se.extended_total_at_commissioned_price
								@total_commissions_at_commissioned_price   +=    se.combined_total
						end
		end

end
######################################################################################


def define_customer_items
         		  @items = Item.find(:all  , :limit => 10 )
end



def find_quarters(year_difference)
  year_difference = year_difference.year
  @first_quarter_begin = Time.new.beginning_of_year + year_difference
  @first_quarter_end = Time.new.beginning_of_year+ year_difference  + 3.months - 1.day

  @second_quarter_begin = Time.new.beginning_of_year + year_difference + 3.months
  @second_quarter_end = Time.new.beginning_of_year  + year_difference + 6.months - 1.day

  @third_quarter_begin = Time.new.beginning_of_year + year_difference + 6.months
  @third_quarter_end = Time.new.beginning_of_year + year_difference + 9.months - 1.day

  @fourth_quarter_begin =  Time.new.beginning_of_year + year_difference + 9.months
  @fourth_quarter_end = Time.new.beginning_of_year + year_difference + 12.months - 1.day
end






    		#@begin_date =  params[:begin_date][:year] +'-'+ params[:begin_date][:month]+'-'+ params[:begin_date][:day]

                    #conditions = [ "customer_id = ?",  @commission_customer_id   ]
                #@purchases_entries_for_commissions = PurchasesEntriesForCommission.find(:all, :conditions => conditions , :order => "id ASC" )
                #conditions = [ "website_id in (?) and QuantityRTD > 0",  @customers_website_ids   ]




    #@customer_departments  = CustomerDepartment.find(:all, :conditions => ["customer_id = ?",  @commission_customer_id    ]   )
    #@customer_departments.each do |comm_dept|
    #                           comm_dept.department.categories.each do |cat|
    #                                    logger.warn "cat.class: " + cat.class.to_s
    #                                      cat.items.each do |itm|
    #                                            logger.warn "itm.id: " +  itm.id.to_s
    #                                            @customer_departments_items_ids.add( itm.id.to_s  )
    #                                       end
    #                          end
    #end
    #
    #@customer_categories  = CustomerCategory.find(:all, :conditions => ["customer_id = ?",  @commission_customer_id  ]  )
    #@customer_categories.each do |cd|
    #                                      cd.category.items.each do |citm|
    #                                            logger.warn "citm.id: " +  citm.id.to_s
    #                                            @customer_categories_items_ids.add( citm.id.to_s  )
    #                                       end
    #end
    #
    #  @all_customer_items_ids.merge(@customer_departments_items_ids)
    #  @all_customer_items_ids.merge(@customer_categories_items_ids)
    #  @all_customer_items_ids.merge(@customer_items_ids.flatten)


end