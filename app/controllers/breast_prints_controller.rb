class BreastPrintsController < ApplicationController
  before_filter :redirect_unless_admin


 def ajax_breast_prints_list
            if params[:show_only_webitems] == 'true'
                           @items = Item.order("ItemLookupCode ASC").includes(:category).where("categories.Name like ? and Inactive = ?",  'pocket prints' , false  )
                       
            else
                         @items = Item.unscoped.order("ItemLookupCode ASC").includes(:category).where("categories.Name like ? and Inactive = ?",  'pocket prints' , false  )                  #.find(:all, :conditions => ['categories.Name like  ?', '%pocket print%'])     #              .limit('20')    #.where("categories.Name like ?",  'pocket prints'  )
            end
                    logger.warn "@items.size: " + @items.size.to_s
                        render  :partial => 'breast_prints/ajax_breast_prints_list'
 end




def ajax_update_crest_print_status
              @item_id = params[:item_id]
              @crest_print =  CrestPrint.where("item_id = ? and category_id = ?",   params[:item_id], params[:category_id] ).first
              if !@crest_print.nil?
                                                      #no_bp
                                                      @crest_print.destroy
                                                      @result = 'false'
              else
                                                      #bp
                                                      new_iep = CrestPrint.new
                                                      new_iep.item_id = params[:item_id]
                                                      new_iep.category_id =  params[:category_id]
                                                      new_iep.save
                                                      @result = 'true'
              end
end

  def index
    @items = Item.unscoped.order("ItemLookupCode ASC").includes(:category).where("categories.Name like ? and Inactive = ?",  'pocket prints' , false  )                  #.find(:all, :conditions => ['categories.Name like  ?', '%pocket print%'])     #              .limit('20')    #.where("categories.Name like ?",  'pocket prints'  )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end


def select_departments
        @item = Item.unscoped.find params[:item_id]
        @departments = @item.breast_print_departments
end



def ajax_change_breast_print_departments
                    @item = Item.unscoped.find params[:item_id]
                    @departments = Department.where( "id in (?)",  params[:department_ids].split(',')  )


                  params[:department_ids].split(',').each do | di |
                                      the_iep =  BreastPrintDepartment.where("item_id = ? and department_id = ?",   params[:item_id]  ,  di    ).all
                                      if the_iep.size > 0
                                                       logger.debug "the_iep WAS FOUND"
                                      else
                                                      logger.debug "the_iep: " + the_iep.to_s
                                                      logger.debug "di: " + di
                                                      new_iep = BreastPrintDepartment.new
                                                      new_iep.item_id = params[:item_id]
                                                      new_iep.department_id = di
                                                      new_iep.save
                                      end
                                       BreastPrintDepartment.delete_all( [ "item_id = ? and department_id not in (?)",   params[:item_id]  ,    params[:department_ids].split(',') ]    )
                  end
                    render  :partial => 'breast_prints/departments_list'
end










end
