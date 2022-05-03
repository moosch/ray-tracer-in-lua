translation = function(x, y, z)
  local id = matrix.diagonal(1)
  id = updateAt(id, 0, 3, x)
  id = updateAt(id, 1, 3, y)
  return updateAt(id, 2, 3, z)
end

--
--Translation
--
--@param x number
--@param y number
--@param z number
Translation = function(x, y, z) return translation(x, y, z) end
