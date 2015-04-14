 module WebsiteSessionManagement

    
 
def limit_session_default_sweep
 		 Session.sweep
end
 
 
 def limit_session_two_week_sweep
 		 Session.two_week_sweep
end
 
 
 
 def limit_session_with_user_preferences
 		if @user
 					if @user.stay_signed_in == "1"
 							limit_session_two_week_sweep
 					else
 							limit_session_default_sweep
 					end
 		else
 							limit_session_default_sweep
 		end
end
  
  
  
def test_session_management
  		time_conditions = "updated_at < '#{1.minute.ago.to_s(:db)}' OR created_at < '#{1.minute.ago.to_s(:db)}'"
     @found_sessions =  Session.find(:all, :conditions => time_conditions)
    if @found_sessions.size > 0
            flash[:notice] = "SESSIONS DO EXIST! SESSIONS DO EXIST! SESSIONS DO EXIST!"
            
        else
            flash[:notice] = "NO EXIST!"
        end
end
  
    
    
    
    
end
