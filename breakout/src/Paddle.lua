Paddle = Class{}

function Paddle:init(skin)
    self.x = VIRTUAL_WIDTH / 2 - 32
    self.y = VIRTUAL_HEIGHT - 32

    self.dx = 0

    self.width = 64
    self.height = 16

    self.skin = skin      --the color of the paddle
    self.size = 2       --size of the paddle is varriant corresponding to level
end


function Paddle:update(dt)

    -- update paddle velocity corresponding to left/right key press
    if love.keyboard.isDown('left') then
        self.dx = - PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    -- update the paddle position
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    elseif self.dx > 0 then
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
    
end


function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end