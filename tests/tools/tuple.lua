require("math")
local lu = require("libs/luaunit")
require("tools/tuple")

--[[
  Tuples
--]]
function testIsTuple()
  local t = Tuple(3, -2, 5, 1)
  lu.assertIsTrue(t.type == "tuple")
end

function testAddTuples()
  local t1 = Tuple(3, -2, 5, 1)
  local t2 = Tuple(-2, 3, 1, 0)
  local actual = t1 + t2
  lu.assertIsTrue(actual == Tuple(1, 1, 6, 1))
end

function testMultiplyTupleByScalar()
  local t = Tuple(1, -2, 3, -4)
  local act = t * 3.5
  lu.assertIsTrue(act == Tuple(3.5, -7, 10.5, -14))
end

function testMultiplyTupleByFraction()
  local t = Tuple(1, -2, 3, -4)
  local act = t * 0.5
  lu.assertIsTrue(act == Tuple(0.5, -1, 1.5, -2))
end

function testDivideTupleByScalar()
  local t = Tuple(1, -2, 3, -4)
  local act = t / 2
  lu.assertIsTrue(act == Tuple(0.5, -1, 1.5, -2))
end


--[[
  Vectors
--]]
function testIsVector()
  local v = Vector(3, -2, 5)
  lu.assertIsTrue(v.type == "vector")
end

function testAddNumberToVector()
  local v = Vector(3, -2, 5)
  local act = v + 2
  lu.assertIsTrue(act == Vector(5, 0, 7))
end
function testAddTwoVectors()
  local v1 = Vector(3, -2, 5)
  local v2 = Vector(-2, 3, 1)
  local act = v1 + v2
  lu.assertIsTrue(act == Vector(1, 1, 6))
end

function testSubtractNumberFromVector()
  local v = Vector(3, 2, 1)
  local act = v - 2
  lu.assertIsTrue(act == Vector(1, 0, -1))
end
function testSubtractTwoVectors()
  local v1 = Vector(3, 2, 1)
  local v2 = Vector(5, 6, 7)
  local act = v1 - v2
  lu.assertIsTrue(act == Vector(-2, -4, -6))
end
function testSubtractingVectorFromZeroVector()
  local v1 = Vector(0, 0, 0)
  local v2 = Vector(1, -2, 3)
  local act = v1 - v2
  lu.assertIsTrue(act == Vector(-1, 2, -3))
end

function testMultiplyVectorByNumber()
  local v = Vector(1, -2, 3)
  local act = v * 3.5
  lu.assertIsTrue(act == Vector(3.5, -7, 10.5))
end
function testMultiplyVectorByFraction()
  local v = Vector(1, -2, 3)
  local act = v * 0.5
  lu.assertIsTrue(act == Vector(0.5, -1, 1.5))
end
function testMultuiplyVectorByVector()
  local v1 = Vector(1, -2, 3)
  local v2 = Vector(1, -2, 3)
  local act = v1 * v2
  lu.assertIsTrue(act == Vector(1, 4, 9))
end

function testDivideVectorByNumber()
  local v = Vector(1, -2, 3)
  local act = v / 2
  lu.assertIsTrue(act == Vector(0.5, -1, 1.5))
end
function testDivideVectorByVector()
  local v1 = Vector(2, -2, 3)
  local v2 = Vector(4, 2, 10)
  local act = v1 / v2
  lu.assertIsTrue(act == Vector(0.5, -1, 0.3))
end

function testNegateVector()
  local v = Vector(1, -2, 3)
  local act = -v
  lu.assertIsTrue(act == Vector(-1, 2, -3))
end

function testVectorMagnitude()
  local v1 = Vector(1, 0, 0)
  local v2 = Vector(0, 1, 0)
  local v3 = Vector(0, 0, 1)
  local v4 = Vector(1, 2, 3)
  local v5 = Vector(-1, -2, -3)
  lu.assertEquals(Magnitude(v1), 1)
  lu.assertEquals(Magnitude(v2), 1)
  lu.assertEquals(Magnitude(v3), 1)
  lu.assertEquals(Magnitude(v4), math.sqrt(14))
  lu.assertEquals(Magnitude(v5), math.sqrt(14))
end

function testVectorNormalizing()
  local v1 = Vector(4, 0, 0)
  local act1 = Normalize(v1)
  lu.assertIsTrue(act1 == Vector(1, 0, 0))
  local v2 = Vector(1, 2, 3)
  local act2 = Normalize(v2)
  lu.assertIsTrue(act2 == Vector(0.26726124191242, 0.53452248382485, 0.80178372573727))
end

function testDotProductOfTwoVectors()
  local v1 = Vector(1, 2, 3)
  local v2 = Vector(2, 3, 4)
  lu.assertEquals(Dot(v1, v2), 20)
end

function testCrossProductOfTwoVectors()
  local v1 = Vector(1, 2, 3)
  local v2 = Vector(2, 3, 4)
  lu.assertIsTrue(Vector(-1, 2, -1) == Cross(v1, v2))
  lu.assertIsTrue(Vector(1, -2, 1) == Cross(v2, v1))
end


--[[
  Points
--]]
function testIsPoint()
  local p = Point(3, -2, 5)
  lu.assertIsTrue(p.type == "point")
end

function testAddNumberToPoint()
  local p = Point(3, -2, 5)
  local act = p + 2
  lu.assertIsTrue(act == Point(5, 0, 7))
end

function testAddPointToVector()
  local p = Point(3, -2, 5)
  local v = Vector(-2, 3, 1)
  local act = p + v
  lu.assertIsTrue(act == Point(1, 1, 6))
end

function testSubtractNumberFromPoint()
  local p = Point(3, 2, 1)
  local act = p - 2
  lu.assertIsTrue(act == Point(1, 0, -1))
end
function testSubtractTwoPoints()
  local p1 = Point(3, 2, 1)
  local p2 = Point(5, 6, 7)
  local act = p1 - p2
  lu.assertIsTrue(act == Vector(-2, -4, -6))
end
function testSubtractingPointFromZeroPoint()
  local p1 = Point(0, 0, 0)
  local p2 = Point(1, -2, 3)
  local act = p1 - p2
  lu.assertIsTrue(act == Vector(-1, 2, -3))
end
function testSubtractVectorFromPoint()
  local p = Point(3, 2, 1)
  local v = Vector(5, 6, 7)
  local act = p - v
  lu.assertIsTrue(act == Point(-2, -4, -6))
end

function testMultiplyPointByNumber()
  local p = Point(1, -2, 3)
  local act = p * 3.5
  lu.assertIsTrue(act == Tuple(3.5, -7, 10.5, 3.5))
end

function testNegatePoint()
  local p = Point(1, -2, 3)
  local act = -p
  lu.assertIsTrue(act == Point(-1, 2, -3))
end


--[[
  Colors
--]]
function testIsColor()
  local c = Color(-0.1, 0.4, 1.7)
  lu.assertIsTrue(c.type == "color")
end

function testAddColors()
   local c1 = Color(0.9, 0.6, 0.75)
   local c2 = Color(0.7, 0.1, 0.25)
   local act = c1 + c2
   lu.assertIsTrue(act == Color(1.6, 0.7, 1.0))
end

function testSubtractColors()
   local c1 = Color(0.9, 0.6, 0.75)
   local c2 = Color(0.7, 0.1, 0.25)
   local act = c1 - c2
   lu.assertIsTrue(act == Color(0.2, 0.5, 0.5))
end

function testMultiplyColorByScalar()
   local c = Color(0.2, 0.3, 0.4)
   local act = c * 2
   lu.assertIsTrue(act == Color(0.4, 0.6, 0.8))
end

function testMultiplyColorByColor()
   local c1 = Color(1, 0.2, 0.4)
   local c2 = Color(0.9, 1, 0.1)
   local act = c1 * c2
   lu.assertIsTrue(act == Color(0.9, 0.2, 0.04))
end


os.exit(lu.LuaUnit.run())
