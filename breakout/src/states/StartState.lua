StartState = Class{ __includes = BaseState}

local hightlight = 1

function StartState:enter(params)
    self.highScores = params.highScores
end

function StartState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        if hightlight == 2 then
            hightlight = 1
        else
            hightlight = 2
        end
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if hightlight == 1 then
            gStateMachine:change('paddle-select', {
                highScores = self.highScores
            })
        else
            gStateMachine:change('high-scores', {
                highScores = self.highScores
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end


function StartState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('BREAKOUT', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 1, 1, 1)

    if hightlight == 1 then
        love.graphics.setColor(103 / 255, 1, 1, 1)
    end

    love.graphics.printf('START', 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)

    if hightlight == 2 then
        love.graphics.setColor(103 / 255, 1, 1, 1)
    end
    love.graphics.printf('HIGH SCORE', 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)

end
