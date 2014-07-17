class WebsitesController < ApplicationController
  #layout 'none'
  #caches_action :show, :cache_path =>  "/test/cool"   #=> Proc.new{ "/products/#{admin?}" }


before_filter :initialize_variables
before_filter :redirect_unless_admin
#ssl_exceptions


  
  def index
    @websites = Website.all

#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @websites }
#    end
  end

  # GET /websites/1
  # GET /websites/1.xml
  def show
    @website = Website.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @website }
    end
  end

  # GET /websites/new
  # GET /websites/new.xml
  def new
    @website = Website.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @website }
    end
  end

  # GET /websites/1/edit
  def edit
    @website = Website.find(params[:id])
  end

  # POST /websites
  # POST /websites.xml
  def create
    @website = Website.new(params[:website])
#    @website.default_design_department_ids = 

    @page = Page.new
    @page.name = 'home'
    @page.slug = 'home'
    @page.website_id = @website.id
    @page.page_type_id = 1
    @page.position = 1
    

    @revision = Revision.new
    @revision.page_id = @page.id


    @revision.content =
      '<br /><br />
      <h1>Welcome to Barbersystem. You will enjoy.</h1>
      <h3> This is your home page.</h3>
      <br/>
    '

    @revision.published = 1
    @revision.user_id = @user.id

    ## TO DO  ### RESTART MEMCACHED SERVICE
     ### RESTART MEMCACHED SERVICE

    respond_to do |format|
      if   @page.save and @revision.save and @website.save
        format.html { redirect_to(@website, :notice => 'Website was successfully created.') }
        format.xml  { render :xml => @website, :status => :created, :location => @website }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @website.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /websites/1
  # PUT /websites/1.xml
  def update
    @website = Website.find(params[:id])
     @website.accessible = :all if admin?
    respond_to do |format|
      if @website.update_attributes(params[:website])
        format.html { redirect_to(@website, :notice => 'Website was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @website.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /websites/1
  # DELETE /websites/1.xml
  def destroy
    @website = Website.find(params[:id])
    @website.destroy

    respond_to do |format|
      format.html { redirect_to(websites_url) }
      format.xml  { head :ok }
    end
  end
end
