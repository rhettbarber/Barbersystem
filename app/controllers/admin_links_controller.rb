class AdminLinksController < ApplicationController
before_filter :redirect_unless_admin

  def index
    @admin_links = AdminLink.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_links }
    end
  end

  # GET /admin_links/1
  # GET /admin_links/1.xml
  def show
    @admin_link = AdminLink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin_link }
    end
  end

  # GET /admin_links/new
  # GET /admin_links/new.xml
  def new
    @admin_link = AdminLink.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_link }
    end
  end

  # GET /admin_links/1/edit
  def edit
    @admin_link = AdminLink.find(params[:id])
  end

  # POST /admin_links
  # POST /admin_links.xml
  def create
    @admin_link = AdminLink.new(params[:admin_link])

    respond_to do |format|
      if @admin_link.save
        flash[:notice] = 'AdminLink was successfully created.'
        format.html { redirect_to(@admin_link) }
        format.xml  { render :xml => @admin_link, :status => :created, :location => @admin_link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_links/1
  # PUT /admin_links/1.xml
  def update
    @admin_link = AdminLink.find(params[:id])

    respond_to do |format|
      if @admin_link.update_attributes(params[:admin_link])
        flash[:notice] = 'AdminLink was successfully updated.'
        format.html { redirect_to(@admin_link) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_links/1
  # DELETE /admin_links/1.xml
  def destroy
    @admin_link = AdminLink.find(params[:id])
    @admin_link.destroy

    respond_to do |format|
      format.html { redirect_to(admin_links_url) }
      format.xml  { head :ok }
    end
  end
end
