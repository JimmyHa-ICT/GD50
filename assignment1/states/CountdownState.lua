--[[
    Countdown State
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin. Transitions to the PlayState as soon as the
    countdown is complete.
]]

CountdownState = Class{__includes = BaseState}

-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]
function CountdownState:update(dt)
    self.timer = self.timer + dt

    -- loop timer back to 0 (plus however far past COUNTDOWN_TIME we've gone)
    -- and decrement the counter once we've gone past the countdown time
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        -- when 0 is reached, we should enter the PlayState
        if self.count == 0 then
            if self.bird ~= nil then
                gStateMachine:change('play', {
                    bird = self.bird,
                    pipePairs = self.pipePairs,
                    timer = self.timer,
                    score = self.score,
                    lastY = self.lastY
                })
            else
                gStateMachine:change('play')
            end
        end
    end
end

function CountdownState:render()
    -- render count big in the middle of the screen
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')

    if self.bird ~= nil then
        for k, pair in pairs(self.pipePairs) do
            pair:render()
        end

        love.graphics.setFont(flappyFont)
        love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

        self.bird:render()
    end
end


function CountdownState:enter(params)
    if params ~= nil then
        self.bird = params.bird
        self.pipePairs = params.pipePairs
        self.timer = params.timer
        self.score = params.score
        self.lastY = params.lastY
    end
end