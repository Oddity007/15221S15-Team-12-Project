local Class = require "Class"
local Map = Class()

local Cannon = require "Cannon"
local SceneryEntity = require "SceneryEntity"
local Collectable = require "Collectable"
local Tunnel = require "Tunnel"

--[[
The Map
-Generates its permanent object list (self.entities) upon creation
]]

--The map gets created when the player is entering it for the first time
--entranceTunnelID is the ID of the tunnel exit they are coming out of
function Map:__init__(game, entranceTunnelID)
	self.game = game
	self.entities = {}

	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	for i=1,math.random(1, 100) do
		local x = width * math.random()
		local y = height * math.random()
		local entity = SceneryEntity(self.game, x, y)
		entity:setRestitution(math.random() * 2)
		self.game:addEntity(entity)
		self:addEntity(entity)
	end

	for i=1,math.random(1, 20) do
		local x = width * math.random()
		local y = height * math.random()
		local collect = Collectable(self.game, x, y)
		self.game:addEntity(collect)
		self:addEntity(collect)
	end

	for i=1,math.random(1, 10) do
		local x = width * math.random()
		local y = height * math.random()
		local numKinds = 5
		local kind = math.random(numKinds)
		local powerup = Powerup(self.game, x, y, kind)
		self.game:addEntity(powerup)
		self:addEntity(powerup)
	end

	--Generate the Tunnel object corresponding to the exit that the player should be entering the map through
	local tunnels = {}
	local tunnelIDs = {}
	local exitTunnelID = self.game:generateNewTunnelID(true, entranceTunnelID)
	do
		local x = width * math.random()
		local y = height * math.random()
		local entity = Tunnel(self.game, x, y, exitTunnelID)
		self.game:addEntity(entity)
		self:addEntity(entity)
		self.game.entities.player:setPosition(x + 20, y + 20)
		tunnels[#tunnels + 1] = entity
	end
	tunnelIDs[#tunnelIDs + 1] = exitTunnelID

	--Generate a certain number of new tunnel entrances/exits
	for i=1,2 --[[math.random(2, 4) ]] do
		local x = width * math.random()
		local y = height * math.random()
		--With 1/2 probability, make the new exit connect to an existing exit
		--Changing this will change the probability that the exit leads to a map they've already been to
		local id = self.game:generateNewTunnelID(math.random(1, 2) == 1)
		local entity = Tunnel(self.game, x, y, id)
		self.game:addEntity(entity)
		self:addEntity(entity)
		tunnelIDs[#tunnelIDs + 1] = id
		tunnels[#tunnels + 1] = entity
	end

	--Tell the game that these are the tunnels that are associated with this map
	--This allows us to return to this map later by entering through related tunnels
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
				self.game:addEntity(entity)
				self:addEntity(entity)
			end
		end
	end
	end

end

--Register an entity with the map's permanent object list
function Map:addEntity(entity)
	local entities = self.entities
	entities[#entities + 1] = entity
end

--Unregister an entity with the map's permanent object list
function Map:removeEntity(entity)
	local entities = self.entities
	local lastEntity = entities[#entities]
	for i, v in ipairs(entities) do
		if v == entity then
			entities[i] = lastEntity
			entities[#entities] = nil
			return
		end
	end
end

--sleep() gets called when the player is exiting this map
function Map:sleep()
	for _, entity in pairs(self.entities) do
		local f = entity.sleep
		if f then f(entity, self) end
	end
end

--awaken() gets called when the player is reentering this map
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
