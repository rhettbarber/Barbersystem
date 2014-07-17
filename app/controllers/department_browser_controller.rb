class DepartmentBrowserController < ApplicationController

before_filter :redirect_unless_admin

respond_to :html, :xml
before_filter :find_departments


def find_departments
            #@departments = Department.search(params)
            #@departments = Department.hidden
            @departments = Department.all   #joins(:categories)  & Category.hidden  # RAILS 3 EXAMPLE
            #@departments = Department.with_hidden_categories
end

   def index
          respond_with(@departments)
  end

def index_testing
      render :text => Department.joins(:categories).to_sql.to_s
end



end
