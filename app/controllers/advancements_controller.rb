class AdvancementsController < ApplicationController
  layout 'blank'
  before_filter :redirect_unless_admin
  # GET /advancements
  # GET /advancements.xml
  def index
#    @advancements = Advancement.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @advancements }
#    end
  end

#  # GET /advancements/1
#  # GET /advancements/1.xml
#  def show
#    @advancement = Advancement.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @advancement }
#    end
#  end
#
#  # GET /advancements/new
#  # GET /advancements/new.xml
#  def new
#    @advancement = Advancement.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @advancement }
#    end
#  end
#
#  # GET /advancements/1/edit
#  def edit
#    @advancement = Advancement.find(params[:id])
#  end
#
#  # POST /advancements
#  # POST /advancements.xml
#  def create
#    @advancement = Advancement.new(params[:advancement])
#
#    respond_to do |format|
#      if @advancement.save
#        format.html { redirect_to(@advancement, :notice => 'Advancement was successfully created.') }
#        format.xml  { render :xml => @advancement, :status => :created, :location => @advancement }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @advancement.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /advancements/1
#  # PUT /advancements/1.xml
#  def update
#    @advancement = Advancement.find(params[:id])
#
#    respond_to do |format|
#      if @advancement.update_attributes(params[:advancement])
#        format.html { redirect_to(@advancement, :notice => 'Advancement was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @advancement.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /advancements/1
#  # DELETE /advancements/1.xml
#  def destroy
#    @advancement = Advancement.find(params[:id])
#    @advancement.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(advancements_url) }
#      format.xml  { head :ok }
#    end
#  end

end
