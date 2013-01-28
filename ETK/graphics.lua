----------------------------------
-- ETK Event Manager            --
-- Some flags and functions     --
-- for painting                 --
--                              --
-- (C) 2013 Jim Bauwens         --
-- Licensed under the GNU GPLv3 --
----------------------------------

do
	etk.graphics = {}
	local eg = etk.graphics
	
	eg.needsFullRedraw = true
	eg.areaToRedraw = {0, 0, 0, 0}
	
	
	------------------------------------------------
	-- Replacement for platform.window:invalidate --
	------------------------------------------------
	
	eg.invalidate = function (x, y, w, h)
		platform.window:invalidate(x, y, w, h)
		
		if x then
			eg.needsFullRedraw = false
			eg.areaToRedraw = {x, y, w, h}
		end
	end
	
	
	----------------------------------------------
	-- Replacement for graphicalContex:clipRect --
	----------------------------------------------
	
	local clipRectData	= {}
	local clipRects = 0
	local old = clipRectData[clipRects]
	
	local gc_clipRect = function (gc, what, x, y, w, h)
		if what == "set"  then
			clipRects = clipRects + 1
			clipRectData[clipRects] = {x, y, w, h}
						
		elseif what == "subset" and old then
			x	= old[1] < x and x or old[1]
			y	= old[2] < y and y or old[2]
			h	= old[2] + old[4] > y + h and h or old[2] + old[4] - y
			w	= old[1] + old[3] > x + w and w or old[1] + old[3] - x
			
			what = "set"
			
			clipRects = clipRects + 1
			clipRectData[clipRects] = {x, y, w, h}
			
		elseif what == "restore" and old then
			what = "set"
			x, y, w, h = old[1], old[2], old[3], old[4]
			
			clipRectData[clipRects] = nil
			clipRects = clipRects - 1
			
		elseif what == "restore" then
			what = "reset"
			
		end
		
		gc:clipRect(what, x, y, w, h)
	end
	
	--------------------------------------
	-- platform.withGC for apiLevel < 2 --
	--------------------------------------
	
	if not platform.withGC then
		platform.withGC = function (func, ...)
			local gc = platform.gc()
			gc:begin()
			func(..., gc)
		end
	end
	
	---------------------------------
	-- Patch the Graphical Context --
	---------------------------------
	
	local addToGC = function (name, func)
		local gcMeta = platform.withGC(getmetatable)
		gcMeta[name] = func
		-- It's that simple!
	end
	
	------------------------
	-- Apply some patches --
	------------------------
	
	addToGC("smartClipRect", gc_clipRect)
	
end