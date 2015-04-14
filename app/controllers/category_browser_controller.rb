class CategoryBrowserController < ApplicationController
respond_to :html, :xml

before_filter  :initialize_variables  , :only => [  :index ]

############################################################################################################
#caches_action :index, :cache_path => Proc.new { |c| c.params }


def index
            startup_browsing
            startup_symbiont

            g = "g"

            @departments = @purchase.symbiote.item.category.potential_opposite_departments.intersection(@combined_departments)

#              @website_hidden_categories = @website.hidden_website_category_ids if @department

             if @incomplete_symbiont
                           if @purchase_symbiote_item_type == 'master'
                                  @completion_status_bar_message = 'Complete your chosen Item by selecting from one of the design categories below'
                          else
                                    @completion_status_bar_message = 'Complete your chosen Design by selecting from one of the Item categories below'
                          end
              else
                       if params[:department_type]
                                    @department_introduction = true
                                    @departments = nil
                      end
            end
end
############################################################################################################









#@departments = departments_containing_applicable_categories( @departments )  if @incomplete_symbiont
#def departments_containing_applicable_categories( departments )
#         applicable_departments = Set.new
#
#
#
#         departments.each do |department|
#                department.categories.each do |category|
#                        logger.debug "@purchase.symbiote.item.category.potential_opposite_categories: " + @purchase.symbiote.item.category.potential_opposite_categories.inspect
#                        logger.debug "category: " + category.inspect
#                        applicable_departments.add?( department )  if @purchase.symbiote.item.category.potential_opposite_categories.include?(category)
#                  end
#         end
#         return applicable_departments
#end









#  logger.debug "202020202020202020202020 "
#  logger.debug "@combined_departments: " + @combined_departments.inspect
#  logger.debug "@combined_departments.size: " + @combined_departments.size.to_s
#  logger.debug "@combined_departments[0].inspect: " + @combined_departments[0].inspect



end


