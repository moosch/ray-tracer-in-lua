require("math")
require("tools/tuple_utilities")

local lu = require("libs/luaunit")
local tuple = require("tools/tuple")
local point = require("tools/point")
local vector = require("tools/vector")
local color = require("tools/color")

function testAddingTwoTuples()
  local t1 = tuple(3, -2, 5, 1)
  local t2 = tuple(-2, 3, 1, 0)
  local act = Tuple.add(t1, t2)
  lu.assertIsTrue(Tuple.equal(act, tuple(1, 1, 6, 1)))
end

function testSubtractingTwoTuples()
  local t1 = tuple(3, 2, 1, 1)
  local t2 = tuple(5, 6, 7, 0)
  local act = Tuple.subtract(t1, t2)
  lu.assertIsTrue(Tuple.equal(act, tuple(-2, -4, -6, 1)))
end

function testSubtractPointFromPoint()
  local p1 = point(3, 2, 1)
  local p2 = point(5, 6, 7)
  local act = Tuple.subtract(p1, p2)
  lu.assertIsTrue(Tuple.equal(act, vector(-2, -4, -6)))
end

function testSubtractVectorFromPoint()
  local p = point(3, 2, 1)
  local v = vector(5, 6, 7)
  local act = Tuple.subtract(p, v)
  lu.assertIsTrue(Tuple.equal(act, point(-2, -4, -6)))
end

function testSubtractVectorFromVector()
  local v1 = vector(3, 2, 1)
  local v2 = vector(5, 6, 7)
  local act = Tuple.subtract(v1, v2)
  lu.assertIsTrue(Tuple.equal(act, vector(-2, -4, -6)))
end

function testSubtractingVectorFromZeroVector()
  local v1 = vector(0, 0, 0)
  local v2 = vector(1, -2, 3)
  local act = Tuple.subtract(v1, v2)
  lu.assertIsTrue(Tuple.equal(act, vector(-1, 2, -3)))
end

function testNegateTuple()
  local t = tuple(1, -2, 3, -4)
  local act = Tuple.negate(t)
  lu.assertIsTrue(Tuple.equal(act, tuple(-1, 2, -3, 4)))
end

function testScaleTuple()
  local t = tuple(1, -2, 3, -4)
  local act = Tuple.scale(t, 3.5)
  lu.assertIsTrue(Tuple.equal(act, tuple(3.5, -7, 10.5, -14)))
end

function testScaleTupleByFraction()
  local t = tuple(1, -2, 3, -4)
  local act = Tuple.scale(t, 0.5)
  lu.assertIsTrue(Tuple.equal(act, tuple(0.5, -1, 1.5, -2)))
end

function testDivideTuple()
  local t = tuple(1, -2, 3, -4)
  local act = Tuple.divide(t, 2)
  lu.assertIsTrue(Tuple.equal(act, tuple(0.5, -1, 1.5, -2)))
end

function testVectorMagnitude()
  local v1 = vector(1, 0, 0)
  local v2 = vector(0, 1, 0)
  local v3 = vector(0, 0, 1)
  local v4 = vector(1, 2, 3)
  local v5 = vector(-1, -2, -3)
  lu.assertEquals(Tuple.magnitude(v1), 1)
  lu.assertEquals(Tuple.magnitude(v2), 1)
  lu.assertEquals(Tuple.magnitude(v3), 1)
  lu.assertEquals(Tuple.magnitude(v4), math.sqrt(14))
  lu.assertEquals(Tuple.magnitude(v5), math.sqrt(14))
end

function testVectorNormalizing()
  local v1 = vector(4, 0, 0)
  local act1 = Tuple.normalize(v1)
  lu.assertIsTrue(Tuple.equal(act1, vector(1, 0, 0)))
  local v2 = vector(1, 2, 3)
  local act2 = Tuple.normalize(v2)
  lu.assertIsTrue(Tuple.equal(act2, vector(0.26726124191242, 0.53452248382485, 0.80178372573727)))
end

function testDotProductOfTwoVectors()
  local v1 = vector(1, 2, 3)
  local v2 = vector(2, 3, 4)
  lu.assertEquals(Tuple.dot(v1, v2), 20)
end

function testCrossProductOfTwoVectors()
  local v1 = vector(1, 2, 3)
  local v2 = vector(2, 3, 4)
  lu.assertIsTrue(Tuple.equal(Tuple.cross(v1, v2), vector(-1, 2, -1)))
  lu.assertIsTrue(Tuple.equal(Tuple.cross(v2, v1), vector(1, -2, 1)))
end


-- Colors

function testIsColor()
  local c = color(-0.1, 0.4, 1.7)
  lu.assertEquals(Tuple.type(c), "color")
end

function testAddColors()
   local c1 = color(0.9, 0.6, 0.75)
   local c2 = color(0.7, 0.1, 0.25)
   local act = Tuple.add(c1, c2)
   lu.assertIsTrue(Tuple.equal(act, color(1.6, 0.7, 1.0)))
end

function testSubtractColors()
   local c1 = color(0.9, 0.6, 0.75)
   local c2 = color(0.7, 0.1, 0.25)
   local act = Tuple.subtract(c1, c2)
   lu.assertIsTrue(Tuple.equal(act, color(0.2, 0.5, 0.5)))
end

function testMultiplyColorByScalar()
   local c = color(0.2, 0.3, 0.4)
   local act = Tuple.scale(c, 2)
   lu.assertIsTrue(Tuple.equal(act, color(0.4, 0.6, .8)))
end

function testMultiplyColorByColor()
   local c1 = color(1, 0.2, 0.4)
   local c2 = color(0.9, 1, 0.1)
   local act = Tuple.multiply(c1, c2)
   lu.assertIsTrue(Tuple.equal(act, color(0.9, 0.2, 0.04)))
end


os.exit(lu.LuaUnit.run())
