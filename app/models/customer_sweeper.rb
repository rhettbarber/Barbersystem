class CustomerSweeper < ActionController::Caching::Sweeper
	observe Customer



    def after_update(customer)
      $stdout.puts "CUSTOMER SWEEPER DELETING CACHE"
		Caching::MemoryCache.instance.delete request.session_options[:id] + '_customer'
    end

    def after_create(customer)
		Caching::MemoryCache.instance.delete request.session_options[:id] + '_customer'
    end

    def after_destroy(customer)
		Caching::MemoryCache.instance.delete request.session_options[:id] + '_customer'
    end

    def after_save(customer)
		Caching::MemoryCache.instance.delete request.session_options[:id] + '_customer'
    end





end
