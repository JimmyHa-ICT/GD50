StartState = Class{__includes = BaseState}

local positions = {}

function StartState:init()
    -- currently selected menu item
    self.currentMenuItem = 1

    -- colors we'll use to change the title text
    self.colors = {
        [1] = {217/255, 87/255, 99/255, 1},
        [2] = {95/255, 205/255, 228/255, 1},
        [3] = {251/255, 242/255, 54/255, 1},
        [4] = {118/255, 66/255, 138/255, 1},
        [5] = {153/255, 229/255, 80/255, 1},
        [6] = {223/255, 113/255, 38/255, 1}
    }

    -- letters of MATCH 3 and their spacing relative to the center
    self.letterTable = {
        {'M', -108},
        {'A', -64},
        {'T', -28},
        {'C', 2},
        {'H', 40},
        {'3', 112}
    }


    -- generate full table of tiles just for display
    for i = 1, 64 do
        table.insert(positions, gFrames['tiles'][math.random(18)][math.random(6)])
    end

    -- used to animate our full-screen transition rect
    self.transitionAlpha = 0

    -- if we've selected an option, we need to pause input while we animate out
    self.pauseInput = false
    self.colorTimer = Timer.every(0.075, function()
        self.colors[0] = self.colors[6]        
        for i = 6, 1, -1 do 
            self.colors[i] = self.colors[i-1]
        end
    end
    )
end


function StartState:update(dt)
    if love.keyboard.waspressed('escape') then
        love.event.quit()
    end


    -- select option by press up/down
    if love.keyboard.waspressed('up') then
        gSounds['select']:play()
        if self.currentMenuItem == 1 then
            self.currentMenuItem = 2
        else
            self.currentMenuItem = self.currentMenuItem - 1
        end
    end

    if love.keyboard.waspressed('down') then
        gSounds['select']:play()
        if self.currentMenuItem == 2 then
            self.currentMenuItem = 1
        else
            self.currentMenuItem = self.currentMenuItem + 1
        end
    end

    -- handle selection
    if love.keyboard.waspressed('enter') or love.keyboard.waspressed('return') then
        if self.currentMenuItem == 2 then
            love.event.quit()
        else
            Timer.tween(1, {
                [self] = {transitionAlpha = 255}
            }):finish(function()
                gStateMachine:change('begin', {
                    level = 1, 
                    score = 0,
                })
            end
            )
        end
    end

    Timer.update(dt)
end


function StartState:render()
    -- draw a quad and it shadow
    for x = 1, 8 do
        for y = 1, 8 do
            -- draw the shadow first
            love.graphics.setColor(0, 0, 0, 0.75)

            love.graphics.draw(gTextures['main'], positions[(y - 1) * 8 + x],
                                (x - 1) * 32 + 128 + 3, (y - 1) * 32 + 16 + 3)

            -- draw the tile
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(gTextures['main'], positions[(y - 1) * 8 + x],
                                (x - 1) * 32 + 128, (y - 1) * 32 + 16)
        end
    end

    -- draw title
    self:drawMatch3Text(-60)

    --draw options panel
    self:drawOptions(12)

    -- fade out
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

-- draw the title match 3
function StartState:drawMatch3Text(y)
    -- draw semi transparent panel behind the word match 3
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y - 11, 150, 58, 6)

    -- draw the word match 3
    love.graphics.setFont(gFonts['large'])
    self:drawTextShadow('MATCH 3', VIRTUAL_HEIGHT / 2 + y)
    for i = 1, 6 do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i][1], 0, VIRTUAL_HEIGHT / 2 + y, VIRTUAL_WIDTH + self.letterTable[i][2], 'center')
    end

end


function StartState:drawOptions(y)
    -- draw rect behind start and quit game text
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y, 150, 58, 6)

    -- draw Start text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Start', VIRTUAL_HEIGHT / 2 + y + 8)
    
    if self.currentMenuItem == 1 then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130/255, 1)
    end
    
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + y + 8, VIRTUAL_WIDTH, 'center')

    -- draw Quit Game text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Quit Game', VIRTUAL_HEIGHT / 2 + y + 33)
    
    if self.currentMenuItem == 2 then
        love.graphics.setColor(99/255, 155/255, 1, 1)
    else
        love.graphics.setColor(48/255, 96/255, 130/255, 1)
    end
    
    love.graphics.printf('Quit Game', 0, VIRTUAL_HEIGHT / 2 + y + 33, VIRTUAL_WIDTH, 'center')
end


function StartState:drawTextShadow(text, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 0.25)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end