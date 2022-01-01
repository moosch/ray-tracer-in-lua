require("math")
local lu = require("libs/luaunit")
local Tuple = require("tools/tuple")

--[[
  Vectors
--]]
function testIsVector()
  local v = Tuple.vector(3, -2, 5)
  lu.assertIsTrue(v.type == "vector")
end

function testAddNumberToVector()
  local v = Tuple.vector(3, -2, 5)
  local act = v + 2
  lu.assertIsTrue(act == Tuple.vector(5, 0, 7))
end
function testAddTwoVectors()
  local v1 = Tuple.vector(3, -2, 5)
  local v2 = Tuple.vector(-2, 3, 1)
  local act = v1 + v2
  lu.assertIsTrue(act == Tuple.vector(1, 1, 6))
end

function testSubtractNumberFromVector()
  local v = Tuple.vector(3, 2, 1)
  local act = v - 2
  lu.assertIsTrue(act == Tuple.vector(1, 0, -1))
end
function testSubtractTwoVectors()
  local v1 = Tuple.vector(3, 2, 1)
  local v2 = Tuple.vector(5, 6, 7)
  local act = v1 - v2
  lu.assertIsTrue(act == Tuple.vector(-2, -4, -6))
end
function testSubtractingVectorFromZeroVector()
  local v1 = Tuple.vector(0, 0, 0)
  local v2 = Tuple.vector(1, -2, 3)
  local act = v1 - v2
  lu.assertIsTrue(act == Tuple.vector(-1, 2, -3))
end

function testMultiplyVectorByNumber()
  local v = Tuple.vector(1, -2, 3)
  local act = v * 3.5
  lu.assertIsTrue(act == Tuple.vector(3.5, -7, 10.5))
end
function testMultiplyVectorByFraction()
  local v = Tuple.vector(1, -2, 3)
  local act = v * 0.5
  lu.assertIsTrue(act == Tuple.vector(0.5, -1, 1.5))
end
function testMultuiplyVectorByVector()
  local v1 = Tuple.vector(1, -2, 3)
  local v2 = Tuple.vector(1, -2, 3)
  local act = v1 * v2
  lu.assertIsTrue(act == Tuple.vector(1, 4, 9))
end

function testDivideVectorByNumber()
  local v = Tuple.vector(1, -2, 3)
  local act = v / 2
  lu.assertIsTrue(act == Tuple.vector(0.5, -1, 1.5))
end
function testDivideVectorByVector()
  local v1 = Tuple.vector(2, -2, 3)
  local v2 = Tuple.vector(4, 2, 10)
  local act = v1 / v2
  lu.assertIsTrue(act == Tuple.vector(0.5, -1, 0.3))
end

function testNegateVector()
  local v = Tuple.vector(1, -2, 3)
  local act = -v
  lu.assertIsTrue(act == Tuple.vector(-1, 2, -3))
end

--[[
  Points
--]]
function testIsPoint()
  local p = Tuple.point(3, -2, 5)
  lu.assertIsTrue(p.type == "point")
end

function testAddNumberToPoint()
  local p = Tuple.point(3, -2, 5)
  local act = p + 2
  lu.assertIsTrue(act == Tuple.point(5, 0, 7))
end
function testAddTwoPoints()
  local p1 = Tuple.point(3, -2, 5)
  local p2 = Tuple.point(-2, 3, 1)
  local act = p1 + p2
  lu.assertIsTrue(act == Tuple.point(1, 1, 6))
end
function testAddPointToVector()
  local p1 = Tuple.point(3, -2, 5)
  local p2 = Tuple.point(-2, 3, 1)
  local act = p1 + p2
  lu.assertIsTrue(act == Tuple.vector(1, 1, 6))
end

function testSubtractNumberFromPoint()
  local p = Tuple.point(3, 2, 1)
  local act = p - 2
  lu.assertIsTrue(act == Tuple.point(1, 0, -1))
end
function testSubtractTwoPoints()
  local p1 = Tuple.point(3, 2, 1)
  local p2 = Tuple.point(5, 6, 7)
  local act = p1 - p2
  lu.assertIsTrue(act == Tuple.vector(-2, -4, -6))
end
function testSubtractingPointFromZeroPoint()
  local p1 = Tuple.point(0, 0, 0)
  local p2 = Tuple.point(1, -2, 3)
  local act = p1 - p2
  lu.assertIsTrue(act == Tuple.point(-1, 2, -3))
end
function testSubtractVectorFromPoint()
  local p = Tuple.point(3, 2, 1)
  local v = Tuple.vector(5, 6, 7)
  local act = p - v
  lu.assertIsTrue(act == Tuple.vector(-2, -4, -6))
end

function testMultiplyPointByNumber()
  local p = Tuple.point(1, -2, 3)
  local act = p * 3.5
  lu.assertIsTrue(act == Tuple.point(3.5, -7, 10.5))
end
function testMultiplyPointByFraction()
  local p = Tuple.point(1, -2, 3)
  local act = p * 0.5
  lu.assertIsTrue(act == Tuple.point(0.5, -1, 1.5))
end
function testMultuiplyTwoPoints()
  local p1 = Tuple.point(1, -2, 3)
  local p2 = Tuple.point(1, -2, 3)
  local act = p1 * p2
  lu.assertIsTrue(act == Tuple.point(1, 4, 9))
end

function testDividePointByNumber()
  local p = Tuple.point(1, -2, 3)
  local act = p / 2
  lu.assertIsTrue(act == Tuple.point(0.5, -1, 1.5))
end
function testDividePointByPoint()
  local p1 = Tuple.point(2, -2, 3)
  local p2 = Tuple.point(4, 2, 10)
  local act = p1 / p2
  lu.assertIsTrue(act == Tuple.point(0.5, -1, 0.3))
end

function testNegatePoint()
  local p = Tuple.point(1, -2, 3)
  local act = -p
  lu.assertIsTrue(act == Tuple.point(-1, 2, -3))
end

function testVectorMagnitude()
  local v1 = Tuple.vector(1, 0, 0)
  local v2 = Tuple.vector(0, 1, 0)
  local v3 = Tuple.vector(0, 0, 1)
  local v4 = Tuple.vector(1, 2, 3)
  local v5 = Tuple.vector(-1, -2, -3)
  lu.assertEquals(Tuple.magnitude(v1), 1)
  lu.assertEquals(Tuple.magnitude(v2), 1)
  lu.assertEquals(Tuple.magnitude(v3), 1)
  lu.assertEquals(Tuple.magnitude(v4), math.sqrt(14))
  lu.assertEquals(Tuple.magnitude(v5), math.sqrt(14))
end

function testVectorNormalizing()
  local v1 = Tuple.vector(4, 0, 0)
  local act1 = Tuple.normalize(v1)
  lu.assertIsTrue(act1 == Tuple.vector(1, 0, 0))
  local v2 = Tuple.vector(1, 2, 3)
  local act2 = Tuple.normalize(v2)
  lu.assertIsTrue(act2 == Tuple.vector(0.26726124191242, 0.53452248382485, 0.80178372573727))
end

function testDotProductOfTwoVectors()
  local v1 = Tuple.vector(1, 2, 3)
  local v2 = Tuple.vector(2, 3, 4)
  lu.assertEquals(Tuple.dot(v1, v2), 20)
end

function testCrossProductOfTwoVectors()
  local v1 = Tuple.vector(1, 2, 3)
  local v2 = Tuple.vector(2, 3, 4)
  lu.assertIsTrue(Tuple.vector(-1, 2, -1) == Tuple.cross(v1, v2))
  lu.assertIsTrue(Tuple.vector(1, -2, 1) == Tuple.cross(v2, v1))
end


--[[
  Colors
--]]
function testIsColor()
  local c = Tuple.color(-0.1, 0.4, 1.7)
  lu.assertIsTrue(c.type == "color")
end

function testAddColors()
   local c1 = Tuple.color(0.9, 0.6, 0.75)
   local c2 = Tuple.color(0.7, 0.1, 0.25)
   local act = c1 + c2
   lu.assertIsTrue(act == Tuple.color(1.6, 0.7, 1.0))
end

function testSubtractColors()
   local c1 = Tuple.color(0.9, 0.6, 0.75)
   local c2 = Tuple.color(0.7, 0.1, 0.25)
   local act = c1 - c2
   lu.assertIsTrue(act == Tuple.color(0.2, 0.5, 0.5))
end

function testMultiplyColorByScalar()
   local c = Tuple.color(0.2, 0.3, 0.4)
   local act = c * 2
   lu.assertIsTrue(act == Tuple.color(0.4, 0.6, 0.8))
end

function testMultiplyColorByColor()
   local c1 = Tuple.color(1, 0.2, 0.4)
   local c2 = Tuple.color(0.9, 1, 0.1)
   local act = c1 * c2
   lu.assertIsTrue(act == Tuple.color(0.9, 0.2, 0.04))
end


os.exit(lu.LuaUnit.run())

