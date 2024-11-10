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

local function is_asterisk_symbol(c)
    return c == "*"
end

local find_tokens = function (schematic)
    return common.find_tokens(schematic, is_asterisk_symbol)
end

local function run(testdata)
    local number_tokens, symbol_tokens = find_tokens(testdata)
    local part_numbers = common.get_part_numbers(number_tokens, symbol_tokens)

    local sum_gears = 0
    for i, pn1 in ipairs(part_numbers) do
        for j = i + 1, #part_numbers do
            local pn2 = part_numbers[j]
            if common.equal_symbols(pn1.symbol, pn2.symbol) then
                sum_gears = sum_gears + (pn1.value * pn2.value)
            end
        end
    end
    return sum_gears
end


-- ----------------------------------------------------------------------------
-- MAIN PROGRAM
-- ----------------------------------------------------------------------------
print("Example run")
print("  Sum of all gears: ", run(common.to_array_of_char_arrays(example_data)))
assert(run(common.to_array_of_char_arrays(example_data)) == 467835)

print("Real Run")
local f = io.open("../testdata/adv2023_03.txt", "r")
local sc_real = f:read("*all")

print("  Sum of all gears: ", run(common.to_array_of_char_arrays(sc_real)))
