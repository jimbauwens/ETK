#!/usr/bin/lua

BUILDERV = 0.2


print("TI-Nspire project builder v" .. BUILDERV)
print("(C) 2012 Jim Bauwens\r\n")


if #arg<2 then
	print"Usage: ./build.lua infile outfile.tns"
	os.exit(0)
else
	buildfilename = assert(arg[1], "You need to specify an input file name !")
	outfilename = assert(arg[2], "You need to specify an output file name !")
end

print("Project file:", buildfilename)

debug.traceback=nil

local luaout = ""
local luafiles = 0


function assert(bool, errormsg)
	if not bool then
		error(errormsg or "", 0)
	end
	return bool
end

function getPath(filename)
	local a,b,path = filename:find( "(.*%/).*%..*")
	return path or ""
end

function processFile(filename, path)
	luafiles = luafiles + 1
	assert(luafiles<=100, "Too many files to include! Are you sure you don't have an include loop?")
	
	local out = ""
	
	local file = assert(io.open(filename, "r"), filename .. " could not be read! Aborting.")
	print("Processing " .. filename)
	
	assert(os.execute("luac -p " .. filename) == 0, filename .. " contains a syntax error! Aborting.")
	
	
	local filecontent = file:read("*a")
	file:close()
	
	if filename ~= buildfilename then
		local fileheader = "-- Start of " .. filename     .. " --\r\n"
		local hbar       = string.rep("-", #fileheader-2) ..    "\r\n"
		local fileend    = "-- End of " .. filename       .. " --\r\n"
		local ebar       = string.rep("-", #fileend-2)    ..    "\r\n"
		
		filecontent = hbar .. fileheader .. hbar .. filecontent .. ebar .. fileend .. ebar
	end
	
	out = filecontent:gsub("%-%-include \"([^\"]*)\"", function (f) local f = path .. f return processFile(f, getPath(f)) end)
	return out
end

luaout = processFile(buildfilename, getPath(buildfilename))

print("\r\nSuccesully loaded " .. luafiles .. " lua files")

local tmpname = "big." .. buildfilename
print("Creating temp file "..tmpname)

local tmpfile = assert(io.open(tmpname, "w"), "Failed to create temp file. Are you sure you have permissions to the current directory ?")
tmpfile:write(luaout)
tmpfile:close()

print("Trying to build project with Luna...")
assert(os.execute("cat " .. tmpname .. "|luna - " .. outfilename)==0, "Building failed! You can try to build " .. tmpname .. " manually")

print("\r\nBuilding successful!")
