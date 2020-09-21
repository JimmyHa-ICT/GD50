require 'src/Dependencies'

local scrollingSpeed = 80
local scrollingX = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Match 3')
    
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
    })

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    gStateMachine = StateMachine{
        ['start'] = function() return StartState() end,
        ['begin'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end


function love.resize(w, h)
    push:resize(w, h)
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end


function love.keyboard.waspressed(key)
    return love.keyboard.keysPressed[key]
end


function love.update(dt)
    scrollingX = (scrollingX + scrollingSpeed * dt) % 512
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()
    love.graphics.draw(gTextures['background'], -scrollingX, 0)
    gStateMachine:render()

    push:finish()
end