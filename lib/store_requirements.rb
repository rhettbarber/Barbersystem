module StoreRequirements
#  protected	



############################################################################################################
#def ensure_positive_quantity(quantity)
#                        if quantity.to_i >= 1
#                          @quantity =quantity.to_i
#                      else
#                          @quantity = 1
#                      end
#end
############################################################################################################
#def fails_membership_requirement?(item)
#    if @customer_array.CustomText4  != 'DO'   &&   item.department.license_required == true   &&   @customer_array.PriceLevel == 2
#           flash[:notice] = "This item requires dixie outfitters license. Call 1-866-916-5866 for details"
#           true
#    else
#            false
#    end
#end
#############################################################################################################
#def purchase_in_progress?
#   unless @purchase
#                  flash[:notice] = "Please begin a new purchase"
#                  redirect_to(:controller =>  'cart' ,:action => 'index')
#                false
#    end
#end
#############################################################################################################
#def incomplete_symbiont?
#            if @purchase
#                            if @purchase.incomplete_symbiont == true
#                                    flash[:notice] = "You have an incomplete item"
#                                   redirect_to( :controller =>  'cart', :action => 'index' )
#                             end
#            end
#end
#############################################################################################################
#def color_compatible(item,design)
#	logger.debug "-------------------------------------color_compatible .shade check: item: #{item.shade.downcase} - design: #{design.shade.downcase}"
#	if item.shade.downcase == 'colored' && design.shade.downcase == 'transparent'
#		'false'
#	else
#		'true'
#	end
#end
############################################################################################################


end
