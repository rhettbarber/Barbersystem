class Film < ActiveRecord::Base
attr_accessible :id    , :description, :created_at, :updated_at, :customer, :work_order_id, :total_column



end
