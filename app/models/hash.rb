	
class Hash
		
#	alias :old_select :select
	
	  def new_select(&block)
	    a = select(&block)
	    Hash[*a.flatten]
	  end
	  
 
	  
	  
end
