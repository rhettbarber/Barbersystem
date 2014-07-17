class ItemSalesController < ApplicationController
  
  before_filter :redirect_unless_admin   , :initialize_variables
  
  
  
  def index

    # test account number M35967
    # test customer_id 96218

    if  params[:week_number]
              @selected_week =   params[:week_number].to_i
   else
              @selected_week =  Date.today.strftime("%U")
     end

              if @selected_week
                        @selected_year  = Time.now.year

                        @customer_item_sales_by_years = ItemSale.where("sale_week = ? and sale_year = ?", @selected_week  , @selected_year   ).order("sum_of_quantity DESC")
              end

    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_sales }
    end
  end


  
  
  
end
