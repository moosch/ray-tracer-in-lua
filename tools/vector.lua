local tuple = require("tools/tuple")

local function vector(x, y, z)
  return tuple(x, y, z, 0.0)
end

return vector
