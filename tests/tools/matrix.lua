local lu = require("libs/luaunit")
require("tools/tuple")
require("tools/matrix")

function testConstructingAndInspecting4by4Matrix()
  local m = Matrix({
      {1, 2, 3, 4},
      {5.5, 6.5, 7.5, 8.5},
      {9, 10, 11, 12},
      {13.5, 14.5, 15.5, 16.5},
  })

  lu.assertEquals(m.at(0, 0), 1)
  lu.assertEquals(m.at(0, 3), 4)
  lu.assertEquals(m.at(1, 0), 5.5)
  lu.assertEquals(m.at(1, 2), 7.5)
  lu.assertEquals(m.at(2, 2), 11)
  lu.assertEquals(m.at(3, 0), 13.5)
  lu.assertEquals(m.at(3, 2), 15.5)
end

function testVariousMatricesSizes()
  local m2 = Matrix({
      {-3, 5},
      {1, -2},
  })

  lu.assertEquals(m2.at(0, 0), -3)
  lu.assertEquals(m2.at(0, 1), 5)
  lu.assertEquals(m2.at(1, 0), 1)
  lu.assertEquals(m2.at(1, 1), -2)

  local m3 = Matrix({
      {-3, 5, 0},
      {1, -2, -7},
      {0, 1, 1},
  })

  lu.assertEquals(m3.at(0, 0), -3)
  lu.assertEquals(m3.at(1, 1), -2)
  lu.assertEquals(m3.at(2, 2), 1)
end

function testMatrixEqualityWithIdenticalMatrices()
  local m1 = Matrix({
      {1, 2, 3, 4},
      {5, 6, 7, 8},
      {9, 8, 7, 6},
      {5, 4, 3, 2},
  })
  local m2 = Matrix({
      {1, 2, 3, 4},
      {5, 6, 7, 8},
      {9, 8, 7, 6},
      {5, 4, 3, 2},
  })

  lu.assertIsTrue(m1 == m2)
end

function testMatrixEqualityWithDifferentMatrices()
  local m1 = Matrix({
      {1, 2, 3, 4},
      {5, 6, 7, 8},
      {9, 8, 7, 6},
      {5, 4, 3, 2},
  })
  local m2 = Matrix({
      {2, 3, 4, 5},
      {6, 7, 8, 9},
      {8, 7, 6, 5},
      {4, 3, 2, 1},
  })

  lu.assertIsFalse(m1 == m2)
end

function testMatrixMultiplication()
  local m1 = Matrix({
      {1, 2, 3, 4},
      {5, 6, 7, 8},
      {9, 8, 7, 6},
      {5, 4, 3, 2}
  })
  local m2 = Matrix({
      {-2, 1, 2, 3},
      {3, 2, 1, -1},
      {4, 3, 6, 5},
      {1, 2, 7, 8}
  })
  local expected = Matrix({
    {20, 22, 50, 48},
    {44, 54, 114, 108},
    {40, 58, 110, 102},
    {16, 26, 46, 42}
  })

  local actual = m1 * m2

  lu.assertIsTrue(actual == expected)
end

function testMultiplyMatrixByTuple()
  local m = Matrix({
      {1, 2, 3, 4},
      {2, 4, 4, 2},
      {8, 6, 4, 1},
      {0, 0, 0, 1},
  })
  local t = Tuple(1, 2, 3, 1)

  local expected = Tuple(18, 24, 33, 1)
  local actual = m * t

  lu.assertIsTrue(actual == expected)
end

function testMultiplyMatrixByIdentityMatrix()
  local m = Matrix({
      {0, 1, 2, 4},
      {1, 2, 4, 8},
      {2, 4, 8, 16},
      {4, 8, 16, 32},
  })
  local id = Identity()
  local actual = m * id

  lu.assertIsTrue(actual == m)
end

function testMultiplyTupleByIdentityMatrix()
  local t = Tuple(1, 2, 3, 4)
  local actual = Identity() * t

  lu.assertIsTrue(actual == t)
end

function testTransposingAMatrix()
  local m = Matrix({
      {0, 9, 3, 0},
      {9, 8, 0, 8},
      {1, 8, 5, 3},
      {0, 0, 5, 8},
  })
  local expected = Matrix({
      {0, 9, 1, 0},
      {9, 8, 8, 0},
      {3, 0, 5, 5},
      {0, 8, 3, 8},
  })
  local actual = Transpose(m)

  lu.assertIsTrue(actual == expected)
end

function testTransposingIdentityReturnsIdentity()
  local id = Identity()
  local actual = Transpose(id)

  lu.assertIsTrue(actual == id)
end

-- Determinants
function testCalculatingDeterminantOf2DMatrix()
  local m = Matrix({
      {1, 5},
      {-3, 2},
  })
  local expected = 17
  local actual = Determinant(m)

  lu.assertIsTrue(actual == expected)
end

-- Submatrices
function testSubmatrixOf3DMatrixIs2DMatrix()
  local m = Matrix({
      {1, 5, 0},
      {-3, 2, 7},
      {0, 6, -3},
  })
  local expected = Matrix({
      {-3, 2},
      {0, 6},
  })
  local actual = Submatrix(m, 0, 2)

  lu.assertIsTrue(actual == expected)
end

function testSubmatrixOf4DMatrixIs3DMatrix()
  local m = Matrix({
      {-6, 1, 1, 6},
      {-8, 5, 8, 6},
      {-1, 0, 8, 2},
      {-7, 1, -1, 1},
  })
  local expected = Matrix({
      {-6, 1, 6},
      {-8, 8, 6},
      {-7, -1, 1},
  })
  local actual = Submatrix(m, 2, 1)

  lu.assertIsTrue(actual == expected)
end

-- Minors

function testCalcAMinorOf3DMatrix()
  local m = Matrix({
      {3, 5, 0},
      {2, -1, -7},
      {6, -1, 5},
  })
  local submatrix = Submatrix(m, 1, 0)
  local determinant = Determinant(submatrix)
  local actual = Minor(m, 1, 0)

  lu.assertIsTrue(determinant == 25)
  lu.assertIsTrue(actual == 25)
end

-- Cofactors

function testCalcCofactorOf3DMatrix()
  local m = Matrix({
      {3, 5, 0},
      {2, -1, -7},
      {6, -1, 5},
  })

  lu.assertEquals(Minor(m, 0, 0), -12)
  lu.assertEquals(Cofactor(m, 0, 0), -12)
  lu.assertEquals(Minor(m, 1, 0), 25)
  lu.assertEquals(Cofactor(m, 1, 0), -25)
end

function testCalcDeterminatnOfLargerMatrices()
  local m1 = Matrix({
      {1, 2, 6},
      {-5, 8, -4},
      {2, 6, 4},
  })
  local m2 = Matrix({
      {-2, -8, 3, 5},
      {-3, 1, 7, 3},
      {1, 2, -9, 6},
      {-6, 7, 7, -9},
  })

  lu.assertEquals(Cofactor(m1, 0, 0), 56)
  lu.assertEquals(Cofactor(m1, 0, 1), 12)
  lu.assertEquals(Cofactor(m1, 0, 2), -46)
  lu.assertEquals(Determinant(m1), -196)

  lu.assertEquals(Cofactor(m2, 0, 0), 690)
  lu.assertEquals(Cofactor(m2, 0, 1), 447)
  lu.assertEquals(Cofactor(m2, 0, 2), 210)
  lu.assertEquals(Cofactor(m2, 0, 3), 51)
  lu.assertEquals(Determinant(m2), -4071)
end



os.exit(lu.LuaUnit.run())
