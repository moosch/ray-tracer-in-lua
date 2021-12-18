local lu = require("libs/luaunit")
local point = require("tools/point")

local function testPointTuple()
  local t = point(4.3, -4.2, 3.1)
  lu.assertEquals(t.x, 4.3)
  lu.assertEquals(t.y, -4.2)
  lu.assertEquals(t.z, 3.1)
  lu.assertEquals(t.w, 1.0)
  lu.assertEquals(t:type(), "point")
  lu.assertNotEquals(t:type(), "vector")
end

testPointTuple()

os.exit(lu.LuaUnit.run())
