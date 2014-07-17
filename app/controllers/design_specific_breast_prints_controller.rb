class DesignSpecificBreastPrintsController < ApplicationController
before_filter :redirect_unless_admin

  def index
    @design_specific_breast_prints = DesignSpecificBreastPrint.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @design_specific_breast_prints }
    end
  end

  # GET /design_specific_breast_prints/1
  # GET /design_specific_breast_prints/1.xml
  def show
    @design_specific_breast_print = DesignSpecificBreastPrint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @design_specific_breast_print }
    end
  end

  # GET /design_specific_breast_prints/new
  # GET /design_specific_breast_prints/new.xml
  def new
    @design_specific_breast_print = DesignSpecificBreastPrint.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @design_specific_breast_print }
    end
  end

  # GET /design_specific_breast_prints/1/edit
  def edit
    @design_specific_breast_print = DesignSpecificBreastPrint.find(params[:id])
  end

  # POST /design_specific_breast_prints
  # POST /design_specific_breast_prints.xml
  def create
    @design_specific_breast_print = DesignSpecificBreastPrint.new(params[:design_specific_breast_print])

    respond_to do |format|
      if @design_specific_breast_print.save
        format.html { redirect_to(@design_specific_breast_print, :notice => 'Design specific breast print was successfully created.') }
        format.xml  { render :xml => @design_specific_breast_print, :status => :created, :location => @design_specific_breast_print }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @design_specific_breast_print.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /design_specific_breast_prints/1
  # PUT /design_specific_breast_prints/1.xml
  def update
    @design_specific_breast_print = DesignSpecificBreastPrint.find(params[:id])

    respond_to do |format|
      if @design_specific_breast_print.update_attributes(params[:design_specific_breast_print])
        format.html { redirect_to(@design_specific_breast_print, :notice => 'Design specific breast print was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @design_specific_breast_print.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /design_specific_breast_prints/1
  # DELETE /design_specific_breast_prints/1.xml
  def destroy
    @design_specific_breast_print = DesignSpecificBreastPrint.find(params[:id])
    @design_specific_breast_print.destroy

    respond_to do |format|
      format.html { redirect_to(design_specific_breast_prints_url) }
      format.xml  { head :ok }
    end
  end
end
