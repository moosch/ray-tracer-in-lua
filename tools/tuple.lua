local epsilon = 0.00001

local function eq(a, b)
  if a == nil and b == nil then return true end
  if math.abs(a - b) < epsilon then
    return true
  else
    return false
  end
end


--[[
  3D Vector
--]]
local vector = {}
local vecmt = {}

vector.new = function(x, y, z)
   local v = {x=x, y=y, z=z, type="vector"}
   setmetatable(v, vecmt)
   return v
end

local addTwoVectors = function(a, b)
   return vector.new(a.x + b.x, a.y + b.y, a.z + b.z)
end
local addConstantToVector = function(vec, v)
   return vector.new(vec.x + v, vec.y + v, vec.z + v)
end

vecmt.__add = function(a, b)
   -- Add constant to vector
   if type(b) == "number" then
      return addConstantToVector(a, b)
   end

   -- Add two vectors
   if b.type == "vector" then
      return addTwoVectors(a, b)
   end

   -- Best guess
   return vector.new(a.x + b.x, a.y + b.y, a.z + b.z)
end

local subtractTwoVectors = function(a, b)
   return vector.new(a.x - b.x, a.y - b.y, a.z - b.z)
end
local subtractConstantFromVector = function(vec, v)
   return vector.new(vec.x - v, vec.y - v, vec.z - v)
end

vecmt.__sub = function(a, b)
   if type(b) == "number" then
      return subtractConstantFromVector(a, b)
   end
   return subtractTwoVectors(a, b)
end

local multiplyConstantByVector = function(vec, v)
   return vector.new(vec.x * v, vec.y * v, vec.z * v)
end
local multiplyTwoVectors = function(a, b)
   return vector.new(a.x * b.x, a.y * b.y, a.z * b.z)
end

vecmt.__mul = function(a, b)
   if type(b) == "number" then
      return multiplyConstantByVector(a, b)
   end
   return multiplyTwoVectors(a, b)
end

local divideVectorByConstant = function(vec, v)
   return vector.new(vec.x / v, vec.y / v, vec.z / v)
end
local divideTwoVectors = function(a, b)
   return vector.new(a.x / b.x, a.y / b.y, a.z / b.z)
end
vecmt.__div = function(a, b)
   if type(b) == "number" then
      return divideVectorByConstant(a, b)
   end
   return divideTwoVectors(a, b)
end

vecmt.__eq = function(a, b)
   if eq(a.x, b.x)
    and eq(a.y, b.y)
    and eq(a.z, b.z) then
    return true
   end
   return false
end

vecmt.__unm = function(v)
   return vector.new(-1.0 * v.x, -1.0 * v.y, -1.0 * v.z)
end

vecmt.__tostring = function(v)
   return "{x: "..v.x..", y: "..v.y..", z: "..v.z.."}"
end

-- local Vector = function(x, y, z) return vector.new(x, y, z) end

--[[
  3D Point in space
--]]

local point = {}
local pointmt = {}

point.new = function(x, y, z)
  local p = {x=x, y=y, z=z, type="point"}
  setmetatable(p, pointmt)
  return p
end

local addTwoPoints = function(a, b)
  return point.new(a.x + b.x, a.y + b.y, a.z + b.z)
end
local addConstantToPoint = function(p, v)
  return point.new(p.x + v, p.y + v, p.z + v)
end
local addPointToVector = function(p, v)
  return vector.new(p.x + v.x, p.y + v.y, p.z + v.z)
end

pointmt.__add = function(a, b)
  -- Add constant to point
  if type(b) == "number" then
     return addConstantToPoint(a, b)
  end

  -- Add two points
  if b.type == "point" then
     return addTwoPoints(a, b)
  end
  -- Add point to vector
  if b.type == "vector" then
     return addPointToVector(a, b)
  end

  -- Best guess
  return point.new(a.x + b.x, a.y + b.y, a.z + b.z)
end

-- Returns a vector
local subtractTwoPoints = function(a, b)
  return vector.new(a.x - b.x, a.y - b.y, a.z - b.z)
end
local subtractConstantFromPoint = function(p, v)
  return point.new(p.x - v, p.y - v, p.z - v)
end
local subtractVectorFromPoint = function(p, v)
  return vector.new(p.x - v.x, p.y - v.y, p.z - v.z)
end

pointmt.__sub = function(a, b)
  if type(b) == "number" then
     return subtractConstantFromPoint(a, b)
  end
  if type(b) == "vector" then
     return subtractVectorFromPoint(a, b)
  end
  return subtractTwoPoints(a, b)
end

local multiplyConstantByPoint = function(p, v)
  return point.new(p.x * v, p.y * v, p.z * v)
end
local multiplyTwoPoints = function(a, b)
  return point.new(a.x * b.x, a.y * b.y, a.z * b.z)
end

pointmt.__mul = function(a, b)
  if type(b) == "number" then
     return multiplyConstantByPoint(a, b)
  end
  return multiplyTwoPoints(a, b)
end

local dividePointByConstant = function(p, v)
  return point.new(p.x / v, p.y / v, p.z / v)
end
local divideTwoPoints = function(a, b)
  return point.new(a.x / b.x, a.y / b.y, a.z / b.z)
end
pointmt.__div = function(a, b)
  if type(b) == "number" then
     return dividePointByConstant(a, b)
  end
  return divideTwoPoints(a, b)
end

pointmt.__eq = function(a, b)
  if eq(a.x, b.x)
   and eq(a.y, b.y)
   and eq(a.z, b.z) then
   return true
  end
  return false
end

pointmt.__unm = function(p)
  return point.new(-1.0 * p.x, -1.0 * p.y, -1.0 * p.z)
end

pointmt.__tostring = function(p)
  return "{x: "..p.x..", y: "..p.y..", z: "..p.z.."}"
end

-- Point = function(x, y, z) return point.new(x, y, z) end


--[[
  Color
--]]
local color = {}
local colmt = {}

function RgbFloatToValue(value, maxValue)
  if value < 0 then return 0 end
  if value > maxValue then return maxValue end
  value = math.ceil(value * maxValue)
  if value > maxValue then return maxValue end
  return value
end


function Clamp(color, min, max)
  local function doClamp(c)
    local v = c * max
    if v > max then v = max end
    if v < min then v = min end
    return math.ceil(v)
  end
  return color.new(
    doClamp(color.r),
    doClamp(color.g),
    doClamp(color.b)
  )
end

function RgbStringList(c)
  return {
    tostring(RgbFloatToValue(c.r, 255)),
    tostring(RgbFloatToValue(c.g, 255)),
    tostring(RgbFloatToValue(c.b, 255))
  }
end

color.new = function(r, g, b)
   local c = {r=r, g=g, b=b, type="color"}
   setmetatable(c, colmt)

  function c:rgbStringList() return RgbStringList(self) end
  function c:clamp(min, max) return Clamp(self, min, max) end
   return c
end

local addTwoColors = function(a, b)
  return color.new(a.r + b.r, a.g + b.g, a.b + b.b)
end
local addConstantToColor = function(col, v)
  return color.new(col.r + v, col.g + v, col.b + v)
end

colmt.__add = function(a, b)
  -- Add constant to color
  if type(b) == "number" then
     return addConstantToColor(a, b)
  end

  -- Add two colors
  if b.type == "color" then
     return addTwoColors(a, b)
  end

  -- Best guess
  return color.new(a.r + b.r, a.g + b.g, a.b + b.b)
end

local subtractTwoColors = function(a, b)
  return color.new(a.r - b.r, a.g - b.g, a.b - b.b)
end
local subtractConstantFromColor = function(c, v)
  return color.new(c.r - v, c.g - v, c.b - v)
end

colmt.__sub = function(a, b)
  if type(b) == "number" then
     return subtractConstantFromColor(a, b)
  end
  return subtractTwoColors(a, b)
end

local multiplyConstantByColor = function(c, v)
  return color.new(c.r * v, c.g * v, c.b * v)
end
local multiplyTwoColors = function(a, b)
  return color.new(a.r * b.r, a.g * b.g, a.b * b.b)
end

colmt.__mul = function(a, b)
  if type(b) == "number" then
     return multiplyConstantByColor(a, b)
  end
  return multiplyTwoColors(a, b)
end

colmt.__eq = function(a, b)
  if eq(a.r, b.r)
   and eq(a.g, b.g)
   and eq(a.b, b.b) then
   return true
  end
  return false
end

colmt.__tostring = function(c)
  return "{r: "..c.r..", g: "..c.g..", b: "..c.b.."}"
end

-- Color = function(r, g, b) return color.new(r, g, b) end


--[[
  Vector & Point operations
--]]

local sumVector = function(v) return v.x + v.y + v.z end

local dotProduct = function(v1, v2) return sumVector(v1 * v2) end

local crossProduct = function(v1, v2)
  return vector.new(
    v1.y * v2.z - v1.z * v2.y,
    v1.z * v2.x - v1.x * v2.z,
    v1.x * v2.y - v1.y * v2.x)
end

local magnitude = function(v) return math.sqrt(dotProduct(v, v)) end

local normalize = function(v) return v / magnitude(v) end

local Tuple = {
  vector = function(x, y, z) return vector.new(x, y, z) end,
  point = function(x, y, z) return point.new(x, y, z) end,
  color = function(r, g, b) return color.new(r, g, b) end,
  magnitude = magnitude,
  normalize = normalize,
  dot = dotProduct,
  cross = crossProduct,
  sumVector = sumVector
}

return Tuple

