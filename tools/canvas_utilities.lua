require("tools/table")
require("tools/string")

-- Mutates matrix in place
local function writePixel(c, x, y, color)
  -- x & y are reversed as x looks for column in row of matrix
  c.matrix[y+1][x+1].color = color
end

local function pixelAt(c, x, y)
  -- x & y are reversed as x looks for column in row of matrix
  return c.matrix[y+1][x+1]
end

local function colorToRGB(color)
  local v = color * 255
  if v > 255 then v = 255 end
  if v < 0 then v = 0 end
  return math.ceil(v)
end

local function formatForLength(str)
  if string.len(str) <= 70 then return str end

  -- go through each int, accumulating string lengths (plus trailing space)
  -- at <=70 split from index and repeat on remainder.
  local strList = String.split(str, " ")
  local newStr = ""
  local accum = 0 -- accumulator for tracking line lengths
  for i = 1, #strList, 1 do
     local nextLen = string.len(strList[i]) + 1 -- +1 for space
     if (accum + nextLen) >= 70 then -- add linebreak
        newStr = newStr.."\n"..strList[i]
        accum = nextLen - 1 -- start of new line
     else
        if newStr == "" then
           newStr = strList[i]
           accum = nextLen - 1
        else
           newStr = newStr.." "..strList[i]
           accum = accum + nextLen -- keep the 1 for the space
        end
     end
  end
  return newStr
end

local function buildPPM(c)
   local ppm = "P3\n"..tostring(c.width).." "..tostring(c.height).."\n255\n"
   for _i, row in pairs(c.matrix) do
    local rowStr
    for _j, pixel in pairs(row) do
      local colors = Table.map(pixel.color, colorToRGB)
      if rowStr == nil then
        rowStr = Table.join(colors, " ")
      else
        rowStr = rowStr.." "..Table.join(colors, " ")
      end
    end
    rowStr = formatForLength(rowStr)
    ppm = ppm..rowStr.."\n"
   end
  return ppm
end

Canvas = {
  writePixel = writePixel,
  pixelAt = pixelAt,
  buildPPM = buildPPM,
}

return Canvas
