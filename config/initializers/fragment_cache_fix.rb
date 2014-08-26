#http://scottiestech.info/2011/07/23/fixing-the-rails-3-fragment-cache-path/
#http://scottiestech.info/2009/12/04/increase-the-performance-of-fragment-caching-in-rails/

ActiveSupport::Cache::FileStore.module_eval do
  def key_file_path(key)
    fname = key.to_s
    fname_paths = []
    # Make sure file name is < 255 characters so it doesn't exceed file system limits
    if fname.size <= 255
      fname_paths << fname
    else
      while fname.size > 255
        fname_paths << fname[0, 255]
        fname = fname[255, -1]
      end
    end
    File.join(cache_path, *fname_paths) + '.cache'
  end
end