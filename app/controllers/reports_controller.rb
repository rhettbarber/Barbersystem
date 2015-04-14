class ReportsController < ApplicationController


ssl_exceptions
before_filter :redirect_unless_manager
before_filter :initialize_variables

######################################################################################
def item_commission_details
		@item = Item.find params[:item_id]
		@begin_date = Date.parse params[:begin_date]
		@end_date = Date.parse  params[:end_date]
		@sales_entries = @item.sales_entry_records(@begin_date,@end_date)
		@total_sales_at_commissioned_price = 0.0
		@total_commissions_at_commissioned_price = 0.0
	  	if @sales_entries  
					  @sales_entries.each do |se|
					  			@total_sales_at_commissioned_price                +=    se.extended_total_at_commissioned_price
								@total_commissions_at_commissioned_price   +=    se.combined_total 
						end
		end
		
end
######################################################################################
def show_commissions_printable
		show_commissions
		  render(:partial => "reports/show_commissions", :layout => 'printable')
end
######################################################################################
def show_commissions
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

		 @commissioned_artist = Customer.find params[:customer_id]
		 @cids = []
		 @customer_items = CustomerItem.find_all_by_customer_id(params[:customer_id]) 
		  @customer_items.each do |ci|
		  		@cids << ci.item_id.to_s if ci.item_id 
		 end if @customer_items
		 conditions = [ "id in (?)", @cids  ]
		 @commissioned_items = Item.find(:all ,  :conditions => conditions, :order => "ItemLookupCode ASC" ) if @cids
		  @items = Item.find(:all  , :limit => 10 )
		  @total_commission = 0.0
			if @commissioned_items  
					  @commissioned_items.each do |item|
					  			@total_commission +=  item.commission_in_dollars(@begin_date,@end_date) 
						end
			end 
			 render(:partial => "reports/show_commissions", :layout => 'reports')  unless action_name == 'show_commissions_printable'
end
######################################################################################
def delete_commissioned_item
		if  params[:item_id]
						@customer_item = CustomerItem.find_by_item_id(params[:item_id])
						if @customer_item 
								@customer_item.destroy
								flash[:notice] = "Item Deleted."
						else
								flash[:notice] = "Item Not found."
						end
			else
						flash[:notice] = "Missing Params."
			end
			redirect_to :back
end
######################################################################################
def add_to_commission_items
		if params[:customer_id] and params[:item_id]
						@item = Item.find(params[:item_id])
						@customer_item = CustomerItem.find_by_item_id(params[:item_id])
						if @customer_item 
								flash[:notice] = "This Item is already on an artists Commisions. You may use RMS to change it, but not from this program."
						else
								@cs = CustomerItem.new
								@cs.customer_id = params[:customer_id]
								@cs.item_id = params[:item_id]
								@cs.save
						end
			else
						flash[:notice] = "Missing Params."
			end
			redirect_to :back
end
######################################################################################
def find_item
		@commissioned_artist = Customer.find params[:customer_id]
		@items = Item.find(:all, :conditions => ["ItemLookupCode LIKE  ?", "%#{params[:item_keywords]}%" ], :limit => 50  )
		render :partial => "reports/item", :collection => @items, :spacer_template => "page_divider"
end
######################################################################################
def commissions
		@commisioned_artists = Customer.commisioned_artists	
end
######################################################################################
  def index
    @reports = Report.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.xml
  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.xml
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.xml
  def create
    @report = Report.new(params[:report])

    respond_to do |format|
      if @report.save
        flash[:notice] = 'Report was successfully created.'
        format.html { redirect_to(@report) }
        format.xml  { render :xml => @report, :status => :created, :location => @report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.xml
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        flash[:notice] = 'Report was successfully updated.'
        format.html { redirect_to(@report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.xml
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to(reports_url) }
      format.xml  { head :ok }
    end
  end
end
