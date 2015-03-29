local Class = require "Class"
local Tunnel = Class()

function Tunnel:__init__(game, x, y, id)
	self.game = game
	self.radius = 10
	self.x = x
	self.y = y
	self.id = id
end

function Tunnel:getPosition()
	--local x, y = self.body:getPosition()
	return self.x, self.y
end

function Tunnel:onRender()
	love.graphics.setColor(0, 0, 0, 255)
	local x, y = self:getPosition()
	local numberOfSegments = 50
	love.graphics.setColor(255, 255, 0)
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)
	love.graphics.setColor(0, 0, 0)
end

function Tunnel:beforePhysicsUpdate(seconds)
	local player = self.game.entities.player
	local px, py = self:getPosition()
	local cx, cy = player:getPosition()
	local dx, dy = (px - cx), (py - cy)
	if dx * dx + dy * dy < self.radius * self.radius then
		self.game:enterTunnel(self.id)
	end
end

return Tunnel
