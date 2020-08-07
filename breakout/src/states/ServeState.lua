ServeState = Class{__includes = BaseState}

function ServeState:enter(args)
    self.paddle = args.paddle
    self.bricks = args.bricks
    self.health = args.health
    self.score = args.score
    self.level = args.level
    self.highScores = args.highScores


    self.ball = Ball()
    self.ball.skin = math.random(7)
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + self.paddle.width/2 - self.ball.width / 2
    self.ball.y = self.paddle.y - self.ball.height
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            level = self.level,
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            highScores = self.highScores,
        })
    end
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()
    renderScore(self.score)
    renderHealth(self.health)
    for k, brick in pairs(self.bricks) do
        brick:render()
    end
end