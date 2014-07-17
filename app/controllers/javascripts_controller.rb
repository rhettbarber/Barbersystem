class JavascriptsController < ApplicationController
layout 'none'
before_filter :redirect_unless_admin

    def dynamic_department_categories
    @designer_department_categories = Category.find(:all)
    respond_to do |format|
        format.js
      end
  end

    def designer_department_categories
    @designer_department_categories = Category.find(:all)
    respond_to do |format|
        format.js
      end
  end



  def dynamic_categories
    @dynamic_categories = Category.find(:all)
    respond_to do |format|
        format.js
      end
  end



end
