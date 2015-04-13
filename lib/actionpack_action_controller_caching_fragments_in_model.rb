require 'fileutils'
require 'uri'
require 'set'

 module ModelFragments
      # Given a key (as described in <tt>expire_fragment</tt>), returns a key suitable for use in reading,
      # writing, or expiring a cached fragment. If the key is a hash, the generated key is the return
      # value of url_for on that hash (without the protocol). All keys are prefixed with "views/" and uses
      # ActiveSupport::Cache.expand_cache_key for the expansion.
      def fragment_cache_key(key)
        ActiveSupport::Cache.expand_cache_key(key.is_a?(Hash) ? url_for(key).split("://").last : key, :views)
      end

      def fragment_for(buffer, name = {}, options = nil, &block) #:nodoc:
        if perform_caching
          if cache = read_fragment(name, options)
            buffer.concat(cache)
          else
            pos = buffer.length
            block.call
            write_fragment(name, buffer[pos..-1], options)
          end
        else
          block.call
        end
      end

      # Writes <tt>content</tt> to the location signified by <tt>key</tt> (see <tt>expire_fragment</tt> for acceptable formats)
      def write_fragment(key, content, options = nil)
      $stdout.puts "################################"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "YYYYYYY   ACTIONPACK ACCF IN MODEL   YYYYYYYYYYY"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "################################"
      $stdout.puts "################################"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "YYYYYYY   ACTIONPACK ACCF IN MODEL   YYYYYYYYYYY"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "################################"
      $stdout.puts "################################"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "YYYYYYY   ACTIONPACK ACCF IN MODEL   YYYYYYYYYYY"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "################################"
        return content unless cache_configured?

        key = fragment_cache_key(key)

        self.class.benchmark "Cached fragment miss: #{key}" do
           ActiveSupport::Cache.lookup_store(:file_store,  '/tmp/cache').write(key, content, options)
        end

        content
      end

      # Reads a cached fragment from the location signified by <tt>key</tt> (see <tt>expire_fragment</tt> for acceptable formats)
      def read_fragment(key, options = nil)
      $stdout.puts "################################"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "YYYYYYY   ACTIONPACK ACCF IN MODEL   YYYYYYYYYYY"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "################################"
      $stdout.puts "################################"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "YYYYYYY   ACTIONPACK ACCF IN MODEL   YYYYYYYYYYY"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "################################"
      $stdout.puts "################################"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "YYYYYYY   ACTIONPACK ACCF IN MODEL   YYYYYYYYYYY"
      $stdout.puts "YYYYYYYYYYYYYYYYYYYYYYYYYYYY"
      $stdout.puts "################################"
        return unless cache_configured?

        key = fragment_cache_key(key)

        self.class.benchmark "Cached fragment hit: #{key}" do
           ActiveSupport::Cache.lookup_store(:file_store,  '/tmp/cache').read(key, options)
        end
      end

      # Check if a cached fragment from the location signified by <tt>key</tt> exists (see <tt>expire_fragment</tt> for acceptable formats)
      def fragment_exist?(key, options = nil)
        return unless cache_configured?

        key = fragment_cache_key(key)

        self.class.benchmark "Cached fragment exists?: #{key}" do
           ActiveSupport::Cache.lookup_store(:file_store,  '/tmp/cache').exist?(key, options)
        end
      end

      # Removes fragments from the cache.
      #
      # +key+ can take one of three forms:
      # * String - This would normally take the form of a path, like
      #   <tt>"pages/45/notes"</tt>.
      # * Hash - Treated as an implicit call to +url_for+, like
      #   <tt>{:controller => "pages", :action => "notes", :id => 45}</tt>
      # * Regexp - Will remove any fragment that matches, so
      #   <tt>%r{pages/\d*/notes}</tt> might remove all notes. Make sure you
      #   don't use anchors in the regex (<tt>^</tt> or <tt>$</tt>) because
      #   the actual filename matched looks like
      #   <tt>./cache/filename/path.cache</tt>. Note: Regexp expiration is
      #   only supported on caches that can iterate over all keys (unlike
      #   memcached).
      #
      # +options+ is passed through to the cache store's <tt>delete</tt>
      # method (or <tt>delete_matched</tt>, for Regexp keys.)
      # 
#      def expire_fragment_BEFORE(key, options = nil)
#       	 #return unless cache_configured?
#
#        	key = key.is_a?(Regexp) ? key : fragment_cache_key(key)
#
#	        if key.is_a?(Regexp)
#	          self.class.benchmark "Expired fragments matching: #{key.source}" do
#	             ActiveSupport::Cache.lookup_store(:file_store,  '/tmp/cache').delete_matched(key, options)
#	          end
#	        else
#		          self.class.benchmark "Expired fragment: #{key}" do
#		             ActiveSupport::Cache.lookup_store(:file_store,  '/tmp/cache').delete(key, options)
#		          end
#	        end
#        end

      def expire_fragment(key, options = nil)
        return unless cache_configured?
        key = fragment_cache_key(key) unless key.is_a?(Regexp)
        message = nil

        instrument_fragment_cache :expire_fragment, key do
          if key.is_a?(Regexp)
            cache_store.delete_matched(key, options)
          else
            cache_store.delete(key, options)
          end
        end
      end

          def instrument_fragment_cache(name, key)
        ActiveSupport::Notifications.instrument("#{name}.action_controller", :key => key){ yield }
      end

####################################################################################################

    def self.included(base) #:nodoc:
      base.class_eval do
        @@cache_store = nil
        cattr_reader :cache_store

        # Defines the storage option for cached fragments
        def self.cache_store=(store_option)
          @@cache_store = ActiveSupport::Cache.lookup_store(store_option)
        end


        @@perform_caching = true
        cattr_accessor :perform_caching

        def self.cache_configured?
          perform_caching && cache_store
        end
      end
    end

    protected
      # Convenience accessor
      def cache(key, options = {}, &block)
        if cache_configured?
          cache_store.fetch(ActiveSupport::Cache.expand_cache_key(key, :controller), options, &block)
        else
          yield
        end
      end

    private
      def cache_configured?
        self.class.cache_configured?
      end
      
  end
