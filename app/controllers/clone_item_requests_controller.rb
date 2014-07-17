class CloneItemRequestsController < ApplicationController
#layout 'white_paper'
before_filter :redirect_unless_admin

  def show_unfinished_files_by_type
          @clone_item_type = CloneItemType.find params[:clone_item_type_id]
          @clone_item_requests = @clone_item_type.unfinished_file_requests
  end

  def show_unfinished_rms_by_type
          @clone_item_type = CloneItemType.find params[:clone_item_type_id]
          @clone_item_requests = @clone_item_type.unfinished_rms_requests
  end
  
  def index
    @clone_item_requests = CloneItemRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clone_item_requests }
    end
  end

  # GET /clone_item_requests/1
  # GET /clone_item_requests/1.xml
  def show
    @clone_item_request = CloneItemRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clone_item_request }
    end
  end

  # GET /clone_item_requests/new
  # GET /clone_item_requests/new.xml
  def new
    @clone_item_request = CloneItemRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clone_item_request }
    end
  end

  # GET /clone_item_requests/1/edit
  def edit
    @clone_item_request = CloneItemRequest.find(params[:id])
  end

  # POST /clone_item_requests
  # POST /clone_item_requests.xml
  def create
    @clone_item_request = CloneItemRequest.new(params[:clone_item_request])

    respond_to do |format|
      if @clone_item_request.save
        format.html { redirect_to(@clone_item_request, :notice => 'Clone item request was successfully created.') }
        format.xml  { render :xml => @clone_item_request, :status => :created, :location => @clone_item_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @clone_item_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clone_item_requests/1
  # PUT /clone_item_requests/1.xml
  def update
    @clone_item_request = CloneItemRequest.find(params[:id])

    respond_to do |format|
      if @clone_item_request.update_attributes(params[:clone_item_request])
        format.html { redirect_to(@clone_item_request, :notice => 'Clone item request was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @clone_item_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clone_item_requests/1
  # DELETE /clone_item_requests/1.xml
  def destroy
    @clone_item_request = CloneItemRequest.find(params[:id])
    @clone_item_request.destroy

    respond_to do |format|
      format.html { redirect_to(clone_item_requests_url) }
      format.xml  { head :ok }
    end
  end
end
