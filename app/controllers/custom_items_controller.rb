class CustomItemsController < ApplicationController
  before_filter :redirect_unless_admin  # UNTIL THIS IS LOCKED DOWN, ONLY ADMINS GET IN
before_filter :redirect_unless_logged_in , :except => [:create_via_ajax ]

#require 'RMagick'
#include Magick



  skip_before_filter :verify_authenticity_token, :only => [:create ]



    def create_from_url_via_ajax
        current_website
        startup_user
        @url_upload = UrlUpload.new( 'http://192.168.0.125:2000/images/item_specsheets/AOT-BEAR-0.png' )
        @a = 'a'
        @custom_item = CustomItem.new(   @url_upload  )                      #  params[:custom_item][:url]  )   )

       @custom_item.size = '23232'
       @custom_item.content_type = 'image/jpeg'
       @custom_item.filename = @url_upload.original_filename
       @custom_item.uploaded_data = @url_upload.tmpfile


        @custom_item.user_id = @user.id
        responds_to_parent do
                if @custom_item.save
                             flash[:notice] = 'CustomItem was successfully created.'
                                   render(:update) { |page|
                                           page.hide 'progress_bar_container'
                                           page.insert_html :top,   'custom_items_container',   :partial => "designer_specsheet/custom_item"
                                        }
                else
                              render :text => ''
                end
        end
  end



  def create_via_ajax
        current_website
        startup_user
        if @user

                  if  params[:custom_item]
                          if params[:custom_item][:uploaded_data]
                                  @original_path = params[:custom_item][:uploaded_data].original_path
                                  @contains_exe_test = @original_path[/.exe/] if @original_path
                          end
                  end

                  if @contains_exe_test
            #                                add_security_warning(7)
#                                           exe_found
                                            render(:update) { |page|
                                                 page.hide 'progress_bar_container'
                                                 page.replace :top,   'custom_items',    :partial => "designer_specsheet/custom_item_executable"
                                              }
                  else
                                              @custom_item = CustomItem.new(params[:custom_item])
                                              @custom_item.user_id = @user.id
                                              responds_to_parent do
                                      #        respond_to do |format|
                                                      if @custom_item.save
                                                                   flash[:notice] = 'CustomItem was successfully created.'
                                      #                             format.js {
                                                                         render(:update) { |page|
                                            #                                   page.replace  'custom_items_container',  :partial => "designer_specsheet/custom_items_container"
                                            #                                   page.replace  'custom_items_container',  :partial => "designer_specsheet/custom_item"
                                            #                                   page.insert_html :top,   'custom_items_container', :text => 'XAAAAASDFASDFASD FASDDDDDDDDDDF AS'   #  :partial => "designer_specsheet/custom_item"
                                                                                 page.hide 'progress_bar_container'
                                                                                 page.insert_html :top,   'custom_items_container',   :partial => "designer_specsheet/custom_item"
                                      #                                       page << "alert('testing')"
                                                                              }
                                      #                             }
                                                      else
                                      #                              wrong_move
                                                                    render :text => ''
                                                                    #        format.html { render :action => "new" }
                                                                    #        format.xml  { render :xml => @custom_item.errors, :status => :unprocessable_entity }
                                                      end
                                      #        end
                                              end
                  end
        else
                       render(:update) { |page|
                           page.replace_html   'custom_items', :text => " <br /> <br /> You must log in to create custom products. <br />  <br />"
                           }
        end
  end


    def create
        current_website
        startup_user
        @original_path = params[:custom_item][:uploaded_data].original_path
        @contains_exe_test = @original_path[/.exe/]
        if @contains_exe_test 
                      add_security_warning(7)
                       flash[:notice] = 'Never upload executables to our server. You have been warned and will be watched.'
                        redirect_to(custom_items_path)
        else
                               @custom_item =    @user.custom_items.new(params[:custom_item])
#                               @custom_item.
                              #    @custom_item.user_id = @user.id
                              @custom_item.accessible = :all 
                                  respond_to do |format|
                                    if @custom_item.save
                                      flash[:notice] = 'CustomItem was successfully created.'
                              #        format.html { redirect_to(@custom_item) }
                                      format.html { redirect_to(custom_items_path) }
                                      format.xml  { render :xml => @custom_item, :status => :created, :location => @custom_item }
                                    else
                                      format.html { render :action => "new" }
                                      format.xml  { render :xml => @custom_item.errors, :status => :unprocessable_entity }
                                    end
                                  end
        end                          
        
  end



  def create_via_ajax_old
        current_website
        startup_user
          logger.debug "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
          logger.debug " params[:custom_item].inspect : " + params[:custom_item].inspect
          logger.debug "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
          @custom_item = CustomItem.new(params[:custom_item])
          @custom_item.user_id = @user.id
      #    respond_to do |format|
      #      if @custom_item.save
      #        flash[:notice] = 'Size too small.'
      #        flash[:notice] = 'CustomItem was successfully created.'
      #        format.html { redirect_to(@custom_item) }
      #        format.xml  { render :xml => @custom_item, :status => :created, :location => @custom_item }
      #      else
      #        format.html { render :action => "new" }
      #        format.xml  { render :xml => @custom_item.errors, :status => :unprocessable_entity }
      #      end
      #    end
       responds_to_parent do
                if @custom_item.save

                   render(:update) { |page|
                        page.replace  'custom_items_container',  :partial => "designer_specsheet/custom_item_upload_failure"
                        }
                end
#                       @custom_items = CustomItem.find(:all,:conditions => ["thumbnail is null" ] )
#                       render(:update) { |page|
#                                  page.replace  'custom_items_container',  :partial => "designer_specsheet/custom_items_container"
#                                  }
#                else
#                       render(:update) { |page|
#                                  page.replace  'custom_items_container',  :partial => "designer_specsheet/custom_item_upload_failure"
#                                  }
#                end
       end


  def create_orig
    @custom_item = CustomItem.new(params[:custom_item])
    @custom_item.user_id = @user.id
    respond_to do |format|
      if @custom_item.save
        flash[:notice] = 'Size too small.'
        flash[:notice] = 'CustomItem was successfully created.'
        format.html { redirect_to(@custom_item) }
        format.xml  { render :xml => @custom_item, :status => :created, :location => @custom_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @custom_item.errors, :status => :unprocessable_entity }
      end
    end
  end



  end





  def destroy_remote
    @custom_item = @user.custom_items.find(params[:id])
    @custom_item.destroy
	 render(:update) { |page|
#	            page.replace_html 'left_print_container',  :partial => "view_details/left_print_update"
               page.remove 'custom_item_container_' + params[:id]
	            }

#    render :nothing => true
  end



def show
	@custom_item = CustomItem.find(params[:id])
  end


def enlarge
	@combination_height = 200
	@custom_item = CustomItem.find(params[:id])
	 render(:update) { |page| 
	            page.replace_html 'left_print_container',  :partial => "view_details/left_print_update"
	            } 
end


def enlarge_via_imagemagick
	@custom_item = CustomItem.find(params[:id])
	@im  = Image.read(@custom_item.im_filename).first 
	@im.resize!(@im.columns *  1.5, @im.rows  *  1.5)
	@im.write(@custom_item.im_filename)
	#-----------------------------------------------------------------------------------------------------------------------------------------------
	 render(:update) { |page| 
	            page.replace_html 'front_print_image', image_tag(@custom_item.public_filename) 
	            } 
end


def shrink_via_imagemagick
  logger.warn "RHETTS WARN"
	@custom_item = CustomItem.find(params[:id])
	@im  = Image.read(@custom_item.im_filename).first 
	@im.resize!(@im.columns *  0.5, @im.rows  *  0.5)
	@im.write(@custom_item.im_filename)
	#-----------------------------------------------------------------------------------------------------------------------------------------------
	 render(:update) { |page| 
	            page.replace_html 'front_print_image', image_tag(@custom_item.public_filename) 
	            } 
end



  def index
    @custom_items = CustomItem.order("id DESC").find(:all,:conditions => ["thumbnail is null" ] )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @custom_items }
    end
  end


  def new
    @custom_item = CustomItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @custom_item }
    end
  end


  def edit
    @custom_item = CustomItem.find(params[:id])
  end





  def update
    @custom_item = CustomItem.find(params[:id])

    respond_to do |format|
      if @custom_item.update_attributes(params[:custom_item])
        flash[:notice] = 'CustomItem was successfully updated.'
        format.html { redirect_to(@custom_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @custom_item.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @custom_item = CustomItem.find(params[:id])
    @custom_item.destroy

    respond_to do |format|
      format.html { redirect_to(custom_items_url) }
      format.xml  { head :ok }
    end
  end
end
