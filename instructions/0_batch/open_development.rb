
_testing
cd "C:\Documents and Settings\Administrator\My Documents\rails\barbersystem" && mongrel_rails start -p 1007 -e production
D: && cd "D:\rails_development\barbersystem_edge" && mongrel_rails start -p 1007 -e development

D: && cd "D:\rails_development\barbersystem_edge" &&  tail -f log\development.log

D: && cd "D:\rails_development\barbersystem_edge" && rake log:clear

D: && cd "D:\rails_development\barbersystem_edge" && rake log:clear && mongrel_rails start -p 1007 -e production_testing

D: && cd "D:\rails_development\barbersystem_edge" && rake log:clear && mongrel_rails start -p 2007 -e production_testing


D: && cd "D:\rails_development\barbersystem_edge" &&  tail -f log\production_testing.log



cd "C:\Documents and Settings\Administrator\My Documents\rails\barbersystem" && mongrel_rails start -p 1007 -e production_testing




cd "C:\Documents and Settings\Administrator\My Documents\rails\barbersystem" && mongrel_rails start -p 1007 -e development

cd "C:\Documents and Settings\Administrator\My Documents\rails\barbersystem"&& rake log:clear &&  tail -f log\development.log

cd "C:\Documents and Settings\Administrator\My Documents\rails\barbersystem"  && tail -f log\production.log

cd "C:\Documents and Settings\Administrator\My Documents\rails\barbersystem" && mongrel_rails start -p 1007 -e production