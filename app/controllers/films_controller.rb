class FilmsController < ApplicationController


before_filter :redirect_unless_intranet   , :initialize_variables

skip_before_filter :verify_authenticity_token, :only => [:camerasnap, :camerasnap_update ]

  # GET /films/1
  # GET /films/1.xml
  def show
    @film = Film.find(params[:id])  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @film, :dasherize => false  }
    end
  end


#ALTER VIEW [dbo].[listing_designs] WITH SCHEMABINDING AS
#SELECT     id, Description, ItemLookupCode,  COALESCE (CAST( id AS varchar(MAX)), '')  + ' ' +  ItemLookupCode  + ' ' +  COALESCE (CAST( Notes AS varchar(MAX)), '')  + ' ' +  COALESCE (CAST( Description AS varchar(MAX)), '')   + ' ' +  COALESCE (CAST( ExtendedDescription AS varchar(MAX)), '')  AS items_combined
#FROM         dbo.item
# FIND MORE SQL CODE LIKE THIS IN NOTES


# GET /films/1/edit
  def edit
    @film = Film.find(params[:id]).to_xml
  end


  def search
             keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}

            if params[:search_scope] == "Matches Any"

                              @initial_films = ListingFilm.find_with_msfte :matches_any => keywords
                              @films_with_rank = []
                              keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}

                              @initial_films.each do |film|

                                         film_words_string = film.id.to_s + ' ' +  film.customer.to_s + ' ' + film.description.to_s + ' ' + film.work_order_id.to_s
                                         film_words_array  = film_words_string.split.collect {|c| "#{c.downcase}"}
                                         film_words_set = film_words_array.to_set

                                          keywords_set      = keywords.to_set
                                          word_count = 0
                                          keywords.each do  |kw|
                                              matching_words = keywords_set.intersection(film_words_set)
                                              if matching_words.size > 0
                                                    logger.debug "matching_words: " + matching_words.inspect
                                              else
                                                     logger.debug "film_words_set because none match: " + film_words_set.inspect
                                              end
                                              if matching_words.size > 0
                                                word_count = matching_words.size
                                              end
                                          end
                                           film.total_column = word_count
                                            @films_with_rank	<< film if film.total_column != 0
                                            @films = @films_with_rank.sort_by {|a| a.total_column}.reverse
                              end


            else
                             @initial_films = ListingFilm.find_with_msfte :matches_all => keywords
                              @films_with_rank = []
                              keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}

                              @initial_films.each do |film|

                                         film_words_string = film.id.to_s + ' ' +  film.customer.to_s + ' ' + film.description.to_s + ' ' + film.work_order_id.to_s
                                         film_words_array  = film_words_string.split.collect {|c| "#{c.downcase}"}
                                         film_words_set = film_words_array.to_set

                                          keywords_set      = keywords.to_set
                                          word_count = 0
                                          keywords.each do  |kw|
                                              matching_words = keywords_set.intersection(film_words_set)
                                              if matching_words.size > 0
                                                    logger.debug "matching_words: " + matching_words.inspect
                                              else
                                                     logger.debug "film_words_set because none match: " + film_words_set.inspect
                                              end
                                              if matching_words.size > 0
                                                word_count = matching_words.size
                                              end
                                          end
                                           film.total_column = word_count
                                            @films_with_rank	<< film if film.total_column != 0
                                            @films = @films_with_rank.sort_by {|a| a.total_column}.reverse
                              end
            end
           render :action => "index"
             logger.debug "ending search"
  end


  def camerasnap
#        logger.debug "params.keys " + params.keys.to_s

        @film = Film.new   #(params[:film])
        @film.description = params[:description]
        @film.customer = params[:customer] if params[:customer]
        @film.work_order_id = params[:work_order_id] if params[:work_order_id]
          if @film.save
                                    send_image( @film.id  ) if params[:content]
                                    flash[:notice] = 'Film was successfully created.'
                                    render :xml => @film, :dasherize => false
#                                    respond_to do |format|
#                                            format.html # show.html.erb
#                                            format.xml  { render :xml => @film, :dasherize => false  }
#                                    end
            end

end


    def camerasnap_update
        logger.debug "params.keys " + params.keys.to_s
        @film = Film.find(params[:id])
        @film.description = params[:description]
        @film.customer = params[:customer]
        @film.work_order_id = params[:work_order_id] if params[:work_order_id]
           if @film.save
                        send_image( @film.id  ) if params[:content]
                        render :xml => @film, :dasherize => false

           end
end


def send_image( film_id )
            #associate the param sent by Flex (content) to a variable
            file_data = params[:content]

            #Decodes our Base64 string sent from Flex
            img_data = Base64.decode64(file_data)

            #Set an image filename, with .jpg extension
            img_filename = Rails.root.to_s  + "/public/film_images/#{ film_id }.jpg"
             logger.debug  "img_filename: " + img_filename
            #Opens the "example_name.jpg" and populates it with "img_data" (our decoded Base64 send from Flex)
            img_file = File.open(img_filename, "wb") { |f| f.write(img_data) }

            #now we have a real JPEG image in our server, do anything you want with it!
            #Write what's necessary to make it a profile picture, an album photo, etc...
#            render :text => "save complete"

end



  def index
    @films = Film.order('id DESC').limit('30')       unless @films

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @films }
    end
  end


  # GET /films/new
  # GET /films/new.xml
  def new
    @film = Film.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @film }
    end
  end

  

  # POST /films
  # POST /films.xml
  def create
    @film = Film.new(params[:film])
     @film.accessible = :all
    respond_to do |format|
      if @film.save
        format.html { redirect_to(@film, :notice => 'Film was successfully created.') }
        format.xml  { render :xml => @film, :status => :created, :location => @film }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @film.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /films/1
  # PUT /films/1.xml
  def update
    @film = Film.find(params[:id])
     @film.accessible = :all
    respond_to do |format|
      if @film.update_attributes(params[:film])
        format.html { redirect_to(@film, :notice => 'Film was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @film.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /films/1
  # DELETE /films/1.xml
  def destroy
    @film = Film.find(params[:id])
    @film.destroy

    respond_to do |format|
      format.html { redirect_to(films_url) }
      format.xml  { head :ok }
    end
  end



#    def search_deprecate
#     keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
#    @films = Film.find_with_msfte :matches_any => keywords
    # REPLACE WITH SQLSERVER FULL TEXT SEARCH
    #  https://github.com/dvrensk/msfte
#          session[:query] = params[:query].strip if params[:query]
#            if session[:query] and request.xhr?
#              logger.debug "beginning search"
#                      @initial_films = Film.all   #.where("description LIKE ? or customer LIKE ? or work_order_id LIKE ?",  "%#{session[:query]}%", "%#{session[:query]}%", "%#{session[:query]}%")
#
#
#                        @films_with_rank = []
#                         keywords   =  params[:query].split(" ").collect {|c| "#{c.downcase}"}
#
#
#                        @initial_films.each do |film|
#                                film_words_string = film.customer.to_s + ' ' + film.description.to_s + ' ' + film.work_order_id.to_s
#                                 film_words_array  = film_words_string.split.collect {|c| "#{c.downcase}"}
#                                 film_words_set = film_words_array.to_set
#
#
#
#                            keywords_set      = keywords.to_set
#                            word_count = 0
#                            keywords.each do  |kw|
#                                matching_words = keywords_set.intersection(film_words_set)
#                                if matching_words.size > 0
#                                      logger.debug "matching_words: " + matching_words.inspect
#                                else
#                                       logger.debug "film_words_set because none match: " + film_words_set.inspect
#                                end
#                                if matching_words.size > 0
#                                  word_count = matching_words.size
#                                end
#                            end
#                             film.total_column = word_count
#                              @films_with_rank	<< film if film.total_column != 0
#                              @films = @films_with_rank.sort_by {|a| a.total_column}.reverse
#                        end
#                       render(:update) { |page|
#                               page.replace_html 'search_results',   :partial => "films/list"
#                            }
#            end
#             logger.debug "ending search"
#  end












end
