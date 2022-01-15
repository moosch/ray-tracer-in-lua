local tuple = {}
local vector = {}
local point = {}
local color = {}

local epsilon = 0.00001

local function fuzzyEq(a, b)
  if math.abs(a - b) < epsilon then
    return true
  else
    return false
  end
end

local function eq(a, b)
  if a == nil and b == nil then return true end
  -- if a.type ~= b.type then return false end
  if fuzzyEq(a.x, b.x) == false
    or fuzzyEq(a.y, b.y) == false
    or fuzzyEq(a.z, b.z) == false
    or fuzzyEq(a.w, b.w) == false then
    return false
  end

  return true
end

--
--Adds two tuples
--
--@param a table # Tuple | Vector | Point
--@param b table # Tuple | Vector | Point
--@return table tuple
local function addTuples(a, b)
  if a.type == "point" and b.type == "point" then
    -- Doesn't make sense to add point to point
    assert(false, "Should not add two Points")
  end
  local w = a.w + b.w
  if w == 0 then
    return vector.new(a.x + b.x, a.y + b.y, a.z + b.z)
  end
  if w == 1 then
    return point.new(a.x + b.x, a.y + b.y, a.z + b.z)
  end
  return tuple.new(a.x + b.x, a.y + b.y, a.z + b.z, w)
end

--
--Adds number to tuple
--
--@param t table # Tuple | Vector | Point
--@param n number
--@return table tuple
local function addToTuple(t, n)
  if t.type == "vector" then
    return vector.new(t.x + n, t.y + n, t.z + n)
  end
  if t.type == "point" then
    return point.new(t.x + n, t.y + n, t.z + n)
  end
  return tuple.new(t.x + n, t.y + n, t.z + n, t.w + n)
end

--
--Subtract Tuple from Tuple
--
--@param a table # Tuple | Vector | Point
--@param b table # Tuple | Vector | Point
--@return table tuple
local function subtractTuples(a, b)
  local w = a.w - b.w
  if w == 0 then
    return vector.new(a.x - b.x, a.y - b.y, a.z - b.z)
  end
  if w == 1 then
    return point.new(a.x - b.x, a.y - b.y, a.z - b.z)
  end
  return tuple.new(a.x - b.x, a.y - b.y, a.z - b.z, w)
end

--
--Subtract number from tuple
--
--@param t table # Tuple | Vector | Point
--@param n number
--@return table tuple
local function subtractFromTuple(t, n)
  if t.type == "vector" then
    return vector.new(t.x - n, t.y - n, t.z - n)
  end
  if t.type == "point" then
    return point.new(t.x - n, t.y - n, t.z - n)
  end
  return tuple.new(t.x - n, t.y - n, t.z - n, t.w - n)
end

--
--Negate a tuple
--
--@param t table # Tuple | Vector | Point
--@return table tuple
local function negateTuple(t)
  if t.type == "vector" then
    return vector.new(t.x * -1.0, t.y * -1.0, t.z * -1.0)
  end
  if t.type == "point" then
    return point.new(t.x * -1.0, t.y * -1.0, t.z * -1.0)
  end
  return tuple.new(t.x * -1.0, t.y * -1.0, t.z * -1.0, t.w * -1.0)
end

--
--Multiply Tuple by Tuple
--
--@param a table # Tuple | Vector | Point
--@param b table # Tuple | Vector | Point
--@return table tuple
local function multiplyTuples(a, b)
  local w = a.w * b.w
  if w == 0 then
    return vector.new(a.x * b.x, a.y * b.y, a.z * b.z)
  end
  if w == 1 then
    return point.new(a.x * b.x, a.y * b.y, a.z * b.z)
  end
  return tuple.new(a.x * b.x, a.y * b.y, a.z * b.z, w)
end

--
--Multiply tuple by number
--
--@param t table # Tuple | Vector | Point
--@param n number
--@return table tuple
local function multiplyTupleBy(t, n)
  local w = t.w * n
   if w == 0 then
    return vector.new(t.x * n, t.y * n, t.z * n)
  end
  if w == 1 then
    return point.new(t.x * n, t.y * n, t.z * n)
  end
  return tuple.new(t.x * n, t.y * n, t.z * n, w)
end

--
--Divide Tuple by Tuple
--
--@param a table # Tuple | Vector | Point
--@param b table # Tuple | Vector | Point
--@return table tuple
local function divideTuples(a, b)
  -- Avoid divide by zero
  local bw = b.w
  if bw == 0 then bw = 1 end
  local w = a.w / bw
  if w == 0 then
    return vector.new(a.x / b.x, a.y / b.y, a.z / b.z)
  end
  if w == 1 then
    return point.new(a.x / b.x, a.y / b.y, a.z / b.z)
  end
  return tuple.new(a.x / b.x, a.y / b.y, a.z / b.z, w)
end

--
--Divide tuple by number
--
--@param t table # Tuple | Vector | Point
--@param n number
--@return table tuple
local function divideTupleBy(t, n)
  assert(n > 0, "Cannot divide by zero")
  local w = t.w / n
   if w == 0 then
    return vector.new(t.x / n, t.y / n, t.z / n)
  end
  if w == 1 then
    return point.new(t.x / n, t.y / n, t.z / n)
  end
  return tuple.new(t.x / n, t.y / n, t.z / n, w)
end


--[[
  Build Metatable for Tuples
--]]
local function tupleMetaTable(tupleType)
  local mt = {}
  mt.__index = { type = tupleType }
  mt.__eq = eq
  mt.__add = function(a, b)
    if type(b) == "number" then
      return addToTuple(a, b)
    end
    return addTuples(a, b)
  end
  mt.__sub = function(a, b)
    if type(b) == "number" then
      return subtractFromTuple(a, b)
    end
    return subtractTuples(a, b)
  end
  mt.__mul = function(a, b)
    if type(b) == "number" then
      return multiplyTupleBy(a, b)
    end
    return multiplyTuples(a, b)
  end
  mt.__div = function(a, b)
    if type(b) == "number" then
      return divideTupleBy(a, b)
    end
    return divideTuples(a, b)
  end
  mt.__unm = function(t)
    return negateTuple(t)
  end
  mt.__tostring = function(t)
    return tupleType.."{x: "..t.x..", y: "..t.y..", z: "..t.z..", w: "..t.w.."}"
  end
  return mt
end

--[[
  Creating Tuples
--]]
vector.new = function(x, y, z)
  local v = {x=x, y=y, z=z, w=0}
  local mt = tupleMetaTable("vector")
  setmetatable(v, mt)
  return v
end

point.new = function(x, y, z)
  local p = {x=x, y=y, z=z, w=1}
  local mt = tupleMetaTable("point")
  setmetatable(p, mt)
  return p
end

tuple.new = function(x, y, z, w)
  local t = {x=x, y=y, z=z, w=w}
  local mt = tupleMetaTable("tuple")
  setmetatable(t, mt)
  return t
end

local sumVector = function(v) return v.x + v.y + v.z end

local dotProduct = function(v1, v2) return sumVector(v1 * v2) end

local crossProduct = function(v1, v2)
  return vector.new(
    v1.y * v2.z - v1.z * v2.y,
    v1.z * v2.x - v1.x * v2.z,
    v1.x * v2.y - v1.y * v2.x
  )
end

-- Length of vector (hypontenuse)
local magnitude = function(v) return math.sqrt(dotProduct(v, v)) end

local normalize = function(v)
  local m = magnitude(v)
  assert(m > 0, "Cannot divide by zero magnitude")
  return v / m
end

--[[
  Color
--]]
local colmt = {}

local function rgbFloatToValue(value, maxValue)
  if value < 0 then return 0 end
  if value > maxValue then return maxValue end
  value = math.ceil(value * maxValue)
  if value > maxValue then return maxValue end
  return value
end


local function clamp(color, min, max)
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

local function rgbStringList(c)
  return {
    tostring(rgbFloatToValue(c.r, 255)),
    tostring(rgbFloatToValue(c.g, 255)),
    tostring(rgbFloatToValue(c.b, 255))
  }
end

local addTwoColors = function(a, b)
  return color.new(a.r + b.r, a.g + b.g, a.b + b.b)
end
local addConstantToColor = function(c, v)
  return color.new(c.r + v, c.g + v, c.b + v)
end

local subtractTwoColors = function(a, b)
  return color.new(a.r - b.r, a.g - b.g, a.b - b.b)
end
local subtractConstantFromColor = function(c, v)
  return color.new(c.r - v, c.g - v, c.b - v)
end

local multiplyConstantByColor = function(c, v)
  return color.new(c.r * v, c.g * v, c.b * v)
end
local multiplyTwoColors = function(a, b)
  return color.new(a.r * b.r, a.g * b.g, a.b * b.b)
end

local function colorMetatable()
  local mt = {}
  mt.__index = { type = "color" }
  mt.__add = function(a, b)
    -- Add constant to color
    if type(b) == "number" then
      return addConstantToColor(a, b)
    end

    -- Add two colors
    if b.type == "color" then
      return addTwoColors(a, b)
    end

    -- Best guess
    return color.new(a.r + b.r, a.g + b.g, a.b + b.b, a.a + b.a)
  end
  mt.__sub = function(a, b)
    if type(b) == "number" then
      return subtractConstantFromColor(a, b)
    end
    return subtractTwoColors(a, b)
  end
  mt.__mul = function(a, b)
    if type(b) == "number" then
      return multiplyConstantByColor(a, b)
    end
    return multiplyTwoColors(a, b)
  end

  mt.__eq = function(a, b)
    if fuzzyEq(a.r, b.r)
      and fuzzyEq(a.g, b.g)
      and fuzzyEq(a.b, b.b)
      and fuzzyEq(a.a, b.a) then
      return true
    end
    return false
  end

  mt.__tostring = function(c)
    return "color{r: "..c.r..", g: "..c.g..", b: "..c.b..", a: "..c.a.."}"
  end

  return mt
end

color.new = function(r, g, b, a)
  local alpha = a or 1
  if alpha > 1 then
    alpha = 1
  end
  if alpha < 0 then
    alpha = 0
  end

  local c = {r=r, g=g, b=b, a=alpha}
  local mt = colorMetatable()
  setmetatable(c, mt)

  function c:rgbStringList() return rgbStringList(self) end
  function c:clamp(min, max) return clamp(self, min, max) end

  return c
end


--
--Create new Tuple
--
--@param x number
--@param y number
--@param z number
--@param w number
--@return table tuple
Tuple = function(x, y, z, w) return tuple.new(x, y, z, w) end
--
--Create new Vector
--
--@param x number
--@param y number
--@param z number
--@return table vector
Vector = function(x, y, z) return vector.new(x, y, z) end
--
--Create new Point
--
--@param x number
--@param y number
--@param z number
--@return table point
Point = function(x, y, z) return point.new(x, y, z) end
--
--Create new Color
--
--@param r number
--@param g number
--@param b number
--@param a number
--@return table color
Color = function(r, g, b, a) return color.new(r, g, b, a) end

--
--Normalize a vector
--
--@param v table # Vector to be normalized
--@return table vector
Normalize = function(v) return normalize(v) end
--
--Get magnitude (length) of a vector
--
--@param v table # Vector
--@return number magnitude
Magnitude = function(v) return magnitude(v) end
--
--Dot Product of two vectors
--
--@param a table # Vector
--@param b table # Vector
--@return number dotproduct
Dot = function(a, b) return dotProduct(a, b) end
--
--Cross Product of two vectors
--
--@param a table # Vector
--@param b table # Vector
--@return number crossproduct
Cross = function(a, b) return crossProduct(a, b) end
--
--Sum of vector values
--
--@param v table # Vector
--@return number sum
Sum = function(v) return sumVector(v) end
