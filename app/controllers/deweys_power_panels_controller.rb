class DeweysPowerPanelsController < ApplicationController
before_filter :redirect_unless_admin

  def index
    @deweys_power_panels = DeweysPowerPanel.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deweys_power_panels }
    end
  end

  # GET /deweys_power_panels/1
  # GET /deweys_power_panels/1.xml
  def show
    @deweys_power_panel = DeweysPowerPanel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deweys_power_panel }
    end
  end

  # GET /deweys_power_panels/new
  # GET /deweys_power_panels/new.xml
  def new
    @deweys_power_panel = DeweysPowerPanel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deweys_power_panel }
    end
  end

  # GET /deweys_power_panels/1/edit
  def edit
    @deweys_power_panel = DeweysPowerPanel.find(params[:id])
  end

  # POST /deweys_power_panels
  # POST /deweys_power_panels.xml
  def create
    @deweys_power_panel = DeweysPowerPanel.new(params[:deweys_power_panel])

    respond_to do |format|
      if @deweys_power_panel.save
        format.html { redirect_to(@deweys_power_panel, :notice => 'Deweys power panel was successfully created.') }
        format.xml  { render :xml => @deweys_power_panel, :status => :created, :location => @deweys_power_panel }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deweys_power_panel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deweys_power_panels/1
  # PUT /deweys_power_panels/1.xml
  def update
    @deweys_power_panel = DeweysPowerPanel.find(params[:id])

    respond_to do |format|
      if @deweys_power_panel.update_attributes(params[:deweys_power_panel])
        format.html { redirect_to(@deweys_power_panel, :notice => 'Deweys power panel was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deweys_power_panel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deweys_power_panels/1
  # DELETE /deweys_power_panels/1.xml
  def destroy
    @deweys_power_panel = DeweysPowerPanel.find(params[:id])
    @deweys_power_panel.destroy

    respond_to do |format|
      format.html { redirect_to(deweys_power_panels_url) }
      format.xml  { head :ok }
    end
  end
end
