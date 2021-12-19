local canvas = require("tools/canvas")
local color = require("tools/color")
local lu = require("libs/luaunit")

function testCreateCanvas()
   local c = canvas(10, 20)
   lu.assertEquals(c.width, 10)
   lu.assertEquals(c.height, 20)
   for _i, row in pairs(c.rows) do
      for _j, pixel in pairs(row) do
         lu.assertEquals(pixel.color, color(0,0,0))
      end
   end
end


os.exit(lu.LuaUnit.run())
