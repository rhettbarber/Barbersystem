module RubyArray


def setup_flash_messages_array
        @flash_messages = []
        if !flash[:notice].nil?
        	@flash_messages << flash[:notice] 
      	end
end



end
