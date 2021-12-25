local colorTuple = require("tools/color")

local function buildPixel(x, y, color)
   if color == nil then color = colorTuple(0, 0, 0) end
   return {x = x, y = y, color = color}
end

local function canvas(width, height, color)
  --[[
  Multidimensional table to hold pixels
  Built as a list of rows (x-axis) containing columns (y-axis) of pixels
  Finding elemnts using x (column#) and y (row#) in matrix
  ]]--
  local matrix = {}
  for i=1, height, 1 do
    matrix[i] = {} -- row
    for j=1, width, 1 do
      matrix[i][j] = buildPixel(i, j, color)
    end
  end

  return { width = width, height = height, matrix = matrix}
end

return canvas
