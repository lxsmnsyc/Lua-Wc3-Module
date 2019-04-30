local cachedModule = {}
local modules = {}
local moduleLoaded = {}
local moduleParents = {}
local moduleBody = {}

local function createModule(name, dependency)
  modules[name] = true
  local parents = {}
  
  if (type(dependency) == "table") then
    for _, v in ipairs(dependency) do
      if (v ~= name) then
        parents[#parents + 1] = v
      end
    end
  end

  moduleLoaded[name] = false
  moduleParents[name] = parents
  return function (body)
    moduleBody[name] = body
  end
end

local function loadModule(name)
  if (not moduleLoaded[name]) then
    local result
    local body = moduleBody[name]
    local parents = moduleParents[name]
    moduleLoaded[name] = true
    if (#parents > 0) then
      local imports = {}
      for _, v in ipairs(parents) do
        imports[v] = loadModule(v)
      end
      result = body(imports)
    else
      result = body()
    end
    cachedModule[name] = result
    return result
  end
  return cachedModule[name]
end

local function loadModules()
  for k, _ in pairs(modules) do
    loadModule(k)
  end
end

module = {
  create = createModule,
  load = loadModule,
  init = loadModules,
}
