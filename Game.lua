local Class = require "Class"
local Game = Class()
local SceneManager = require "SceneManager"
local Player = require "Player"
local Cannon = require "Cannon"
local Map = require "Map"
local Tunnel = require "Tunnel"

function Game:__init__()
	self.sceneManager = SceneManager()
	self.world = love.physics.newWorld(0, 0, 0)

	self.camera = {position = {x = 0, y = 0}, scale = 1}

	local function postSolveCallback(fixture1, fixture2, contact)
		local entity1 = fixture1:getUserData()
		local entity2 = fixture2:getUserData()
		if entity1 then entity1:onCollision(contact, entity2) end
		if entity2 then entity2:onCollision(contact, entity1) end
	end
	self.world:setCallbacks(nil, nil, nil, postSolveCallback)

	self.unpairedTunnelIDs = {}
	self.tunnelIDs = {}
	self.tunnelTransitions = {}
	self.startingTunnelID = self:generateNewTunnelID(false)

	self.entities = {}
	self.entities.player = Player(self)
	self.entities.map = Map(self, self.startingTunnelID)

	love.graphics.setBackgroundColor(255, 255, 255)
end

function Game:enterTunnel(id)
	local exitTunnelID = self.tunnelIDs[id]
	local nextMap = nil
	if exitTunnelID then
		nextMap = self.tunnelTransitions[exitTunnelID]
	end
	
	self.entities.map:sleep()
	
	local player = self.entities.player
	
	self.entities = {}
	self.entities.player = player
	if nextMap then
		self.entities.map = nextMap
		self.entities.map:awaken()
	else
		nextMap = Map(self, exitTunnelID)
		self.entities.map = nextMap
	end
	print(id)
	print(nextMap)
end

function Game:registerMapTunnelIDs(map, tunnelIDs)
	for _, id in ipairs(tunnelIDs) do
		self.tunnelTransitions[id] = map
	end
end

function Game:generateNewTunnelID(shouldPairWithPreviousTunnel, pairingTunnelID)
	if shouldPairWithPreviousTunnel and #self.unpairedTunnelIDs > 0 then
		local id = pairingTunnelID
		if id then
			for i, v in pairs(self.unpairedTunnelIDs) do
				if v == id then
					self.unpairedTunnelIDs[i] = nil
				end
			end
		else
			id = self.unpairedTunnelIDs[#self.unpairedTunnelIDs]
			self.unpairedTunnelIDs[#self.unpairedTunnelIDs] = nil
		end
		local newID =  #self.tunnelIDs + 1
		self.tunnelIDs[id] = newID
		self.tunnelIDs[newID] = id
		return id
	else
		local id =  #self.tunnelIDs + 1
		self.unpairedTunnelIDs[#self.unpairedTunnelIDs + 1] = id
		self.tunnelIDs[id] = false
		return id
	end
end

function Game:onRender()
	love.graphics.push()
	love.graphics.scale(self.camera.scale)
	love.graphics.translate(-self.camera.position.x, -self.camera.position.y)
	for _, entity in pairs(self.entities) do
		local f = entity.onRender
		if f then f(entity) end
	end
	love.graphics.pop()
end

function Game:onUpdate(seconds)
	for _, entity in pairs(self.entities) do
		local f = entity.beforePhysicsUpdate
		if f then f(entity, seconds) end
	end

	self.world:update(seconds)

	for _, entity in pairs(self.entities) do
		local f = entity.afterPhysicsUpdate
		if f then f(entity, seconds) end
	end
end

function Game:onMousePress(mouseX, mouseY, button)
	for _, entity in pairs(self.entities) do
		local f = entity.onMousePress
		if f then f(entity, mouseX, mouseY, button) end
	end
end

function Game:onKeyPress(key, unicode)
	for _, entity in pairs(self.entities) do
		local f = entity.onKeyPress
		if f then f(entity, key, unicode) end
	end
end

return Game