#!/opt/homebrew/bin/lua
print("hello world")

t = 5
print(t *2)

v = {}
v[1] = "a"
v["b"] = "b"

tbl = {
    a = 1,
    b = 2,
    c = "drei"
}

print("Items:")
for k,v in pairs(tbl) do
    print(string.format("item tbl(%s) = %s", k, v))
end


-- for i=1, 10, .2 do
--     local tab = 102 + 100*math.sin(i)
--     for j=1, tab do
--         io.write(" ");
--     end
--     print("Hallo Welt")
-- end

-- for k,v in ipairs(v) do
--     print("key =", k)
-- end


-- function f(x)
--     print(string.format("Argument is (%s) %d", x, 42))
-- end
