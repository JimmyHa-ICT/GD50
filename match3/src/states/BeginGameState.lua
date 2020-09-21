BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()
    -- fade in
    self.transitionAlpha = 1

    -- start with the level label off-screen
    self.levelLabelY = -64
end

function BeginGameState:enter(params)
    self.level = params.level
    self.score = params.score

    -- inititalize the table
    self.Board = Board(VIRTUAL_WIDTH - 272, 16, math.random(self.level))

    -- set the tween animation
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    }):finish(function()
        Timer.tween(1, {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}
        }):finish(function()
            Timer.after(1, function()
                Timer.tween(1, {
                    [self] = {levelLabelY = VIRTUAL_HEIGHT + 64}
                }):finish(function()
                    gStateMachine:change('play', {
                        level = self.level,
                        Board = self.Board,
                        score = self.score,
                    })
                end)
            end)
        end)
    end)    
end


function BeginGameState:update(dt)
    Timer.update(dt)
end


function BeginGameState:render()
    -- fade in animation
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    -- print the board
    self.Board:render()

    -- print level label with blue background
    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level),
        0, self.levelLabelY, VIRTUAL_WIDTH, 'center')
end