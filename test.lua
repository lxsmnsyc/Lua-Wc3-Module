
require "Lua-Wc3-Module"

module.create("foo", function(require)
  Foo = {}
  Bar = Bar or require "bar"
  Foo.name = 'foo'

  function Foo:getName()
      return Foo.name .. Bar.name
  end

  return Foo
end)
module.create("bar", function(require)
  Bar = {}
  Foo = Foo or require "foo"
  Bar.name = 'bar'

  function Bar:getName()
      return Bar.name .. Foo.name
  end

  return Bar
end)
module.create("main", function (require)
  Foo = Foo or require "foo"
  Bar = Bar or require "bar"
  print (Foo.getName())
  print (Bar.getName())
end)

module.load("main")