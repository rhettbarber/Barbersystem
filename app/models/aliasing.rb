class Aliasing  < ActiveRecord::Base
belongs_to  :item


default_scope :joins => :item,   :conditions => ['items.WebItem = ? and items.Inactive = ? ', true ,   false   ]


end
