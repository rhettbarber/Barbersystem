class AffiliatesController < ApplicationController
 #ssl_required :compensation_report
ssl_exceptions

before_filter :initialize_variables#, :only => [ :show_discount_info]

before_filter :redirect_unless_admin, :except => [:index, :terms_and_conditions, :links_and_banners, :compensation_report, :email_templates,:version_information,:how_it_works ]
before_filter :redirect_unless_logged_in, :except => [:index, :terms_and_conditions, :how_it_works]



def index
end

def compensation_report
					#@user = User.find 53859 if @user.id = 145
					logger  = Logger.new(STDOUT)
					logger.level = Logger::DEBUG
					@non_qualifying_total           =  0.0
					@non_qualifying_commision_total   =  0.0
					@qualifying_total           =  0.0
					@qualifying_commision_total   =  0.0
					@total_paid = 0.0
					@user_sales_by_affiliates = @user.sales_by_affiliates
					@user_sales_by_affiliates.each do |sba|
						#debugger
						#	logger.warn(sba.to_xml)
							if sba.sale
									logger.warn("SUCCESS SBA.SALE!")
									@qualifying_total +=   sba.sale.total_payable   if sba.sale.payable_qualification_information  == true 
									@qualifying_commision_total += sba.sale.link_affiliate_payable_sale_amount   if  sba.sale.payable_qualification_information  == true 
									@non_qualifying_total += sba.sale.total_payable  if  sba.sale.purchase.affiliate_paid != 1 and  sba.sale.payable_qualification_information  == false 
									@non_qualifying_commision_total += sba.sale.link_affiliate_payable_sale_amount   if  sba.sale.purchase.affiliate_paid != 1  and  sba.sale.payable_qualification_information  == false 
									@total_paid += sba.sale.link_affiliate_payable_sale_amount   if  sba.sale.purchase.affiliate_paid == 1  
							end	
					end
						########## BEGIN AFFILIATE RECRUITER REPORT AREA
					@recruited_users = User.find_all_by_affiliate_originator_id(@user.id.to_s)
								@recruited_non_qualifying_total           =  0.0
								@recruited_non_qualifying_commision_total   =  0.0
								@recruited_qualifying_total           =  0.0
								@recruited_qualifying_commision_total   =  0.0
					if @recruited_users

								@user_sales_by_affiliate_recruiters = @user.sales_by_affiliate_recruiters
								@user_sales_by_affiliate_recruiters.each do |sbar|
										@recruited_qualifying_total += sbar.sale.total_payable   if  sbar.sale.payable_qualification_information  == true
										@recruited_qualifying_commision_total += sbar.sale.recruited_affiliate_payable_sale_amount   if  sbar.sale.payable_qualification_information  == true
										@recruited_non_qualifying_total += sbar.sale.total_payable  unless  sbar.sale.payable_qualification_information == true
										@recruited_non_qualifying_commision_total += sbar.sale.recruited_affiliate_payable_sale_amount  unless  sbar.sale.payable_qualification_information == true
								end
					end
						########## END AFFILIATE RECRUITER REPORT AREA
									@non_qualifying_combined_total = @non_qualifying_total + @recruited_non_qualifying_total
									@non_qualifying_combined_commision_total = @non_qualifying_commision_total + @recruited_non_qualifying_commision_total
									@qualifying_combined_total = @qualifying_total  + @recruited_qualifying_total 
									@qualifying_combined_commision_total = @qualifying_commision_total  + @recruited_qualifying_commision_total
end





def email_templates
#	render :partial => "affiliates/email_templates"  #,:layout => 'affiliates'
end

def links_and_banners
#	render :partial => "affiliates/links_and_banners"  #,:layout => 'affiliates'
end




end
