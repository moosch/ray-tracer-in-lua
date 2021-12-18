local tuple = require("tools/tuple")

local function point(x, y, z)
  return tuple(x, y, z, 1.0)
end

return point
