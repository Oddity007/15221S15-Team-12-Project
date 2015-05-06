local Class = require "Class"
local Game = Class()
local AssetManager = require "AssetManager"
local SoundManager = require "SoundManager"
local Player = require "Player"
local Cannon = require "Cannon"
local Map = require "Map"
local Tunnel = require "Tunnel"
local Collectable = require "Collectable"
local Powerup = require "Powerup"
local ItemTracker = require "ItemTracker"

--[[The Game class controls everything that happens in the game at a high
	level.

	--Forwards and generates events for all objects registered in self.entities
	--Manages the connections between maps
	--Updates physics
--]]

-- initialize the Game
function Game:__init__(character)
	self.status = true
	self.character = character
	self.assetManager = AssetManager()
	self.soundManager = SoundManager()
	self.world = love.physics.newWorld(0, 0, 0)

	self.camera = {position = {x = 0, y = 0}, scale = 1}

	--Forwards a collision message to colliding entities
	local function postSolveCallback(fixture1, fixture2, contact)
		local entity1 = fixture1:getUserData()
		local entity2 = fixture2:getUserData()
		if entity1 and entity1.onCollision then entity1:onCollision(contact, entity2) end
		if entity2 and entity2.onCollision then entity2:onCollision(contact, entity1) end
	end

	--Forwards an end contact message to touching entities
	local function onContact(fixture1, fixture2, contact)
		local entity1 = fixture1:getUserData()
		local entity2 = fixture2:getUserData()
		if entity1 and entity1.onContact then entity1:onContact(contact, entity2) end
		if entity2 and entity2.onContact then entity2:onContact(contact, entity1) end
	end
	self.world:setCallbacks(onContact, nil, nil, postSolveCallback)

	--prepare tunnels
	self.unpairedTunnelIDs = {}
	self.tunnelIDs = {}
	self.tunnelTransitions = {}
	--Start off with a single tunnel exit that player starts out of
	--self.startingTunnelID = self:generateNewTunnelID(false)

	--prepare (collidable) entities
	self.entities = {}
	self.entities.player = Player(self, self.character)
	self.entities.map = Map(self, self.startingTunnelID)

	self.itemTracker = ItemTracker(self)

	love.graphics.setBackgroundColor(255, 255, 255)

	self.collectableCount = 0

	self.timeDilation = 1
	self.timeOffset = 0
	self.timeTotal = 180.0
	self.timePassed = 0.0
end

--Register an entity for events
function Game:addEntity(entity)
	local entities = self.entities
	entities[#entities + 1] = entity
end

--Unregister an entity for events
function Game:removeEntity(entity)
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

--Control Time Dilation (Game time relative to player time)
function Game:setTimeDilation(to)
	self.timeDilation = to
end

--Add to or remove from Time Offset (Game time relative to player time)
function Game:addTimeOffset(to)
	self.timeOffset = self.timeOffset + to
end

-- process what happens when player enters a tunnel
function Game:enterTunnel(id)
	local exitTunnelID = self.tunnelIDs[id]
	local nextMap = nil

	--If the tunnel entrance has an existing exit, then find the map that's it leads to
	if exitTunnelID then
		nextMap = self.tunnelTransitions[exitTunnelID]
		assert(nextMap)
	end

	--print("Entering tunnel:", id, "Map: ", self.entities.map)

	--Tell the current map that it is being switched away from
	self.entities.map:sleep()

	--Unregister everything except the player from the entity list
	local player = self.entities.player
	self.entities = {}
	self.entities.player = player

	--If the map that the player is going to already exists, then tell that map to wake up
	if nextMap then
		assert(exitTunnelID)
		self.entities.map = nextMap
		self.entities.map:awaken(exitTunnelID)
	else
		assert(not exitTunnelID)
		--Otherwise, create a new map
		nextMap = Map(self, id)
		self.entities.map = nextMap
	end

	--print("Exiting tunnel:", exitTunnelID, "Map: ", self.entities.map)
end

-- Register each tunnel exit as leading to some map
function Game:registerMapTunnelIDs(map, tunnelIDs)
	for _, id in ipairs(tunnelIDs) do
		assert(not self.tunnelTransitions[id])
		self.tunnelTransitions[id] = map
	end
	for _, id in ipairs(self.unpairedTunnelIDs) do
		assert(self.tunnelTransitions[id])
	end
end

-- Generate a new tunnel exit, with the option to connect it to some existing tunnel exit
function Game:generateNewTunnelID(shouldPairWithPreviousTunnel, pairingTunnelID)
	if shouldPairWithPreviousTunnel and #self.unpairedTunnelIDs > 0 then
		local id = pairingTunnelID
		if id then
			for i, v in pairs(self.unpairedTunnelIDs) do
				if v == id then
					self.unpairedTunnelIDs[i] = self.unpairedTunnelIDs[#self.unpairedTunnelIDs]
					self.unpairedTunnelIDs[#self.unpairedTunnelIDs] = nil
					break
				end
			end

		else
			local randomIndex = math.random(1, #self.unpairedTunnelIDs)
			id = self.unpairedTunnelIDs[randomIndex]
			self.unpairedTunnelIDs[randomIndex] = self.unpairedTunnelIDs[#self.unpairedTunnelIDs]
			self.unpairedTunnelIDs[#self.unpairedTunnelIDs] = nil
		end
		local newID =  #self.tunnelIDs + 1
		self.tunnelIDs[id] = newID
		self.tunnelIDs[newID] = id
		return newID
	else
		local id =  #self.tunnelIDs + 1
		self.unpairedTunnelIDs[#self.unpairedTunnelIDs + 1] = id
		self.tunnelIDs[id] = false
		return id
	end
end

-- draw everything in the game (called each draw loop)
function Game:onRender()
	love.graphics.push()

	if self.timePassed >= self.timeTotal then
		love.graphics.setColor(150, 150, 150, 255)
		love.graphics.rectangle("fill", 0, 0, 1000, 800)
		love.graphics.setColor(0, 0, 0, 255)
		self.status = false
		love.graphics.pop()
		return
	end

	love.graphics.scale(self.camera.scale)
	love.graphics.translate(-self.camera.position.x, -self.camera.position.y)
	for _, entity in pairs(self.entities) do
		local f = entity.onRender
		if f then f(entity) end
	end

	--Bottom bar
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", 0, 570, 1000, 100)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print("Collected: " .. self.collectableCount, 10, 580)
	local barItems = self.itemTracker:getAllItems()
	for i,v in ipairs(barItems) do
		love.graphics.draw(v.image, 300+(i*v.radius*2), 570, 0, .5, .5)
	end

	--Timer bar
	love.graphics.setBlendMode("multiplicative")
	timeUp = self.timePassed/self.timeTotal
	local alpha = (1 - math.pow(timeUp, 1/2.2))*255
    	love.graphics.setColor(alpha, alpha, alpha, 255)
    love.graphics.rectangle("fill", 0, 0, 1000, 800)
	love.graphics.setBlendMode("alpha")

	love.graphics.pop()
end

-- update everything in the game (called each update loop)
function Game:onUpdate(seconds)
	seconds = seconds * self.timeDilation
	self.timePassed = self.timePassed + seconds

	self.soundManager:update(seconds)

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

-- process mouse clicks
function Game:onMousePress(mouseX, mouseY, button)
	for _, entity in pairs(self.entities) do
		local f = entity.onMousePress
		if f then f(entity, mouseX, mouseY, button) end
	end
end

-- process key presses
function Game:onKeyPress(key, unicode)
	for _, entity in pairs(self.entities) do
		local f = entity.onKeyPress
		if f then f(entity, key, unicode) end
	end
end

return Game
