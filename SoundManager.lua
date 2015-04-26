local Class = require "Class"
local SoundManager = Class()

function SoundManager:__init__(game)
	self.game = game
	self.sources = {}
	self.waits = {}
end

function SoundManager:update(seconds)
	local removed = {}

	for k, wait in pairs(self.waits) do
		wait = wait - seconds
		self.waits[k] = wait
		if wait <= 0 then
			removed[#removed + 1] = k
		end
	end

	for i, k in ipairs(removed) do
		self.waits[k] = nil
	end
	
	removed = {}

	for _, s in pairs(self.sources) do
		if s:isStopped() then
			removed[#removed + 1] = s
		end
	end

	for i, s in ipairs(removed) do
		self.sources[s] = nil
	end
end

function SoundManager:play(what, how, shouldLoop, wait)
	local source = what
	if type(what) ~= "userdata" or not what:typeOf("Source") then
		if self.waits[source] then
			return nil
		end
		self.waits[source] = wait
		source = love.audio.newSource(what, how)
		source:setLooping(shouldLoop or false)
	end
	
	love.audio.play(source)
	
	self.sources[source] = source
	return source
end

function SoundManager:stop()
	if not source then return end
	love.audio.stop(source)
	self.sources[source] = nil
end


return SoundManager
