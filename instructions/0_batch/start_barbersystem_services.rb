Thread.new{ system("cmd /c sc start 1000_dixie_store")}
Thread.new{ system("cmd /c sc start 1001_dixie_store")}
Thread.new{ system("cmd /c sc start 1002_dixie_store")}
Thread.new{ system("cmd /c sc start 1003_dixie_store")}
Thread.new{ system("cmd /c sc start 2000_barber_store")}
Thread.new{ system("cmd /c sc start 2001_barber_store")}
Thread.new{ system("cmd /c sc start 2002_barber_store")}
Thread.new{ system("cmd /c sc start 2003_barber_store")}
#Thread.new{ system("cmd /c sc start 3000_american_store")}
#Thread.new{ system("cmd /c sc start 4000_rhett_barber")}
#Thread.new{ system("cmd /c sc start 7000_christian_store")}
#Thread.new{ system("cmd /c sc start 7001_christian_store")}