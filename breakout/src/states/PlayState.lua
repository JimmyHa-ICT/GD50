PlayState = Class{__includes = BaseState}

function PlayState:enter(args)
    self.paddle = args.paddle
    self.ball = args.ball
    self.score = args.score
    self.health = args.health
    self.bricks = args.bricks
    self.level = args.level
    self.highScores = args.highScores

    self.paused = false
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
end

function PlayState:update(dt)
    if self.paused == false then
        self.paddle:update(dt)
        self.ball:update(dt)


        -- collision handling
        if self.ball:collides(self.paddle) then
            self.ball.y = self.paddle.y - 8         -- keep the ball above the paddle  after collision
            self.ball.dy = -self.ball.dy

            -- adjust the ball.dx corresponding to the place of collision
            if self.ball.x < (self.paddle.x + self.paddle.width / 2) and self.paddle.dx < 0 then
                self.ball.dx = -50 - (8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

            elseif self.ball.x > (self.paddle.x + self.paddle.width / 2) and self.paddle.dx > 0 then
                self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
            end

            gSounds['paddle-hit']:play()
        end

        for k, brick in pairs(self.bricks) do
            brick:update(dt)
            if brick.inPlay and self.ball:collides(brick) then
                self.score = self.score + (brick.tier * 200 + brick.color * 25)
                brick:hit()

                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        ball = self.ball,
                        highScores = self.highScores
                    })
                end

                -- left collision
                if self.ball.x + 2 < brick.x + 2 and self.ball.dx > 0 then
                    self.ball.x = brick.x - self. ball.width
                    self.ball.dx = -self.ball.dx

                -- right collision
                elseif self.ball.x + self.ball.width  - 2 > brick.x + brick.width and self.ball.dx < 0 then
                    self.ball.x = brick.x + brick.width
                    self.ball.dx = -self.ball.dx

                -- top collision
                elseif self.ball.y < brick.y then
                    self.ball.y = brick.y - self.ball.height
                    self.ball.dy = -self.ball.dy
                
                -- bottom collision
                else
                    self.ball.y = brick.y + brick.height + self.ball.height
                    self.ball.dy = -self.ball.dy
                end
                
                -- slightly speed up the game
                self.ball.dy = self.ball.dy * 1.02

                break           -- just allow collision with one brick
            end
        end
        
        if love.keyboard.wasPressed('space') then
            self.paused = true
            gSounds['pause']:play()
        end

        if self.ball.y >= VIRTUAL_HEIGHT then
            gSounds['hurt']:play()
            self.health = self.health - 1

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores,
                })

            else
                gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    level = self.level,
                    highScores = self.highScores,
                })
            end
        end

    
    else            -- if game is paused
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end


function PlayState:render()
    self.paddle:render()
    self.ball:render()
    renderScore(self.score)
    renderHealth(self.health)
    for k, brick in pairs(self.bricks) do
        brick:render()
        brick:renderParticle()
    end

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end


function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then 
            return false
        end
    end
    return true
end