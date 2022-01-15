require("math")
require("tools/tuple")
local Canvas = require("tools/canvas")
local buildPPM = require("tools/ppm")

local white = Color(1, 1, 1)

local function projectile(position, velocity)
  return {
    position = position,
    velocity = velocity,
  }
end

local function environment(g, w)
  return {
    gravity = g,
    wind = w,
  }
end

local function updateCanvas(canvas, pos)
  canvas:updatePixel(math.ceil(pos.x), canvas.height - math.ceil(pos.y), white)
  return canvas
end


local function tick(canvas, env, proj)
   local position = proj.position + proj.velocity
   local velocity = proj.velocity + env.gravity + env.wind
   canvas = updateCanvas(canvas, position)
   print(tostring(position))
  return canvas, projectile(position, velocity)
end

local p = projectile(Point(0, 1, 0), Normalize(Vector(1, 1.8, 0)) * 11.25)
local gravity = Vector(0, -0.1, 0)
local wind = Vector(-0.01, 0, 0)
local e = environment(gravity, wind)
local c = Canvas(900, 500)

while p.position.y > 0.0 do
  c, p = tick(c, e, p)
end

local ppm = buildPPM(c)

file = io.open("./projectile.ppm", "w+")
print("saving ppm file...")
file:write(ppm)
file:close()
print("done")
