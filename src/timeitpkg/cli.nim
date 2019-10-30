import streams, strformat, strutils
import parseopt
import os, osproc



proc command*() = 
  var 
    p = initOptParser()
    name: string
    def: string
    args: string
    option: string
  while true:
    p.next()
    case p.kind
    of cmdEnd: break
    of cmdShortOption, cmdLongOption:
      if p.key == "name":
        name = p.val
      elif p.key == "def":
        def = p.val
      elif p.key == "d":
        option = p.val
    of cmdArgument:
      args = p.key
  if args != "" and args.endsWith(".nim"):
    name = args
    def = ""
  elif args == "":
    if name == "" or def == "":
      echo "missing name or function call"
      return
  else:
    echo "error params"
    return

  if option == "":
    option = "debug"

  if name.endsWith(".nim"):
    name = name[ .. ^5]
  var strm = newFileStream(name & ".nim", fmRead)
  var line = ""
  let tempFile = getTempDir() & "timeit_temp.nim"
  var temp = newFileStream(tempFile, fmWrite)
  if not isNil(temp):
    temp.writeLine("import timeit")
    if def == "":
      temp.writeLine("""var m = monit("test-whole")""")
      temp.writeLine("m.start()")
  if not isNil(strm):
    while strm.readLine(line):
      if not isNil(temp):
        temp.writeLine(line)
    if not isNil(temp):
      temp.writeLine("echo \"****************************\"")
      temp.writeLine(fmt"""echo "{option} mode"""")
      if def == "":
        temp.writeLine("m.finish()")
      else:
        temp.writeLine(fmt"echo timeGo({def})")
      temp.close()
    strm.close()

    
  let (output, _) = execCmdEx(fmt"nim c -r -f --d:{option} --verbosity=0 --hints=off --hint[source]=on " & tempFile)

  temp.close()

  echo output