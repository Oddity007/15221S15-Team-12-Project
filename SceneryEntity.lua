local Class = require "Class"
local SceneryEntity = Class()

function SceneryEntity:__init__(game, x, y)
	self.game = game
	self.radius = 10
	local mass = 1
	self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, x, y, "static")
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
	self.fixture:setRestitution(0.9)
end

function SceneryEntity:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

function SceneryEntity:onRender()
	love.graphics.setColor(0, 0, 0, 255)
	local x, y = self:getPosition()
	local numberOfSegments = 50
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)
end

function SceneryEntity:onCollision(contact, otherEntity)
	local body = otherEntity.body	
end

function SceneryEntity:awaken(map)
	self.body:isActive(true)
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
	self.fixture:setRestitution(0.9)
end

function SceneryEntity:sleep(map)
	self.body:isActive(false)
	self.fixture:destroy()
end

return SceneryEntity
