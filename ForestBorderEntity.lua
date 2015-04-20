local Class = require "Class"
local ForestBorderEntity = Class()

function ForestBorderEntity:__init__(game, x, y, width, height)
	self.game = game
	self.width = width
	self.height = height
	self.mass = 1
	self.restitution = 1
	self.shape = love.physics.newRectangleShape(width, height)
	self.body = love.physics.newBody(game.world, x, y, "static")
	self.fixture = love.physics.newFixture(self.body, self.shape, self.mass)
	self.fixture:setUserData(self)
	self.fixture:setRestitution(self.restitution)
end

function ForestBorderEntity:setRestitution(to)
	self.restitution = to
	self.fixture:setRestitution(to)
end

function ForestBorderEntity:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

function ForestBorderEntity:onCollision(contact, otherEntity)
	local body = otherEntity.body	
end


function ForestBorderEntity:awaken(map)
	self.body:isActive(true)
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
	self.fixture:setRestitution(self.restitution)
end

function ForestBorderEntity:sleep(map)
	self.body:isActive(false)
	self.fixture:destroy()
end

return ForestBorderEntity
