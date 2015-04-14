class ItemSalesReportsController < ApplicationController
before_filter :redirect_unless_admin

def departments
        @deparments = @website.default_item_departments
end



  def test
  end

  def monthly_item_sales
  end

  def monthly_item_sales_top_15
  end

end
