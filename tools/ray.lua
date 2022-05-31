require("tools/fuzzy_eq")

local ray = {}

local function eq(a, b)
   if a == nil and b == nil then return true end

   if a.type ~= 'ray' or b.type ~= 'ray' then
     return false
   end

  -- if a.origin ~= b.origin)
  --   or a.position ~= b.position then
  --   return false
  -- end

  return true
end

local function position(r, t)
  return r.origin + (r.direction * t)
end


--[[
  Build Metatable for Ray
--]]
local function metaTable()
  local mt = {}
  mt.__index = { type = "ray" }
  mt.__eq = eq

  return mt
end


ray.new = function(origin, direction)
  local r = {origin = origin, direction = direction}
  local mt = metaTable()
  setmetatable(r, mt)

  -- Returns the Point position at Ray.t (time)
  function r:position(t) return position(self, t) end

  return r
end

--
--Create new Ray
--
--@param origin Point
--@param direction Vector
--@return table Ray
Ray = function(origin, direction) return ray.new(origin, direction) end
