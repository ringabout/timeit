# timeit
measuring execution times written in nim.
## Usage
for proc without return value
```nim
proc mySleep(age: varargs[int]) = 
  for i in 1 .. 10:
    discard
echo timeIt(mySleep(5, 2, 1))
# [216.50ns] ± [1μs 354.44ns] per loop (mean ± std. dev. of 7 runs, 1000000 loops each)
```
for proc with return value
```nim
proc mySleep(age: varargs[int]): int {.discardable.} = 
  for i in 1 .. 10:
    discard
echo timeIt(mySleep(5, 2, 1)) 
# [221.82ns] ± [1μs 837.93ns] per loop (mean ± std. dev. of 7 runs, 1000000 loops each) 
```