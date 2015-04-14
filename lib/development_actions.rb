module DevelopmentActions
  protected	


def send_error_to_admin
		begin
					UserNotifier.deliver_named_error(@user, @website, @purchase, params, @error_description_string )
		rescue
					red_alert
					logger.warn "send_error_to_admin FAILED"
		end
end

def warn_for_production
		if ["production"].include?(ENV["RAILS_ENV"])
				large_error_block
				do_not_start_up
		end

end



end
