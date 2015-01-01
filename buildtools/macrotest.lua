--Lambda style!
--define "λ(.-)->(.-);" "(function (%1) return %2 end)"

--Indexing of strings, string[~index]
--define "(%w+)%[%~(%w+)%]" "%1:sub(%2, %2)"

--define "ETK" "ETK Version 4.0"
--define "HELP" "Why would I help you"


local myString = [[
	this is a little pretty string
	abc
	test
]]


newStringA = myString:gsub("(.)", λ x -> x..x;)
print(newStringA)

newStringB = myString:gsub("()", λ x -> myString:sub(x,x);)
print(newStringB)

print("ETK")
print("HELP")

local myString = "ETK"

for i=1, #myString do
	print(myString[~i])
end

