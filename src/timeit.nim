import times, os, stats
import strformat
import std/monotimes

const repeatTimes = 7

type
  Timer = ref object
    mean: float
    std: float
    times: int
    loops: int

proc `$`(timer: Timer): string = 
  fmt"{timer.mean:.2f} ns ± {timer.std:.2f} ns per loop (mean ± std. dev. of {timer.times} runs)"

# 8.26 ns ± 0.12 ns per loop (mean ± std. dev. of 7 runs, 100000000 loops each)

template timeGo(myFunc: untyped, repeatTimes: int = repeatTimes): Timer = 
  var 
    timer = new Timer
    timerTotal: seq[int]
    timerTimes: int = repeatTimes
    timerLoops: int = 1000
  GC_disable()
  for _ in 1 .. repeatTimes:
    let time = getMonoTime()
    myFunc
    let lasting = getMonoTime() - time
    timerTotal.add(lasting.inNanoseconds.int)
  GC_enable()
  echo timerTotal
  timer.mean = timerTotal.mean
  timer.std = timerTotal.standardDeviation
  timer.times = timerTimes
  timer.loops = timerLoops
  timer
  


proc mySleep(age: varargs[int]): int {.discardable.} = 
  sleep(100)
 


echo timeGo(mySleep(1, 2, 3))