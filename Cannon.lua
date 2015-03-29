local Class = require "Class"
local Cannon = Class()

function Cannon:__init__(game, x, y, launchImpulseX, launchImpulseY)
	self.game = game
	self.radius = 10
	self.launchImpulseX = launchImpulseX
	self.launchImpulseY = launchImpulseY
	local mass = 1
	self.x = x
	self.y = y
	--[[self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, x, y, "static")
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)]]
end

function Cannon:getPosition()
	--local x, y = self.body:getPosition()
	return self.x, self.y
end

function Cannon:onRender()
	love.graphics.setColor(0, 0, 0, 255)
	local x, y = self:getPosition()
	local numberOfSegments = 50
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)
end

function Cannon:beforePhysicsUpdate(seconds)
	local player = self.game.entities.player
	local px, py = player:getPosition()
	local cx, cy = player:getPosition()
	local dx, dy = (px - cx), (py - cy)
	if dx * dx + dy * dy < self.radius * self.radius then
		player.body:applyLinearImpulse(self.launchImpulseX, self.launchImpulseY)
	end
end

function Cannon:onCollision(contact, otherEntity)
	--[[local body = otherEntity.body
	if body then
		--local ox, oy = body:getPosition()
		--local sx, sy = body:getPosition()
		body:applyLinearImpulse(self.launchImpulseX, self.launchImpulseY)
	end]]
end

return Cannon
