import times, stats, math
import strformat
import std/monotimes

const repeatTimes = 7

type
  Time = int
  Timer = ref object
    name: string
    mean: float
    std: float
    times: int
    loops: int
  Moment = ref object
    minutes: Time
    seconds: Time
    milliSeconds: Time
    microSeconds: Time
    nanoSeconds: float


proc `$`(moment: Moment): string
proc `$`(timer: Timer): string
proc toTime(time: float): Moment



proc `$`(moment: Moment): string = 
  result &= "["
  if moment.minutes != 0:
    result &= fmt"{moment.minutes}m "
  if moment.seconds != 0:
    result &= fmt"{moment.seconds}s "
  if moment.milliSeconds != 0:
    result &= fmt"{moment.milliSeconds}ms "
  if moment.microSeconds != 0:
    result &= fmt"{moment.microSeconds}μs "
  result &= fmt"{moment.nanoSeconds:.2f}ns"
  result &= "]"

  

proc `$`(timer: Timer): string = 
  let momentMean = toTime(timer.mean)
  let momentStd = toTime(timer.std)
  fmt"{momentMean} ± {momentStd} per loop (mean ± std. dev. of {timer.times} runs, {timer.loops} loops each)"


proc toTime(time: float): Moment = 
  var moment = new Moment
  let nanoTime = Time(time)
  moment.nanoSeconds = float(nanoTime mod 1_000 - nanoTime) + time 
  moment.microSeconds = (nanoTime div 1_000) mod 1_000
  moment.milliSeconds = (nanoTime div 1_000_000) mod 1_000
  moment.seconds = (nanoTime div 1_000_000_000) mod 1_000
  moment.minutes = (nanoTime div 1_000_000_000 div 60) mod 1_000
  moment



# 8.26 ns ± 0.12 ns per loop (mean ± std. dev. of 7 runs, 100000000 loops each)
template inner(myFunc: untyped): Time = 
  let time = getMonoTime()
  myFunc
  let lasting = getMonoTime() - time
  lasting.inNanoseconds.Time



template timeIt(myFunc: untyped, repeatTimes: int = repeatTimes): Timer = 
  var 
    timer = new Timer
    timerTotal: seq[Time]
    totalMean: seq[float]
    totalStd: seq[float]
    timerTimes: int = repeatTimes
    timerLoops: Time
  assert repeatTimes >= 1, "repeatTimes must be greater than 1"
  timerLoops = 1000_000_000 div myFunc.inner
  timerLoops = 10 ^ int(log10(timerLoops.float))
  if timerLoops == 0:
    timerLoops = 1
  GC_disable()
  for _ in 1 .. repeatTimes:
    for _ in 1 .. timerLoops:
      timerTotal.add myFunc.inner
    totalMean.add timerTotal.mean
    totalStd.add timerTotal.standardDeviation
  GC_enable()
  timer.mean = totalMean.mean
  timer.std = totalStd.standardDeviation
  timer.times = timerTimes
  timer.loops = timerLoops
  timer
  


when isMainModule:
  import os
  proc mySleep(age: varargs[int]): int {.discardable.} = 
    sleep(3)
  echo timeIt(mySleep(1, 2, 3), 7)