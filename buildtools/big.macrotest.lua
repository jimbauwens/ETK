--Lua variable pattern


--Lambda style!


--Indexing of strings, string:sub(index, index)


--Increment/Decrement (Note: just use that in a "standalone way", not like: print(a = a + 1) etc.)



--Bitwise operators
-- todo with Jim's lib :)

--Compound assignment operators



--Test stuff




local myString = [[
	this is a little pretty string
	abc
	test
]]

local a = 0
a = a + 1
print(a)
a = a - 2
print(a)

newStringA = myString:gsub("(.)", (function ( x ) return  x..x end))
print(newStringA)

newStringB = myString:gsub("()", (function ( x ) return  myString:sub(x, x) end)) 
print(newStringB)

print("ETK Version 4.0")
print("Why would I help you")

local myString = "ETK Version 4.0"

for i=1, #myString do
	print(myString:sub(i, i))
end

