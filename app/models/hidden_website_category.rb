class HiddenWebsiteCategory < ActiveRecord::Base


  belongs_to :website
  belongs_to :category


end
