class Email < ActiveRecord::Base


 validates_length_of       :address,    :within => 3..255
#validates_uniqueness_of   :email, :case_sensitive => false , :message => 'Your email address has already been used, go to "forgot password" and it will be emailed to you'
validates_format_of :address, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i
validates_uniqueness_of  :address,     :message => "Your email is already on our list. Thanks!"



end
