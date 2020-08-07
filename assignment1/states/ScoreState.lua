--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]

-- https://www.flaticon.com/free-icon/
GOLD_MEDAL = love.graphics.newImage('gold.png')
SILVER_MEDAL = love.graphics.newImage('silver.png')
BRONZE_MEDAL = love.graphics.newImage('bronze.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    if self.score >= 10 then
        love.graphics.draw(BRONZE_MEDAL, VIRTUAL_WIDTH / 1.5 - BRONZE_MEDAL:getWidth(), 100)
    elseif self.score >= 15 then
        love.graphics.draw(SILVER_MEDAL, VIRTUAL_WIDTH / 1.5 - SILVER_MEDAL:getWidth(), 100)
    elseif self.score > 20 then
        love.graphics.draw(GOLD_MEDAL, VIRTUAL_WIDTH / 1.5 - GOLD_MEDAL:getWidth(), 100)
    else
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Try to get 10 point to get medal', VIRTUAL_WIDTH / 2, 120, 100, 'center')
    end

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), VIRTUAL_WIDTH / 3, 120, VIRTUAL_WIDTH, 'left')

    love.graphics.printf('Press Enter to Play Again!', 0, 180, VIRTUAL_WIDTH, 'center')
end