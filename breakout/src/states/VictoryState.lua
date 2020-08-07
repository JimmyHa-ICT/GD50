VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.level = params.level
    self.score = params.score
    self.health = params.health
    self.paddle = params.paddle
    self.ball = params.ball
    self.highScores = params.highScores
end

function VictoryState:update(dt)
    self.paddle:update(dt)

    self.ball.x = self.paddle.x + self.paddle.width / 2 - self.ball.width / 2
    self.ball.y = self.paddle.y - self.ball.height

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            level = self.level + 1,
            score = self.score,
            health = self.health,
            paddle = self.paddle,
            bricks = LevelMaker.CreateMap(self.level + 1),
            highScores = self.highScores
        })
    end
end


function VictoryState:render()
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Press Enter to serve!", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end