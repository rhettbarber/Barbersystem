class HiddenWebsiteCategoriesController < ApplicationController
before_filter :redirect_unless_admin

  
  def index
    @hidden_website_categories = HiddenWebsiteCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hidden_website_categories }
    end
  end

  # GET /hidden_website_categories/1
  # GET /hidden_website_categories/1.xml
  def show
    @hidden_website_category = HiddenWebsiteCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hidden_website_category }
    end
  end

  # GET /hidden_website_categories/new
  # GET /hidden_website_categories/new.xml
  def new
    @hidden_website_category = HiddenWebsiteCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hidden_website_category }
    end
  end

  # GET /hidden_website_categories/1/edit
  def edit
    @hidden_website_category = HiddenWebsiteCategory.find(params[:id])
  end

  # POST /hidden_website_categories
  # POST /hidden_website_categories.xml
  def create
    @hidden_website_category = HiddenWebsiteCategory.new(params[:hidden_website_category])

    respond_to do |format|
      if @hidden_website_category.save
        format.html { redirect_to(@hidden_website_category, :notice => 'Hidden website category was successfully created.') }
        format.xml  { render :xml => @hidden_website_category, :status => :created, :location => @hidden_website_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hidden_website_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hidden_website_categories/1
  # PUT /hidden_website_categories/1.xml
  def update
    @hidden_website_category = HiddenWebsiteCategory.find(params[:id])

    respond_to do |format|
      if @hidden_website_category.update_attributes(params[:hidden_website_category])
        format.html { redirect_to(@hidden_website_category, :notice => 'Hidden website category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hidden_website_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hidden_website_categories/1
  # DELETE /hidden_website_categories/1.xml
  def destroy
    @hidden_website_category = HiddenWebsiteCategory.find(params[:id])
    @hidden_website_category.destroy

    respond_to do |format|
      format.html { redirect_to(hidden_website_categories_url) }
      format.xml  { head :ok }
    end
  end
end
