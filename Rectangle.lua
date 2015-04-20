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

function Rectangle:overlaps(other)
	local sx = self.x + self.width * 0.5
	local ox = other.x + other.width * 0.5
	local sy = self.y + self.height * 0.5
	local oy = other.y + other.height * 0.5
	local dx = sx - ox
	local dy = sy - oy
	local thw = (self.width + other.width) * 0.5
	local thh = (self.height + other.height) * 0.5
	return math.abs(dx) <= thw and math.abs(dy) <= thh
end

return Rectangle
