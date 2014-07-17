class MissingElement < ActiveRecord::Base
	validates_uniqueness_of   :path
	
	scope :unfixed, :conditions => {:fixed => 0},:order => "times_missed DESC"
	
	
	
end
