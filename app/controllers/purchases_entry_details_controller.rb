class PurchasesEntryDetailsController < ApplicationController
  ssl_exceptions
  before_filter :redirect_unless_manager

  def index
    @purchases_entry_details = PurchasesEntryDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @purchases_entry_details }
    end
  end

  # GET /purchases_entries_details/1
  # GET /purchases_entries_details/1.xml
  def show
    @purchases_entry_detail = PurchasesEntryDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @purchases_entry_detail }
    end
  end

  # GET /purchases_entries_details/new
  # GET /purchases_entries_details/new.xml
  def new
    @purchases_entry_detail = PurchasesEntryDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @purchases_entry_detail }
    end
  end

  # GET /purchases_entries_details/1/edit
  def edit
    @purchases_entry_detail = PurchasesEntryDetail.find(params[:id])
  end

  # POST /purchases_entries_details
  # POST /purchases_entries_details.xml
  def create
    @purchases_entry_detail = PurchasesEntryDetail.new(params[:purchases_entry_detail])

    #respond_to do |format|
      if @purchases_entry_detail.save
        flash[:notice] = 'PurchasesEntryDetail was successfully created.'
        #format.html { redirect_to(@purchases_entry_detail) }
        #format.xml  { render :xml => @purchases_entry_detail, :status => :created, :location => @purchases_entry_detail }
        redirect_to :back
      else
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @purchases_entry_detail.errors, :status => :unprocessable_entity }
        redirect_to :back
      end
    #end
  end

  # PUT /purchases_entries_details/1
  # PUT /purchases_entries_details/1.xml
  def update
    @purchases_entry_detail = PurchasesEntryDetail.find(params[:id])

    respond_to do |format|
      if @purchases_entry_detail.update_attributes(params[:purchases_entry_detail])
        flash[:notice] = 'PurchasesEntryDetail was successfully updated.'
        #format.html { redirect_to(@purchases_entry_detail) }
        format.html { redirect_to( :controller => "purchases_entries", :action => "control_sheet") }
        #render :partial => 'purchases_entries/control_sheet_purchases'  ,:layout => "purchases_entries"
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchases_entry_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases_entries_details/1
  # DELETE /purchases_entries_details/1.xml
  def destroy
    @purchases_entry_detail = PurchasesEntryDetail.find(params[:id])
    @purchases_entry_detail.destroy

    respond_to do |format|
      format.html { redirect_to(purchases_entries_details_url) }
      format.xml  { head :ok }
    end
  end
end
