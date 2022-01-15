--[[
A Matrix is a table with additional metatable methods.
--]]

require("tools/tuple")

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
  if a.type ~= "matrix" then return false end
  if b.type ~= "matrix" and b.type ~= "vector" then return false end

  -- If b is matrix
  -- If b is tuple/vector

  for i=1, #a, 1 do
    if equal(rawget(a, i), rawget(b, i)) == false then
      return false
    end
  end

  return true
end

local function mul(a, b)
  -- For each cell in the matrix, find the dot product of the cell's row and column Tuples
  -- Then sum those results
  local m = a
  local s = a.size

  for r = 1, s, 1 do
    local row = {}
    for c = 1, s, 1 do
      -- Boo! Better if this scales to any sized matrix
      row[c] = a.at(r-1, 0) * b.at(0, c-1) +
        a.at(r-1, 1) * b.at(1, c-1) +
        a.at(r-1, 2) * b.at(2, c-1) +
        a.at(r-1, 3) * b.at(3, c-1)
    end
    m[r] = row
  end

  return m
end

local function mulTuple(m, t)
  local res = {}
  for r = 1, m.size, 1 do
    local w = 1
    if t.w ~= nil then w = t.w end
    res[r] = m.at(r-1, 0) * t.x +
        m.at(r-1, 1) * t.y +
        m.at(r-1, 2) * t.z +
        m.at(r-1, 3) * w
  end
  return Tuple(res[1], res[2], res[3], res[4])
end

local function new(t)
  -- Default as identity matrix
  if t == nil then
    t = {
      {1, 0, 0, 0},
      {0, 1, 0, 0},
      {0, 0, 1, 0},
      {0, 0, 0, 1},
    }
  end

  local mt = {}
  mt.__index = {
    at = function(row, col) return at(t, row, col) end,
    type = "matrix",
    size = #t,
  }
  mt.__eq = eq
  mt.__mul = function(a, b)
    if b.type == "matrix" then
      return new(mul(a, b))
    end
    if b.type == "tuple" then
      return mulTuple(a, b)
    end
    return a
  end

  setmetatable(t, mt)
  return t
end

local function diagonal(n)
  return new({
      {n, 0, 0, 0},
      {0, n, 0, 0},
      {0, 0, n, 0},
      {0, 0, 0, n},
  })
end

local function transpose(m)
  -- Columns turn into rows
  local s = m.size
  local matrix = {}
  for r = 1, s, 1 do
    for c = 1, s, 1 do
      if matrix[c] == nil then matrix[c] = {} end
      if matrix[c][r] == nil then matrix[c][r] = {} end
      matrix[c][r] = m.at(r-1, c-1)
    end
  end
  return new(matrix)
end


--
--Create a new matrix. Basically just runs checks on a multidimensional table.
--A matrix must have equal number of columns and rows, and not be empty.
--
--@param t table # The matrix candidate
--@return table matrix
Matrix = function(t) return new(t) end

--
--Create a diagonal Matrix.
--All non-diagonal 0,0 to 3,3 elements are 0
--
--@param n number # The diagonal value
--@return table matrix
Diagonal = function(n) return diagonal(n) end

--
--Create an Identity Matrix
--
--@return table matrix
Identity = function() return diagonal(1) end

--
--Transpose a Matrix
--
--@param m table # Matrix
--@return table matrix
Transpose = function(m) return transpose(m) end
