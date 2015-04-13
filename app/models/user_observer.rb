class UserObserver < ActiveRecord::Observer
 
  
  
  
  
  def after_create(user)
    UserNotifier.deliver_registration_confirmation(user)
  end

  def after_save(user)
  #  UserNotifier.new_user_welcome(user) 
    UserNotifier.deliver_forgot_password(user) if user.recently_forgot_password?
    UserNotifier.deliver_reset_password(user) if user.recently_reset_password?
  end


  def after_save_ORIG(user)
    UserNotifier.deliver_activation(user) if user.recently_activated?
  end




end