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
function PowerupFactory:__init__(kind, game)
    self.game = game
	self.image = self.game.assetManager:acquire("Assets/FairyImage.lua")
	--if kind == 1 then
	--elseif kind == 2 then
	--end
end



return PowerupFactory
