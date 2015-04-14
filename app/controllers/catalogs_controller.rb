class CatalogsController < ApplicationController
  before_filter :redirect_unless_admin, :except => :show_catalog
  before_filter :no_item_menu
  before_filter  :initialize_variables_except_store


  def show_catalog
        @per_page = params[:per_page] ||= 30
        @catalog = Catalog.find(params[:id])
        # @original_items = Item.joins(:department, :category, :category_class).order("departments.Name ASC,  categories.Name ASC, items.ItemLookupCode").where( "items.category_id in (?)", @catalog.category_ids.split(",")  ).all
        ids = @catalog.category_ids.split(",").map(&:to_i)
        @original_items = Item.joins(:department, :category, :category_class).where( "items.category_id in (?)", ids ).all

        @items = Set.new
        already_seen_item_picturenames = Set.new

        @original_items.each do |item|
                if already_seen_item_picturenames.include?( item.PictureName.to_s  )
                          logger.debug "skipped already included picturename"
                else
                          @items.add( item) if item.department and item.category  and item.category_class
                          already_seen_item_picturenames .add  item.PictureName.to_s
                end
        end
        s = "s"
        # @items = @items.sort_by { |u| ids.index(u.category_id)    }
        @items = @items.sort_by { | a,b |  [ ids.index(a.category_id) , a.ItemLookupCode ]   }
  end





  def website_design_departments_catalog
    # if  params[:department_ids]
    #                @departments = Department.find(:all, :conditions => ["department_id in (?)", params[:department_ids]   ])
    # else
    #               # @departments = @website.default_design_departments
    #               #  @departments = Department.limit(2).order("departments.Name ASC").where( "id in (?)",  @website.default_design_department_ids.split(/,/)   ).to_set
    # end
    # @original_items = Item.limit(400).joins(:department, :category, :category_class).order("departments.Name ASC,  categories.Name ASC").where( "items.department_id in (?)",  @website.default_design_department_ids.split(/,/)   ).all


    if params[:type] == "merchandise"
                  @original_items = Item.joins(:department, :category, :category_class).order("departments.Name ASC,  categories.Name ASC").where( "category_classes.search_results_set in (?) and departments.id not in (?) and categories.id not in (?)",    [ "merchandise"  ] ,  [ "42", "44","45","59","35", "28", "39", "37"  ] ,  [ "218", "219","220", "234",  "478", "239", "497","498", "628","629", "677", "929","926","578", "579" ,"595","576" ]    ).all
      else
                 @original_items = Item.joins(:department, :category, :category_class).order("departments.Name ASC,  categories.Name ASC").where( "items.department_id in (?)",  @website.default_design_department_ids.split(/,/)   ).all
     end



    @items = Set.new
    already_seen_item_picturenames = Set.new
    @original_items.each do |item|
                if already_seen_item_picturenames.include?( item.PictureName.to_s  )
                           logger.debug "SKIPPING ITEM because already used this picturname: " +  item.PictureName.to_s
                else
                      @items.add( item) if item.department and item.category  and item.category_class
                      already_seen_item_picturenames.add(item.PictureName.to_s)
                end
    end

  end





  def index
    @catalogs = Catalog.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @catalogs }
    end
  end

  # GET /catalogs/1
  # GET /catalogs/1.json
  def show
    @catalog = Catalog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @catalog }
    end
  end

  # GET /catalogs/new
  # GET /catalogs/new.json
  def new
    @catalog = Catalog.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @catalog }
    end
  end

  # GET /catalogs/1/edit
  def edit
    @catalog = Catalog.find(params[:id])
  end

  # POST /catalogs
  # POST /catalogs.json
  def create
    @catalog = Catalog.new(params[:catalog])

    respond_to do |format|
      if @catalog.save
        format.html { redirect_to @catalog, notice: 'Catalog was successfully created.' }
        format.json { render json: @catalog, status: :created, location: @catalog }
      else
        format.html { render action: "new" }
        format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /catalogs/1
  # PUT /catalogs/1.json
  def update
    @catalog = Catalog.find(params[:id])

    respond_to do |format|
      if @catalog.update_attributes(params[:catalog])
        format.html { redirect_to @catalog, notice: 'Catalog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catalogs/1
  # DELETE /catalogs/1.json
  def destroy
    @catalog = Catalog.find(params[:id])
    @catalog.destroy

    respond_to do |format|
      format.html { redirect_to catalogs_url }
      format.json { head :no_content }
    end
  end
end
