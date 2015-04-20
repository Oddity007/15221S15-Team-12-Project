local Class = require "Class"
local Player = Class()

--[[The Player class represents the player character in the game. It
	includes methods to move and display the character.
--]]

-- initialize Player object
function Player:__init__(game)
	self.game = game
	self.radius = 20
	local startX, startY = 0, 0
	local mass = 1
	self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, startX, startY, "dynamic")
	self.body:setLinearDamping(0.1)
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
	self.fixture:setRestitution(0.9)

	self.cloudImage = self.game.assetManager:acquire("Assets/ExampleImage.lua")
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
	love.graphics.setColor(0, 255, 0, 255)
	local x, y = self:getPosition()
	--more segments makes for a smoother circle but takes more resources
	--local numberOfSegments = 50
	--love.graphics.circle("fill", x, y, self.radius, numberOfSegments)

	love.graphics.setColor(255, 255, 255, 255)
	-- makes the image center the center of the object
	love.graphics.draw(self.cloudImage, x - self.radius, y - self.radius, 0, 0.1, 0.1, 0, 0)

	love.graphics.setColor(0, 0, 0, 255)
end

-- update forces on Player depending on player input
function Player:beforePhysicsUpdate(seconds)
	local force = 50
	local velocityX, velocityY = self.body:getLinearVelocity()


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
--[[ Need to find a way to communicate with this method to apply physics
 effects based off of what the player hit!  Changed dampingFactor to something
 that is sent in.  Original code is commented out, does not work for now.]]--
function Player:afterPhysicsUpdate(seconds)
	local velocityX, velocityY = self.body:getLinearVelocity()
	local dampingFactor = -1
	self.body:applyForce(dampingFactor * velocityX, dampingFactor * velocityY)

	--[[-- to limit velocity; not done yet; does not take into account cannons
	if velocityX > 15 then
		velocityX = 15
	elseif velocityX < -15 then
		velocityX = -15
	end
	if velocityY > 15 then
		velocityY = 15
	elseif velocityY < -15 then
		velocityY = -15
	end
	if velocityX + velocityY > 15 then
		velocityX = 7.5
		velocityY = 7.5
	elseif velocityX + velocityY < -15 then
		velocityX = -7.5
		velocityY = -7.5
	end
	self.body:setLinearVelocity(velocityX, velocityY)]]
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
