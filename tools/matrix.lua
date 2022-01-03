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
    at = function(row, col) return at(t, row, col) end
  }
  -- mt.__eq

  setmetatable(t, mt)
  return t
end

return new
