local lu = require("libs/luaunit")
local Matrix = require("tools/matrix")

function testConstructingAndInspecting4by4Matrix()
  local m = Matrix({
      {1, 2, 3, 4},
      {5.5, 6.5, 7.5, 8.5},
      {9, 10, 11, 12},
      {13.5, 14.5, 15.5, 16.5},
  })

  lu.assertEquals(m.at(0, 0), 1)
  lu.assertEquals(m.at(0, 3), 4)
  lu.assertEquals(m.at(1, 0), 5.5)
  lu.assertEquals(m.at(1, 2), 7.5)
  lu.assertEquals(m.at(2, 2), 11)
  lu.assertEquals(m.at(3, 0), 13.5)
  lu.assertEquals(m.at(3, 2), 15.5)
end

function testVariousMatricesSizes()
  local m2 = Matrix({
      {-3, 5},
      {1, -2},
  })

  lu.assertEquals(m2.at(0, 0), -3)
  lu.assertEquals(m2.at(0, 1), 5)
  lu.assertEquals(m2.at(1, 0), 1)
  lu.assertEquals(m2.at(1, 1), -2)

  local m3 = Matrix({
      {-3, 5, 0},
      {1, -2, -7},
      {0, 1, 1},
  })

  lu.assertEquals(m3.at(0, 0), -3)
  lu.assertEquals(m3.at(1, 1), -2)
  lu.assertEquals(m3.at(2, 2), 1)
end

os.exit(lu.LuaUnit.run())
