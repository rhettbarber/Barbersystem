class ControlPanelsController < ApplicationController
  ssl_exceptions
  before_filter :redirect_unless_manager
  before_filter :initialize_variables

  # GET /control_panels
  # GET /control_panels.xml
  def index
    @control_panels = ControlPanel.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @control_panels }
    end
  end

  # GET /control_panels/1
  # GET /control_panels/1.xml
  def show
    @control_panel = ControlPanel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @control_panel }
    end
  end

  # GET /control_panels/new
  # GET /control_panels/new.xml
  def new
    @control_panel = ControlPanel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @control_panel }
    end
  end

  # GET /control_panels/1/edit
  def edit
    @control_panel = ControlPanel.find(params[:id])
  end

  # POST /control_panels
  # POST /control_panels.xml
  def create
    @control_panel = ControlPanel.new(params[:control_panel])

    respond_to do |format|
      if @control_panel.save
        flash[:notice] = 'ControlPanel was successfully created.'
        format.html { redirect_to(@control_panel) }
        format.xml  { render :xml => @control_panel, :status => :created, :location => @control_panel }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @control_panel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /control_panels/1
  # PUT /control_panels/1.xml
  def update
    @control_panel = ControlPanel.find(params[:id])

    respond_to do |format|
      if @control_panel.update_attributes(params[:control_panel])
        flash[:notice] = 'ControlPanel was successfully updated.'
        format.html { redirect_to(@control_panel) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @control_panel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /control_panels/1
  # DELETE /control_panels/1.xml
  def destroy
    @control_panel = ControlPanel.find(params[:id])
    @control_panel.destroy

    respond_to do |format|
      format.html { redirect_to(control_panels_url) }
      format.xml  { head :ok }
    end
  end
end
