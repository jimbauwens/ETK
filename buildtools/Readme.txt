TI-Nspire Project Builder v0.5
(C) 2014 Jim Bauwens
Part of the ETK project.

License:
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

What is this tool?
	The TI-Nspire project builder is a tool that allows you to easily build Lua projects for the TI-Nspire that consists of many files.
	It uses a C-like include system, and including files is as easy as :
		--include "filename.lua"
	Also, the builder works recursively : you can have includes in file you include.
	The builder will also check every file for syntax errors, and give detailed info on them, and where they can be found, if any.
	When all that is done, it will try to build the project with Luna. If it fails to do so, you can always build the output file yourself

	The builder now allows you to define constants and macro’s using —define:
	
	--define "LOL" "'Life of links'"
	print("LOL") -- prints Life of links
	
	You can also use Lua patterns. For example, to simulate string indexing you could use the following snippit:
	--define "(%w+)%[%~(%w+)%]" "%1:sub(%2, %2)"
	
	This would allow you to do something as
	
	local myString = "ETK"
	
	for i=1, #myString do
		print(myString[~i])
	end
	
	
Usage:

	./build.lua InputLuaFile OutputTNSFile

Including files:
	
	--include "blaap/test.lua"
	--include "some/dir/core.lua"
