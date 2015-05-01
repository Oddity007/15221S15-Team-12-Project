local Class = require "Class"
local Item = Class()

--[[The Item class is for unique objects the player collects as part
	of the story or to give them certain powers
--]]

-- initialize Item object
function Item:__init__(game, x, y, name)
	self.game = game
	self.radius = 16
	local mass = 1
	self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, x, y, "static")
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
	self.image =
		love.graphics.newImage("Assets/GoalCollectables/" .. name .. ".png")
end

-- draw Item
function Item:onRender()
	love.graphics.setColor(150, 150, 150, 255)
	local x, y = self:getPosition()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.image,
						x - self.radius,
						y - self.radius,
						0, 0.5, 0.5, 0, 0)
end

-- process collision with Item
function Item:onCollision(contact, otherEntity)
	self.body:destroy()
	self.fixture:destroy()
	self.game.entities.map:removeEntity(self)
	self.game:removeEntity(self)
end

function Item:setRestitution(to)
	self.fixture:setRestitution(to)
end

-- get the Item's position as (x,y) coordinates
function Item:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

-- prepare Item for collisions
function Item:awaken(map)
	self.body:isActive(true)
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
end

-- stop checking Item for collisions
function Item:sleep(map)
	self.body:isActive(false)
	self.fixture:destroy()
end

return Item
