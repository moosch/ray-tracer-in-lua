require("math")
local Canvas = require("tools/canvas")
local buildPPM = require("tools/ppm")
require("tools/matrix")
require("tools/tuple")

local width = 500
local height = 500

local color = Color(1, 1, 1)

local canvas = Canvas(width, height)

local twelve = Point(0, 1, 0)
local angle = math.pi/6
local origin = Point(width/2, height/2, 0)

local scaleFactor = width * 3/8
local scale = Scaling(scaleFactor, scaleFactor, 0)
local translate = Translation(origin.x, origin.y, origin.z)

-- For each hour
for hour=1, 12 do
   local rotation = RotationZ(hour * angle)
   local h = translate * (scale * (rotation * twelve))
   print(h)
   canvas:updatePixel(math.ceil(h.x), math.ceil(h.y),  color)
end


local ppm = buildPPM(canvas)

file = io.open("./clock.ppm", "w+")
print("saving ppm file...")
file:write(ppm)
file:close()
print("done")
