--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

push = require 'push'

require 'Util'

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

TILE_SIZE = 16

CAMERA_SCROLL_SPEED = 40

-- tile ID constants
SKY = 2
GROUND = 1

function love.load()
    math.randomseed(os.time())
    
    tiles = {}
    
    -- tilesheet image and quads for it, which will map to our IDs
    tilesheet = love.graphics.newImage('tiles.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)
    
    mapWidth = 20
    mapHeight = 20

    cameraScrollX = 0

    backgroundR = math.random()
    backgroundG = math.random()
    backgroundB = math.random()

    for y = 1, mapHeight do
        table.insert(tiles, {})
        
        for x = 1, mapWidth do
            -- sky and bricks; this ID directly maps to whatever quad we want to render
            table.insert(tiles[y], {
                id = y < 5 and SKY or GROUND
            })
        end
    end

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('tiles0')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end


function love.update(dt)
    if love.keyboard.isDown('left') then
        cameraScrollX  = cameraScrollX - 40 * dt
    elseif love.keyboard.isDown('right') then
        cameraScrollX = cameraScrollX + 40 * dt
    end
end


function love.draw()
    push:start()
        love.graphics.clear(backgroundR, backgroundG, backgroundB, 255)
        love.graphics.translate(-math.floor(cameraScrollX), 0)
        
        for y = 1, mapHeight do
            for x = 1, mapWidth do
                local tile = tiles[y][x]
                love.graphics.draw(tilesheet, quads[tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
            end
        end
    push:finish()
end