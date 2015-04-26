local Game = require "Game"
local CurrentGame

function love.load()
	CurrentGame = Game()
	love.audio.setVolume(0.1)
end

function love.draw()
	CurrentGame:onRender()
end

function love.focus(element)
	
end

function love.update(seconds)
	CurrentGame:onUpdate(seconds)
	
end

function love.quit()
	
end

function love.mousepressed(x, y, button)
	CurrentGame:onMousePress(x, y, button)
end

function love.keypressed(key, unicode)
	CurrentGame:onKeyPress(key, unicode)
end
