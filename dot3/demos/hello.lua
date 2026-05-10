-- hello.lawk -- demo all sugars.

for _k,_v in pairs(math) do if _G[_k]==nil then _G[_k]=_v end end   -- imports abs, max, min, sqrt, ... as bare names

-- inline arrow lambda (auto-return)
local inc  = (function(x) return x + 1 end)
print("inc(10) =", inc(10))

-- block arrow lambda
local add5  = function(x)
  return x + 5 end

print("add5(3) =", add5(3))

-- exponent **
print("2**10 =", 2^10)

-- list comprehension
local xs  = {1, 2, 3, 4, 5}
local squares  = comp(function(x) return x*x end, xs)
o(squares); print()

-- comprehension + inline lambda
local doubled  = comp(function(x) return ((function(y) return y*2 end))(x) end, xs)
o(doubled); print()

-- block named function via =>
function mean(t)
  local s, n  = 0, 0
  for _, v in ipairs(t) do s = s + v; n = n + 1 end
  return s / n end

printf("mean(squares) = %.2f\n", mean(squares))

-- auto-pairs in 2-var for loop
local tally  = {a=1, b=2, c=3}
for k, v in pairs(tally) do printf("  %s=%d\n", k, v) end
