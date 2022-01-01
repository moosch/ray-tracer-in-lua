local Canvas = require("tools/canvas")
local buildPPM = require("tools/ppm")
local String = require("tools/string")
local Tuple = require("tools/tuple")
local lu = require("libs/luaunit")

function testCreateCanvas()
  local c = Canvas(10, 20)
  local black = Tuple.color(0, 0, 0)

  lu.assertEquals(c.width, 10)
  lu.assertEquals(c.height, 20)
  for _, pixel in pairs(c.pixels) do
    lu.assertIsTrue(pixel == black)
  end
end

function testWritingPixelToCanvas()
  local c = Canvas(10, 20)
  local red = Tuple.color(1, 0, 0)
  c:updatePixel(0, 0, red)
  c:updatePixel(2, 3, red)

  lu.assertEquals(c:pixelAt(0, 0), red)
  lu.assertEquals(c:pixelAt(2, 3), red)
end

function testConstructPPMData()
   local c = Canvas(5, 3)
   local c1 = Tuple.color(1.5, 0, 0)
   local c2 = Tuple.color(0, 0.5, 0)
   local c3 = Tuple.color(-0.5, 0, 1)
   c:updatePixel(0, 0, c1)
   c:updatePixel(2, 1, c2)
   c:updatePixel(4, 2, c3)
   local ppm = buildPPM(c)
   local ppmList = String.split(ppm, "\n")

   lu.assertEquals(ppmList[1], "P3")
   lu.assertEquals(ppmList[2], "5 3")
   lu.assertEquals(ppmList[3], "255")
   lu.assertEquals(ppmList[4], "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0")
   lu.assertEquals(ppmList[5], "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0")
   lu.assertEquals(ppmList[6], "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255")
end

function testSplittingLongPPMLines()
   local c = Canvas(10, 2, Tuple.color(1, 0.8, 0.6))
   local ppm = buildPPM(c)
   local ppmList = String.split(ppm, "\n")

   lu.assertEquals(ppmList[4], "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204")
   lu.assertEquals(ppmList[5], "153 255 204 153 255 204 153 255 204 153 255 204 153")
   lu.assertEquals(ppmList[6], "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204")
   lu.assertEquals(ppmList[7], "153 255 204 153 255 204 153 255 204 153 255 204 153")
end

function testPPMTerminatedByNewline()
   local c = Canvas(5, 3)
   local ppm = buildPPM(c)

   lu.assertEquals(string.sub(ppm, -1), "\n")
end


os.exit(lu.LuaUnit.run())
