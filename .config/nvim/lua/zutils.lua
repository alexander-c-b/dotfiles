local move = require('table').move
local math = require 'math'

local function map(f, list)
    local result = {}
    for k, v in pairs(list) do
        result[k] = f(v)
    end
    return result
end

local function foldl(f, accum, list)
    for i, v in ipairs(table) do
        accum = f(accum, v)
    end
    return accum
end

local function foldr(f, accum, list)
    for i = #list, 1 do
        accum = f(list[i], accum)
    end
    return accum
end

local function partialn(f, ...)
    local stored = {...}
    return function(...)
        for i, v in ipairs({...}) do
            stored[i + #stored] = v
        end
        return f(unpack(stored))
    end
end

local function partial(f, a)
    return function(...)
        return f(a, ...)
    end
end

-- From http://lua-users.org/wiki/ShortAnonymousFunctions
local function lambda(s, ...)
  local src = [[
    local l1, l2, l3, l4, l5, l6, l7, l8, l9 = ...
    return function(p1,p2,p3,p4,p5,p6,p7,p8,p9) return ]] .. s .. [[ end
  ]]
  return loadstring(src)(...)
end


local function totable(gen, param, state)
    local t = {}
    local i = 1
    for v in gen, param, state do
        t[i] = v
        i = i + 1
    end
    return t
end

local function pipe(...)
    local functions = {...}
    return function(arg)
        return foldl(function(accum, f) return f(accum) end,
                     arg, functions)
    end
end

local function singleton(e)
    return {e}
end

return {
    map       = map,
    foldl     = foldl,
    foldr     = foldr,
    partial   = partial,
    partialn  = partialn,
    pipe      = pipe,
    lambda    = lambda,
    singleton = singleton,
    totable   = totable,
}
