local Class = require "Class"
local Cannon = Class()

function Cannon:__init__(game, x, y, launchImpulseX, launchImpulseY)
	self.game = game
	self.radius = 50
	self.launchImpulseX = launchImpulseX
	self.launchImpulseY = launchImpulseY
	local mass = 1
	self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, x, y, "static")
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
end

function Cannon:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

function Cannon:onRender()
	love.graphics.setColor(0, 0, 0, 255)
	local x, y = self:getPosition()
	local numberOfSegments = 50
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)
end

function Cannon:onCollision(contact, otherEntity)
	local body = otherEntity.body
	if body then
		--local ox, oy = body:getPosition()
		--local sx, sy = body:getPosition()
		body:applyLinearImpulse(self.launchImpulseX, self.launchImpulseY)
	end
end

return Cannon
