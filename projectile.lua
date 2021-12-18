require("tools/tuple_utilities")
point = require("tools/point")
vector = require("tools/vector")

function projectile(position, velocity)
  return {
    position = position,
    velocity = velocity,
  }
end

function environment(gravity, wind)
  return {
    gravity = gravity,
    wind = wind,
  }
end


function tick(env, proj)
  local position = Tuple.add(proj.position, proj.velocity)
  local velocity = Tuple.add(Tuple.add(proj.velocity, env.gravity), env.wind)
  print("Position: {x="..tostring(position.x)..", y="..tostring(position.y)..", z="..tostring(position.z)..", w="..tostring(position.w).."}")
  return projectile(position, Tuple.normalize(velocity))
end

-- gravity -0.1 unit/tick, and wind is -0.01 unit/tick.
e = environment(vector(0, -0.1, 0), vector(-0.01, 0, 0))
-- projectile starts one unit above the origin.
-- velocity is normalized to 1 unit/tick.
p = projectile(point(0, 1, 0), Tuple.normalize(vector(1, 1, 0)))
