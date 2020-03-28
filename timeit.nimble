# Package

version       = "0.3.6"
author        = "flywind"
description   = "measuring execution times written in nim."
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["timeit"]




# Dependencies

requires "nim >= 1.0.0"

task tests, "Run tests":
  exec "nim c -r tests/examples.nim"
