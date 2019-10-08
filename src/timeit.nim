import times, os

template timeIt(myFunc: untyped): float = 
  let time = cpuTime()
  myFunc()
  cpuTime() - time

proc mySleep() = 
  sleep(100)

echo timeIt(mySleep)
  
