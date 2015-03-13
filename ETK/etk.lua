----------------------------------
-- ETK 4.0                      --
--                              --
-- (C) 2015 Jim Bauwens         --
-- Licensed under the GNU GPLv3 --
----------------------------------

etk = {}

do
	local etk = etk
	
	--include "helpers.lua"
	--include "graphics.lua"
	--include "screenmanager.lua"
	--include "viewmanager.lua"
	--include "eventmanager.lua"
	--include "widgetmanager.lua"
end

do
	local Button = etk.Widgets.Button
	local Input = etk.Widgets.Input
	local myView = etk.View()
	
	
	local box1 = Box(
					Position {
                        top  = "50px",
                        left   = "100px"
                    },
                    Dimension ("100px", "10%"),
				   "Hello world")
	
	local box2 = Box(
                   	Position {
						top  = "50px",
						left   = "2px",
						alignment = {
						  {ref=box1, side=Position.Sides.Right}
						}
                    },
                    Dimension ("50px", "10%"),
					"Hello!")
	
	local box3 = Box(
				Position {
					top  = "2px",
					left = "0",
					alignment = {
					  {ref=box2, side=Position.Sides.Bottom},
					  {ref=box2, side=Position.Sides.Left}
					}
				},
				Dimension ("50px", "20%"),
				"Yolo")
	
	local button1 = Button {
		position = Position { bottom  = "2px", right = "2px" },
		text = "Button1"
	}
	
	local button2 = Button {
		position = Position { bottom  = "2px", right = "2px", alignment = {{ref=button1, side=Position.Sides.Left}}},
		text = "Button2"
	}
	
	local input1 = Input {
		position = Position { top  = "2px", left = "2px" },
		value = "1000"
	}
	input1.disabled = true

	local input2 = Input {
		position = Position { top  = "2px", left = "2px", alignment = {{ref=input1, side=Position.Sides.Bottom}}},
		value = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	}	
	input2.dimension.width = Input.defaultStyle.defaultWidth * 2
	
	myView:addChildren(box1, box2, box3, button1, button2, input1, input2)
    	
	
	function button2:charIn(char)
		self.text = self.text .. char
		
		self.parent:invalidate()
	end
	
	button2.onAction = λ -> input1.value++;
	button2.redrawParentOnChange = true
	
	function myView:draw(gc, x, y, width, height)
		Logger.Log("in myView draw")
	end
	
	
	
	etk.RootScreen:pushScreen(myView)
end