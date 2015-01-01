--Lambda style!


--Indexing of strings, string:sub(index, index)






local myString = [[
	this is a little pretty string
	abc
	test
]]


newStringA = myString:gsub("(.)", (function ( x ) return  x..x end))
print(newStringA)

newStringB = myString:gsub("()", (function ( x ) return  myString:sub(x,x) end))
print(newStringB)

print("ETK Version 4.0")
print("Why would I help you")

local myString = "ETK Version 4.0"

for i=1, #myString do
	print(myString:sub(i, i))
end

