local Game = require "Game"
local Title = require "Title"
local End = require "End"
local CurrentGame
local TitleStatus
local GameStatus
local FinalScore
local Character

function love.load()
	CurrentGame = Title()
	love.audio.setVolume(0.1)
	TitleStatus = true
end

function love.draw()
	CurrentGame:onRender()
end

function love.focus(element)

end

function love.update(seconds)
	if not CurrentGame.status then
		if TitleStatus then
			TitleStatus = false
			GameStatus = true
			Character = CurrentGame.character
			CurrentGame = Game(Character)
		elseif GameStatus then
			FinalScore = CurrentGame.collectableCount
			CurrentGame = End(FinalScore)
			GameStatus = false
		end
	end
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
