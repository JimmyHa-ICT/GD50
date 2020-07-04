push = require 'push'       -- push is a library used for making game with fix resolution
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 150

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("Pong")

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/hit_paddle.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/hit_wall.wav', 'static'),
        ['background'] = love.audio.newSource('sounds/background.mp3', 'stream')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = false,
    })

    --set the random seed corresponding to the time, so the return number of random is always random
    math.randomseed(os.time())

    player1Score = 0
    player2Score = 0

    paddle1 = Paddle(10, 30, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 50, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    servingPlayer = 0
    winningPlayer = 0

    gameState = 'start'
    sounds['background']:setVolume(0.2)
    sounds['background']:play()
end


function love.resize(w,h)
    push:resize(w, h)
end


function love.update(dt)
    if gameState == 'done' then
        if player1Score >= 10 then
            winningPlayer = 1
        else
            winningPlayer = 2
        end
    end

    -- collisions handling
    if gameState == 'play' then
        
        --if ball hit paddle 1
        if ball:collides(paddle1) then
            sounds['paddle_hit']:play()
            ball.dx = -ball.dx * 1.03
            ball.x = paddle1.x + 5            

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        --if ball hit paddle 2
        if ball:collides(paddle2) then
            sounds['paddle_hit']:play()
            ball.dx = -ball.dx * 1.03
            ball.x = paddle2.x - 4            

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        
        --if ball hits lower bound
        if ball.y >= VIRTUAL_HEIGHT - ball.height then
            sounds['wall_hit']:play()
            ball.y = VIRTUAL_HEIGHT - ball.height
            ball.dy = -ball.dy
        end

        -- if ball hits upper bound
        if ball.y <= 0 then
            sounds['wall_hit']:play()
            ball.y = 0
            ball.dy = -ball.dy
        end
    

        if ball.x < 0 then
            sounds['score']:play()
            player2Score = player2Score + 1
            if player2Score >= 10  then
                gameState = 'done'
            else
                gameState = 'serve'
                servingPlayer = 1
                ball:reset()
                ball.dx = 100
            end

        elseif ball.x > VIRTUAL_WIDTH - ball.width then
            sounds['score']:play()
            player1Score = player1Score + 1
            if player1Score >= 10 then
                gameState = 'done'
            else
                gameState = 'serve'
                servingPlayer = 2
                ball:reset()
                ball.dx = -100
            end
        end
    end

    -- player 1 movement
    if love.keyboard.isDown('w') then
        paddle1.dy = - PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        paddle2.dy = - PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    paddle1:update(dt)
    paddle2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            sounds['background']:stop()
            gameState = 'play'
        elseif gameState == 'done'then
            sounds['background']:play()
            gameState = 'serve'
            ball:reset()
            
            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function love.draw()
    push:apply('start')         --start rendering at virtual screen

    love.graphics.clear(40/255, 45/255, 52/255, 1)
    displayScore()
    
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome to pong!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press enter to begin!", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player' .. tostring(servingPlayer) .. " 's serve!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press enter to serve!", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then

    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press enter to restart!", 0, 30, VIRTUAL_WIDTH, 'center')    
    end

    ball:render()
    paddle1:render()
    paddle2:render()
    displayFPS()

    push:apply('end')           --end rendering at virtual screen
end


function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS:' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
   --render the scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3) 
end