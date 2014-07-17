class CategoryClassesController < ApplicationController
#ssl_exceptions
before_filter :redirect_unless_admin

  def index
    @category_classes = CategoryClass.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @category_classes }
    end
  end

  # GET /category_classes/1
  # GET /category_classes/1.xml
  def show
    @category_class = CategoryClass.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category_class }
    end
  end

  # GET /category_classes/new
  # GET /category_classes/new.xml
  def new
    @category_class = CategoryClass.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category_class }
    end
  end

  # GET /category_classes/1/edit
  def edit
    @category_class = CategoryClass.find(params[:id])
  end

  # POST /category_classes
  # POST /category_classes.xml
  def create
    @category_class = CategoryClass.new(params[:category_class])

    respond_to do |format|
      if @category_class.save
        flash[:notice] = 'CategoryClass was successfully created.'
        format.html { redirect_to(@category_class) }
        format.xml  { render :xml => @category_class, :status => :created, :location => @category_class }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /category_classes/1
  # PUT /category_classes/1.xml
  def update
    @category_class = CategoryClass.find(params[:id])

    respond_to do |format|
      if @category_class.update_attributes(params[:category_class])
        flash[:notice] = 'CategoryClass was successfully updated.'
        if params[:redirect_back] == '1'
        	 format.html { redirect_to :back, :params => params }
        else	
	        format.html { redirect_to(@category_class) }
	        format.xml  { head :ok }
	    end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category_class.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /category_classes/1
  # DELETE /category_classes/1.xml
  def destroy
    @category_class = CategoryClass.find(params[:id])
    @category_class.destroy

    respond_to do |format|
      format.html { redirect_to(category_classes_url) }
      format.xml  { head :ok }
    end
  end
end
