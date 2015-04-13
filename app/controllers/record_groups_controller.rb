class RecordGroupsController < ApplicationController

before_filter :redirect_unless_admin

  def index
    @record_groups = RecordGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @record_groups }
    end
  end

  # GET /record_groups/1
  # GET /record_groups/1.xml
  def show
    @record_group = RecordGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @record_group }
    end
  end

  # GET /record_groups/new
  # GET /record_groups/new.xml
  def new
    @record_group = RecordGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @record_group }
    end
  end

  # GET /record_groups/1/edit
  def edit
    @record_group = RecordGroup.find(params[:id])
  end

  # POST /record_groups
  # POST /record_groups.xml
  def create
    @record_group = RecordGroup.new(params[:record_group])

    respond_to do |format|
      if @record_group.save
        flash[:notice] = 'RecordGroup was successfully created.'
        format.html { redirect_to(@record_group) }
        format.xml  { render :xml => @record_group, :status => :created, :location => @record_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @record_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /record_groups/1
  # PUT /record_groups/1.xml
  def update
    @record_group = RecordGroup.find(params[:id])
    @record_group.accessible = :all if admin?
    respond_to do |format|
      if @record_group.update_attributes(params[:record_group])
        flash[:notice] = 'RecordGroup was successfully updated.'
        format.html { redirect_to(@record_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @record_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /record_groups/1
  # DELETE /record_groups/1.xml
  def destroy
    @record_group = RecordGroup.find(params[:id])
    @record_group.destroy

    respond_to do |format|
      format.html { redirect_to(record_groups_url) }
      format.xml  { head :ok }
    end
  end
end
