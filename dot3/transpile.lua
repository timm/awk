-- transpile.lua -- lawk -> lua transpiler.
--
-- Sugars (in pipeline order):
--   a ** b                    -> a ^ b                       (exponentiation)
--   ^expr   (line-start)      -> return expr
--   .x = expr                 -> local x = expr
--   .x, y = a, b              -> local x, y = a, b
--   use math                  -> for k,v in pairs(math) do _G[k]=v end
--   for k,v in IDENT do       -> for k,v in pairs(IDENT) do  (auto-pairs)
--   [expr for x in xs]        -> comp(function(x) return expr end, xs)
--   NAME(args) =>      (EOL)  -> function NAME(args)         (block, ".." closes)
--   (args) =>          (EOL)  -> function(args)              (block anon)
--   (args) => expr   (inline) -> (function(args) return expr end)
--   <content> SP DOT+ EOL     -> N x "end"                   (close blocks)

local M = {}

-- ----- skip strings/comments ---------------------------------------
local function skip_skipable(src, i,    c, j, quote, cj)
  c = src:sub(i, i)
  if src:sub(i, i+1) == "--" then
    if src:sub(i+2, i+3) == "[[" then
      j = src:find("]]", i+4, true)
      return j and j + 2 or #src + 1
    end
    j = src:find("\n", i, true)
    return j or #src + 1
  end
  if c == '"' or c == "'" then
    quote = c; j = i + 1
    while j <= #src do
      cj = src:sub(j, j)
      if     cj == "\\"  then j = j + 2
      elseif cj == quote then return j + 1
      else                    j = j + 1 end
    end
    return #src + 1
  end
  if src:sub(i, i+1) == "[[" then
    j = src:find("]]", i+2, true)
    return j and j + 2 or #src + 1
  end
  return i
end

-- ----- find balanced close -----------------------------------------
local function find_close(src, open_pos, open_ch, close_ch,    depth, i, skipped, c)
  depth = 1; i = open_pos + 1
  while i <= #src and depth > 0 do
    skipped = skip_skipable(src, i)
    if skipped > i then i = skipped
    else
      c = src:sub(i, i)
      if     c == open_ch  then depth = depth + 1
      elseif c == close_ch then depth = depth - 1 end
      if depth == 0 then return i end
      i = i + 1
    end
  end
  error("unbalanced "..open_ch.." at pos "..open_pos)
end

-- ----- arrow body end (inline lambda) ------------------------------
-- Scan from i forward, return position just before terminator.
-- Stops at: end-of-line, ;, or unbalanced ),],}, or , at depth 0.
local function arrow_body_end(src, start,    i, depth, skipped, c)
  i = start; depth = 0
  while i <= #src do
    skipped = skip_skipable(src, i)
    if skipped > i then i = skipped
    else
      c = src:sub(i, i)
      if c == "\n" or c == ";" then return i - 1 end
      if depth == 0 and c == "," then return i - 1 end
      if c == "(" or c == "[" or c == "{" then depth = depth + 1
      elseif c == ")" or c == "]" or c == "}" then
        if depth == 0 then return i - 1 end
        depth = depth - 1
      end
      i = i + 1
    end
  end
  return #src
end

-- ----- per-line helper (preserves trailing newline structure) -----
local function each_line(src, fn,    out, pos, nl, line)
  out, pos = {}, 1
  while pos <= #src do
    nl = src:find("\n", pos, true)
    if nl then
      line = src:sub(pos, nl-1)
      out[#out+1] = fn(line) .. "\n"
      pos = nl + 1
    else
      line = src:sub(pos)
      out[#out+1] = fn(line)
      break
    end
  end
  return table.concat(out)
end

-- ----- pipeline passes ---------------------------------------------

-- 1. exponent: ** -> ^
local function rewrite_exponent(src,    out, i, skipped)
  out, i = {}, 1
  while i <= #src do
    skipped = skip_skipable(src, i)
    if skipped > i then
      out[#out+1] = src:sub(i, skipped-1); i = skipped
    elseif src:sub(i, i+1) == "**" then
      out[#out+1] = "^"; i = i + 2
    else
      out[#out+1] = src:sub(i, i); i = i + 1
    end
  end
  return table.concat(out)
end

-- 2. ^expr at statement-start -> return expr
--    statement-start = line-start, or after then/else/do/;
local function rewrite_return_sigil(src)
  return each_line(src, function(line)
    line = line:gsub("^(%s*)%^(%S)",       "%1return %2")
    line = line:gsub("(%f[%w_]then%s+)%^", "%1return ")
    line = line:gsub("(%f[%w_]else%s+)%^", "%1return ")
    line = line:gsub("(%f[%w_]do%s+)%^",   "%1return ")
    line = line:gsub(";(%s*)%^",           ";%1return ")
    return line
  end)
end

-- 3. trailing space-dots -> N x "end"
local function rewrite_end_dots(src)
  return each_line(src, function(line,    body, dots, n, ends)
    body, dots = line:match("^(.-%S)%s+(%.+)%s*$")
    if body and dots:match("^%.+$") then
      n = #dots; ends = {}
      for j = 1, n do ends[j] = "end" end
      return body .. " " .. table.concat(ends, " ")
    end
    return line end)
end

-- 4. .x = expr (line-start) -> local x = expr
local function rewrite_local_dot(src)
  return each_line(src, function(line)
    return (line:gsub(
      "^(%s*)%.([%w_]+[%w_,%s]*)%s*=%s*",
      "%1local %2 = ")) end)
end

-- 5. use MOD -> import-all loop  (allow trailing comment)
local function rewrite_use(src)
  return each_line(src, function(line)
    return (line:gsub(
      "^(%s*)use%s+([%w_.]+)(%s*.*)$",
      "%1for _k,_v in pairs(%2) do if _G[_k]==nil then _G[_k]=_v end end%3")) end)
end

-- 6. for k,v in IDENT do -> for k,v in pairs(IDENT) do
local function rewrite_auto_pairs(src)
  return (src:gsub(
    "(for%s+[%w_]+%s*,%s*[%w_]+%s+in%s+)([%w_][%w_%.]*)(%s+do)",
    "%1pairs(%2)%3"))
end

-- 7. comprehension [expr for x in xs] -> comp(function(x) return expr end, xs)
local function rewrite_comp(src,    out, i, skipped, close, inside, expr, var, iter)
  out, i = {}, 1
  while i <= #src do
    skipped = skip_skipable(src, i)
    if skipped > i then
      out[#out+1] = src:sub(i, skipped-1); i = skipped
    elseif src:sub(i, i) == "[" then
      local ok, c = pcall(find_close, src, i, "[", "]")
      if ok then
        inside = src:sub(i+1, c-1)
        expr, var, iter = inside:match("^%s*(.-)%s+for%s+(%S+)%s+in%s+(.-)%s*$")
        if expr then
          out[#out+1] = "comp(function("..var..") return "..expr.." end, "..iter..")"
          i = c + 1
        else
          out[#out+1] = src:sub(i, c); i = c + 1
        end
      else
        out[#out+1] = src:sub(i, i); i = i + 1
      end
    else
      out[#out+1] = src:sub(i, i); i = i + 1
    end
  end
  return table.concat(out)
end

-- 8a. block arrow: line ending in `=>` -> prepend "function" to head
--   NAME(args) =>           -> function NAME(args)
--   (args) =>               -> function(args)
local function rewrite_arrow_block(src)
  return each_line(src, function(line,    prefix, before, name, args, before2, args2)
    prefix = line:match("^(.*)=>%s*$")
    if not prefix then return line end
    before, name, args = prefix:match("^(.-)([%w_][%w_.]*)%s*(%b())%s*$")
    if name then return before.."function "..name..args end
    before2, args2 = prefix:match("^(.-)(%b())%s*$")
    if args2 then return before2.."function"..args2 end
    return line
  end)
end

-- 8b. inline arrow: (args) => expr  ->  (function(args) return expr end)
-- Mid-line `=>` only (block form already handled).
local function rewrite_arrow_inline(src,    out, i, skipped, arrow_pos, after,
                                    pre, paren_close, depth, pp, c, paren_open,
                                    args, body_start, body_end, body)
  out, i = {}, 1
  while i <= #src do
    skipped = skip_skipable(src, i)
    if skipped > i then
      out[#out+1] = src:sub(i, skipped-1); i = skipped
    else
      arrow_pos = src:find("=>", i, true)
      if not arrow_pos then
        out[#out+1] = src:sub(i); break
      end
      -- skip if block form (=> at line end after whitespace)
      after = src:sub(arrow_pos+2):match("^([ \t]*)\n")
      if after then
        out[#out+1] = src:sub(i, arrow_pos+1); i = arrow_pos + 2
      else
        -- find (args) before arrow
        pre = arrow_pos - 1
        while pre > i and src:sub(pre,pre):match("[ \t]") do pre = pre - 1 end
        if src:sub(pre,pre) ~= ")" then
          out[#out+1] = src:sub(i, arrow_pos+1); i = arrow_pos + 2
        else
          paren_close = pre
          depth = 1; pp = pre - 1
          while pp >= 1 and depth > 0 do
            c = src:sub(pp,pp)
            if     c == ")" then depth = depth + 1
            elseif c == "(" then depth = depth - 1 end
            if depth == 0 then break end
            pp = pp - 1
          end
          if depth ~= 0 then
            out[#out+1] = src:sub(i, arrow_pos+1); i = arrow_pos + 2
          else
            paren_open = pp
            args = src:sub(paren_open+1, paren_close-1)
            out[#out+1] = src:sub(i, paren_open-1)
            body_start = arrow_pos + 2
            while body_start <= #src and src:sub(body_start,body_start):match("[ \t]") do
              body_start = body_start + 1
            end
            body_end = arrow_body_end(src, body_start)
            body = src:sub(body_start, body_end)
            out[#out+1] = "(function("..args..") return "..body.." end)"
            i = body_end + 1
          end
        end
      end
    end
  end
  return table.concat(out)
end

-- ---------------------------------------------------------------- entry
function M.transpile(src)
  src = rewrite_exponent(src)
  src = rewrite_return_sigil(src)
  src = rewrite_local_dot(src)
  src = rewrite_use(src)
  src = rewrite_auto_pairs(src)
  src = rewrite_comp(src)
  src = rewrite_arrow_inline(src)   -- mid-line first
  src = rewrite_arrow_block(src)    -- then block form
  src = rewrite_end_dots(src)       -- last: ".." -> "end"
  return src
end

-- ---------------------------------------------------------------- CLI
if arg and arg[0] and arg[0]:match("transpile%.lua$") then
  local fin  = assert(io.open(arg[1], "r"), "cannot read "..tostring(arg[1]))
  local src  = fin:read("*a"); fin:close()
  local out  = M.transpile(src)
  if arg[2] then
    local fout = assert(io.open(arg[2], "w"))
    fout:write(out); fout:close()
  else
    io.write(out)
  end
end

return M
