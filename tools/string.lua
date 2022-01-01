local function split(s, delim)
  local result = {}
  for str in string.gmatch(s, "([^"..delim.."]+)") do
    table.insert(result, str)
  end
  return result
end

return { split = split }

