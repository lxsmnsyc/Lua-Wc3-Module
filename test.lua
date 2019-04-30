
require "Lua-Wc3-Module"

module.create("A", function() return 100 end)
module.create("B", function() return 200 end)
module.create("add", function ()
  return function (a, b)
    return a + b
  end
end)
module.create("print", function ()
  return print
end)
module.create("addAB", function (require)
  local A = require("A")
  local B = require("B")
  local add = require("add")
  return add(A, B)
end)
module.create("init", function (require)
  require("print")(require("addAB"))
end)

module.load("init")