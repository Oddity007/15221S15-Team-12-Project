local Class = require "Class"
local Player = Class()

--[[The Player class represents the player character in the game. It
	includes methods to move and display the character.
--]]

-- initialize Player object
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

-- get the Player's position as (x,y) coordinates
function Player:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

-- set the Player's position with (x,y) coordinates
function Player:setPosition(x, y)
	self.body:setPosition(x, y)
end

-- draw Player
function Player:onRender()
	love.graphics.setColor(0, 0, 0, 255)
	local x, y = self:getPosition()
	--more segments makes for a smoother circle but takes more resources
	local numberOfSegments = 50
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)
end

-- update forces on Player depending on player input
function Player:beforePhysicsUpdate(seconds)
	local force = 100

	--up
	if love.keyboard.isDown("w") then
		self.body:applyForce(0, -force)
	end
	
	--down
	if love.keyboard.isDown("s") then
		self.body:applyForce(0, force)
	end

	--left
	if love.keyboard.isDown("a") then
		self.body:applyForce(-force, 0)
	end

	--right
	if love.keyboard.isDown("d") then
		self.body:applyForce(force, 0)
	end

	--slow time
	if love.keyboard.isDown("lshift") then
		self.game:setTimeDilation(1/8)
	else
		self.game:setTimeDilation(1)
	end
end

-- implements the damping portion of a spring-damper system
function Player:afterPhysicsUpdate(seconds)
	local velocityX, velocityY = self.body:getLinearVelocity()
	local dampingFactor = -1
	self.body:applyForce(dampingFactor * velocityX, dampingFactor * velocityY)
end

-- NYI
function Player:onCollision(contact, otherEntity)
	
end

-- NYI
function Player:onMousePress(x, y, button)
	if button == "r" then
		
	elseif button == "l" then
		
	end
end

-- NYI
function Player:onKeyPress(key, unicode)
	
end

return Player
