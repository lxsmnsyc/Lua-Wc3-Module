# Lua-Wc3-Module

module system for Lua Warcraft 3

There are two kinds of module systems:
- Dependent module system
- Async module system

The dependent module system prevents circular dependency internally. The downside is that it doesn't allow asynchronous module loading (unlike the built-in Lua require). It also requires you to declare the dependency modules. This module system also allows you to load all modules.

The async module system is like the Lua require module system. The difference is that module are declared inside a callback (since Wc3 Lua doesn't have IO). The difference between async module system and dependent module system is that the async doesn't prevent circular dependency, but it allows async module loading. Another downside is that you need to defined the module entrypoint of which you want to load.

## Example Dependent Module

```lua
require "Lua-Wc3-Module"
module.create("A")(function ()
  print("module A loaded")
  return 100
end)
module.create("B")(function ()
  print("module B loaded")
  return 200
end)
module.create("C")(function ()
  print("module C loaded")
  return function (a, b)
    return a + b
  end
end)
module.create("D", {"A", "B", "C"})(function (imports)
  print("module D loaded")
  return imports.C(imports.A, imports.B)
end)
module.create("E")(function ()
  print("module E loaded")
  return print
end)
module.create("F", {"D", "E"})(function (imports)
  print("module F loaded")
  imports.E(imports.D)
end)
module.init()
```

## Example Async Module

```lua

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
```