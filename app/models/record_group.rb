class RecordGroup < ActiveRecord::Base

  def self.all_over_shirt_design_department_ids
            self.find_by_name('all_over_shirt_design_department_ids').ids
  end


end
