local Class = require "Class"
local Tunnel = Class()

--[[The Tunnel class represents the portals between areas in the game. When
	the player enters one, he or she warps to a new level/area.
--]]

-- initialize Tunnel object
function Tunnel:__init__(game, x, y, id)
	self.game = game
	self.radius = 10
	self.x = x
	self.y = y
	self.id = id
	self.shouldWaitUntilPlayerLeaves = false
end

-- get the Tunnel's position as (x,y) coordinates
function Tunnel:getPosition()
	--local x, y = self.body:getPosition()
	return self.x, self.y
end

-- draw Tunnel
function Tunnel:onRender()
	--love.graphics.setColor(0, 0, 0, 255)
	local x, y = self:getPosition()
	--local numberOfSegments = 50
	love.graphics.setColor(255, 255, 0)
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)
	love.graphics.setColor(0, 0, 0)
end

-- check if Player has entered Tunnel
function Tunnel:beforePhysicsUpdate(seconds)
	local player = self.game.entities.player
	local px, py = self:getPosition()
	local cx, cy = player:getPosition()
	local dx, dy = (px - cx), (py - cy)
	if dx * dx + dy * dy < self.radius * self.radius then
		if not self.shouldWaitUntilPlayerLeaves then
			self.game:enterTunnel(self.id)
		end
	else
		self.shouldWaitUntilPlayerLeaves = false
	end
end

return Tunnel
