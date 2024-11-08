#!/opt/homebrew/bin/lua
local function get_example_data()
    local example_data = [[467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..]]

    local schematic = {}

    for line in example_data:gmatch("([^\n]+)") do
        local row = {}
        for i = 1, #line do
           row[i] = line:sub(i, i)
        end
        table.insert(schematic, row)
    end
    return schematic
end

local sc = get_example_data()
for i, row in ipairs(sc) do
    for j = 1, #row do
        io.write(row[j])
    end
    print()
end


function is_digit(c) 
    return c:match("%d") ~= nil
end

function is_symbol(c) 
    return c:match("%d") == nil and c ~= "."
end

function find_tokens(schematic)
    local cursor = {row = 1, col = 1 }

    -- find tokens and store their start position and length and type
    local number_tokens = {}
    local symbol_tokens = {}
    local state = "BETWEEN_TOKENS"
    local current_token = nil
    for i, row in ipairs(schematic) do
        for j, item in ipairs(row) do
            if state == "BETWEEN_TOKENS" then
                if is_digit(item) then
                    current_token = {
                        row = i, col = j, number = item
                    }
                    state = "IN_NUMBER_TOKEN"
                    goto continue
                end
                if is_symbol(item) then
                    table.insert(symbol_tokens, {
                        row = i, col = j
                    })
                    goto continue
                end
            end
      
            if state == "IN_NUMBER_TOKEN" then
                if is_digit(item) and current_token then
                    current_token.number = current_token.number .. item
                    goto continue
                end
                if item == "." then
                    state = "BETWEEN_TOKENS"
                    if current_token then
                        current_token["length"] = #current_token.number
                        table.insert(number_tokens, current_token)
                        current_token = nil
                    end
                goto continue
                end
                if is_symbol(item) then
                    state = "BETWEEN_TOKENS"
                    table.insert(symbol_tokens, {
                        row = i, col = j
                    })
                    if current_token then
                        current_token["length"] = #current_token.number
                        table.insert(number_tokens, current_token)
                        current_token = nil
                    end
                    goto continue
                end
            end
            ::continue::
        end
    end
    return number_tokens, symbol_tokens
end

-- ----------------------------------------------------------------------------
-- MAIN PROGRAM
-- ----------------------------------------------------------------------------

local number_tokens, symbol_tokens = find_tokens(sc)

for i, n in ipairs(number_tokens) do
    print(string.format("number token: %s (%d, %d) - length: %d", n.number, n.row, n.col, n.length))
end

for i, s in ipairs(symbol_tokens) do
    print(string.format("symbol token: (%d, %d)", s.row, s.col))
end