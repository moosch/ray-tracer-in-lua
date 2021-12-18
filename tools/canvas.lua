local color = require("tools/color")

local function canvas(width, height)
   -- Multidimensional table to hold pixels
   local pixels = {}
   for i=1, width do
      for j=1, height do
	 pixels[i] = {
	    x = i,
	    y = j,
	    color = color(0, 0, 0)
	 }
      end
   end

   return { width = width, height = height, pixels = pixels}
end

return canvas
