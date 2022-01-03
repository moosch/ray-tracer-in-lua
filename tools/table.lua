--
--Returns a string of all table values separated by delimiter
--
--@param t table # Table to be joined
--@param delim string # Delimiter
--@return string join
local function join(t, delim)
  if delim == nil then delim = "" end
  local str = {}
  for _, v in pairs(t) do
    if #str == 0 then
      str[1] = tostring(v)
    else
      str[#str+1] = delim
      str[#str+1] = tostring(v)
    end
  end
  return table.concat(str)
end

--
--Returns table result of mapping function over valies
--
--@param t table # Table to operate over
--@param fn function # Mapping function accepts values returns any
--@return table mapped
local function map(t, fn)
  local result = {}
  for k, v in pairs(t) do
    result[k] = fn(v)
  end
  return result
end

--
--Returns a table containing key/values that pass the supplied test function
--
--@param t table # Table to be filtered
--@param test function # Accepts key and value, returns eturns boolean
--@return table filtered
local function filter(t, test)
  local resp = {}
  for k, v in pairs(t) do
    if test(k, v) then
      resp[k] = v
    end
  end
  return resp
end

--
--Flatten a 2 dimensional table
--
--@param t table # Table to be flattened
--@return table flattened
local function flatten(t)
  local resp = {}
  local idx = 1
  for _,v in t do
    for _,i in v do
      resp[idx] = i
      idx = idx + 1
    end
  end
  return resp
end

return {
  join = join,
  map = map,
  filter = filter,
  flatten = flatten,
}
