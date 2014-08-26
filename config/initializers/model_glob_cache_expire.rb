class ActiveRecord::Base

  def glob_cache_expire( cachepath )
    logger.debug "cachepath: " + cachepath.inspect
    glob_directories_to_expire = Dir.glob( cachepath )
    logger.debug "glob_directories_to_expire: " + glob_directories_to_expire.inspect
    FileUtils.rm_rf(Dir.glob( glob_directories_to_expire ))
  end



end