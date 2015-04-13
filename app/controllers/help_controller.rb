class HelpController < ApplicationController
  
  def index
  end

  ############################################################################################################
def help_popup
	render :partial => "cart/help_popup"
end
############################################################################################################
def opacity_help_popup
	render :partial => "shared_item/opacity_help_popup"
end
###########################################################################################################




end
