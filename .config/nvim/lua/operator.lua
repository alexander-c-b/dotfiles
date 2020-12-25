local string = require "string"
local debug  = require "debug"

function over_sub_str(f, i, j, str)
    local first  = str:sub(1, i - 1)
    local middle = str:sub(i, j)
    local last   = str:sub(j + 1)
    return first .. f(middle) .. last
end

--    (String -> String)
-- -> Maybe ([String] -> [String])
-- -> Maybe ((Int, Int, [String]) -> [String])
-- -> (String, Int, Int) -> [String] -> [String]
local function to_operator(char_fn, line_fn, block_fn)
    return function(mode, start_col, end_col)
        local default_char_fn = partial(map, partialn(over_sub_str, char_fn, 
                                                      start_col, end_col))
        -- return_value :: [String] -> [String]
        return ({
            char  = default_char_fn,
            line  = line_fn  or partial(map, char_fn),
            block = block_fn and partialn(block_fn, start_col, end_col) 
                             or  default_char_fn
        })[mode]
    end
end

--    ([String] -> [String])
-- -> Int
-- -> Int
-- -> Vim ()
local function over_vim_lines(transform, start_row, end_row)
    assert(type(transform) == "function")
    assert(type(start_row) == "number")
    assert(type(end_row)   == "number")
    -- api functions use 0 indexing, so correct for this.
    -- end_row is excluded, so do not correct
    start_row = start_row - 1
    local result =
        transform(vim.api.nvim_buf_get_lines(0, start_row, end_row, true))
    vim.api.nvim_buf_set_lines(0, start_row, end_row, true, result)
end

--    ((String, Int, Int) -> [String] -> [String])
-- -> String
-- -> Vim ()
local function run_operator(get_operator, mode)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, '['))
    local end_row,   end_col   = unpack(vim.api.nvim_buf_get_mark(0, ']'))
    -- cols should use 1-indexing for get_operator.
    start_col = start_col + 1
    end_col   = end_col   + 1
    over_vim_lines(get_operator(mode, start_col, end_col), start_row, end_row)
end

local non_title_words = { 
    ["the"] = true, 
    ["The"] = true, 
    ["THE"] = true,
    ["a"]   = true, 
    ["A"]   = true,
}

local function title_case(str)
    assert(type(str) == "string", "type of title_case arg was " .. type(str))
    s = str
    -- debug.debug()
    return str:gsub("((%w)(%w*))",
        function(whole, first, rest)
            -- if the  whole  is a non title-case word,
            -- don't replace it (return nil)
            return non_title_words[whole] and nil 
                   or first:upper() .. rest
        end)
end

local TitleCaseOp = partial(run_operator, to_operator(title_case))

return {
    run_operator = run_operator,
    TitleCaseOp  = TitleCaseOp,
}
