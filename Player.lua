local Class = require "Class"
local Player = Class()

local Rectangle = require "Rectangle"

--[[The Player class represents the player character in the game. It
	includes methods to move and display the character.
--]]

-- initialize Player object
function Player:__init__(game, character)
	self.game = game
	self.character = character
	self.radius = 8
	self.isPlayer = true
	local startX, startY = 0, 0
	local mass = 1
	self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, startX, startY, "dynamic")
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
	self.fixture:setRestitution(0.75)

	-- girl
	if self.character == 1 then
		self.frontImage =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlFront.lua")
		self.frontImageStep1 =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlFront1.lua")
		self.frontImageStep2 =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlFront2.lua")

		self.sideImageLeft =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlSideLeft.lua")
		self.sideImageLeftStep1 =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlSideLeft1.lua")
		self.sideImageLeftStep2 =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlSideLeft2.lua")

		self.sideImageRight =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlSideRight.lua")
		self.sideImageRightStep1 =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlSideRight1.lua")
		self.sideImageRightStep2 =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlSideRight2.lua")

		self.backImage =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlBack.lua")
		self.backImageStep1 =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlBack1.lua")
		self.backImageStep2 =
	self.game.assetManager:acquire("Assets/CharacterSprites/GirlBack2.lua")
	-- boy
	else
		self.frontImage =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoyFront.lua")
		self.frontImageStep1 =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoyFront1.lua")
		self.frontImageStep2 =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoyFront2.lua")

		self.sideImageLeft =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoySideLeft.lua")
		self.sideImageLeftStep1 =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoySideLeft1.lua")
		self.sideImageLeftStep2 =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoySideLeft2.lua")

		self.sideImageRight =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoySideRight.lua")
		self.sideImageRightStep1 =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoySideRight1.lua")
		self.sideImageRightStep2 =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoySideRight2.lua")

		self.backImage =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoyBack.lua")
		self.backImageStep1 =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoyBack1.lua")
		self.backImageStep2 =
	self.game.assetManager:acquire("Assets/CharacterSprites/BoyBack2.lua")
	end

	self.image = self.frontImage
	self.index = 0
	--self.frames = {self.frontImage, self.backImage}

	self.freezeTimeRemaining = 0
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
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)

	love.graphics.setColor(255, 255, 255, 255)
	-- makes the image center the center of the object
	--love.graphics.draw(self.image, x - self.radius, y - self.radius, 0, 1/4, 1/4, 0, 0)
	local scale = 1/4
	love.graphics.draw(self.image, x - self.image:getWidth()/2 * scale, y - self.radius, 0, scale, scale, 0, 0)

	love.graphics.setColor(0, 0, 0, 255)
end

-- update forces on Player depending on player input
function Player:beforePhysicsUpdate(seconds)
--<<<<<<< HEAD
	local force = 400
--=======
	--local force = 50
-->>>>>>> 0603a07b204b577ecd3b0115072ad2544bb5bf73
	local velocityX, velocityY = self.body:getLinearVelocity()

	if self.index == 119 then
		self.index = 0
	else
		self.index = self.index + 1
	end

	local canWalk = self:canWalk()

	self.freezeTimeRemaining = self.freezeTimeRemaining - seconds

	if self.freezeTimeRemaining < 0 then
		self.freezeTimeRemaining = 0
		self.game:setTimeDilation(1)
	end

	--slow time
	if self.freezeTimeRemaining <= 0 and love.keyboard.isDown("lshift") then
		self.game:setTimeDilation(1/32)
		canWalk = true
		self.freezeTimeRemaining = 2 / 32
	end

	if self.freezeTimeRemaining > 0 and love.mouse.isDown("l") then
		local mx, my = love.mouse.getPosition()
		local px, py = self:getPosition()
		local dx, dy = mx - px, my - px
		local magnitude = math.sqrt(dx * dx + dy * dy)
		local speed = math.sqrt(velocityX * velocityX + velocityY * velocityY)
		local minimumSpeed = 0
		if speed < minimumSpeed then
			speed = minimumSpeed
		end
		dx = dx / magnitude
		dy = dy / magnitude
		self.body:setLinearVelocity(dx * speed, dy * speed)
	end

	--up
	if love.keyboard.isDown("w") and canWalk then
		self.body:applyForce(0, -force)
		--self.image = self.frames[index]
		--if not self.image then
		--	print("wtf", self.index)
		--end
		--self.image = self.backImage
		if self.index == 0 or self.index == 60 then
			self.image = self.backImage
		elseif self.index == 30 then
			self.image = self.backImageStep1
		elseif self.index == 90 then
			self.image = self.backImageStep2
		end
	end

	--down
	if love.keyboard.isDown("s") and canWalk then
		self.body:applyForce(0, force)
		if self.index == 0 or self.index == 60 then
			self.image = self.frontImage
		elseif self.index == 30 then
			self.image = self.frontImageStep1
		elseif self.index == 90 then
			self.image = self.frontImageStep2
		end
	end

	--left
	if love.keyboard.isDown("a") and canWalk then
		self.body:applyForce(-force, 0)
		if self.index == 0 or self.index == 60 then
			self.image = self.sideImageLeft
		elseif self.index == 30 then
			self.image = self.sideImageLeftStep1
		elseif self.index == 90 then
			self.image = self.sideImageLeftStep2
		end
	end

	--right
	if love.keyboard.isDown("d") and canWalk then
		self.body:applyForce(force, 0)
		if self.index == 0 or self.index == 60 then
			self.image = self.sideImageRight
		elseif self.index == 30 then
			self.image = self.sideImageRightStep1
		elseif self.index == 90 then
			self.image = self.sideImageRightStep2
		end
	end
end

-- implements the damping portion of a spring-damper system
function Player:afterPhysicsUpdate(seconds)
	local velocityX, velocityY = self.body:getLinearVelocity()
	local dampingFactor = -0.1
	if self:canWalk() then
		dampingFactor = -5
	end
	self.body:applyForce(dampingFactor * velocityX, dampingFactor * velocityY)
end

function Player:canWalk()
	local velocityX, velocityY = self.body:getLinearVelocity()
	local squaredSpeed = velocityX * velocityX + velocityY * velocityY
	return squaredSpeed < 10000
end

-- NYI
function Player:onContact(contact, otherEntity)

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
