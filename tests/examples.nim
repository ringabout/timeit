# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest, os

import ../src/timeit

proc sleepNoReturn(num: varargs[int]) = 
  sleep(3)

proc sleepDiscardValue(num: varargs[int]): int {.discardable.} = 
  sleep(3)

test "proc without return value":
  echo timeGo(sleepNoReturn(5, 2, 1), 7, 2)

test "proc with discardable value":
  echo timeGo(sleepDiscardValue(5, 2, 1), 7, 10)
