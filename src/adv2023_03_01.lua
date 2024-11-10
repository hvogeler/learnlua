#!/opt/homebrew/bin/lua
local common = require("adv2023_03_common")

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

local function is_any_symbol(c)
    return c:match("%d") == nil and c ~= "."
end

local find_tokens = function (schematic)
    return common.find_tokens(schematic, is_any_symbol)
end

local function run(testdata)
    local number_tokens, symbol_tokens = find_tokens(testdata)
    -- for i, n in ipairs(number_tokens) do print(n.number) end

    local part_numbers = common.get_part_numbers(number_tokens, symbol_tokens)


    local sum_part_numbers = 0
    for i, n in ipairs(part_numbers) do
        sum_part_numbers = sum_part_numbers + n.value
    end
    return sum_part_numbers
end

-- ----------------------------------------------------------------------------
-- MAIN PROGRAM
-- ----------------------------------------------------------------------------
print("Example run")
print("  Sum of all example part numbers: ", run(common.to_array_of_char_arrays(example_data)))
assert(run(common.to_array_of_char_arrays(example_data)) == 4361)

-- -- Real Run
print("Real Run")
local f = io.open("../testdata/adv2023_03.txt", "r")
local sc_real = f:read("*all")

print("  Sum of all part numbers: ", run(common.to_array_of_char_arrays(sc_real)))
