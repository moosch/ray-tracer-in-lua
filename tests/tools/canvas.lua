local canvas = require("tools/canvas")
local lu = require("libs/luaunit")


local function createCanvas()
   local c = canvas(10, 20)
   lu.assertEquals(c.width, 10)
   lu.assertEquals(c.height, 20)
end


createCanvas()

os.exit(lu.LuaUnit.run())
