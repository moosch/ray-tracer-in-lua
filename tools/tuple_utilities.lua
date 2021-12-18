require("math")
local tuple = require("tools/tuple")
local vector = require("tools/vector")

local function tupleType(t)
  if t.w == nil then return "color" end
  if t.w == 1.0 then return "point" end
  if t.w == 0.0 then return "vector" end
  return nil
end

local epsilon = 0.00001

local function eq(a, b)
  if a == nil and b == nil then return true end
  if math.abs(a - b) < epsilon then
    return true
  else
    return false
  end
end

local function equal(t1, t2)
  if eq(t1.x, t2.x)
    and eq(t1.y, t2.y)
    and eq(t1.z, t2.z)
    and eq(t1.w, t2.w) then
    return true
  end
  print("Tuples are not equal")
  print("Expected: {x="..tostring(t1.x)..", y="..tostring(t1.y)..", z="..tostring(t1.z)..", w="..tostring(t1.w).."}")
  print("Actual: {x="..tostring(t2.x)..", y="..tostring(t2.y)..", z="..tostring(t2.z)..", w="..tostring(t2.w).."}")
  return false
end

local function add(t1, t2)
  -- assert(t1.w + t2.w <= 1)
   local w = nil
   if t1.w ~= nil and t2.w ~= nil then
      w = t1.w + t2.w
   end
  return tuple(t1.x + t2.x, t1.y + t2.y, t1.z + t2.z, w)
end

local function subtract(t1, t2)
   -- assert(t1.w - t2.w >= 0)
  local w = nil
  if t1.w ~= nil and t2.w ~= nil then
    w = t1.w - t2.w
  end
  return tuple(t1.x - t2.x, t1.y - t2.y, t1.z - t2.z, w)
end

local function negate(t)
  local w = nil
  if t.w ~= nil then w = 0 - t.w end
  return tuple(0 - t.x, 0 - t.y, 0 - t.z, w)
end

local function scale(t, v)
  local w = nil
  if t.w ~= nil then w = t.w * v end
  return tuple(t.x * v, t.y * v, t.z * v, w)
end

local function multiply(t1, t2)
  local w = nil
  if t1.w ~= nil and t2.w ~= nil then w = t1.w * t2.w end
  return tuple(t1.x * t2.x, t1.y * t2.y, t1.z * t2.z, w)
end

local function divide(t, v)
  local w = nil
  if t.w ~= nil then w = t.w / v end
  return tuple(t.x / v, t.y / v, t.z / v, w)
end

local function _sumOfMultiples(t1, t2)
  local w = 0
   if t1.w ~= nil and t2.w ~= nil then
     w = t1.w * t2.w
   end
  return (t1.x * t2.x) + (t1.y * t2.y) + (t1.z * t2.z) + w
end

local function magnitude(t)
  return math.sqrt(_sumOfMultiples(t, t))
end

local function normalize(t)
  return tuple(
    t.x / magnitude(t),
    t.y / magnitude(t),
    t.z / magnitude(t),
    t.w / magnitude(t))
end

local function dot(t1, t2)
  return _sumOfMultiples(t1, t2)
end

local function cross(v1, v2)
  return vector(v1.y * v2.z - v1.z * v2.y,
		v1.z * v2.x - v1.x * v2.z,
		v1.x * v2.y - v1.y * v2.x)
end

Tuple = {
  type = tupleType,
  equal = equal,
  add = add,
  subtract = subtract,
  negate = negate,
  multiply = multiply,
  scale = scale,
  divide = divide,
  magnitude = magnitude,
  normalize = normalize,
  dot = dot,
  cross = cross,
}
