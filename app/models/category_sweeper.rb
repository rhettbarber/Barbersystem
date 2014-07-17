class CategorySweeper < ActionController::Caching::Sweeper
	observe Category



    def after_update(category)
    	category.delete_category_menu_fragments
    	category.delete_cache
    end

    def after_create(category)
      category.delete_category_menu_fragments
    	category.delete_cache
    end

    def after_destroy(category)
     category.delete_category_menu_fragments
    	category.delete_cache
    end

    def after_save(category)
    	category.delete_category_menu_fragments
    	category.delete_cache
    end





end
