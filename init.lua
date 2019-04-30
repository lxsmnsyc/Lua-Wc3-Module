local moduleLoaded = {}
local cachedModule = {}
local moduleBody = {}
local origin = ""

local function loadModule(name)
  if((not moduleLoaded[name]) and origin ~= name) then
    local parent = origin
    origin = name
    cachedModule[name] = moduleBody[name](loadModule)
    origin = parent
  end
  return cachedModule[name]
end

local function moduleCreate(name, body)
  moduleBody[name] = body
  moduleLoaded[name] = false
  cachedModule[name] = nil
end

module = {
  create = moduleCreate,
  load = loadModule
}