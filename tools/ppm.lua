require("math")

local maxLineLength = 70
local maxColorVal = 255

--
--Build PPM file header from canvas
--
--@param width number # Canvas width
--@param height number # Canvas height
--@return string header
local function buildPPMHeader(width, height)
  local header = {
    "P3\n",
    tostring(width),
    " ",
    tostring(height),
    "\n",
    tostring(maxColorVal)
  }
  return table.concat(header)
end

--
--Expands lists of color strings to strings of colors with a max column wrap.
--
--@param canvas table # Canvas
--@param colorsList table # List of color strings
--@return string ppm
local function canvasPPMDataString(canvas)
  local buffer = {}
  local width = canvas.width-1
  local height = canvas.height-1

  local x = 1 -- Keep track of x position while moving through pixel table
  local col = 0 -- Keep track of file column to wrap on MaxLineLength

  for i, pixel in ipairs(canvas.pixels) do
    local colorList = pixel:rgbStringList()

    for c = 1, #colorList, 1 do
      local colorLen = string.len(colorList[c])
      if (col + colorLen + 1) >= maxLineLength then
        buffer[#buffer+1] = "\n"
        col = 0
      end
      if col > 0 then
        buffer[#buffer+1] = " "
        col = col + 1
      end
      col = col + colorLen
      buffer[#buffer+1] = colorList[c]
    end

     -- reset x as starting a new canvas row
    if x > width then
      x = 0
      col = 0
      buffer[#buffer+1] = "\n"
    end
    x = x + 1
  end

  return table.concat(buffer)
end


--
--Builds PPM file data from Canvas table
--
--@param canvas table # Canvas
--@return string ppm
local function buildPPM(canvas)
  local res = {
    buildPPMHeader(canvas.width, canvas.height),
    "\n",
    canvasPPMDataString(canvas),
    "\n"
  }
  return table.concat(res)
end

return buildPPM

