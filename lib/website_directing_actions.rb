module WebsiteDirectingActions
 
############################################################################################################
def redirect_unless_logged_in

            store_location
            if   logged_in?
                         true
            else
                    flash[:notice] = "Please log in as authorized user"
                    redirect_to(:controller => 'account',:action => 'login')
                        false
            end
end
############################################################################################################
 def redirect_sale_items
		if @user
					redirect_to(:controller => @website.name ,:action => 'sale_items')  
		else
					session['return-to'] = '/' + @website.name + '/' + 'sale_items'
					flash[:notice] = "Please log in to see Your Sale Price"
					redirect_to(:controller => 'account',:action => 'login')  
		end
end
############################################################################################################
def redirect_sale_designs
		if @user
					redirect_to(:controller => @website.name ,:action => 'sale_designs')  
		else
					session['return-to'] = '/' + @website.name + '/' + 'sale_designs'
					flash[:notice] = "Please log in to see Your Sale Price"
					redirect_to(:controller => 'account',:action => 'login')  
		end
end 
############################################################################################################
def redirect_unless_manager
             store_location
           if   manager?
                         true
            else
                    flash[:notice] = "Please log in.m"
                    redirect_to(:controller => 'account',:action => 'login')  
                        false
            end
end     
############################################################################################################
def store_location
      session['return-to'] = request.fullpath
end
############################################################################################################
def redirect_to_stored_or_default(default=nil)
      if session['return-to'].nil?
        redirect_to default
      else
        redirect_to session['return-to']
        session['return-to'] = nil
      end
end
############################################################################################################
def redirect_back_or_default(default=nil)
      if request.env["HTTP_REFERER"].nil?
        redirect_to default
      else
        redirect_to(request.env["HTTP_REFERER"]) # same as redirect_to :back
      end
end
############################################################################################################  
def referring_action
    referrer = request.env["HTTP_REFERER"]
    if referrer
        referrer_path  = Pathname.new(referrer)
        referrer_basename = referrer_path.basename.to_s
        return referrer_basename
    else
          ['0']
    end
end
############################################################################################################     
def redirect_unless_development_port
  store_location
            if   development_port? == true
                         true
            else
                    flash[:notice] = "Not D"
                    redirect_to(:controller => 'account',:action => 'login')  
                        false
            end
end      
############################################################################################################
def redirect_unless_admin
            #if   logged_in? && current_user.user_type_id == 3
          store_location
          startup_user  unless @user
           if   admin?

                         true
            else
                    flash[:notice] = "Please log in"
                    redirect_to(:controller => 'account',:action => 'login')  
                        false
            end
end       
############################################################################################################
def redirect_unless_intranet
            #if   logged_in? && current_user.user_type_id == 3
           store_location
           if   intranet? or admin?
                         true
            else
                    flash[:notice] = "Please log in, zewd"
                    redirect_to(:controller => 'account',:action => 'login')
                        false
            end
end
############################################################################################################


def redirect_unless_priviledged_ip
            if   priviledged_ip? == true
                         true
            else
                    flash[:notice] = "No Access"
                    redirect_to(:controller => 'account',:action => 'login')  
                        false
            end
end      
############################################################################################################  
def redirect_unless_cashier
          store_location
          logger.debug "SEE ME - SEE ME - SEE ME - SEE ME - SEE ME - SEE ME"
          logger.debug "cashier?: " + cashier?.to_s
           logger.debug "developer?: " + developer?.to_s
            if   cashier?     or developer?
                         true
            else
                    flash[:notice] = "No Access"
                    redirect_to(:controller => 'account',:action => 'login')
                        false
            end
            logger.debug "SEE ME - SEE ME - SEE ME - SEE ME - SEE ME - SEE ME"
end      
############################################################################################################ 
def your_cart
  redirect_to(:controller => 'cart' , :action => 'index')
end
###########################################################################################################
def home
       render(:partial => "#{@website.name}/index",:layout => @website.name )
end
###########################################################################################################
#def index
#    redirect_to(:controller => @website.name, :action => 'category_browser')
#end
###########################################################################################################



end
