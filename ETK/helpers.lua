----------------------------------
-- ETK Helper Classes           --
-- make stuff more easy         --
--                              --
-- (C) 2015 Jim Bauwens         --
-- Licensed under the GNU GPLv3 --
----------------------------------

------------------
-- Enumerations --
------------------

Enum = function(enumTable)
	for k,v in ipairs(enumTable) do
		enumTable[v] = k		
	end
	
	return enumTable
end

-------------
-- Logging --
-------------

do Logger = {}
    Logger.Log = function (message, ...)
        print(message:format(...))
    end
    
    Logger.Warn = function (message, ...) 
        Logger.Log("Warning: " .. message, ...)
    end
end


-----------------------------------------------
-- Handle different types of user unit input --
-----------------------------------------------

do UnitCalculator = {}
    UnitCalculator.GetAbsoluteValue = function (value, referenceValue)
        local numberValue, unit = string.match(tostring(value), "([%d.]+)(.*)")
        
        local number = tonumber(numberValue)
        
        if not number then
             Logger.Warn("UnitCalculator.GetAbsoluteValue - Invalid number value, returning 0")
             return 0
        end
        
        if unit == "%" then
            return referenceValue / 100 * number
        else
           return number
        end 
    end
end

-------------------------------------------------
-- Keep dimensions in a nice to handle wrapper --
-------------------------------------------------

do Dimension = class()
    function Dimension:init(width, height)
        self.width = width
        self.height = height
    end
    
    function Dimension:get(parentWidth, parentHeight, dirty)
		if self.width then
			if dirty or not self.cachedWidth then
				self.cachedWidth  = UnitCalculator.GetAbsoluteValue(self.width, parentWidth)
				self.cachedHeight = UnitCalculator.GetAbsoluteValue(self.height, parentHeight)
			end		
			
			return self.cachedWidth, self.cachedHeight
		else
			return parentWidth, parentHeight
		end
    end
end

do Position = class()
    Position.Type  = Enum { "Absolute", "Relative" }
    Position.Sides = Enum { "Left", "Right", "Top", "Bottom" }
    
    function Position:init(arg)
		arg = arg or {}
		
        self.left   = arg.left
        self.top    = arg.top
        self.bottom = arg.bottom
        self.right  = arg.right
        
        self.alignment = arg.alignment or {}
		
		if not (self.left or self.right) then
			self.left = 0
		end
		
		if not (self.top or self.bottom) then
			self.top = 0
		end
    end
    
    function Position:get(parentX, parentY, parentWidth, parentHeight, width, height, dirty)
		if dirty or not self.cachedX then			
			local x, y
			local originX = parentX
			local originY = parentY
			
			for _, alignment in ipairs(self.alignment) do
				local side = alignment.side
				local ref = alignment.ref
				local refWidth, refHeight = ref:getDimension()
				local refX, refY = ref:getPosition()
				
				if side == Position.Sides.Left then
					originX = refX
				elseif side == Position.Sides.Right then
					originX = refX + refWidth
				elseif side == Position.Sides.Top then
					originY = refY
				elseif side == Position.Sides.Bottom then
					originY = refY + refHeight
				else
					Logger.Warn("Invalid side specified")
				end
			end
			
			if self.left then
				x = originX + self.left
			elseif self.right then
				x = originX - self.right - width
			end
			
			if self.top then
				y = originY + self.top
			elseif self.bottom then
				y = originY - self.bottom - height
			end
			
			self.cachedX = x
			self.cachedY = y
        end
		
        return self.cachedX, self.cachedY
    end
    
end