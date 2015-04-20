local Class = require "Class"
local PowerupFactory = Class()


--[[The PowerupFactory class is to create powerup objects that will add
	temporary effects to the game.
	It will decouple individual types of powerup creation from other code.
	Time Slow/Fast
	Momentum Gain/Loss
--]]


-- initialize PowerupFactory object
-- sets kind to
function PowerupFactory:__init__(game, x, y)
	local numKinds = 100
	self.kind = math.random(numKinds)
    self.game = game
    self.radius = 16
	local mass = 0
	self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, x, y, "static")
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)
	self.bodyStatus = true

	if self.kind > 0 and self.kind <= 20 then
		self.kind = 1
		self.image =
		self.game.assetManager:acquire("Assets/Powerups/TimeImageSpeed.lua")
	elseif self.kind > 20  and self.kind <= 50 then
		self.kind = 2
		self.image =
		self.game.assetManager:acquire("Assets/Powerups/TimeImageSlow.lua")
	elseif self.kind > 50  and self.kind <= 60 then
		self.kind = 3
		self.image =
		self.game.assetManager:acquire("Assets/Powerups/FairyImageRed.lua")
	elseif self.kind > 60  and self.kind <= 65 then
		self.kind = 4
		self.image =
		self.game.assetManager:acquire("Assets/Powerups/FairyImageGreen.lua")
	elseif self.kind > 65  and self.kind <= 80 then
		self.kind = 5
		self.image =
		self.game.assetManager:acquire("Assets/Powerups/FairyImageGold.lua")
	elseif self.kind > 80  and self.kind <= 90 then
		self.kind = 6
		self.image =
		self.game.assetManager:acquire("Assets/Powerups/FairyImageBlue.lua")
	else
		self.kind = 7
		self.image =
		self.game.assetManager:acquire("Assets/Powerups/FairyImageViolet.lua")
	end
end

-- prepare Powerup for collisions
function PowerupFactory:awaken(map)
	self.body:isActive(true)
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
end

-- Process contact with powerup
function PowerupFactory:onContact(contact, otherEntity)
    --Apply effect based on kind
	if self.kind == 1 then
		self.game:addTimeOffset(-5)
	elseif self.kind == 2 then
		self.game:addTimeOffset(5)
	else
		local xVector, yVector = otherEntity.body:getLinearVelocity()
		if self.kind == 3 then
			xVector = -xVector * 4
			yVector = -yVector * 4
		elseif self.kind == 4 then
			xVector = xVector / 2
			yVector = yVector / 2
		elseif self.kind == 5 then
			xVector = -xVector / 2
			yVector = -yVector / 2
		elseif self.kind == 6 then
			xVector = xVector / 4
			yVector = yVector / 4
		else
			xVector = -xVector * 2
			yVector = -yVector * 2
		end
		otherEntity.body:applyLinearImpulse(xVector, yVector)
	end

    self.body:destroy()
	self.fixture:destroy()
	self.bodyStatus = false
end


-- stop checking Powerup for collisions
function PowerupFactory:sleep(map)
	self.body:isActive(false)
	self.fixture:destroy()
end

-- get the Powerup's position as (x,y) coordinates
function PowerupFactory:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

return PowerupFactory
