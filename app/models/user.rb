require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :custom_items
  has_many :viewable_purchases
  has_one :user_theme
  has_many :sales_by_affiliates , :foreign_key => "a_id"
  has_many :sales_by_affiliate_recruiters , :foreign_key => "recruiter_a_id"  
	has_many  :user_authorities
	has_many :user_sessions
	belongs_to :customer
	belongs_to :user_type
	has_many :revisions
	has_many :purchases , :through => :customer 
	
	attr_accessible :email ,:password, :password_confirmation
	#  has_many :sessions # , :foreign_key => 'session_user_id'
	# Virtual attribute for the unencrypted password
	attr_accessor :password
	# attr_protected :login
	# attr_protected :email
	# attr_protected :crypted_password
	# attr_protected :salt
	# attr_protected :customer_id
	#  validates_presence_of     :login, :email
	validates_presence_of     :password,                   :if => :password_required?
	validates_presence_of     :password_confirmation,      :if => :password_required?
	validates_length_of       :password, :within => 4..40, :if => :password_required?
	validates_confirmation_of :password,                   :if => :password_required?
	validates_length_of       :email,    :within => 3..255
	validates_uniqueness_of   :email, :case_sensitive => false , :message => 'Your email address has already been used, go to "forgot password" and it will be emailed to you'
	validates_format_of :email, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i
	
	before_save :encrypt_password
	#   before_create :make_activation_code
###########################################################################################
#validates_associated :customer
###########################################################################################
	cattr_accessor  :is_administrator_subdomain
	cattr_accessor  :admin
  ###########################################################################################


  def self.theme_name(user=0)
           if user != 0
                    if user.user_theme
                          user.user_theme.name
                    else
                             'default-theme'
                    end
           else
                    'default-theme'
           end
  end



def recruiter
		if self.original_affiliate
				potential_recruiter = self.original_affiliate.original_affiliate
				if potential_recruiter
					return potential_recruiter
				else
					return false
				end
		else
				return false
		end
end
###########################################################################################
def original_affiliate
			if self.affiliate_originator_id
					if self.affiliate_originator_id != '0' and self.affiliate_originator_id != 0
			 				User.find self.affiliate_originator_id
			 		else
			 					false
			 		end
			else
						false
			end
end
###########################################################################################
#def is_admin?
#                              if  self.admin
#                                            logger.debug "admin == true because main admin? action says so"
#                                            true
#                              else
#                                           logger.debug "admin != true because main admin? action says so"
#                                           false
#                              end
#end

	def can_real?(action,website)
		if self.user_type_id == 5  and  self.is_administrator_subdomain
            return user_type.actions.include?(Action.find_by_name(action))
		else
        if  self.is_administrator_subdomain or self.is_admin?
            return user_type.actions.include?(Action.find_by_name(action)) && this_website_authority?(website)
        else
              return false
        end
		end
	end


 	def can?(action,website)
        if self.admin
                return true
        else
              return false
        end
	end



  ###########################################################################################
def find_affiliate_rail_stats_with_sales
					conditions = [ "a_id = ?", self.a_id ]
					@initial_rail_stats = RailStat.find(:all, :conditions => conditions)
					self_session_ids = []
					@initial_rail_stats.each do |rs|
						self_session_ids << rs.user_session_id
					end
					self_session_ids = self_session_ids.uniq
					conditions = [ "user_session_id in (?)", self_session_ids ]
					@all_this_affiliates_rail_stats = RailStat.find(:all, :conditions => conditions)
					@purchased_rail_stat_ids = []
					@purchased_user_session_ids = []
					@all_this_affiliates_rail_stats.each do |rs|
						
						if rs.a_id != 0
								if rs.a_id = self.a_id
											if rs.user_session
														if rs.user_session.purchase
																	if rs.user_session.purchase.sale
																				if rs.user_session.purchase.sale.Total > 0
																							if @purchased_user_session_ids != nil
																								unless @purchased_user_session_ids.include?(rs.user_session_id)
																									@purchased_rail_stat_ids << rs.id
																									@purchased_user_session_ids << rs.user_session_id
																								end
																							else
																								@purchased_rail_stat_ids << rs.id
																								@purchased_user_session_ids << rs.user_session_id
																							end	
																				end
																	end
														end
											end
									end
						end
					end	
					@purchased_user_session_ids = @purchased_user_session_ids.uniq
					conditions = [ "rail_stats.id in (?)", @purchased_rail_stat_ids ]
					@rail_stats = RailStat.find(:all, :conditions => conditions, :include => ["user_session" ] )
					if @rail_stats
							return @rail_stats
					else
							return 0
					end
end






###########################################################################################
def a_id
	self.id.to_s
end
###########################################################################################
def self.new_a_id_code
	random_string = 'bb' + User.generate_random_string.to_s
	if User.exists?(:a_id => random_string)
		User.new_a_id_code
	else
		return random_string
	end
end	
###########################################################################################
def self.generate_random_string
#	key = Array.new(7) { (rand(122-97) + 97).chr }.join
	key = rand(10000)
end
###########################################################################################
def customer_attributes=(customer_attributes)
	customer_attributes.each do |attribute|
		customers.build(attributes)
	end	
end
###########################################################################################
def validate
   self.errors.add_to_base  'This record did not save correctly' unless self.errors.empty?
end
###########################################################################################
def commision_percentage
	8
end	
###########################################################################################
def this_quarter_payable_commision
	this_quarter_stats  =	UserSession.find(:all, :conditions => [ "a_id LIKE ? and created_at > ?" , self.a_id , Time.now.at_beginning_of_quarter ] )
	
	this_quarter_total = 0
	this_quarter_stats.each do |stat|
		if stat.purchase
			this_quarter_total += stat.purchase.affiliate_payable_amount if stat.link_affiliate_paid == 0
		end	
	end	
	return this_quarter_total
end
###########################################################################################
def previous_quarters_leftover_commision
	previous_quarters_stats = UserSession.find(:all, :conditions => [ "a_id LIKE ? and created_at < ?" , self.a_id , Time.now.at_beginning_of_quarter ] )
	previous_quarters_total = 0
	previous_quarters_stats.each do |stat|
		if stat.purchase
			previous_quarters_total += stat.purchase.affiliate_payable_amount if stat.link_affiliate_paid != 0
		end	
	end	
	return previous_quarters_total
end
###########################################################################################
def total_payable_commision
	previous_quarters_leftover_commision + this_quarter_payable_commision
end
###########################################################################################
###########################################################################################
###########################################################################################
###########################################################################################

	def login
			self.email
	end
###########################################################################################
def this_website_authority?(website)
	 if user_authorities.find_by_website_id(website) or  user_authorities.find_by_website_id(16)
	 	true
	 else
	 	false
	 end		
end
###########################################################################################
	def change_email_address(new_email_address)
	      @change_email  = true
	      self.new_email = new_email_address
	   #   self.make_email_activation_code
	end
###########################################################################################
   def activate_new_email
     activate_new_email_off
     @activated_email = true
     update_attributes(:email=> self.new_email, :new_email => nil, :email_activation_code => nil)
   end
###########################################################################################
   def recently_changed_email?
      @change_email
   end
###########################################################################################
   def forgot_password
     @forgotten_password = true
     self.make_password_reset_code
   end
###########################################################################################
   def reset_password
     # First update the password_reset_code before setting the 
     # reset_password flag to avoid duplicate email notifications.
     update_attributes(:password_reset_code => nil)
     @reset_password = true
   end
###########################################################################################
   def recently_reset_password?
     @reset_password
   end
###########################################################################################
   def recently_forgot_password?
     @forgotten_password
   end
###########################################################################################
    # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
    def self.authenticate(email, password)
      # hide records with a nil activated_at
  #    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login]   ##this method requires activation
      u = find :first, :conditions => ['email = ?', email]
      u && u.authenticated?(password) ? u : nil
    end
###########################################################################################
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end
###########################################################################################
  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
###########################################################################################
  def authenticated?(password)
    crypted_password == encrypt(password)
  end
###########################################################################################
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end
###########################################################################################
  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end
###########################################################################################
  def forget_me
        begin
                self.remember_token_expires_at = nil
                self.remember_token            = nil
        save(false)
        rescue
        end
    end
###########################################################################################
  protected
  
    def make_password_reset_code
     self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
   end
  
  
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end


#####################################################################################################################

def find_user_id_using_session_id_DEPRECATE
	ses = Session.find(:first, :conditions => ["session_id = ?", session.session_id ] )
	ses_user = ses.user
	if ses_user
		return ses_user.id
	else
		return 0	
	end
	
end	

#####################################################################################################################
	def can_DEPRECATE?(action,website)
		if self.user_type_id == 5
					
					debugger
					
					return user_type.actions.include?(Action.find_by_name(action))
		else	
					return user_type.actions.include?(Action.find_by_name(action)) && this_website_authority?(website)
		end
	end
###########################################################################################


end
