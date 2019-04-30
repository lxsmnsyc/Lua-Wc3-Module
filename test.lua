
require "Lua-Wc3-Module"
module.create("A")(function ()
  return 100
end)
module.create("B")(function ()
  return print
end)
module.create("C", {"A", "B"})(function (imports)
  return imports.B(imports.A)
end)
module.init()

