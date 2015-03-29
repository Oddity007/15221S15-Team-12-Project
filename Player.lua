local Class = require "Class"
local Player = Class()

function Player:__init__(game)
	self.game = game
	self.radius = 10
	local startX, startY = 0, 0
	local mass = 1
	self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, startX, startY, "dynamic")
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
	self.fixture:setRestitution(0.9)
end

function Player:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

function Player:setPosition(x, y)
	self.body:setPosition(x, y)
end

function Player:onRender()
	love.graphics.setColor(0, 0, 0, 255)
	local x, y = self:getPosition()
	local numberOfSegments = 50
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)
end

function Player:beforePhysicsUpdate(seconds)
	local force = 1000

	if love.keyboard.isDown("w") then
		self.body:applyForce(0, -force)
	end
	
	if love.keyboard.isDown("s") then
		self.body:applyForce(0, force)
	end

	if love.keyboard.isDown("a") then
		self.body:applyForce(-force, 0)
	end

	if love.keyboard.isDown("d") then
		self.body:applyForce(force, 0)
	end
end

function Player:afterPhysicsUpdate(seconds)
	--Implements the damping portion of a spring-damper system
	local velocityX, velocityY = self.body:getLinearVelocity()
	local dampingFactor = -10
	self.body:applyForce(dampingFactor * velocityX, dampingFactor * velocityY)
end

function Player:onCollision(contact, otherEntity)
	
end

function Player:onMousePress(x, y, button)
	if button == "r" then
		
	elseif button == "l" then
		
	end
end

function Player:onKeyPress(key, unicode)
	
end

return Player
