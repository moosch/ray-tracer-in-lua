local epsilon = 0.00001

function fuzzyEq(a, b)
  if math.abs(a - b) < epsilon then
    return true
  else
    return false
  end
end
