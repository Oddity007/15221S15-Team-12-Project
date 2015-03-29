local Class = require "Class"
local Map = Class()

local Cannon = require "Cannon"
local SceneryEntity = require "SceneryEntity"
local Tunnel = require "Tunnel"

function Map:__init__(game, entraceTunnelID)
	self.game = game
	self.entities = {}
	
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	for i=1,math.random(1, 100) do
		local x = width * math.random()
		local y = height * math.random()
		local entity = SceneryEntity(self.game, x, y)
		self.game.entities[#self.game.entities + 1] = entity
		self.entities[#self.entities + 1] = entity
	end	

	local tunnelIDs = {}
	local exitTunnelID = self.game:generateNewTunnelID(true, entraceTunnelID)
	do
		local x = width * math.random()
		local y = height * math.random()
		local entity = Tunnel(self.game, x, y, exitTunnelID)
		self.game.entities[#self.game.entities + 1] = entity
		self.entities[#self.entities + 1] = entitye
		self.game.entities.player:setPosition(x + 20, y + 20)
	end
	tunnelIDs[#tunnelIDs + 1] = exitTunnelID
	for i=1,2 --[[math.random(2, 4) ]] do
		local x = width * math.random()
		local y = height * math.random()
		local id = self.game:generateNewTunnelID(math.random(1, 2) == 1)
		local entity = Tunnel(self.game, x, y, id)
		self.game.entities[#self.game.entities + 1] = entity
		self.entities[#self.entities + 1] = entity
		tunnelIDs[#tunnelIDs + 1] = id
	end
	self.game:registerMapTunnelIDs(self, tunnelIDs)
end

function Map:sleep()
	for _, entity in pairs(self.entities) do
		local f = entity.sleep
		if f then f(entity, self) end
	end
end

function Map:awaken()
	for _, entity in pairs(self.entities) do
		self.game.entities[#self.game.entities + 1] = entity
	end
	for _, entity in pairs(self.entities) do
		local f = entity.awaken
		if f then f(entity, self) end
	end
end

return Map
