local Class = require "Class"
local SceneryEntity = Class()

--[[The SceneryEntity class is the base class for all environment objects
	(collectables, obstacles, powerups, etc.).
--]]

-- initialize SceneryEntity object
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

-- get the SceneryEntity's position as (x,y) coordinates
function SceneryEntity:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

-- draw SceneryEntity
function SceneryEntity:onRender()
	love.graphics.setColor(0, 0, 0, 255)
	local x, y = self:getPosition()
	local numberOfSegments = 50
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)
end

-- process collision with SceneryEntity
function SceneryEntity:onCollision(contact, otherEntity)
	local body = otherEntity.body	
end

-- prepare SceneryEntity for collisions
function SceneryEntity:awaken(map)
	self.body:isActive(true)
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
	self.fixture:setRestitution(0.9)
end

-- stop checking SceneryEntity for collisions
function SceneryEntity:sleep(map)
	self.body:isActive(false)
	self.fixture:destroy()
end

return SceneryEntity
