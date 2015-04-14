class ItemSetsController < ApplicationController
  before_filter :redirect_unless_admin
  # GET /item_sets
  # GET /item_sets.json
  def index
    @item_sets = ItemSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_sets }
    end
  end

  # GET /item_sets/1
  # GET /item_sets/1.json
  def show
    @item_set = ItemSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_set }
    end
  end

  # GET /item_sets/new
  # GET /item_sets/new.json
  def new
    @item_set = ItemSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_set }
    end
  end

  # GET /item_sets/1/edit
  def edit
    @item_set = ItemSet.find(params[:id])
  end

  # POST /item_sets
  # POST /item_sets.json
  def create
    @item_set = ItemSet.new(params[:item_set])

    respond_to do |format|
      if @item_set.save
        format.html { redirect_to @item_set, notice: 'Item set was successfully created.' }
        format.json { render json: @item_set, status: :created, location: @item_set }
      else
        format.html { render action: "new" }
        format.json { render json: @item_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_sets/1
  # PUT /item_sets/1.json
  def update
    @item_set = ItemSet.find(params[:id])

    respond_to do |format|
      if @item_set.update_attributes(params[:item_set])
        format.html { redirect_to @item_set, notice: 'Item set was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_sets/1
  # DELETE /item_sets/1.json
  def destroy
    @item_set = ItemSet.find(params[:id])
    @item_set.destroy

    respond_to do |format|
      format.html { redirect_to item_sets_url }
      format.json { head :no_content }
    end
  end
end
