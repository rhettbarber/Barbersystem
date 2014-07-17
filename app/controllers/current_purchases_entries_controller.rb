class CurrentPurchasesEntriesController < ApplicationController
before_filter :redirect_unless_admin

  def index
#        render :text => 'sas'

            @purchases_entries = PurchasesEntry.only_designer_series



  end


  def purchase_details
  end

end
