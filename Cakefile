# http://anvarichn.livejournal.com/43752.html Использование UTF-8 в cmd.exe
# http://www.danneu.com/posts/14-setting-up-mocha-testing-with-coffeescript-node-js-and-a-cakefile/

{exec} = require 'child_process'

reporter = "min"

task 'test', ->
  exec """chcp 65001 | .\\node_modules\\.bin\\mocha
      --compilers coffee:coffee-script/register
      --reporter #{reporter}
      --require coffee-script
      --require test/test_helper.coffee
  """, (error, stdout, stderr) ->
    console.log error.toString() if error
    output = if error then stderr else stdout
    console.log output
