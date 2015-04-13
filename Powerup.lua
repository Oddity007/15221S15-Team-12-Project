local Class = require "Class"
local Powerup = Class()

local PowerupFactory = require "PowerupFactory"

--[[The Powerup class is for powerup objects that
	add temporary effects to the game.
	Time Slow/Fast
	Momentum Gain/Loss
--]]

-- initialize Powerup object
function Powerup:__init__(game, x, y, kind)
	self.game = game
	self.radius = 15
	local mass = 1
	self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, x, y, "static")
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)

	self.kind = PowerupFactory(kind, game)
end

-- draw Powerup
function Powerup:onRender()
	love.graphics.setColor(0, 0, 255, 255)
	local x, y = self:getPosition()
	--local numberOfSegments = 50
	--love.graphics.circle("fill", x, y, self.radius, numberOfSegments)

	love.graphics.draw(self.kind.image, x - self.radius, y - self.radius, 0, 0.4, 0.4, 0, 0)
end

-- process collision with Powerup
function Powerup:onCollision(contact, otherEntity)
    --Apply effect based on kind
	self.body:destroy()
	self.fixture:destroy()
	self.game.entities.map:removeEntity(self)
	self.game:removeEntity(self)
end

--[[function Powerup:setRestitution(to)
	self.fixture:setRestitution(to)
end
]]--

-- get the Powerup's position as (x,y) coordinates
function Powerup:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

-- prepare Powerup for collisions
function Powerup:awaken(map)
	self.body:isActive(true)
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
end

-- stop checking Powerup for collisions
function Powerup:sleep(map)
	self.body:isActive(false)
	self.fixture:destroy()
end

return Powerup
