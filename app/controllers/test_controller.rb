class TestController < ApplicationController

  before_filter  :initialize_variables
before_filter :redirect_unless_admin

  skip_before_filter :verify_authenticity_token, :only => [:form_action ]

  layout 'blank'


def gems
              @gems = Gem.loaded_specs.values.map {|x| "#{x.name} #{x.version}"}
end



def  sql_optimizer

end


def last_core_number
          @items = Item.order("id DESC" ).limit("600").all

end



  def index



  end


def ajax_test
#  render :text => "alert('what!')"
          render :update do |page|

            page << "alert('great')"
          end
  end





#                  @advanced_combination = AdvancedCombination.find 2
#            @ss = Film.find_with_msfte :matches_any => ["patricks", "firemen", "warehouse", "riverstreet","imprint"]


  def test_cache
            @ss = Caching::MemoryCache.instance.read "test_read"
            if @ss
                    logger.warn "TEST READ SUCCESS!!!"
            else
                    logger.warn "TEST READ FAILURE!!!"
                   @ss = Item.limit('20').all
                  Caching::MemoryCache.instance.write "test_read", @ss
            end

  end


def ajax_multipart

end



  def ajax_multipart_action
        responds_to_parent do
          render :update do |page|
            page.replace_html :test, "This is the resulting test"
            page << "alert($('stuff').innerHTML)"
          end
    end
  end





  def main
  end

  def form_action
      # Do stuff with params[:uploaded_file]

      responds_to_parent do
        render :update do |page|
#          page << "alert($('stuff').innerHTML)"
            page << "$('stuff').innerHTML = 'stuff from controller'"
        end
      end
    end



end
