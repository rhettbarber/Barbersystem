class UserNotifier < ActionMailer::Base


 def affiliate_sale_notification_admin( user_who_purchased, website, purchase)
    @recipients  = [ "rhett@barberandcompany.com", "dewey@barberandcompany.com" ]
    @from        = "no_respond@" + website.domain
    @subject     =  '  - '
    @sent_on     = Time.now
    @subject    +=  website.domain + "ADMIN-affiliate sale notification"
    @body[:website] = website
    @body[:purchase] = purchase
    @body[:affiliate_user] = 	purchase.affiliate_user
     @body[:user_who_purchased] = 	user_who_purchased
  end


  def affiliate_recruiter_sale_notification( user, website, purchase)
    setup_email(user,website)
    @subject    +=  website.domain + " affiliate recruiter sale notification"
    @body[:user] = user
    @body[:website] = website
    @body[:purchase] = purchase
  end




  def affiliate_sale_notification( website, purchase)
  	user = purchase.affiliate_user
    setup_email(user,website)
    @subject    +=  website.domain + " affiliate sale notification"
    @body[:user] = user
    @body[:website] = website
    @body[:purchase] = purchase
  end





def named_image_error(user, website, params, error_name ,referrer )
    setup_error_email(website)
    if params
    	@subject    +=  error_name + '_' + params.to_hash.to_s
	else
	 	@subject    +=  error_name
	end
    @body[:user] = user
    @body[:website] = website
    @body[:params] = params
    @body[:referrer] = referrer
    @body[:error_name] = error_name
end	

def named_error(user, website, purchase, params, error_name )
    setup_error_email(website)
    if params
    	@subject    +=  error_name + '_' + params.to_hash.to_s
	else
	 	@subject    +=  error_name
	end
    @body[:user] = user
    @body[:website] = website
    @body[:purchase] = purchase
    @body[:params] = params
    @body[:error_name] = error_name
end	

  def purchase_confirmation(user, website, purchase)
    setup_email(user,website)
    @subject    += 'Purchase Confirmation from '  + website.domain
    @body[:user] = user
    @body[:website] = website
    @body[:purchase] = purchase
  end


  def email_new_password(user, website, new_password)
         setup_email(user, website)
         @subject    +=  website.domain + ' new password'
         @body[:new_password] = new_password
         @body[:website] = website
  end
  
 
  def my_mail_message
    part "text/plain" do |p|
      p.body "hello, world"
      p.transfer_encoding "base64"
    end

    attachment "image/jpg" do |a|
      a.body = File.read("hello.jpg")
      a.filename = "hello.jpg"
    end
  end


  def forgot_password(user, website)
    setup_email(user,website)
    @subject    += 'Request to change your password'
    @body[:url]  = "https://" + website.domain + "/account/reset_password/#{user.password_reset_code}" 
  end

  def reset_password(user,website)
    setup_email(user,website)
    @subject    += 'Your password for ' + website.domain + ' has been reset'
  end

   
  def registration_confirmation(user,website)
         setup_email(user, website)
         @subject    += 'Thank you for Registering with ' + website.domain
  end
  

  protected
  def setup_email(user,website)
    @recipients  = "#{user.email}"
    @from        = "no_respond@" + website.domain
    @subject     =  '  - '
    @sent_on     = Time.now
    @body[:user] = user
  end
 
	def setup_error_email(website)
	    @recipients  = "rhett@barberandcompany.com"
	    @from        = "rhett@" + website.domain
	    @subject     = "ne_"
	    @sent_on     = Time.now
	 end
  
  
  def setup_admins_email(user,website)
    @recipients  = "b_rhettbarber@yahoo.com"
    @from        = "rhett@" + website.domain
    @subject     = domain + " admin notice"
    @sent_on     = Time.now
    @body[:user] = user
  end

######################## DEPRECATED
  
  def signup_notification_OFF(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://YOURSITE/account/activate/#{user.activation_code}"
  end
  
end
