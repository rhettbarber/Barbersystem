module Caching
  class MemoryCache
    # create a private instance of MemoryStore
    def initialize
      @memory_store = ActiveSupport::Cache::MemCacheStore.new
    end

    # this will allow our MemoryCache to be called just like Rails.cache
    # every method passed to it will be passed to our MemoryStore
    def method_missing(m, *args, &block)
      @memory_store.send(m, *args)
    end

    # create the singleton object
    @@me = MemoryCache.new


    # this is a class method, we will be using it as follows: MemoryCache.instance
    def self.instance
      return @@me
    end

    # do not allow outsider calls to instantiate this cache
    private_class_method :new
  end
end


#http://stackoverflow.com/questions/7898994/how-to-use-multiple-caches-in-rails-for-real

      #Caching::MemoryCache.instance.write("foo", "bar")
      #=> true
      #Caching::MemoryCache.instance.read("foo")
      #=> "bar"
      #Caching::MemoryCache.instance.clear
      #=> 0
      #Caching::MemoryCache.instance.read("foo")
      #=> nil
      #Caching::MemoryCache.instance.write("foo1", "bar1")
      #=> true
      #Caching::MemoryCache.instance.write("foo2", "bar2")
      #=> true
      #Caching::MemoryCache.instance.read_multi("foo1", "foo2")
      #=> {"foo1"=>"bar1", "foo2"=>"bar2"}