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

  lu.assertEquals(actual, expected)
end

function testTransposingIdentityReturnsIdentity()
  local id = Identity()
  local actual = Transpose(id)

  lu.assertEquals(actual, id)
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

-- Determinants of larger matrices

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

-- Inversion

function testInvertibleMatrixForInvertability()
  local m = Matrix({
      {6, 4, 4, 4},
      {5, 5, 7, 6},
      {4, -9, 3, -7},
      {9, 1, 7, -6},
  })
  lu.assertEquals(Determinant(m), -2120)
end

function testNonInvertibleMatrixForInvertability()
  local m = Matrix({
      {-4, 2, -2, -3},
      {9, 6, 2, 6},
      {0, -5, 1, -5},
      {0, 0, 0, 0},
  })

  lu.assertIsTrue(Determinant(m) == 0)
end

function testCalculatingTheInverseOfAMatrix()
  local a = Matrix({
      {-5, 2, 6, -8},
      {1, -5, 1, 8},
      {7, 7, -6, -7},
      {1, -3, 7, 4},
  })
  local b = Inverse(a)

  local expectedB = Matrix({
      {0.21805, 0.45113, 0.24060, -0.04511},
      {-0.80827, -1.45677, -0.44361, 0.52068},
      {-0.07895, -0.22368, -0.05263, 0.19737},
      {-0.52256, -0.81391, -0.30075, 0.30639},
  })

  lu.assertEquals(Determinant(a), 532)
  lu.assertEquals(Cofactor(a, 2, 3), -160)
  lu.assertEquals(b.at(3, 2), -160/532)
  lu.assertEquals(Cofactor(a, 3, 2), 105)
  lu.assertEquals(b.at(2, 3), 105/532)
  lu.assertIsTrue(b == expectedB)
end

function testCalculatingTheInverseOfAnotherMatrix()
  local a = Matrix({
      {8, -5, 9, 2},
      {7, 5, 6, 1},
      {-6, 0, 9, 6},
      {-3, 0, -9, -4},
  })
  local b = Inverse(a)
  local expectedB = Matrix({
      {-0.15385, -0.15385, -0.28205, -0.53846},
      {-0.07692, 0.12308, 0.02564, 0.03077},
      {0.35897, 0.35897, 0.43590, 0.92308},
      {-0.69231, -0.69231, -0.76923, -1.92308},
  })

  lu.assertIsTrue(b == expectedB)
end

function testCalculatingTheInverseOfAThirdMatrix()
  local a = Matrix({
      {9, 3, 0, 9},
      {-5, -2, -6, -3},
      {-4, 9, 6, 4},
      {-7, 6, 6, 2},
  })
  local b = Inverse(a)
  local expectedB = Matrix({
      {-0.04074, -0.07778, 0.14444, -0.22222},
      {-0.07778, 0.03333, 0.36667, -0.33333},
      {-0.02901, -0.14630, -0.10926, 0.12963},
      {0.17778, 0.06667, -0.26667, 0.33333},
  })

  lu.assertIsTrue(b == expectedB)
end

function testMultiplyAProductByItsInverse()
  local a = Matrix({
      {3, -9, 7, 3},
      {3, -8,  2, -9},
      {-4, 4, 4, 1},
      {-6, 5, -1, 1},
  })
  local b = Matrix({
      {8, 2, 2, 2},
      {3, -1, 7, 0},
      {7, 0, 5, 4},
      {6, -2, 0, 5},
  })
  local c = a * b

  local expected = c * Inverse(b)

  lu.assertEquals(expected, a)
end

function testInvertingIdentityMatrix()
  local id = Identity()
  local actual = Inverse(id)
  local expected = Matrix({
      {1.0, 0.0, 0.0, 0.0},
      {0.0, 1.0, 0.0, 0.0},
      {0.0, 0.0, 1.0, 0.0},
      {0.0, 0.0, 0.0, 1.0},
  })

  lu.assertEquals(0,0)
end

-- Translation

function testMulitplyATranslationMatrix()
  local transform = Translation(5, -3, 2)
  local p = Point(-3, 4, 5)

  local expected = Point(2, 1, 7)
  local actual = transform * p

  lu.assertEquals(actual, expected)
end

function testMultiplyingByTheInverseOfTranslationMatrix()
  local transform = Translation(5, -3, 2)
  local inv = Inverse(transform)
  local p = Point(-3, 4, 5)

  local expected = Point(-8, 7, 3)
  local actual = inv * p

  lu.assertEquals(actual, expected)
end

function testTranslationDoesNotAffectVectors()
  local transform = Translation(5, -3, 2)
  local v = Vector(-3, 4, 5)

  local actual = transform * v
  lu.assertEquals(actual, v)
end

-- Scaling

function testScalingMatrixAppliedToPoint()
  local transform = Scaling(2, 3, 4)
  local p = Point(-4, 6, 8)

  local expected = Point(-8, 18, 32)
  local actual = transform * p

  lu.assertEquals(actual, expected)
end

function testScalingMatrixAppliedToVector()
  local transform = Scaling(2, 3, 4)
  local v = Vector(-4, 6, 8)

  local expected = Vector(-8, 18, 32)
  local actual = transform * v

  lu.assertEquals(actual, expected)
end

function testMultiplyingByInverseOfScalingMatrix()
  local transform = Scaling(2, 3, 4)
  local inv = Inverse(transform)
  local v = Vector(-4, 6, 8)

  local expected = Vector(-2, 2, 2)
  local actual = inv * v

  lu.assertEquals(actual, expected)
end

function testReflectionIsScalingByNegativeValue()
  local transform = Scaling(-1, 1, 1)
  local p = Point(2, 3, 4)

  local expected = Point(-2, 3, 4)
  local actual = transform * p

  lu.assertEquals(actual, expected)
end

-- Rotation

function testRotatingPointAroundXAxis()
  local p = Point(0, 1, 0)
  local halfQuarter = RotationX(math.pi/4)
  local fullQuarter = RotationX(math.pi/2)

  local expectedHalf = Point(0, math.sqrt(2)/2, math.sqrt(2)/2)
  local actualHalf = halfQuarter * p

  local expectedFull = Point(0, 0, 1)
  local actualFull = fullQuarter * p

  lu.assertIsTrue(actualHalf == expectedHalf)
  lu.assertIsTrue(actualFull == expectedFull)
end

function testInverseOfXRotationRotatesInOpposite()
  local p = Point(0, 1, 0)
  local halfQuarter = RotationX(math.pi/4)
  local inv = Inverse(halfQuarter)

  local expected = Point(0, math.sqrt(2)/2, -math.sqrt(2)/2)
  local actual = inv * p

  lu.assertIsTrue(actual == expected)
end

function testRotatingPointAroundYAxis()
  local p = Point(0, 0, 1)
  local halfQuarter = RotationY(math.pi/4)
  local fullQuarter = RotationY(math.pi/2)

  local expectedHalf = Point(math.sqrt(2)/2, 0, math.sqrt(2)/2)
  local actualHalf = halfQuarter * p

  local expectedFull = Point(1, 0, 0)
  local actualFull = fullQuarter * p

  lu.assertIsTrue(actualHalf == expectedHalf)
  lu.assertIsTrue(actualFull == expectedFull)
end

function testRotatingPointAroundZAxis()
  local p = Point(0, 1, 0)
  local halfQuarter = RotationZ(math.pi/4)
  local fullQuarter = RotationZ(math.pi/2)

  local expectedHalf = Point(-math.sqrt(2)/2, math.sqrt(2)/2, 0)
  local actualHalf = halfQuarter * p

  local expectedFull = Point(-1, 0, 0)
  local actualFull = fullQuarter * p

  lu.assertIsTrue(actualHalf == expectedHalf)
  lu.assertIsTrue(actualFull == expectedFull)
end

-- Shearing/Skew

function testShearingTransformationMovesXInProportionToY()
  local transform = Shearing(1, 0, 0, 0, 0, 0)
  local p = Point(2, 3, 4)

  local expected = Point(5, 3, 4)
  local actual = transform * p

  lu.assertEquals(actual, expected)
end

function testShearingTransformationMovezXInProportionToZ()
  local transform = Shearing(0, 1, 0, 0, 0, 0)
  local p = Point(2, 3, 4)

  local expected = Point(6, 3, 4)
  local actual = transform * p

  lu.assertEquals(actual, expected)
end

function testShearingTransformationMovezYInProportionToX()
  local transform = Shearing(0, 0, 1, 0, 0, 0)
  local p = Point(2, 3, 4)

  local expected = Point(2, 5, 4)
  local actual = transform * p

  lu.assertEquals(actual, expected)
end

function testShearingTransformationMovezYInProportionToZ()
  local transform = Shearing(0, 0, 0, 1, 0, 0)
  local p = Point(2, 3, 4)

  local expected = Point(2, 7, 4)
  local actual = transform * p

  lu.assertEquals(actual, expected)
end

function testShearingTransformationMovezZInProportionToX()
  local transform = Shearing(0, 0, 0, 0, 1, 0)
  local p = Point(2, 3, 4)

  local expected = Point(2, 3, 6)
  local actual = transform * p

  lu.assertEquals(actual, expected)
end

function testShearingTransformationMovezZInProportionToY()
  local transform = Shearing(0, 0, 0, 0, 0, 1)
  local p = Point(2, 3, 4)

  local expected = Point(2, 3, 7)
  local actual = transform * p

  lu.assertEquals(actual, expected)
end

-- Chaining Transformations
function testIndividualTransformationsAreAppliedInSequence()
  local p = Point(1, 0, 1)
  local a = RotationX(math.pi / 2)
  local b = Scaling(5, 5, 5)
  local c = Translation(10, 5, 7)

  local p2 = a * p
  lu.assertIsTrue(p2 == Point(1, -1, 0))

  local p3 = b * p2
  lu.assertIsTrue(p3 == Point(5, -5, 0))

  local p4 = c * p3
  lu.assertIsTrue(p4 == Point(15, 0, 7))
end

function testChainedTransformationsMustBeAppliedInReverseOrder()
  local p = Point(1, 0, 1)
  local a = RotationX(math.pi / 2)
  local b = Scaling(5, 5, 5)
  local c = Translation(10, 5, 7)

  local t = c * b * a
  local actual = t * p
  local expected = Point(15, 0, 7)
  lu.assertEquals(actual, expected)
end

os.exit(lu.LuaUnit.run())
