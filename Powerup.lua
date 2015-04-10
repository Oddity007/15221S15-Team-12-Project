local Class = require "Class"
local Powerup = Class()

--[[The Powerup class is for indistinguishable objects that
	add to a score count when the player touches them.
--]]

-- initialize Powerup object
function Powerup:__init__(game, x, y, kind)
	self.game = game
	self.radius = 5
	local mass = 1
	self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, x, y, "static")
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)

	--self.kind = PowerupFactory(kind)

	--will not need to set this once PowerupFactory is made
	self.image = self.game.assetManager:acquire("Assets/FairyTest.png")
end

-- draw Powerup
function Powerup:onRender()
	love.graphics.setColor(0, 0, 255, 255)
	local x, y = self:getPosition()
	local numberOfSegments = 50
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)

	--love.graphics.draw(kind.image, x, y, 0, 0.1, 0.1, 0, 0)
	love.graphics.draw(self.image, x, y, 0, 0.1, 0.1, 0, 0)
end

-- process collision with Powerup
function Powerup:onCollision(contact, otherEntity)
    --Apply effect based on kind
	self.body:destroy()
	self.fixture:destroy()
	self.game.entities.map:removeEntity(self)
	self.game:removeEntity(self)
end

function Powerup:setRestitution(to)
	self.fixture:setRestitution(to)
end

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
