import streams, strformat
import parseopt
import osproc



proc command*() = 
  var 
    p = initOptParser()
    name: string
    def: string
  while true:
    p.next()
    case p.kind
    of cmdEnd: break
    of cmdShortOption, cmdLongOption:
      if p.key == "name":
        name = p.val
      elif p.key == "def":
        def = p.val
    of cmdArgument:
      echo "Argument: ", p.key
  var strm = newFileStream(name & ".nim", fmRead)
  var line = ""
  let tempFile = "temp.nim"

  var temp = newFileStream(tempFile, fmWrite)
  if not isNil(temp):
    temp.writeLine(fmt"import timeit")
  if not isNil(strm):
    while strm.readLine(line):
      if not isNil(temp):
        temp.writeLine(line)
    if not isNil(temp):
      temp.writeLine(fmt"echo timeGo({def})")
      temp.close()
    strm.close()

  let (output, _) = execCmdEx("nim c -r --verbosity=0 --hints=off --hint[source]=off " & tempFile)

  temp = newFileStream(tempFile, fmWrite)
  temp.close()
  echo output