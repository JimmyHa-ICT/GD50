PlayState = Class{__includes = BaseState}


function PlayState:init()
    self.selected = false

    -- lock the selection or not
    self.canInput = true

    -- current selected tile (prepare for swap)
    self.highlightTile = nil


    self.timer = 60

    Timer.every(1, function()
        self.timer = self.timer - 1
        if self.timer <= 5 then
            gSounds['clock']:play()
        end
    end)

    self.highlighRect = false
    Timer.every(0.5, function()
        self.highlighRect = not self.highlighRect
    end)
end


function PlayState:enter(params)
    self.level = params.level
    self.score = params.score
    self.Board = params.Board or Board(VIRTUAL_WIDTH - 272, 16, math.random(self.level))

    self.scoreGoal = 5 / 8 * (self.level * self.level + self.level) * 1000

    self.currentX = 1
    self.currentY = 1
    self.currentTile = self.Board.tiles[self.currentY][self.currentX]
end


function PlayState:update(dt)
    if love.keyboard.waspressed('escape') then
        love.event.quit()
    end

    -- move cursor to select tile
    if self.canInput then
        if love.keyboard.waspressed('up') then
            gSounds['select']:play()
            self.currentY = math.max(self.currentY - 1, 1)
            self.currentTile = self.Board.tiles[self.currentY][self.currentX]

        elseif love.keyboard.waspressed('down') then
            gSounds['select']:play()
            self.currentY = math.min(self.currentY + 1, 8)
            self.currentTile = self.Board.tiles[self.currentY][self.currentX]

        elseif love.keyboard.waspressed('left') then
            gSounds['select']:play()
            self.currentX = math.max(self.currentX - 1, 1)
            self.currentTile = self.Board.tiles[self.currentY][self.currentX]

        elseif love.keyboard.waspressed('right') then
            gSounds['select']:play()
            self.currentX = math.min(self.currentX + 1, 8)
            self.currentTile = self.Board.tiles[self.currentY][self.currentX]
        end
    end

    if love.keyboard.waspressed('enter') or love.keyboard.waspressed('return') then

        -- if there already have highlight tile
        if self.highlightTile then
            -- if current tile is select tile, it means unselection
            if self.highlightTile == self.currentTile then
                self.highlightTile = nil
            -- otherwise, swap current tile with highlight tile
            elseif math.abs(self.currentTile.gridX - self.highlightTile.gridX) +
                    math.abs(self.currentTile.gridY - self.highlightTile.gridY) <= 1 then
                self.canInput = false

                -- swap grid potision
                tempX = self.highlightTile.gridX
                tempY = self.highlightTile.gridY

                local currentTile = self.Board.tiles[self.currentY][self.currentX]
                self.highlightTile.gridX = currentTile.gridX
                self.highlightTile.gridY = currentTile.gridY

                currentTile.gridX = tempX
                currentTile.gridY = tempY

                -- swap tile in tile table
                self.Board.tiles[self.highlightTile.gridY][self.highlightTile.gridX] = self.highlightTile
                self.Board.tiles[currentTile.gridY][currentTile.gridX] = currentTile

                Timer.tween(0.25, {
                    [self.highlightTile] = {x = currentTile.x, y = currentTile.y},
                    [currentTile] = {x = self.highlightTile.x, y = self.highlightTile.y}
                }):finish(function()
                    self:calculateMatches()
                end)
            end

        -- not currently have highlight tile, then set the highlight tile is current tile
        else
            self.highlightTile = self.currentTile
        end
    end

    if self.timer <= 0 then
        Timer.clear()
        gStateMachine:change('game-over', {
            score = self.score
        })
    end

    if self.score >= self.scoreGoal then
        gSounds['next-level']:play()
        Timer.clear()
        gStateMachine:change('begin', {
            level = self.level + 1,
            score = self.score,
        })
    end

    Timer.update(dt)
end


function PlayState:render()
    self.Board:render()

    -- render the cursor
    if self.highlighRect then
        love.graphics.setColor(217/255, 87/255, 99/255, 1)
    else
        love.graphics.setColor(172/255, 50/255, 50/255, 1)
    end
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.currentTile.x + self.Board.x, self.currentTile.y + self.Board.y, 32, 32, 4)

    -- render the highlight tile
    if self.highlightTile then
        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', self.highlightTile.x + self.Board.x, self.highlightTile.y + self.Board.y, 32, 32, 4)
    end

    -- GUI text
    love.graphics.setColor(56/255, 56/255, 56/255, 234/255)
    love.graphics.rectangle('fill', 16, 16, 186, 116, 4)

    love.graphics.setColor(99/255, 155/255, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), 20, 52, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(self.scoreGoal), 20, 80, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')
end


function PlayState:calculateMatches()
    -- reset the select tile, update current tile
    self.highlightTile = nil
    self.currentTile = self.Board.tiles[self.currentY][self.currentX]

    -- if we have any matches, remove them and tween the falling blocks that result
    local matches = self.Board:calculateMatches()
    
    if matches then
        gSounds['match']:stop()
        gSounds['match']:play()

        -- add score for each match
        for k, match in pairs(matches) do
            self.score = self.score + #match * 50

            -- extend timer 1 second for each tile in match
            self.timer = self.timer + #match
        end

        -- remove any tiles that matched from the board, making empty spaces
        self.Board:removeMatches()

        -- gets a table with tween values for tiles that should now fall
        local tilesToFall = self.Board:getFallingTiles(self.level)

        -- first, tween the falling tiles over 0.25s
        Timer.tween(0.25, tilesToFall):finish(function()
            local newTiles = self.Board:getNewTiles()
            
            -- then, tween new tiles that spawn from the ceiling over 0.25s to fill in
            -- the new upper gaps that exist
            Timer.tween(0.25, newTiles):finish(function()
                -- recursively call function in case new matches have been created
                -- as a result of falling blocks once new self.canInput = trueblocks have finished falling
                self:calculateMatches()
            end)
        end)
    -- if no matches, we can continue playing
    else
        self.canInput = true
    end
end