# timeit
measuring execution times written in nim.
## Usage
for proc without return value
```nim
proc mySleep(age: varargs[int]) = 
  for i in 1 .. 10:
    discard
timeIt(mySleep(5, 2, 1))
```
for proc with return value
```nim
proc mySleep(age: varargs[int]): int = 
  for i in 1 .. 10:
    discard
timeIt(dicard mySleep(5, 2, 1))
# or
proc mySleep(age: varargs[int]): int {.discardable.} = 
  for i in 1 .. 10:
    discard
timeIt(mySleep(5, 2, 1)) 
```