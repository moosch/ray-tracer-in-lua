local lu = require("libs/luaunit")
require("tools/tuple")
require("tools/ray")

function testCreatingAndQueryingRay()
  local origin = Point(1, 2, 3)
  local direction = Vector(4, 5, 6)
  local r = Ray(origin, direction)

  lu.assertEquals(r.origin, origin)
  lu.assertEquals(r.direction, direction)
end

function testComputingPointFromDistance()
  local r = Ray(Point(2, 3, 4), Vector(1, 0, 0))

  lu.assertEquals(r:position(0), Point(2, 3, 4))
  lu.assertEquals(r:position(1), Point(3, 3, 4))
  lu.assertEquals(r:position(-1), Point(1, 3, 4))
  lu.assertEquals(r:position(2.5), Point(4.5, 3, 4))
end

os.exit(lu.LuaUnit.run())
