-- showcase.lawk -- demonstrates every sugar in one file.
-- generated for syntax-highlighting reference.

for _k,_v in pairs(math) do if _G[_k]==nil then _G[_k]=_v end end   -- imports abs, sqrt, exp, log, floor, max, min, ... as bare names

-- # constants and locals (.x = expr)
local PI, E, EPS  = 3.14159, 2.71828, 1e-9
local greeting    = "hello"

-- # exponent (** -> ^)
local area  = (function(r) return PI * r ^ 2 end)

-- # inline arrow lambda, single expression, auto-return
local inc  = (function(x) return x + 1 end)
local add  = (function(a, b) return a + b end)
local lt   = (function(a, b) return a < b end)

-- # block arrow lambda (multi-statement, ^ for explicit return, .. closes)
local welcome  = function(name)
  printf("%s, %s!\n", greeting, name)
  return "done" end

-- # named function via function NAME(args)
function fib(n)
  if n < 2 then return n end
  return fib(n-1) + fib(n-2) end

-- # method-style def
function NUM(s, at)
  return {is="Num", txt=s, at=at, n=0, mu=0, m2=0} end

function NUM_add(c, x)
  c.n  = c.n + 1
  local d    = x - c.mu
  c.mu = c.mu + d / c.n
  c.m2 = c.m2 + d * (x - c.mu) end

function NUM_sd(c)
  return c.n < 2 and 0 or sqrt(c.m2 / (c.n - 1)) end

-- # list comprehension
local xs        = {1, 2, 3, 4, 5, 6, 7, 8}
local squares   = comp(function(x) return x * x end, xs)
local evens     = comp(function(x) return x end, xs)              -- pass-through
local shifted   = comp(function(x) return add(x, 10) end, xs)

-- # auto-pairs in 2-var for
local tally  = {a=1, b=2, c=3}
for k, v in pairs(tally) do printf("  %s=%d\n", k, v) end

-- # nested lambdas inside comp
local cubes  = comp(function(x) return ((function(y) return y*y*y end))(x) end, xs)

-- # mixing several sugars in one block
function sum_squares(t)
  local total  = 0
  for _, v in ipairs(t) do total = total + v ^ 2 end
  return total end

-- # multiple end-closers via dots
function classify(c, x)
  if x == "?" then
    return 0
  elseif c.is == "Num" then
    if x > c.mu then return 1
    else             return -1 end end end

-- # main entry uses comprehension + arrow lambdas + auto-pairs
function main()
  printf("area(2) = %.3f\n", area(2))
  printf("fib(10) = %d\n", fib(10))
  printf("squares = "); o(squares); print()
  printf("cubes   = "); o(cubes); print()
  local num  = NUM("AGE", 1)
  for _, x in ipairs(xs) do NUM_add(num, x) end
  printf("Num: n=%d mu=%.2f sd=%.2f\n", num.n, num.mu, NUM_sd(num)) end

main()
