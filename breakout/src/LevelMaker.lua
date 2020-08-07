LevelMaker = Class{}

function LevelMaker.CreateMap(level)
    local bricks = {}

    local numRows = math.random(1, 5)
    local numCols = math.random(7, 13)
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols

    local highestTier = math.min(3, math.floor(level / 5))
    local highestColor = math.min(5, level % 5 + 3)

    for y = 1, numRows do
        -- flag for skipping this row
        local skipPatterns = math.random(1, 2) == 1 and true or false

        --flag for changing color and tier for this row
        local alternativePatterns = math.random(1, 2) == 1 and true or false

        --list color and tier to change
        alternativeColor1 = math.random(1, highestColor)
        alternativeColor2 = math.random(1, highestColor)
        alternativeTier1 = math.random(0, highestTier)
        alternativeTier2 = math.random(0, highestTier)

        --solid color we use if not altenating
        solidColor = math.random(1, highestColor)
        solidTier = math.random(0, highestTier)

        -- flag for skipping a brick
        skipFlag = math.random(1, 2) == 1 and true or false

        -- flag for changing a brick color and tier
        alternativeFlag = math.random(1, 2) == 1 and true or false


        for x = 1, numCols do
            if skipPatterns and skipFlag then
                skipFlag = not skipFlag
                goto continue
            else
                skipFlag = not skipFlag
            end

            b = Brick((x - 1) * 32 + 8 + (13 - numCols) * 16, y * 16)

            if alternativePatterns and alternativeFlag then
                b.color = alternativeColor1
                b.tier = alternativeTier1
            else
                b.color = alternativeColor2
                b.tier = alternativeTier2
            end

            if alternativePatterns == false then
                b.color = solidColor
                b.tier = solidTier
            end

            table.insert(bricks, b)

            ::continue::
        end
    end

    if #bricks == 0 then
        bricks = LevelMaker.CreateMap(level)
    end

    return bricks
end