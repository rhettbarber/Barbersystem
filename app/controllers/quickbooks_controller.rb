class QuickbooksController < ApplicationController
  before_filter :redirect_unless_admin
  def index
          @first_customer =   Quickbooks::Customer.first
          render :text => 'begin page <br> new line </br>First Customer <br> #{@first_customer}  </br>'
  end



end
