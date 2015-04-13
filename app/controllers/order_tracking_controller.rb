class OrderTrackingController < ApplicationController
 # layout 'ajaxified_application' via nested-layouts

before_filter :redirect_unless_logged_in
before_filter :initialize_variables, :only => [:index]

  def this_order
    startup_purchase

  end



  def index
                  # index action renders index.html which renders the page logo, all_orders.html and more to come...
                  # @user.viewable_purchases.sort_by{ |a|  a.purchase_id  }.reverse.each do |a_purchase|
                  # the index.html view finds the correct user purchases by association
                  #  @user = User.find( 923  )
  end

 
#  def show_order
#        firebug @user.viewable_purchases.inspect
##      firebug @user.inspect
#        @purchase = @user.customer.purchases.find( params[:purchase_id] )
#  end
#
#
#def checkout_review
#            firebug 'is updating'
#            firebug @purchase.inspect
#           prepare_purchase_totals(@purchase)
#            @your_purchases_entries = PurchasesEntry.find(:all,:conditions => ["purchase_id = ? ",session[:purchase_id] ] , :order => "id ASC"  )
#            @quote_tender_entry = QuoteTenderEntry.find_by_purchase_id(@purchase.id)
#            @ship_to = @purchase.ship_to
#end






end
