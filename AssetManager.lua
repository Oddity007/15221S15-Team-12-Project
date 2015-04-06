local Class = require "Class"
local AssetManager = Class()

--[[
The AssetManager
]]

function AssetManager:__init__()
	--This sets up the acquiredObjects table as a weak-value-reference table.
	--The garbage collector will not look at values stored in this table when looking for references.
	--This means that if an entry in this table is the only reference to an object, it will probably be deleted and replaced with null some time soon.
	--For assets like Images, this is very useful for implementing a cache.  It means that once no other object is holding onto a reference to the asset, it will be deleted.
	self.acquiredObjects = setmetatable({}, {__mode = "v"})
end

function AssetManager:acquire(path, ...)
	local acquiredObject = self.acquiredObjects[path]
	--Check if the asset has already been loaded and return it if so
	if acquiredObject then return acquiredObject end
	--Otherwise, load it and store it for next time
	--We load the file at path as a function and then execute it with the arguments of ...
	--The returned value is the asset we store
	acquiredObject = assert(loadfile(path))(...)
	self.acquiredObjects[path] = acquiredObject
	return acquiredObject
end

return AssetManager
