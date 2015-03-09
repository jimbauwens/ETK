----------------------------------
-- ETK 4.0                      --
--                              --
-- (C) 2015 Jim Bauwens         --
-- Licensed under the GNU GPLv3 --
----------------------------------

etk = {}
local etk = etk

--include "helpers.lua"
--include "graphics.lua"
--include "screenmanager.lua"
--include "eventmanager.lua"
--include "widgetmanager.lua"


do
	local myView = View()
	
	function myView:draw(gc, x, y, width, height)
		Logger.Log("in myView draw")
		gc:drawString(string.format("%d, %d, %d, %d", x, y, width, height), 10, 10, "top")
	end
	
	etk.RootScreen:pushScreen(myView)
end