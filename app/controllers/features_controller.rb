class FeaturesController < ApplicationController
  before_filter  :initialize_variables
  before_filter :no_item_menu
  before_filter :redirect_unless_admin , :except => [:list,:carousel]

  def list
    @features = Feature.where("name = ?",  params[:name])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @features }
    end
  end


  def index

   if params[:item_id]
                  @item = Item.find  params[:item_id]
                  @features = @item.features
   else
                  @features = Feature.select("name").all.group_by{ |nm|  nm.name }.sort
     end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @features }
    end
  end

  # GET /features/1
  # GET /features/1.json
  def show
    @item = Item.find  params[:item_id]
    @feature = Feature.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feature }
    end
  end

  # GET /features/new
  # GET /features/new.json
  def new
    @item = Item.find params[:item_id]
    @feature = Feature.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feature }
    end
  end

  # GET /features/1/edit
  def edit
    @feature = Feature.find(params[:id])
    @item = @feature.items.find( params[:item_id])

  end

  # POST /features
  # POST /features.json
  def create

   @item = Item.find params[:item_id]
   @feature =@item.features.create(params[:feature])

    # @feature = Feature.new(params[:feature])

    respond_to do |format|
      if @feature.save
        format.html { redirect_to :action => "index", :item_id => params[:item_id] }

        # format.html { redirect_to @feature, notice: 'Feature was successfully created.' }
        # format.json { render json: @feature, status: :created, location: @feature }
      else
        format.html { render action: "new" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.json
  def update
    @feature = Feature.find(params[:id])

    respond_to do |format|
      if @feature.update_attributes(params[:feature])
        format.html { redirect_to :action => "index", :item_id => params[:item_id] }
        # format.html { redirect_to @feature, notice: 'Feature was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to :action => "index", :item_id => params[:item_id] }
      # format.html { redirect_to features_url }
      # format.json { head :no_content }
    end
  end
end
