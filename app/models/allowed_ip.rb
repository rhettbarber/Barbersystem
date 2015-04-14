class AllowedIp < ActiveRecord::Base
	
	validates_uniqueness_of   :ip_address
	
end
