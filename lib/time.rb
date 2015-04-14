module TimeManagement
  protected	

############################################################################################################
def find_quarters(year_difference)
	year_difference = year_difference.year
	@first_quarter_begin = Time.new.beginning_of_year + year_difference
	@first_quarter_end = Time.new.beginning_of_year+ year_difference  + 3.months - 1.day
	
	@second_quarter_begin = Time.new.beginning_of_year + year_difference + 3.months
	@second_quarter_end = Time.new.beginning_of_year  + year_difference + 6.months - 1.day
	
	@third_quarter_begin = Time.new.beginning_of_year + year_difference + 6.months
	@third_quarter_end = Time.new.beginning_of_year + year_difference + 9.months - 1.day
	
	@fourth_quarter_begin =  Time.new.beginning_of_year + year_difference + 9.months
	@fourth_quarter_end = Time.new.beginning_of_year + year_difference + 12.months - 1.day
end



end
