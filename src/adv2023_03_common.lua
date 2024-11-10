#!/opt/homebrew/bin/lua
local M = {}
function M.to_array_of_char_arrays(str)
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

function M.is_digit(c)
    return c:match("%d") ~= nil
end

function M.equal_symbols(s1, s2) 
    return s1.row == s2.row and s1.col == s2.col
end

-- function M.is_symbol(c)
--     return c:match("%d") == nil and c ~= "."
-- end

function M.find_tokens(schematic, is_symbol)
    -- find tokens and store their start position and length and type
    local number_tokens = {}
    local symbol_tokens = {}
    local state = "BETWEEN_TOKENS"
    local current_token = nil
    for i, row in ipairs(schematic) do
        for j, item in ipairs(row) do
            if state == "BETWEEN_TOKENS" then
                if M.is_digit(item) then
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
                if M.is_digit(item) and current_token then
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

function M.is_adjacent(token, symbol)
    if symbol.row >= token.row - 1 and symbol.row <= token.row + 1 then
        if symbol.col >= token.col - 1 and symbol.col <= token.col + token.length  then
            return true
        end
    end
    return false
end

function M.get_part_numbers(number_tokens, symbol_tokens)
    local part_numbers = {}
    for i, number_token in ipairs(number_tokens) do
        for j, symbol_token in ipairs(symbol_tokens) do
            if M.is_adjacent(number_token, symbol_token) then
                -- print("+++: ", tonumber(number_token.number))
                table.insert(part_numbers, { value = tonumber(number_token.number), symbol = symbol_token })
                goto continue
            end
        end
        -- print("---: ", tonumber(number_token.number))
        ::continue::
    end
    return part_numbers
end
return M