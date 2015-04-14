class AdvancedCombinationsController < ApplicationController
  before_filter :redirect_unless_admin

  def index
    @advanced_combinations = AdvancedCombination.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @advanced_combinations }
    end
  end

  # GET /advanced_combinations/1
  # GET /advanced_combinations/1.xml
  def show
    @advanced_combination = AdvancedCombination.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @advanced_combination }
    end
  end

  # GET /advanced_combinations/new
  # GET /advanced_combinations/new.xml
  def new
    @advanced_combination = AdvancedCombination.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @advanced_combination }
    end
  end

  # GET /advanced_combinations/1/edit
  def edit
    @advanced_combination = AdvancedCombination.find(params[:id])
#    render  :partial => 'designer_specsheet/ajax_edit_advanced_combinations'




  end

  # POST /advanced_combinations
  # POST /advanced_combinations.xml
  def create
    @advanced_combination = AdvancedCombination.new(params[:advanced_combination])  if admin?
    #@advanced_combination.accessible = :all if admin?
    respond_to do |format|
      if @advanced_combination.save
        format.html { redirect_to(@advanced_combination, :notice => 'Advanced combination was successfully created.') }
        format.xml  { render :xml => @advanced_combination, :status => :created, :location => @advanced_combination }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @advanced_combination.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
                    @advanced_combination = AdvancedCombination.find(params[:id])
                    #@advanced_combination.accessible = :all if admin?
                     if @advanced_combination.update_attributes( params[:advanced_combination]   )
                              render(:update) { |page|
                                      if params[:side] == 'front'
                                               page.replace_html 'advanced_combinations_saved_front'  , :partial => 'designer_specsheet/ajax_update_advanced_combinations'  , :locals => {:side => params[:side], :status => "Success" }
                                      else
                                               page.replace_html 'advanced_combinations_saved_back'  , :partial => 'designer_specsheet/ajax_update_advanced_combinations'  , :locals => {:side => params[:side] , :status => "Success"}
                                      end
                          }
                     else
                              render(:update) { |page|
                                      if params[:side] == 'front'
                                               page.replace_html 'advanced_combinations_saved_front'  , :partial => 'designer_specsheet/ajax_update_advanced_combinations'  , :locals => {:side => params[:side], :status => "Failed" }
                                      else
                                               page.replace_html 'advanced_combinations_saved_back'  , :partial => 'designer_specsheet/ajax_update_advanced_combinations'  , :locals => {:side => params[:side] , :status => "Failed"}
                                      end
                          }
                     end

#    respond_to do |format|
#      if @advanced_combination.update_attributes(params[:advanced_combination])
#        format.html { redirect_to(@advanced_combination, :notice => 'Advanced combination was successfully updated.') }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @advanced_combination.errors, :status => :unprocessable_entity }
#      end
#    end
  end

  # DELETE /advanced_combinations/1
  # DELETE /advanced_combinations/1.xml
  def destroy
    @advanced_combination = AdvancedCombination.find(params[:id])
    @advanced_combination.destroy

    respond_to do |format|
      format.html { redirect_to(advanced_combinations_url) }
      format.xml  { head :ok }
    end
  end
end
