Token = Class{}

function Token:init(type)
    self.x = math.random(16, VIRTUAL_WIDTH - 16)
    self.y = math.random(16, 32)
    self.dy = math.random(10, 20)
    self.height = 16
    self.width = 16

    self.skin = type
    self.inPlay = true
end

function Token:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Token:update(dt)
    self.y = self.y + self.dy * dt
end

function Token:render()
    love.graphics.draw(gTextures['main'], gFrames['token'][self.skin], self.x, self.y)
end