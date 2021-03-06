--[[
A Matrix is a table with additional metatable methods.
--]]

require("tools/fuzzy_eq")
require("tools/tuple")

local matrix = {}

local function fillTable(n, size)
  local t = {}
  for i=1, size, 1 do
    t[i] = n
  end
  return t
end

--
--Get the value at a given row/column coordinate
--To access a position, use `myMatrix.at(0, 2)`
--
--@param matrix table # A matrix
--@param row number # Row position
--@param col number # Column position
--@return number value
local function at(m, row, col)
  local row = rawget(m, row+1)
  return rawget(row, col+1)
end

local function eq(a, b)
  if a == nil and b == nil then return true end
  if b.type ~= "matrix" then return false end
  if a.size ~= b.size then return false end

  local size = a.size
  for row=1, size, 1 do
    for col=1, size, 1 do
      if fuzzyEq(a.at(row-1, col-1), b.at(row-1, col-1)) == false then
        return false
      end
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

local function doTupleMul(m, t)
  local res = {}
  for r = 1, m.size, 1 do
    local w = 1
    if t.w ~= nil then w = t.w end
    res[r] = m.at(r-1, 0) * t.x +
        m.at(r-1, 1) * t.y +
        m.at(r-1, 2) * t.z +
        m.at(r-1, 3) * w
  end
  return res
end

local function mulTuple(m, t)
  local res = doTupleMul(m, t)
  return Tuple(res[1], res[2], res[3], res[4])
end

local function mulVector(m, v)
  local res = doTupleMul(m, v)
  return Vector(res[1], res[2], res[3])
end

local function mulPoint(m, p)
  local res = doTupleMul(m, p)
  return Point(res[1], res[2], res[3], res[4])

end

local function updateAt(m, r, c, val)
  if #m <= r or #m <= c then
    error('Cannot update Matrix beyond it\'s size')
  end

   -- Get row
  local row = rawget(m, r+1)
  -- update at column
  row[c+1] = val
  -- update matrix row
  m[r+1] = row
  return m
end

matrix.new = function(t)
  local t_cache = t
  if t == nil then
    t = matrix.idendity()
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
      return matrix.new(mul(a, b))
    end
    if b.type == "tuple" then
      return mulTuple(a, b)
    end
    if b.type == "vector" then
      return mulVector(a, b)
    end
    if b.type == "point" then
      return mulPoint(a, b)
    end
    return a
  end
  mt.__tostring = function(t)
    local printTable = {}
    for row=1, #t, 1 do
      printTable[row] = table.concat(t[row], ", ")..",\n"
    end
    return "Matrix{\n"..table.concat(printTable).."}"
  end

  setmetatable(t, mt)
  return t
end

matrix.diagonal = function(n, size)
  if size == nil then size = 4 end
  local m = {}
  for i=1, size, 1 do
    if m[i] == nil then m[i] = fillTable(0, size) end
    m[i][i] = n
  end
  return matrix.new(m)
end

matrix.identity = function() return matrix.diagonal(1) end

matrix.transpose = function(m)
  -- Columns turn into rows
  local s = m.size
  local mat = {}
  for r = 1, s, 1 do
    for c = 1, s, 1 do
      if mat[c] == nil then mat[c] = {} end
      if mat[c][r] == nil then mat[c][r] = {} end
      mat[c][r] = m.at(r-1, c-1)
    end
  end
  return matrix.new(mat)
end

matrix.determinant = function(m)
  -- dot product of topLeft-bottomRight diagonal
  -- minus dot product of topRight-bottomLeft diagonal

  -- Naive approach
  -- return (m.at(0,0) * m.at(1,1)) - (m.at(0, 1) * m.at(1, 0))
  if m.size == 2 then
    return (m.at(0,0) * m.at(1,1)) - (m.at(0, 1) * m.at(1, 0))
  end

  local det = 0
  for col=1, m.size, 1 do
    det = det + m.at(0, col-1) * matrix.cofactor(m, 0, col-1)
  end
  return det
end

matrix.submatrix = function(m, row, col)
  local omittedRow = row+1
  local omittedCol = col+1
  local size = m.size
  local mat = {}
  local rowTracker = 0
  local colTracker = 0

  for r=1, size, 1 do
    if r ~= omittedRow then
      rowTracker = rowTracker + 1
      mat[rowTracker] = {}
      for c=1, size, 1 do
        if c ~= omittedCol then
          colTracker = colTracker + 1
          mat[rowTracker][colTracker] = m.at(r-1, c-1)
        end
      end
      colTracker = 0
    end
  end

  return matrix.new(mat)
end

matrix.minor = function(m, r, c)
  return matrix.determinant(matrix.submatrix(m, r, c))
end

matrix.cofactor = function(m, r, c)
  local minorAt = matrix.minor(m, r, c)
  if (r + c) % 2 == 0 then return minorAt end
  return minorAt * -1
end

matrix.inverse = function(m)
  local determinant = matrix.determinant(m)

  if determinant == 0 then
    error("matrix is not invertible")
  end

  local mat = {}
  local size = m.size

  for row=1, size, 1 do
    for col=1, size, 1 do
      if mat[col] == nil then mat[col] = {} end
      if mat[col][row] == nil then mat[col][row] = {} end
      local cofactor = matrix.cofactor(m, row-1, col-1)
      -- Store as transposed
      mat[col][row] = cofactor / determinant
    end
  end

  return matrix.new(mat)
end

matrix.translation = function(x, y, z)
  return matrix.new({
      {1, 0, 0, x},
      {0, 1, 0, y},
      {0, 0, 1, z},
      {0, 0, 0, 1}
  })
end

matrix.scaling = function(x, y, z)
  return matrix.new({
      {x, 0, 0, 0},
      {0, y, 0, 0},
      {0, 0, z, 0},
      {0, 0, 0, 1}
  })
end

matrix.rotationX = function(r)
  return matrix.new({
      {1, 0, 0, 0},
      {0, math.cos(r), -(math.sin(r)), 0},
      {0, math.sin(r), math.cos(r), 0},
      {0, 0, 0, 1}
  })
end

matrix.rotationY = function(r)
  return matrix.new({
      {math.cos(r), 0, math.sin(r), 0},
      {0, 1, 0, 0},
      {-math.sin(r), 0, math.cos(r), 0},
      {0, 0, 0, 1}
  })
end

matrix.rotationZ = function(r)
  return matrix.new({
      {math.cos(r), -math.sin(r), 0, 0},
      {math.sin(r), math.cos(r), 0, 0},
      {0, 0, 1, 0},
      {0, 0, 0, 1}
  })
end

matrix.shearing = function(xy, xz, yx, yz, zx, zy)
  return matrix.new({
      {1, xy, xz, 0},
      {yx, 1, yz, 0},
      {zx, zy, 1, 0},
      {0, 0, 0, 1}
  })
end

--
--Create a new matrix. Basically just runs checks on a multidimensional table.
--A matrix must have equal number of columns and rows, and not be empty.
--
--@param t table # The matrix candidate
--@return table matrix
Matrix = function(t) return matrix.new(t) end

--
--Create a diagonal Matrix.
--All non-diagonal 0,0 to 3,3 elements are 0
--
--@param n number # The diagonal value
--@return table matrix
Diagonal = function(n) return matrix.diagonal(n) end

--
--Create an Identity Matrix
--
--@return table matrix
Identity = function() return matrix.diagonal(1) end

--
--Transpose a Matrix
--
--@param m table # Matrix
--@return table matrix
Transpose = function(m) return matrix.transpose(m) end

--
--Determinant of a Matrix
--
--@param m table # Matrix
--@return number determinant
Determinant = function(m) return matrix.determinant(m) end

--
--Submatrix of Matrix
--
--@param m table # Matrix
--@param r number # Row number to be removed
--@param c number # Column number to be removed
--@return table matrix
Submatrix = function(m, r, c) return matrix.submatrix(m, r, c) end

--
--Minor of Matrix
--Composition of submatrix and derterminant
--```lua
--Determinant(Submatrix(m, r, c))
--```
--
--@param m table # Matrix
--@param r number # Row number to be removed
--@param c number # Column number to be removed
--@return table matrix
Minor = function(m, r, c) return matrix.minor(m, r, c) end

--
--Cofactor of Matrix
--
--@param m table # Matrix
--@param r number # Row number
--@param c number # Column number
--@return table matrix
Cofactor = function(m, r, c) return matrix.cofactor(m, r, c) end

--
--Inverse of Matrix
--
--@param m table # Matrix
--@return table matrix
Inverse = function(m) return matrix.inverse(m) end

--
--Translation matrix
--
--@param x number
--@param y number
--@param z number
--@return table matrix
Translation = function(x, y, z) return matrix.translation(x, y, z) end

--
--Scaling matrix
--
--@param x number
--@param y number
--@param z number
--@return table matrix
Scaling = function(x, y, z) return matrix.scaling(x, y, z) end

--
--RotationX matrix
--
--@param r number # Radians
--@return table matrix
RotationX = function(r) return matrix.rotationX(r) end

--
--RotationY matrix
--
--@param r number # Radians
--@return table matrix
RotationY = function(r) return matrix.rotationY(r) end

--
--RotationZ matrix
--
--@param r number # Radians
--@return table matrix
RotationZ = function(r) return matrix.rotationZ(r) end

--
--Shearing matrix
--
--@param xy number
--@param xz number
--@param yx number
--@param yz number
--@param zx number
--@param zy number
--@return table matrix
Shearing = function(xy, xz, yx, yz, zx, zy) return matrix.shearing(xy, xz, yx, yz, zx, zy) end
