local function math_chemical(str)
    return str
        :gsub("(%u%l?)", "{:text(%1):}")
        :gsub("(%d+)", "_{:%1:}")
        :gsub("%^(%d*[+-])",  "^{:%1:}")
        :gsub("^(.*)$",       "{:%1:}")  -- braces for the whole formula
end

function Math(el)
    el.text = el.text:gsub("chem%(([%d%a^+-]+)%)", math_chemical)
    return el
end

function Code(el)
    if el.classes[1] == "chem" then
        return pandoc.read(
            el.text
                :gsub("(%u%l?)(%d+)", "%1~%2~")
                :gsub("%^(%d*[+-])",  "^%1^"),
            "markdown"
        ).blocks[1].content
    end
end
