-- init.lua -- runtime helpers for lawk.
-- Loaded automatically by `lawk` wrapper; provides comp/map/filter/reduce,
-- printf/o, plus a tiny each_line helper for line-oriented files.

local M = {}

-- list comprehension target. xs may be array (ipairs) or dict (pairs).
function M.comp(fn, xs,    r, k, v)
  r = {}
  for k, v in pairs(xs) do
    if type(k) == "number" then r[#r+1] = fn(v)
    else                        r[k]    = fn(v) end
  end
  return r
end

function M.map(xs, fn) return M.comp(fn, xs) end

function M.filter(xs, p,    r, _, v)
  r = {}
  for _, v in ipairs(xs) do if p(v) then r[#r+1] = v end end
  return r
end

function M.reduce(xs, fn, init,    acc, _, v)
  acc = init
  for _, v in ipairs(xs) do acc = fn(acc, v) end
  return acc
end

function M.printf(...) io.write(string.format(...)) end

-- polymorphic print: array, dict, scalar.
local o
o = function(x,    keys, k, i, v)
  if type(x) ~= "table" then io.write(tostring(x)); return end
  if x[1] ~= nil then
    io.write("[")
    for i, v in ipairs(x) do
      if i > 1 then io.write(", ") end
      o(v)
    end
    io.write("]")
  else
    keys = {}
    for k in pairs(x) do keys[#keys+1] = k end
    table.sort(keys)
    io.write("{")
    for i, k in ipairs(keys) do
      if i > 1 then io.write(", ") end
      io.write(tostring(k), ": "); o(x[k])
    end
    io.write("}")
  end
end
M.o = o

function M.each_line(file, fn,    f, line)
  f = file and assert(io.open(file, "r")) or io.stdin
  for line in f:lines() do fn(line) end
  if file then f:close() end
end

function M.csv_split(line,    out, field)
  out = {}
  for field in line:gmatch("[^,]+") do
    out[#out+1] = field:match("^%s*(.-)%s*$")
  end
  return out
end

-- expose helpers as globals so .lawk code reads naturally
for k, v in pairs(M) do _G[k] = v end

return M
