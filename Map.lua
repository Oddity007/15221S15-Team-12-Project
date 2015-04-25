local Class = require "Class"
local Map = Class()

local Cannon = require "Cannon"
local SceneryEntity = require "SceneryEntity"
local Collectable = require "Collectable"
local Powerup = require "Powerup"
local Tunnel = require "Tunnel"
local ForestBorderEntity = require "ForestBorderEntity"

local Rectangle = require "Rectangle"

--The occupancy grid allows us to detect whether the object we're placing will collide with something.  It's a slow hack, but it works for now until I implement something better.
--I would give it its own file, but it'll probably be gone soon

local OccupancyGrid = Class()

function OccupancyGrid:__init__(width, height)
	self.width = width
	self.height = height
	self.filterRatio = 10
	self.image = love.image.newImageData(width, height)
	self.filterImage = love.image.newImageData(width / self.filterRatio, height / self.filterRatio)
end

function OccupancyGrid:reserveCircle(cx, cy, radius)
	local function f(x, y, r, g, b, a)
		local dx = x - cx
		local dy = y - cy
		if dx * dx + dy * dy > radius * radius then
			return r, g, b, a
		end
		return 1, g, b, a
	end
	self.image:mapPixel(f)

	local function f(x, y, r, g, b, a)
		x = self.filterRatio * x
		y = self.filterRatio * y
		local filterradius = self.filterRatio * 2 + radius
		local dx = x - cx
		local dy = y - cy
		if dx * dx + dy * dy > filterradius * filterradius then
			return r, g, b, a
		end
		return 1, g, b, a
	end
	self.filterImage:mapPixel(f)
end

function OccupancyGrid:circleIsUnreserved(sx, sy, radius)
	local hadNoLowResolutionCollisions = true
	for dy = -radius, radius, self.filterRatio do
	for dx = -radius, radius, self.filterRatio do
		local x = sx + dx
		local y = sy + dy
		if dx * dx + dy * dy <= radius * radius then
			if x >= 0 and y >= 0 and x < self.width and y < self.height then
				local r, g, b, a = self.filterImage:getPixel(x / self.filterRatio, y / self.filterRatio)
				if r > 0 then
					hadNoLowResolutionCollisions = false
				end
			end
		end
	end
	end

	if hadNoLowResolutionCollisions then
		return true
	end

	for dy = -radius, radius do
	for dx = -radius, radius do
		local x = sx + dx
		local y = sy + dy
		if dx * dx + dy * dy <= radius * radius then
			if x >= 0 and y >= 0 and x < self.width and y < self.height then
				local r, g, b, a = self.image:getPixel(x, y)
				if r > 0 then
					return false
				end
			end
		end
	end
	end
	return true
end

function OccupancyGrid:reserveLineSegment(sx, sy, ex, ey, thickness)
	local function f(x, y, r, g, b, a)
		local rx = ex - sx
		local ry = ey - sy
		local rmagnitude = math.sqrt(rx * rx + ry * ry)
		rx = rx / rmagnitude
		ry = ry / rmagnitude
		local dx = x - sx
		local dy = y - sy
		local distanceAlongLine = dx * rx + dy * ry
		if distanceAlongLine > thickness * 2 + rmagnitude then
			return r, g, b, a
		end
		dx = dx - rx * distanceAlongLine
		dy = dy - ry * distanceAlongLine
		if dx * dx + dy * dy > thickness * thickness then
			return r, g, b, a
		end
		return 1, g, b, a
	end
	self.image:mapPixel(f)

	local function f(x, y, r, g, b, a)
		x = self.filterRatio * x
		y = self.filterRatio * y
		local filterthickness = self.filterRatio * 2 + thickness
		local rx = ex - sx
		local ry = ey - sy
		local rmagnitude = math.sqrt(rx * rx + ry * ry)
		rx = rx / rmagnitude
		ry = ry / rmagnitude
		local dx = x - sx
		local dy = y - sy
		local distanceAlongLine = dx * rx + dy * ry
		if distanceAlongLine > filterthickness * 2 + rmagnitude then
			return r, g, b, a
		end
		dx = dx - rx * distanceAlongLine
		dy = dy - ry * distanceAlongLine
		if dx * dx + dy * dy > filterthickness * filterthickness then
			return r, g, b, a
		end
		return 1, g, b, a
	end
	self.filterImage:mapPixel(f)
end

--[[
The Map
-Generates its permanent object list (self.entities) upon creation
]]

--The map gets created when the player is entering it for the first time
--entranceTunnelID is the ID of the tunnel endpoint the player entered to get here (if there was one)
function Map:__init__(game, entranceTunnelID)
	self.game = game
	self.entities = {}

	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	local occupancyGrid = OccupancyGrid(width, height)

--[[<<<<<<< HEAD
	for i=1,math.random(1, 10) do
		local x = width * math.random()
		local y = height * math.random()
		local powerup = Powerup(self.game, x, y)
		self.game:addEntity(powerup)
		self:addEntity(powerup)
=======]]
	local function generateRandomCircle(radius)
		repeat
			local x = width * math.random()
			local y = height * math.random()
			if occupancyGrid:circleIsUnreserved(x, y, radius) then
				return x, y
			end
		until false
-->>>>>>> 0603a07b204b577ecd3b0115072ad2544bb5bf73
	end

	--Generate the Tunnel object corresponding to the exit that the player should be entering the map through
	local tunnels = {}
	local tunnelIDs = {}
	if entranceTunnelID then
		local exitTunnelID = self.game:generateNewTunnelID(true, entranceTunnelID)
		local x, y = generateRandomCircle(10)
		occupancyGrid:reserveCircle(x, y, 10)
		local entity = Tunnel(self.game, x, y, exitTunnelID)
		self.game.entities.player:setPosition(x, y)
		entity.shouldWaitUntilPlayerLeaves = true
		self.game:addEntity(entity)
		self:addEntity(entity)
		tunnels[#tunnels + 1] = entity
		tunnelIDs[#tunnelIDs + 1] = exitTunnelID
	else
		--if it doesn't exist, we have no where to have the player start, so just pick a spot
		--[[local x, y = generateRandomCircle(10)
		occupancyGrid:reserveCircle(x, y, 10)
		self.game.entities.player:setPosition(x, y)]]
	end

	--Generate a certain number of new tunnel entrances/exits
	for i=1, math.random(2, 3) do
		local x, y = generateRandomCircle(10)
		occupancyGrid:reserveCircle(x, y, 10)
		--With 1/8 probability, make the new exit connect to an existing exit
		--Changing this will change the probability that the exit leads to a map they've already been to
		local id = self.game:generateNewTunnelID(math.random(1, 8) == 1)
		local entity = Tunnel(self.game, x, y, id)
		self.game:addEntity(entity)
		self:addEntity(entity)
		tunnelIDs[#tunnelIDs + 1] = id
		tunnels[#tunnels + 1] = entity
	end

	if not entranceTunnelID then
		--now that we have a tunnel door, just pick one to have the player start at if there's no default entrance
		local fakeStartTunnel = tunnels[math.random(1, #tunnels)]
		local x, y = fakeStartTunnel:getPosition()
		fakeStartTunnel.shouldWaitUntilPlayerLeaves = true
		self.game.entities.player:setPosition(x, y)
	end

	--Tell the game that these are the tunnels that are associated with this map
	--This allows us to return to this map later by entering through related tunnels
	self.game:registerMapTunnelIDs(self, tunnelIDs)

	self.tunnels = {}
	for i, id in ipairs(tunnelIDs) do
		self.tunnels[id] = tunnels[i]
	end

	--To do: Generate cannon paths first, then generate object placements
	--That would make this actually playable

	--Generate cannon paths
	--Randomly generate cannon paths between all tunnels and generate the collectables and powerups along the paths
	for i = 1, #tunnels do
	for j = 1, #tunnels do
		if i ~= j then
			local n = math.random(1, 2)
			local xs = {}
			local ys = {}
			local x, y = tunnels[i]:getPosition()
			do
				local dx, dy = math.random() * 2 - 1, math.random() * 2 - 1
				local d = math.sqrt(dx * dx + dy * dy)
				dx = dx / d
				dy = dy / d
				x = x + dx * 25
				y = y + dy * 25
			end
			xs[#xs + 1], ys[#ys + 1] = x, y
			for k = 1, n do
				local x, y = generateRandomCircle(10)
				occupancyGrid:reserveCircle(x, y, 10)
				--local x = width * math.random()
				--local y = height * math.random()
				xs[#xs + 1], ys[#ys + 1] = x, y
			end
			xs[#xs + 1], ys[#ys + 1] = tunnels[j]:getPosition()
			for k = 1, n + 1 do
				occupancyGrid:reserveLineSegment(xs[k], ys[k], xs[k + 1], ys[k + 1], 10)
				local x = xs[k]
				local y = ys[k]
				local impulseFactor = (math.random() + 1) * 1
				local impulseX = xs[k + 1] - xs[k]
				local impulseY = ys[k + 1] - ys[k]
				impulseX = impulseX * impulseFactor
				impulseY = impulseY * impulseFactor

				--Generate collectables
				for i=1,math.random(1, 20) do
					local ox, oy = (math.random() * 2 - 1) * 10, (math.random() * 2 - 1) * 10
					local cx = ox + x + (xs[k + 1] - xs[k]) * math.random()
					local cy = oy + y + (ys[k + 1] - ys[k]) * math.random()
					--occupancyGrid:reserveCircle(cx, cy, 10)
					local collect = Collectable(self.game, cx, cy)
					self.game:addEntity(collect)
					self:addEntity(collect)
				end

				--Generate power ups
				for i=1,math.random(1, 2) do
					local ox, oy = (math.random() * 2 - 1) * 10, (math.random() * 2 - 1) * 10
					local cx = ox + x + (xs[k + 1] - xs[k]) * math.random()
					local cy = oy + y + (ys[k + 1] - ys[k]) * math.random()
					--occupancyGrid:reserveCircle(cx, cy, 10)
					local numKinds = 5
					local kind = math.random(numKinds)
					local powerup = Powerup(self.game, cx, cy, kind)
					self.game:addEntity(powerup)
					self:addEntity(powerup)
				end

				local entity = Cannon(self.game, x, y, impulseX, impulseY)
				self.game:addEntity(entity)
				self:addEntity(entity)
			end
		end
	end
	end

	--Generate trees
	for i=1,math.random(300, 400) do
		local x, y = generateRandomCircle(10)
		--occupancyGrid:reserveCircle(x, y, 20)
		local entity = SceneryEntity(self.game, x, y)
		entity:setRestitution(math.random() * 2)
		self.game:addEntity(entity)
		self:addEntity(entity)
	end

	--Add borders so the player can't go out of the map
	do
		local border = ForestBorderEntity(self.game, width / 2, -5, width, 10)
		self.game:addEntity(border)
		self:addEntity(border)
	end

	do
		local border = ForestBorderEntity(self.game, width / 2, height + 5, width, 10)
		self.game:addEntity(border)
		self:addEntity(border)
	end

	do
		local border = ForestBorderEntity(self.game, -5, height / 2, 10, height)
		self.game:addEntity(border)
		self:addEntity(border)
	end

	do
		local border = ForestBorderEntity(self.game, width + 5, height / 2, 10, height)
		self.game:addEntity(border)
		self:addEntity(border)
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
function Map:awaken(exitTunnelID)
	do
		local exitTunnel = self.tunnels[exitTunnelID]
		local x, y = exitTunnel:getPosition()
		self.game.entities.player:setPosition(x, y)
		exitTunnel.shouldWaitUntilPlayerLeaves = true
	end
	for _, entity in pairs(self.entities) do
		self.game.entities[#self.game.entities + 1] = entity
	end
	for _, entity in pairs(self.entities) do
		local f = entity.awaken
		if f then f(entity, self) end
	end
end

return Map
