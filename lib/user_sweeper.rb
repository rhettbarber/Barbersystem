class UserSweeper < ActionController::Caching::Sweeper
	#observe User



    def delete_user_cache
        $stdout.puts "USER  DELETING CACHE"
        Caching::MemoryCache.instance.delete request.session_options[:id] + '_user'
    end







end
