local Class = require "Class"
local Map = Class()

local Cannon = require "Cannon"
local SceneryEntity = require "SceneryEntity"
local Collectable = require "Collectable"
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
		entity:setRestitution(math.random() * 2)
		self.game.entities[#self.game.entities + 1] = entity
		self.entities[#self.entities + 1] = entity
	end	

---[[
	for i=1,math.random(1, 20) do
		local x = width * math.random()
		local y = height * math.random()
		local collect = Collectable(self.game, x, y)
		self.game.entities[#self.game.entities + 1] = collect
		self.entities[#self.entities + 1] = collect
	end	
--]]

	local tunnels = {}
	local tunnelIDs = {}
	local exitTunnelID = self.game:generateNewTunnelID(true, entraceTunnelID)
	do
		local x = width * math.random()
		local y = height * math.random()
		local entity = Tunnel(self.game, x, y, exitTunnelID)
		self.game.entities[#self.game.entities + 1] = entity
		self.entities[#self.entities + 1] = entity
		self.game.entities.player:setPosition(x + 20, y + 20)
		tunnels[#tunnels + 1] = entity
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
		tunnels[#tunnels + 1] = entity
	end
	self.game:registerMapTunnelIDs(self, tunnelIDs)

	--To do: Generate cannon paths first, then generate object placements
	--That would make this actually playable

	--Randomly generate cannon paths between all tunnels
	for i = 1, #tunnels do
	for j = 1, #tunnels do
		if i ~= j then
			local n = math.random(1, 3)
			local xs = {}
			local ys = {}
			local x, y = tunnels[i]:getPosition()
			x = x + (math.random() * 2 - 1) * 25
			y = y + (math.random() * 2 - 1) * 25
			xs[#xs + 1], ys[#ys + 1] = x, y
			for k = 1, n do
				local x = width * math.random()
				local y = height * math.random()
				xs[#xs + 1], ys[#ys + 1] = x, y
			end
			xs[#xs + 1], ys[#ys + 1] = tunnels[j]:getPosition()
			for k = 1, n + 1 do
				local x = xs[k]
				local y = ys[k]
				local impulseX = xs[k + 1] - xs[k]
				local impulseY = ys[k + 1] - ys[k]
				impulseX = impulseX * (math.random() + 1)
				impulseY = impulseY * (math.random() + 1)
				local entity = Cannon(self.game, x, y, impulseX, impulseY)
				self.game.entities[#self.game.entities + 1] = entity
				self.entities[#self.entities + 1] = entity
			end
		end
	end
	end

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
