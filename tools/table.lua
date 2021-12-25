local function join(t, delim)
  if delim == nil then delim = "" end
  local str
  for _, v in pairs(t) do
    if str == nil then
      str = tostring(v)
    else
      str = str..delim..tostring(v)
    end
  end
  return str
end

local function map(t, fn)
  local result = {}
  for k, v in pairs(t) do
    result[k] = fn(v)
  end
  return result
end


Table = {
   join = join,
   map = map,
}

return Table
