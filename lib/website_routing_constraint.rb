class WebsiteRoutingConstraint


          #BE AWARE.. EVEN IN DEVELOPMENT RAILS  MUST BE RESTARTED
          #BE AWARE.. EVEN IN DEVELOPMENT RAILS  MUST BE RESTARTED
          #BE AWARE.. EVEN IN DEVELOPMENT RAILS  MUST BE RESTARTED
          #BE AWARE.. EVEN IN DEVELOPMENT RAILS  MUST BE RESTARTED
          #BE AWARE.. EVEN IN DEVELOPMENT RAILS  MUST BE RESTARTED





  def  self.matches?(request)
      $stdout.puts "HOST  " + request.host
      $stdout.puts "%%%%%% ADMIN %%%%%%%%%%%%%%%%%%%%%"
      $stdout.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
      $stdout.puts "%%%%%%%  request.ip %%%%%%%%%%%%%%%%: " + request.ip
       if [ '192.168.0.122' , '192.168.0.123', '192.168.0.126' , '192.168.0.135', '192.168.0.131', '192.168.0.33', '192.168.0.225', '192.168.0.101', '10.1.10.10',"192.168.0.104","192.168.0.172","192.168.0.158"].include?( request.ip )
              $stdout.puts "%%%%%%%%%%%%  TRUE  %%%%%%%%%%%%%"
              $stdout.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
              $stdout.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
              $stdout.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
              true
       else
              $stdout.puts "%%%%%%%%%%%%  FALSE  %%%%%%%%%%%%%"
              $stdout.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
              $stdout.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
              $stdout.puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            false
      end
end



end




#  request.host == '192.168.0.125'
#      !request.session[:user_id].blank?
#            case request.host
#            when "great"
#                      $stdout.puts "GREAT request.host: " + request.host
#                      true
#            else
#                    $stdout.puts "NOT GREAT request.host: " + request.host
#                       false
#            end