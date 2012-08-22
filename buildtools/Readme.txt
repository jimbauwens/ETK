TI-Nspire Project Builder v0.2
(C) 2012 Jim Bauwens
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
	The TI-Nspire project builder is a tool that allows you too easily build projects for the TI-Nspire that consists of many files.
	It ultilizes a C-like include system, including files is as easy as 
		--inlude "filename.lua"
	Also, the builder works recursively; you can have includes in file you include.
	The builder will also check every file for syntax errors, and give detailed info on it and where it can be found.
	After all that is done, it will try to build the project with Luna. If it fails to do so you can always build the output file yourself
	
Usage:

	./build.lua InputLuaFile OutputTNSFile

Including files:
	
	--include "blaap/test.lua"
	--include "some/dir/core.lua"
