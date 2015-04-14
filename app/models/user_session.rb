class UserSession < ActiveRecord::Base
	
belongs_to :user
belongs_to :purchase
has_many :rail_stats


def link_affiliate_paid?
		if    [ '' , nil ].include?(link_affiliate_paid)
					false
		else
					if    [ 1, '1' ].include?(link_affiliate_paid)
								true
					else
								false
					end
		end
end




end
