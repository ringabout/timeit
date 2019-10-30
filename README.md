# timeit [![nimble](https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble.png)](https://github.com/yglukhov/nimble-tag)
measuring execution times written in nim.

## Installation
```text
nimble install timeit
```

## Usage
### import timeit
In **timeit** module, you can use the **timeGo** to
measure execution times of proc. \
There are three parameters in **timeGo**.\
**myFunc** is the call of proc. **repeatTimes** is
how many times you want to measure, the result is the average of all the times, **loopTimes** is how many loops you want to execute in each time.
If you don't give the value of **loopTimes**, the program will calculate the **loopTimes** according to the execution times in first time.    
```nim
template timeGo*(myFunc: untyped, 
                repeatTimes: int = repeatTimes, 
                loopTimes: int = loopTimes): Timer
```
When you want to pass **myFunc** parameter to **timeGo**, there are some points you should take care of. \
If you want to pass the proc without return value, you should use the call of the proc, namely **myProc(args)**. \
If you want to pass the proc with return value,
you should add the pragma **{.discardable.}** to the
definitions of your proc.Then you can use **timeGo**
to measure the execution times of your proc, namely **myProc(args)**.

### another Way
You can also use timeGo as follow:
```nim
import os

echo timeGo do:
  os.sleep(12)
  var a = 12
  for i in 1 .. 1000:
  a += 12
# output [12ms 883μs 34.58ns] ± [19μs 974.83ns] per loop (mean ± std. dev. of 7 runs, 10 loops each)
```

### use monit function
You can use monit function to measure the times
of code executions. \
First you can specify the **name** of this test,
for example, "first".Then you can place the
**start** function in the begin of the code you want
to measure, and place the **finsih** function in the
end of the code you want to measure.
```nim
import timeit
var m = monit("first")
m.start()
let a = 12
echo a + 3 
m.finish()
# first -> [17μs 0.00ns]
```
You can also monit once as follows:
```nim
timeOnce:
  var a = 12
  for i in 1 .. 10000:
    a += i
  echo a
```


### use command-line interface
Firstly, you need to make sure that your **.nimble** directory must be in your path environment.
Then you can use **timeit --name=yourNimFile --def=yourProc**. \
However, string parameters can't appear in yourProc.And If you want
to specify more than one parameter, you should use **"yourProc(parameters)"**.

```nim
# in bash
timeit --name=test --def=hello()
# [46ms 290μs 893.17ns] ± [1ms 164μs 333.97ns] per loop (mean ± std. dev. of 7 runs, 10 loops each)
```
You can also measure the execution time of the whole Nim file.
```nim
# in bash
timeit test.nim
# test-whole -> [216μs 400.00ns]

# or specify the -d flag
timeit test.nim -d:release
# test-whole -> [26μs 0.00ns]

```



## Examples
for proc without return value
```nim
import timeit

proc mySleep(num: varargs[int]) = 
  for i in 1 .. 10:
    discard
echo timeGo(mySleep(5, 2, 1))
# [216.50ns] ± [1μs 354.44ns] per loop (mean ± std. dev. of 7 runs, 1000000 loops each)
```
for proc with return value
```nim
import timeit

proc mySleep(num: varargs[int]): int {.discardable.} = 
  for i in 1 .. 10:
    discard
echo timeGo(mySleep(5, 2, 1)) 
# [221.82ns] ± [1μs 837.93ns] per loop (mean ± std. dev. of 7 runs, 1000000 loops each) 
```
