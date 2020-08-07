PauseState = Class{__includes = BaseState}


function PauseState:enter(params)
    scrolling = false
    sounds['music']:pause()
    sounds['pause']:play()

    self.bird = params.bird
    self.pipePairs = params.pipePairs
    self.timer = params.timer
    self.score = params.score
    self.lastY = params.lastY
end


function PauseState:update(dt)
    if love.keyboard.wasPressed('p') or love.keyboard.wasPressed('P') then
        gStateMachine:change('countdown', {
            bird = self.bird,
            pipePairs = self.pipePairs,
            timer = self.timer,
            score = self.score,
            lastY = self.lastY
        })
    end
end

function PauseState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()

    love.graphics.setFont(hugeFont)
    love.graphics.printf('PAUSE', 0, 64, VIRTUAL_WIDTH, 'center')
end

function PauseState:exit()
    sounds['music']:play()
end
