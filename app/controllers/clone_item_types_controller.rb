class CloneItemTypesController < ApplicationController
#layout 'designer'
before_filter :redirect_unless_admin
skip_before_filter :verify_authenticity_token, :only => [:destroy ]

  def index
    @clone_item_types = CloneItemType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clone_item_types }
    end
  end

  # GET /clone_item_types/1
  # GET /clone_item_types/1.xml
  def show
    @clone_item_type = CloneItemType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clone_item_type }
    end
  end

  # GET /clone_item_types/new
  # GET /clone_item_types/new.xml
  def new
    @clone_item_type = CloneItemType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clone_item_type }
    end
  end

  # GET /clone_item_types/1/edit
  def edit
    @clone_item_type = CloneItemType.find(params[:id])
  end

  # POST /clone_item_types
  # POST /clone_item_types.xml
  def create
          @clone_item_type = CloneItemType.new(params[:clone_item_type])
          @the_item = Item.find params[:clone_item_type][:original_item_id]
#          @clone_item_type.original_itemlookupcode = Slug.generate( @the_item.ItemLookupCode )
          if @the_item
                            respond_to do |format|
                               @clone_item_type.accessible = :all if admin?
                              if @clone_item_type.save
                                flash[:notice] = 'CloneItemType was successfully created.'
                              format.html { redirect_to(@clone_item_type) }
#                                format.html { redirect_to(  :controller => 'designer', :search_type_name => 'search_clone_item_types'  ) }
#                                format.html { redirect_to(  :controller => 'designer', :search_type_name => 'search_clone_item_types'  ) }
                                format.xml  { render :xml => @clone_item_type, :status => :created, :location => @clone_item_type }
                              else
                                format.html { render :action => "new" }
                                format.xml  { render :xml => @clone_item_type.errors, :status => :unprocessable_entity }
                              end
                            end
          else
                      create_command_did_not_find_item
          end
  end

  # PUT /clone_item_types/1
  # PUT /clone_item_types/1.xml
  def update
    @clone_item_type = CloneItemType.find(params[:id])
 @clone_item_type.accessible = :all if admin?


    respond_to do |format|
      if @clone_item_type.update_attributes(params[:clone_item_type])
        flash[:notice] = 'CloneItemType was successfully updated.'
        format.html { redirect_to(@clone_item_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @clone_item_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clone_item_types/1
  # DELETE /clone_item_types/1.xml
  def destroy
    @clone_item_type = CloneItemType.find(params[:id])
    @clone_item_type.destroy

    respond_to do |format|
#      format.html { redirect_to(clone_item_types_url) }
        format.html { redirect_to(  :controller => 'designer', :search_type_name => 'search_clone_item_types'  ) }
        format.xml  { head :ok }
    end
  end
end
