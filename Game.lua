local Class = require "Class"
local Game = Class()
local SceneManager = require "SceneManager"
local Player = require "Player"
local Cannon = require "Cannon"

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

	self.entities = {}
	self.entities.player = Player(self)
	self.entities[#self.entities + 1] = Cannon(self, 400, 250, 1000, 1000)

	love.graphics.setBackgroundColor(255, 255, 255)
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
