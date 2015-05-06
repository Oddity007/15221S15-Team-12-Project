local Class = require "Class"
local End = Class()

--[[The End class
--]]

-- initialize the Game
function End:__init__(finalScore)
	self.status = true

	self.finalScore = finalScore

	self.camera = {position = {x = 0, y = 0}, scale = 1}

	self.bg = love.graphics.newImage("Assets/FairyForestBG.png")

end

function End:onRender()
	width, height = love.graphics.getDimensions()
	bgScalew = width / 1440
	bgScaleh = height / 900

	love.graphics.draw(self.bg,0,0,0, bgScalew, bgScaleh)

	love.graphics.setFont(love.graphics.newFont(18))
	love.graphics.print("Your final score is: " .. self.finalScore, 10, 10)
	love.graphics.print("You collected NUMBER items in NUMBER time.", 10, 28)

end


-- update everything in the game (called each update loop)
function End:onUpdate(seconds)

end

-- process mouse clicks
function End:onMousePress(mouseX, mouseY, button)

end

-- Nothing Happens
function End:onKeyPress(key)

end

return End
