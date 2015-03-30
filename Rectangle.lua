local Class = require "Class"
local Rectangle = Class()

--[[The Rectangle class is used when we need to test if a point is within
	a particular rectangular region (typically for collision detection).
--]]

function Rectangle:__init__(x, y, w, h)
	self.x = x
	self.y = y
	self.width = w
	self.height = h
end

function Rectangle:containsPoint(x, y)
	return (x > self.x and x < self.width + self.x) and (y > self.y and y < self.height + self.y)
end

return Rectangle