class CustomerItemSalesByYearsController < ApplicationController

  before_filter  :initialize_variables
  before_filter :redirect_unless_admin , :except => [:your_purchases_this_year]




def your_purchases_this_year
              # @selected_customer =   Customer.where("AccountNumber = ?", "9410"  ).first   # @customer
              # @selected_customer =   Customer.where("AccountNumber = ?", "mob2656"  ).first   # @customer
              @selected_customer =    @customer
                      if @selected_customer
                                @selected_customer_id =  @selected_customer.id
                                @selected_year  = Time.now.year

                                @customer_item_sales_by_years = CustomerItemSalesByYear.where("customer_id = ? and sale_year = ?", @selected_customer_id  , @selected_year   ).order("sum_of_quantity DESC")
                      end

            respond_to do |format|
                      format.html # index.html.erb
                      format.json { render json: @customer_item_sales_by_years }
            end
end





  def index

    # test account number M35967
   # test customer_id 96218

    if  params[:account_number]
                   @selected_customer =   Customer.where("AccountNumber = ?",  params[:account_number]  ).first
                   if @selected_customer
                                  @selected_customer_id =  @selected_customer.id
                                  @selected_year  = Time.now.year

                                  @customer_item_sales_by_years = CustomerItemSalesByYear.where("customer_id = ? and sale_year = ?", @selected_customer_id  , @selected_year   ).order("sum_of_quantity DESC")
                    end
     end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customer_item_sales_by_years }
    end
  end
  #
  ## GET /customer_item_sales_by_years/1
  ## GET /customer_item_sales_by_years/1.json
  #def show
  #  @customer_item_sales_by_year = CustomerItemSalesByYear.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @customer_item_sales_by_year }
  #  end
  #end
  #
  ## GET /customer_item_sales_by_years/new
  ## GET /customer_item_sales_by_years/new.json
  #def new
  #  @customer_item_sales_by_year = CustomerItemSalesByYear.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @customer_item_sales_by_year }
  #  end
  #end
  #
  ## GET /customer_item_sales_by_years/1/edit
  #def edit
  #  @customer_item_sales_by_year = CustomerItemSalesByYear.find(params[:id])
  #end
  #
  ## POST /customer_item_sales_by_years
  ## POST /customer_item_sales_by_years.json
  #def create
  #  @customer_item_sales_by_year = CustomerItemSalesByYear.new(params[:customer_item_sales_by_year])
  #
  #  respond_to do |format|
  #    if @customer_item_sales_by_year.save
  #      format.html { redirect_to @customer_item_sales_by_year, notice: 'Customer item sales by year was successfully created.' }
  #      format.json { render json: @customer_item_sales_by_year, status: :created, location: @customer_item_sales_by_year }
  #    else
  #      format.html { render action: "new" }
  #      format.json { render json: @customer_item_sales_by_year.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## PUT /customer_item_sales_by_years/1
  ## PUT /customer_item_sales_by_years/1.json
  #def update
  #  @customer_item_sales_by_year = CustomerItemSalesByYear.find(params[:id])
  #
  #  respond_to do |format|
  #    if @customer_item_sales_by_year.update_attributes(params[:customer_item_sales_by_year])
  #      format.html { redirect_to @customer_item_sales_by_year, notice: 'Customer item sales by year was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @customer_item_sales_by_year.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## DELETE /customer_item_sales_by_years/1
  ## DELETE /customer_item_sales_by_years/1.json
  #def destroy
  #  @customer_item_sales_by_year = CustomerItemSalesByYear.find(params[:id])
  #  @customer_item_sales_by_year.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to customer_item_sales_by_years_url }
  #    format.json { head :no_content }
  #  end
  #end
end
