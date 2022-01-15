require("tools/tuple")

local canvas = {}

local function pixelIdxFromPos(x, y, width) return (x + y * width) + 1 end

-- Mutates matrix in place
local function updatePixel(c, x, y, color)
  if c.pixels[pixelIdxFromPos(x, y, c.width)] ~= nil then
    c.pixels[pixelIdxFromPos(x, y, c.width)] = color
  end
  return c
end

local function pixelAt(c, x, y)
  return c.pixels[pixelIdxFromPos(x, y, c.width)]
end

canvas.new = function(width, height, initialColor)
  local c = {}
  local color = initialColor or Color(0, 0, 0)
  local pixels = {}
  for i = 1, width * height, 1 do
    table.insert(pixels, i, color)
  end

  c.width = width
  c.height = height
  c.pixels = pixels

  function c:pixelAt(x, y) return pixelAt(self, x, y) end
  function c:updatePixel(x, y, color) return updatePixel(self, x, y, color) end

  return c
end

return function(width, height, initialColor) return canvas.new(width, height, initialColor) end
