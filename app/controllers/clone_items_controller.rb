class CloneItemsController < ApplicationController
before_filter :redirect_unless_admin

  def request_clone_item
    @clone_item = CloneItem.new
    @clone_item.clone_item_type_id  = params[:clone_item_type_id]
    @clone_item.item_id = params[:item_id]
    @clone_item.clone_id = params[:clone_id]
    @clone_item.save
      if @clone_item.save
            flash[:notice] = 'CloneItem was successfully created.'
            redirect_to  :controller => 'item_management', :action => 'management_options' , :item_id => params[:item_id], :clone_item_type_id => params[:clone_item_type_id]
      else
           flash[:message] = "ERROR!"
           redirect_to :back
      end
  end








#layout 'item_management'

#    before_filter :load_variables

#  def load_variables
#         @verification_file = 'Y://STORAGE_DISK_1/MAIN_FILES_STORAGE/ITEM_MANAGEMENT/STOCK_DESIGNS_BY_NUMBER/4264L_t_rp.psd'
#         @asset_server = 'localhost:7000'
#  end


  def link_clone_to_original
    @clone_item = CloneItem.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clone_item }
    end
  end

def find_item
	 keywords = params[:item_keywords]
 	conditions = ["department_id in (?)  and ItemLookupCode  LIKE ?",   [  '22','28', '26'  ]  ,       "%#{keywords}%"  ]
	@items = Item.find(:all , :conditions => conditions, :limit => 50 )
	render :partial => "clone_items/item", :collection => @items ,:layout => 'none'
end

 

  def index
    @clone_items = CloneItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clone_items }
    end
  end

  # GET /clone_items/1
  # GET /clone_items/1.xml
  def show
    @clone_item = CloneItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clone_item }
    end
  end


  def new
    @clone_item = CloneItem.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clone_item }
    end
  end


  def edit
    @clone_item = CloneItem.find(params[:id])
  end



  # PUT /clone_items/1
  # PUT /clone_items/1.xml
  def update
    @clone_item = CloneItem.find(params[:id])
    respond_to do |format|
        @clone_item.status_id = params[:status_id] if  params[:status_id]
        @clone_item.clone_item_type_id  = params[:clone_item_type_id] if params[:clone_item_type_id]
        @clone_item.item_id = params[:item_id] if params[:item_id]
        if @clone_item.save
            flash[:notice] = 'CloneItem was successfully updated.'
            format.html { redirect_to(@clone_item) }
            format.xml  { head :ok }
      else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @clone_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @clone_item = CloneItem.find(params[:clone_item_id])
    @clone_item.destroy
   flash[:notice] = 'CloneItem was successfully deleted.'
            redirect_to  :controller => 'item_management', :action => 'management_options' , :item_id => params[:item_id]
  end
end
