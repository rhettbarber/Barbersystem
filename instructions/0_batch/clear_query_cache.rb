


	Thread.new{ system("cmd /c cd C:\Documents and Settings\Administrator\My Documents\rails\barbersystem && ruby script/console")}
			
		ActiveRecord::Base.query_cache.clear_query_cache
		
		ActiveRecord::ConnectionAdapters.clear_query_cache