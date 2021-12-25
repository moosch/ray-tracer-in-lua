local function tuple(x, y, z, w)
   local t = {}
   if x ~= nil then table.insert(t, x) end
   if y ~= nil then table.insert(t, y) end
   if z ~= nil then table.insert(t, z) end
   if w ~= nil then table.insert(t, w) end
   return setmetatable(t, { __index = {
                               x = t[1],
                               y = t[2],
                               z = t[3],
                               w = t[4]}})
end

return tuple
