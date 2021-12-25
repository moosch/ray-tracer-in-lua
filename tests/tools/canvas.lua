require("tools/canvas_utilities")
require("tools/string")
local canvas = require("tools/canvas")
local color = require("tools/color")
local lu = require("libs/luaunit")

function testCreateCanvas()
  local c = canvas(10, 20)
  lu.assertEquals(c.width, 10)
  lu.assertEquals(c.height, 20)
  for _i, row in pairs(c.matrix) do
    for _j, pixel in pairs(row) do
      lu.assertEquals(pixel.color, color(0,0,0))
    end
  end
end

function testWritingPixelToCanvas()
  local c = canvas(10, 20)
  local red = color(1, 0, 0)
  Canvas.writePixel(c, 2, 3, red)
  lu.assertEquals(Canvas.pixelAt(c, 2, 3).color, red)
end

function testCanvasToPPM()
  local c = canvas(5, 3)
  local ppm = Canvas.buildPPM(c)
  local ppmList = String.split(ppm, "\n")
  lu.assertEquals(ppmList[1], "P3")
  lu.assertEquals(ppmList[2], "5 3")
  lu.assertEquals(ppmList[3], "255")
end

function testConstructPPMData()
   local c = canvas(5, 3)
   local c1 = color(1.5, 0, 0)
   local c2 = color(0, 0.5, 0)
   local c3 = color(-0.5, 0, 1)
   Canvas.writePixel(c, 0, 0, c1)
   Canvas.writePixel(c, 2, 1, c2)
   Canvas.writePixel(c, 4, 2, c3)
   local ppm = Canvas.buildPPM(c)
   local ppmList = String.split(ppm, "\n")
   lu.assertEquals(ppmList[4], "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0")
   lu.assertEquals(ppmList[5], "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0")
   lu.assertEquals(ppmList[6], "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255")
end

function testSplittingLongPPMLines()
   local c = canvas(10, 2, color(1, 0.8, 0.6))
   local ppm = Canvas.buildPPM(c)
   local ppmList = String.split(ppm, "\n")
   lu.assertEquals(ppmList[4], "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204")
   lu.assertEquals(ppmList[5], "153 255 204 153 255 204 153 255 204 153 255 204 153")
   lu.assertEquals(ppmList[6], "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204")
   lu.assertEquals(ppmList[7], "153 255 204 153 255 204 153 255 204 153 255 204 153")
end

function testPPMTerminatedByNewline()
   local c = canvas(5, 3)
   local ppm = Canvas.buildPPM(c)
   lu.assertEquals(string.sub(ppm, -1), "\n")
end

function testSplittingLongPPMLines()
   local c = canvas(10, 2)

 end

os.exit(lu.LuaUnit.run())
