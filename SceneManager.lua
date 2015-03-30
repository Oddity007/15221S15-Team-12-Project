local Class = require "Class"
local SceneManager = Class()

--[[Describe the SceneManager class:
--]]

function SceneManager:__init__()
	self.acquiredObjects = setmetatable({}, {__mode = "v"})
end

function SceneManager:acquireObject(path, ...)
	local acquiredObject = self.acquiredObjects[path]
	if acquiredObject then return acquiredObject end
	acquiredObject = assert(loadfile(path))(...)
	self.acquiredObjects[path] = acquiredObject
	return aqcuiredObject
end

function SceneManager:getAcquiredObjects()
	return self.acquiredObjects
end

return SceneManager
