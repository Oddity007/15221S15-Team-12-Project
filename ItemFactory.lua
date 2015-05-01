local Class = require "Class"
local ItemFactory = Class()


--[[The ItemFactory class is to create item objects that will serve as
	goal collectables for the game.
	It will decouple individual types of item creation from other code.
--]]


-- initialize ItemFactory object
-- sets kind to
function ItemFactory:__init__(game, x, y, owningItem)
	local numKinds = 15
	self.owningItem = owningItem
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
		self.game.assetManager:acquire("Assets/GoalCollectables/BaseballBatAndBall.lua")
	elseif self.kind > 20  and self.kind <= 50 then
		self.kind = 2
		self.image =
		self.game.assetManager:acquire("Assets/GoalCollectables/Boomerang.lua")
	elseif self.kind > 50  and self.kind <= 60 then
		self.kind = 3
		self.image =
		self.game.assetManager:acquire("Assets/GoalCollectables/EzelAndPaintbrush.lua")
	elseif self.kind > 60  and self.kind <= 65 then
		self.kind = 4
		self.image =
		self.game.assetManager:acquire("Assets/GoalCollectables/FairyImageGreen.lua")
	elseif self.kind > 65  and self.kind <= 80 then
		self.kind = 5
		self.image =
		self.game.assetManager:acquire("Assets/GoalCollectables/FairyImageGold.lua")
	elseif self.kind > 80  and self.kind <= 90 then
		self.kind = 6
		self.image =
		self.game.assetManager:acquire("Assets/GoalCollectables/FairyImageBlue.lua")
	else
		self.kind = 7
		self.image =
		self.game.assetManager:acquire("Assets/GoalCollectables/FairyImageViolet.lua")
	end
end

-- prepare Item for collisions
function ItemFactory:awaken(map)
	self.body:isActive(true)
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
	self.bodyStatus = true
end

-- Process contact with Item
function ItemFactory:onContact(contact, otherEntity)
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
	self.owningItem:onContact(contact, otherEntity)
end


-- stop checking Item for collisions
function ItemFactory:sleep(map)
	self.body:isActive(false)
	self.fixture:destroy()
	self.bodyStatus = false
end

-- get the Item's position as (x,y) coordinates
function ItemFactory:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

return ItemFactory
