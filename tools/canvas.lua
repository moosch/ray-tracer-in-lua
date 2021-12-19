local color = require("tools/color")

local function generateBlankPixel(x, y)
   return {x = x, y = y, color = color(0, 0, 0)}
end

local function canvas(width, height)
   -- Multidimensional table to hold pixels
   local rows = {}
   for i=1, width, 1 do
      rows[i] = {}
      for j=1, height, 1 do
         rows[i][j] = generateBlankPixel(i, j)
      end
   end

   return { width = width, height = height, rows = rows}
end

return canvas
