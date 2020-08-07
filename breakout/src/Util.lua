-- generate the squad by dividing the atlas evenly

function GenerateQuads(atlas, tileWidth, tileHeight)
    sheetWidth = atlas:getWidth() / tileWidth
    sheetHeight = atlas:getHeight() / tileHeight
    sheetCounter = 1
    spriteSheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spriteSheet[sheetCounter] = love.graphics.newQuad(x * tileWidth,
                                            y * tileHeight, tileWidth, tileHeight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spriteSheet
end


function table.slice(tbl, first, last, step)
    sliced_table = {}

    for x = first or 1, last or #tbl, step or 1 do
        sliced_table[#sliced_table + 1] = tbl[x]
    end

    return sliced_table
end


-- function is designed specifically to read the paddle quad
function GenerateQuadsPaddle(atlas)
    x = 0
    y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        --get small paddle
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1

        --get medium paddle
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1

        --get large paddle
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1

        --get huge paddle
        quads[counter] = love.graphics.newQuad(x + 16, y, 128, 16, atlas:getDimensions())
        counter = counter + 1

        x = 0
        y = y + 32
    end

    return quads
end


function GenerateQuadsBall(atlas)
    x = 96
    y = 48

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x + i * 8, y, 8, 8, atlas:getDimensions())
        counter = counter + 1
    end

    for i = 0, 2 do
        quads[counter] = love.graphics.newQuad(x + i * 8, y + 8, 8, 8, atlas:getDimensions())
        counter = counter + 1
    end

    return quads
end


function GenerateQuadsBricks(atlas)
    return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)    
end