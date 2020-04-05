import ../src/timeit


proc mod1(a, b: int): int {.inline.} =
  if a > b:
    result = a - b
  else:
    result = a

timeOnce("1"):
  echo mod1(12, 8192)

timeOnce("2"):
  echo mod1(12675, 8192)

timeOnce("3"):
  echo 12 mod 8192

timeOnce("4"):
  echo 12675 mod 8192