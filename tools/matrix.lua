--[[
A Matrix is a table with additional metatable methods.
--]]

--
--Get the value at a given row/column coordinate
--To access a position, use `myMatrix.at(0, 2)`
--
--@param matrix table # A matrix
--@param row number # Row position
--@param col number # Column position
--@return number value
local function at(matrix, row, col)
  local row = rawget(matrix, row+1)
  return rawget(row, col+1)
end

local function equal(a, b)
  return table.concat(a) == table.concat(b)
end

local function eq(a, b)
  if #a ~= #b then return false end
  if a.type ~= b.type then return false end

  for i=1, #a, 1 do
    if equal(rawget(a, i), rawget(b, i)) == false then
      return false
    end
  end

  return true
end

local function mul(a, b)
  -- If Matrix is stored as flat list:
  -- local size = a.size
  -- local rowStart = size*(n-1)+1
  -- local colStart = math.ceil(((n/size) % 1) * size)
  -- row = i+rowStart-1
  -- col = colStart*i

  -- For each cell in the matrix, find the dot product of the cell's row and column Tuples
  -- Then sum those results
  local m = a
  local s = a.size

  for r = 1, s, 1 do
    local row = {}
    for c = 1, s, 1 do
      -- Boo, this should scale to any sized matrix
      row[c] = a.at(r-1, 0) * b.at(0, c-1) +
        a.at(r-1, 1) * b.at(1, c-1) +
        a.at(r-1, 2) * b.at(2, c-1) +
        a.at(r-1, 3) * b.at(3, c-1)
    end
    m[r] = row
  end

  return m
end

--
--Create a new matrix. Basically just runs checks on a multidimensional table.
--A matrix must have equal number of columns and rows, and not be empty.
--
--@param t table # The matrix candidate
--@return table matrix
local function new(t)
  assert(type(t), "table", "matrix must be a table")
  assert(#t == #t[1], "matrix must be a square. As in 2x2, 3x3, 4x4 etc.")

  local mt = {}
  mt.__index = {
    at = function(row, col) return at(t, row, col) end,
    type = "matrix",
    size = #t,
  }
  mt.__eq = eq
  mt.__mul = function(a, b) return new(mul(a, b)) end

  setmetatable(t, mt)
  return t
end

return new
