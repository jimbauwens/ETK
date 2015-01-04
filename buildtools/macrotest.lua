--Lua variable pattern
--superdefine "__LuaVar__" "[%w%._%[%]]+"
-- Jim, go handle that in build.lua then remove this line :P

--Lambda style!
--define "λ(.-)->(.-);" "(function (%1) return %2 end)"

--Indexing of strings, string[~index]
--define "(%w+)%[%~(%w+)%]" "%1:sub(%2, %2)"

--Increment/Decrement (Note: just use that in a "standalone way", not like: print(a++) etc.)
--define "(__LuaVar__)%+%+" "%1 = %1 + 1"
--define "(__LuaVar__)%-%-" "%1 = %1 - 1"

--Bitwise operators
-- todo with Jim's lib :)

--Compound assignment operators
--define "(__LuaVar__)%+=(__LuaVar__)" "%1 = %1 + %2"
--define "(__LuaVar__)%-=(__LuaVar__)" "%1 = %1 - %2"

--Test stuff
--define "ETK" "ETK Version 4.0"
--define "HELP" "Why would I help you"


local myString = [[
	this is a little pretty string
	abc
	test
]]

local a = 0
a++
print(a)

newStringA = myString:gsub("(.)", λ x -> x..x;)
print(newStringA)

--newStringB = myString:gsub("()", λ x -> myString:sub(x,x);)
newStringB = myString:gsub("()", λ x -> myString[~x];) 
print(newStringB)

print("ETK")
print("HELP")

local myString = "ETK"

for i=1, #myString do
	print(myString[~i])
end

