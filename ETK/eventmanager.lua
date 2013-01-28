----------------------------------
-- ETK Event Manager            --
-- Handle the events!           --
--                              --
-- (C) 2013 Jim Bauwens         --
-- Licensed under the GNU GPLv3 --
----------------------------------

do
	etk.eventmanager = {}
	etk.eventhandlers = {}

	local em = etk.eventmanager
	local eh = etk.eventhandlers
	local eg = etk.graphics
	
	-----------
	-- TOOLS --
	-----------
		
	-- We will use this function when calling events
	local callEventHandler = function (func, ...)
		if func then
			func(...)
		end
	end
	
	
	-------------------
	-- EVENT LINKING --
	-------------------
	
	local eventLinker = {}
	eventLinker.__index = function (on, event)
		return eh[event]
	end
	
	setmetatable(on, eventLinker)
	
	eh.activate = function () 
		eg.needsFullRedraw = true
	end
	
	eh.getFocus = function ()
		eg.needsFullRedraw = true
	end
	
end
