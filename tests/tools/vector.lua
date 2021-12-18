local lu = require("libs/luaunit")
local vector = require("tools/vector")

function testVectorTuple()
  local t = vector(4.3, -4.2, 3.1)
  lu.assertEquals(t.x, 4.3)
  lu.assertEquals(t.y, -4.2)
  lu.assertEquals(t.z, 3.1)
  lu.assertEquals(t.w, 0.0)
  lu.assertEquals(t:type(), "vector")
  lu.assertNotEquals(t:type(), "point")
end

os.exit(lu.LuaUnit.run())
