local Class = require "Class"
local Powerup = Class()

local PowerupFactory = require "PowerupFactory"

--[[The Powerup class is for powerup objects that
	add temporary effects to the game.
	Time Slow/Fast
	Momentum Gain/Loss
--]]

-- initialize Powerup object
function Powerup:__init__(game, x, y)
	self.game = game
	self.kind = PowerupFactory(game, x, y, self)
end

-- draw Powerup
function Powerup:onRender()
	local x, y
	love.graphics.setColor(255, 255, 255, 255)
	if self.kind.bodyStatus then
		x, y = self.kind:getPosition()
		love.graphics.draw(self.kind.image,
						   x - self.kind.radius,
						   y - self.kind.radius,
						   0, 0.5, 0.5, 0, 0)
	end
end

-- process contact with Powerup
function Powerup:onContact(contact, otherEntity)
    --Apply effect based on kind
	--self.kind:onContact(contact, otherEntity)
	self.game.entities.map:removeEntity(self)
	self.game:removeEntity(self)
	if otherEntity.isPlayer then
		self.game.soundManager:play("Assets/Sounds/Pickup1.ogg", nil, false, 1/8)
	end
end

function Powerup:afterPhysicsUpdate(seconds)

end

-- prepare Powerup for collisions
function Powerup:awaken(map)
	self.kind:awaken(map)
end

-- stop checking Powerup for collisions
function Powerup:sleep(map)
	self.kind:sleep(map)
end

-- get the Powerup's position as (x,y) coordinates
function Powerup:getPosition()
	return self.kind:getPosition()
end

return Powerup
