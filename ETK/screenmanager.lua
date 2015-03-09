----------------------------------
-- ETK Screenmanager            --
-- stuff and stuff I guess      --
-- cookies                      --
--                              --
-- (C) 2015 Jim Bauwens         --
-- Licensed under the GNU GPLv3 --
----------------------------------

do etk.RootScreen = {}
	local RootScreen = etk.RootScreen
	local eg = etk.graphics

	local x, y = 0, 0
	
	---------------------
	-- Screen handling --
	---------------------
	
	RootScreen.screens = {}
	local screens = RootScreen.screens
	
	function RootScreen:pushScreen(screen, args)
		screen:onPushed(args)
		
		table.insert(screens, screen)
	end
	
	function RootScreen:popScreen(args)
		screen:onPopped(args)
		
		return table.remove(screens)
	end
	
	function RootScreen:peekScreen()
		return screens[#screens] or RootScreen
	end

	----------------------------
	-- Dimension and position --
	----------------------------
	
	function RootScreen:getDimension()
		return eg.viewPortWidth, eg.viewPortHeight
	end
	
	function RootScreen:getPosition()
		return x, y
	end	
end

------------------
-- Screen class --
------------------

do Screen = class()
	local eg = etk.graphics
	
	function Screen:init(parent, position, dimension)
		self.parent = parent
		self.position = position
		self.dimension = dimension
		
		self.children = {}
	end

	--------------------------------
	-- Dimension helper functions --
	--------------------------------

	function Screen:getDimension()
		local parentWidth, parentHeight = self.parent:getDimension()
		
		return self.dimension:get(parentWidth, parentHeight, eg.dimensionsChanged)
	end
	
	function Screen:getPosition()
		local parentX, parentY = self.parent:getPosition()
		local parentWidth, parentHeight = self.parent:getDimension()
		local width, height = self:getDimension()
		
		return self.position:get(parentX, parentY, parentWidth, parentHeight, width, height, eg.dimensionsChanged)
	end
	
	-------------------
	-- Screen events --
	-------------------
	
	function Screen:onPushed(args)
		-- when pushed
	end
	
	function Screen:onPopped(args)
		-- when popped
	end
	
	--------------------
	-- Drawing events --
	--------------------
	
	function Screen:paint(gc)
		local width, height = self:getDimension()
		local x, y = self:getPosition()
		
		self:draw(gc, x, y, width, height)
		
		for k, screen in ipairs(self.children) do
			screen:paint(gc)	
		end
		
		self:postDraw(gc, x, y, width, height)
	end
	
	function Screen:draw(gc, x, y, width, height)
		-- all drawing should happen here
		
		-- called before drawing children
	end
	
	function Screen:postDraw(gc, x, y, width, height)
		-- all drawing should happen here
		
		-- called after drawing children
	end
end

----------------
-- View class --
----------------

do View = class(Screen)
	function View:init(args)
		args = args or {}
		
		local parent	= args.parent   or etk.RootScreen
		local dimension = args.dimension or Dimension()
		local position  = args.position  or Position()
		
		Screen.init(self, parent, position, dimension)
		
		self.focusIndex = 0
	end
	
	-----------------
	-- Focus logic --
	-----------------
	
	function View:switchFocus(direction, isChildView)
		local children = self.children
		local focusIndex = self.focusIndex
		
		local currentChild = children[focusIndex]
		local continue = true
		
		if currentChild and currentChild.focusIndex then
			continue = not currentChild:switchFocus(direction, true) -- do we need to handle the focus change
		end
		
		if continue then
			if currentChild then
				currentChild:onBlur()	
			end
			
			local nextFocusIndex = focusIndex + direction
			local childrenCount = #self.children
			local wrapped = false
			
			if nextFocusIndex > childrenCount then
				nextFocusIndex = 1
				wrapped = true
			elseif nextFocusIndex <= 0 then
				nextFocusIndex = childrenCount
				wrapped = true
			end
			
			if wrapped and isChildView then
				return false -- we are not handling the focus change due to wrapping, the parent focus manager needs to handle it
			else
				self:giveFocusToChildAtIndex(nextFocusIndex)
				return true -- we have handled the focus change
			end
		end
	end
	
	function View:giveFocusToChildAtIndex(index)
		self.focusIndex = index
		local nextChild = self.children[index]
		
		if nextChild then
			nextChild.hasFocus = true
			nextChild:onFocus()
		end
	end
	
	function View:getFocusedChild()
		return self.children[self.focusIndex]
	end
	
	-------------------------------------
	-- Link tab events to focus change --
	-------------------------------------
	
	function View:tabKey()
		self:switchFocus(1)
	end
	
	function View:backtabKey()
		self:switchFocus(-1)
	end
	
	----------------------------------------
	-- Propagate other events to children --
	----------------------------------------
	
	function View:onEvent(event, eventHandler, ...)
		Logger.Log("View %q - event %q - eventHandler %q", tostring(self), tostring(event), tostring(eventHandler))
		
		local child = self:getFocusedChild()
		
		if not eventHandler and child and child[event] then
			child[event](child, ...)
		end
	end
end