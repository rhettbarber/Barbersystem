class UserMailer < ActionMailer::Base
  default from: "support@dixieoutfitters.com"



  def forgot_password(user, website)
    #setup_email(user,website)
    #@subject    += 'Request to change your password'
    #@body[:url]  = "https://" + website.domain + "/account/reset_password/#{user.password_reset_code}"


   if Rails.env.to_s  == "production"
                    @url  = "https://"  +  website.domain   + "/account/reset_password/#{user.password_reset_code}"
    else
                    @url  = "https://" + $request.server_name  + "/account/reset_password/#{user.password_reset_code}"
   end



    logger.warn "#################################"
    logger.warn "#################################"
    logger.warn "#################################"
    logger.warn "@url: " + @url
    logger.warn "#################################"
    logger.warn "#################################"
    logger.warn "#################################"

    mail(:to => user.email, :subject => "Forgot Password")

  end

  def purchase_confirmation(user, website, purchase, customer)
    #setup_email(user,website)
    #@subject    += 'Request to change your password'
    #@body[:url]  = "https://" + website.domain + "/account/reset_password/#{user.password_reset_code}"

    @s = "s"

    @subject   = 'Purchase Confirmation from '  + website.domain
    @user = user
    @website = website
    @purchase = purchase
    @customer = customer

    if Rails.env.to_s  == "production"
      @url  = "https://"  +  website.domain   + "/order_tracking"
    else
      @url  = "https://" + $request.server_name  + "/order_tracking"
    end



    logger.warn "#################################"
    logger.warn "#################################"
    logger.warn "#################################"
    logger.warn "@subject: " + @subject.to_s
    logger.warn "@user: " + @user.to_s
    logger.warn "@website: " + @website.to_s
    logger.warn "@purchase: " + @purchase.to_s
    logger.warn "@customer: " + @customer.to_s
    logger.warn "@url: " + @url.to_s
    logger.warn "#################################"
    logger.warn "#################################"
    logger.warn "#################################"

    mail(:to => user.email, :subject =>  @subject)

  end


  protected
  def setup_email(user,website)
    @recipients  = "#{user.email}"
    @from        = "no_respond@" + website.domain
    @subject     =  '  - '
    @sent_on     = Time.now
    #@body[:user] = user
  end




end
