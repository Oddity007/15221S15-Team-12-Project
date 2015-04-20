local Class = require "Class"
local Collectable = Class()

--[[The Collectable class is for indistinguishable objects that
	add to a score count when the player touches them.
--]]

-- initialize Collectable object
function Collectable:__init__(game, x, y)
	self.game = game
	self.radius = 5
	local mass = 1
	self.shape = love.physics.newCircleShape(self.radius)
	self.body = love.physics.newBody(game.world, x, y, "static")
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
end

-- draw Collectable
function Collectable:onRender()
	love.graphics.setColor(30, 150, 50, 255)
	local x, y = self:getPosition()
	local numberOfSegments = 50
	love.graphics.circle("fill", x, y, self.radius, numberOfSegments)
end

-- NYI
function Collectable:onContact(contact, otherEntity)

end

-- process collision with Collectable
function Collectable:onCollision(contact, otherEntity)
	self.body:destroy()
	self.fixture:destroy()
	self.game.entities.map:removeEntity(self)
	self.game:removeEntity(self)
end

function Collectable:setRestitution(to)
	self.fixture:setRestitution(to)
end

-- get the Collectable's position as (x,y) coordinates
function Collectable:getPosition()
	local x, y = self.body:getPosition()
	return x, y
end

-- prepare Collectable for collisions
function Collectable:awaken(map)
	self.body:isActive(true)
	self.fixture = love.physics.newFixture(self.body, self.shape, mass)
	self.fixture:setUserData(self)
end

-- stop checking Collectable for collisions
function Collectable:sleep(map)
	self.body:isActive(false)
	self.fixture:destroy()
end

return Collectable
