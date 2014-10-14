class FeaturedItemsController < ApplicationController
  before_filter  :initialize_variables
  before_filter :redirect_unless_admin ,:except => :list
  skip_before_filter :verify_authenticity_token , :only => :destroy

  def list
    @featured_items = FeaturedItem.where("website_id = ? and list = ?", @website.id , true  ). all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @featured_items }
    end
  end


  def index
    @featured_items = FeaturedItem.where("website_id = ?", @website.id ). all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @featured_items }
    end
  end

  # GET /featured_items/1
  # GET /featured_items/1.json
  def show
    @featured_item = FeaturedItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @featured_item }
    end
  end

  # GET /featured_items/new
  # GET /featured_items/new.json
  def new
    @featured_item = FeaturedItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @featured_item }
    end
  end

  # GET /featured_items/1/edit
  def edit
    @featured_item = FeaturedItem.find(params[:id])
  end

  # POST /featured_items
  # POST /featured_items.json
  def create
    @featured_item = FeaturedItem.new(params[:featured_item])
    @featured_item.website_id = @website.id

    respond_to do |format|
      if @featured_item.save
        format.html { redirect_to @featured_item, notice: 'Featured item was successfully created.' }
        format.json { render json: @featured_item, status: :created, location: @featured_item }
      else
        format.html { render action: "new" }
        format.json { render json: @featured_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /featured_items/1
  # PUT /featured_items/1.json
  def update
    @featured_item = FeaturedItem.find(params[:id])

    respond_to do |format|
      if @featured_item.update_attributes(params[:featured_item])
        format.html { redirect_to @featured_item, notice: 'Featured item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @featured_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /featured_items/1
  # DELETE /featured_items/1.json
  def destroy
    @featured_item = FeaturedItem.find(params[:id])
    @featured_item.destroy

    respond_to do |format|
      format.html { redirect_to featured_items_url }
      format.json { head :no_content }
    end
  end
end
