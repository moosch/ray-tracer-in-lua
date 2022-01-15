require("tools/tuple")

local function projectile(position, velocity)
  return {
    position = position,
    velocity = velocity,
  }
end

local function environment(gravity, wind)
  return {
    gravity = gravity,
    wind = wind,
  }
end


local function tick(env, proj)
  local position = proj.position + proj.velocity
  local velocity = proj.velocity + env.gravity + env.wind
  return projectile(position, velocity)
end

-- gravity -0.1 unit/tick, and wind is -0.01 unit/tick.
local e = environment(Vector(0, -0.1, 0), Vector(-0.01, 0, 0))

-- projectile starts one unit above the origin.
-- velocity is normalized to 1 unit/tick.
local p = projectile(Point(0, 1, 0), Normalize(Vector(1, 1, 0)))

while p.position.y >= 0 do
  p = tick(e, p)
  print(p.position)
end
