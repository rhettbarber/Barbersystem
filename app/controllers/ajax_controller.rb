class AjaxController < ApplicationController
layout 'blank'
before_filter :redirect_unless_admin

def ajax_search_items
                                            logger.debug "BEGIN ajax_search_items ########################################"
                                           @initial_items = ListingItem.find_with_msfte :matches_any => @keywords
                                           @items_with_rank = []
                                           @keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
                                           @initial_items.each do |item|
                                                                  item_words_string = item.id.to_s + ' ' +  item.ItemLookupCode.to_s + ' ' + item.Description.to_s    # + ' ' + item.ExtenededDescription.to_s + ' ' + item.Notes.to_s
                                                                  item_words_array  = item_words_string.split.collect {|c| "#{c.downcase}"}


                                                                 if item.aliasings
                                                                      item.aliasings.each do |al|
                                                                          item_words_array <<  al.Alias.downcase
                                                                      end
                                                                end


                                                                  item_words_set = item_words_array.to_set

                                                                   @keywords_set      = @keywords.to_set
                                                                   word_count = 0
                                                                   @keywords.each do  |kw|
                                                                       matching_words = @keywords_set.intersection(item_words_set)
                                                                       if matching_words.size > 0
                                                                             logger.debug "matching_words: " + matching_words.inspect
                                                                       else
                                                                              logger.debug "item_words_set because none match: " + item_words_set.inspect
                                                                       end
                                                                       if matching_words.size > 0
                                                                         word_count = matching_words.size
                                                                       end
                                                                   end
                                                                    item.SubDescription3 = word_count

                                                                    startup_website_all_items
                                                                   startup_acceptable_item_ids_by_website



                                                                     if !@acceptable_item_ids
                                                                             not_acceptable_item_ids
                                                                     end
                                                                     @items_with_rank	<< item if item.SubDescription3 != 0    && @acceptable_item_ids.include?(item.id)
                                                                     @items = @items_with_rank.sort_by {|a| a.SubDescription3}.reverse
                                           end
                                     render(:update) { |page|
                                                        page.replace_html 'page_content',   :partial => "advanced_main_menu/search_results_list_items"
                                     }
                                     logger.debug "END ajax_search_items ########################################"
end







  def ajax_search
                     @keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
                     @tokens = @keywords
                    if params[:search_type_name] == 'articles'
                                        ajax_search_articles

                    else
                                        ajax_search_items
                      end
  end



   def ajax_search_articles
                                                       @initial_revisions = ListingRevision.find_with_msfte :matches_any => @keywords
                                                  @revisions_with_rank = []
                                                  @keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}

                                                  @initial_revisions.each do |revision|

                                                             revision_words_string = revision.id.to_s + ' ' + revision.content.to_s  #  +  revision.page.name.to_s + ' ' + revision.page.slug.to_s     + ' '
                                                             revision_words_array  = revision_words_string.split.collect {|c| "#{c.downcase}"}
                                                             revision_words_set = revision_words_array.to_set

                                                              @keywords_set      = @keywords.to_set
                                                              word_count = 0
                                                              @keywords.each do  |kw|
                                                                  matching_words = @keywords_set.intersection(revision_words_set)
                                                                  if matching_words.size > 0
                                                                        logger.debug "matching_words: " + matching_words.inspect
                                                                  else
                                                                         logger.debug "revision_words_set because none match: " + revision_words_set.inspect
                                                                  end
                                                                  if matching_words.size > 0
                                                                    word_count = matching_words.size
                                                                  end
                                                              end
                                                               revision.total_column = word_count
                                                                @revisions_with_rank	<< revision if revision.total_column != 0
                                                                @revisions = @revisions_with_rank.sort_by {|a| a.total_column}.reverse
                                                  end
                                            render(:update) { |page|
                                                               page.replace_html 'page_content',   :partial => "advanced_main_menu/search_results_list_revisions"
                                             }
                                             logger.debug "ending search"
   end























def ajax_customer
                        @from_ajax = true
                        if @user.customer.update_attributes(params[:customer] )
                                              @status = "Success"

                        else
                                             @status = "Failure"
                        end
                                             render(:update) { |page|
                                                                 page.replace 'ajax_bill_to'  , :partial => 'advanced_main_menu/ajax_bill_to'  , :locals => { :status => @status }
                                            }

end


def ajax_ship_to
                        @from_ajax = true
                        if @user.customer.purchase.ship_to.update_attributes(params[:customer] )
                                              @status = "Success"

                        else
                                             @status = "Failure"
                        end
                                             render(:update) { |page|
                                                                 page.replace 'ajax_ship_to'  , :partial => 'advanced_main_menu/ajax_ship_to'  , :locals => { :status => @status }
                                            }

end







end
