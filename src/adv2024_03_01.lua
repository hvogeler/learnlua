#!/opt/homebrew/bin/lua
local function to_array_of_char_arrays(str)
    local schematic = {}

    for line in str:gmatch("([^\n]+)") do
        local row = {}
        for i = 1, #line do
           row[i] = line:sub(i, i)
        end
        table.insert(schematic, row)
    end
    return schematic
end

local example_data = [[467.114./.
..*.......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..]]


-- local sc = to_array_of_char_arrays(example_data)
-- for i, row in ipairs(sc) do
--     for j = 1, #row do
--         io.write(row[j])
--     end
--     print()
-- end


function is_digit(c)
    return c:match("%d") ~= nil
end

function is_symbol(c)
    return c:match("%d") == nil and c ~= "."
end

function find_tokens(schematic)
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
                if  item == "." then
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
        if state == "IN_NUMBER_TOKEN" then
            -- this happens when a  number ends with line end AND 
            -- a number starts at the beginning of the next line
            if current_token then
                current_token["length"] = #current_token.number
                table.insert(number_tokens, current_token)
                current_token = nil
            end
            state = "BETWEEN_TOKENS"
        end
    end
    return number_tokens, symbol_tokens
end

local function is_adjacent(token, symbol)
    if symbol.row >= token.row - 1 and symbol.row <= token.row + 1 then
        if symbol.col >= token.col - 1 and symbol.col <= token.col + token.length  then
            return true
        end
    end
    return false
end

local function get_part_numbers(number_tokens, symbol_tokens)
    local part_numbers = {}
    for i, number_token in ipairs(number_tokens) do
        for j, symbol_token in ipairs(symbol_tokens) do
            if is_adjacent(number_token, symbol_token) then
                -- print("+++: ", tonumber(number_token.number))
                table.insert(part_numbers, tonumber(number_token.number))
                goto continue
            end
        end
        -- print("---: ", tonumber(number_token.number))
        ::continue::
    end
    return part_numbers
end

local function run(testdata)
    local number_tokens, symbol_tokens = find_tokens(testdata)
    -- for i, n in ipairs(number_tokens) do print(n.number) end

    local part_numbers = get_part_numbers(number_tokens, symbol_tokens)
    for i, n in ipairs(part_numbers) do
        if n > 999 then
        print(string.format("%d. %d", i, n))
        end
        -- if i > 100 then break end
    end

    local sum_part_numbers = 0
    for i, n in ipairs(part_numbers) do
        sum_part_numbers = sum_part_numbers + n
    end
    return sum_part_numbers
end


-- ----------------------------------------------------------------------------
-- MAIN PROGRAM
-- ----------------------------------------------------------------------------

-- local number_tokens, symbol_tokens = find_tokens(sc)
-- local part_numbers = get_part_numbers(number_tokens, symbol_tokens)

-- -- Test
-- local sum_part_numbers = 0
-- for i, n in ipairs(part_numbers) do
--     sum_part_numbers = sum_part_numbers + n
-- end

print("Example run")
print("  Sum of all example part numbers: ", run(to_array_of_char_arrays(example_data)))
assert(run(to_array_of_char_arrays(example_data)) == 4361)

-- -- Real Run
print("Real Run")
local f = io.open("../testdata/adv2023_03_01.txt", "r")
local sc_real = f:read("*all")

print("  Sum of all part numbers: ", run(to_array_of_char_arrays(sc_real)))
