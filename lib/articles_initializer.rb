module ArticlesInitializer
############################################################################################################
def find_latest_revision_ids
	 logger.debug "-------------------------------------begin latest_revision_ids"
      current_website unless @website
			@latest_revision_ids = Caching::MemoryCache.instance.read  @website.name + '_latest_revision_ids'
		if !@latest_revision_ids or @latest_revision_ids.nil? or @latest_revision_ids == ''
			@latest_revision_ids =  Revision.find_latest_published_revision_ids
			Caching::MemoryCache.instance.write( @website.name + '_latest_revision_ids' , @latest_revision_ids , :expires_in => 227.minutes)

		end
	 logger.debug "-------------------------------------end latest_revision_ids"
end
 
end
