import times, os
import std/monotimes


template timeGo(myFunc: untyped): Duration = 
  let time = getMonoTime()
  myFunc()
  getMonoTime() - time


proc mySleep() = 
  sleep(100)


echo timeGo(mySleep).inNanoseconds 