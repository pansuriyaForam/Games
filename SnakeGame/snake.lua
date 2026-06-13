local settings = require "settings"
local food = require "food"
local ui = require "ui"
local utils = require "utils"
local particles = require "particles"  

local snake = {}
local direction, nextDirection
local moveTimer = 0

function snake.reset()
    snake.body = { {x=5, y=5}, {x=4, y=5}, {x=3, y=5} }  -- Starting snake (3 blocks long)
    direction = "right"
    nextDirection = "right"
    moveTimer = 0
end

function snake.update(dt)
    moveTimer = moveTimer + dt
    if moveTimer >= settings.moveSpeed then
        snake.move()
        moveTimer = 0
    end
end

function snake.move()
    direction = nextDirection
    local head = {x = snake.body[1].x, y = snake.body[1].y}

    if direction == "up" then head.y = head.y - 1
    elseif direction == "down" then head.y = head.y + 1
    elseif direction == "left" then head.x = head.x - 1
    elseif direction == "right" then head.x = head.x + 1
    end

    -- Check collision (Wall or Self)
    if head.x < 1 or head.x > settings.gridWidth or head.y < 1 or head.y > settings.gridHeight or utils.checkCollision(head.x, head.y, snake.body) then
        ui.gameOver = true
        sounds.gameOver:play()
        ui.triggerScreenShake(5)
        return
    end

    -- Insert new head position
    table.insert(snake.body, 1, head)

    -- Check if snake ate the food
    if head.x == food.x and head.y == food.y then
        ui.score = ui.score + 1
        
        -- Play eat sound and create particles
        sounds.eatFood:play()
        particles.createFoodParticles(food.x, food.y)
        ui.triggerScreenShake(2)

        if ui.score > ui.highscore then
            ui.highscore = ui.score
            love.filesystem.write("highscore.txt", tostring(ui.highscore))
        end
        
        -- Spawn new food at a different location
        food.spawn(snake.body)
    else
        table.remove(snake.body)  -- Remove tail if no food eaten
    end
end

function snake.handleInput(key)
    if key == "up" and direction ~= "down" then nextDirection = "up"
    elseif key == "down" and direction ~= "up" then nextDirection = "down"
    elseif key == "left" and direction ~= "right" then nextDirection = "left"
    elseif key == "right" and direction ~= "left" then nextDirection = "right"
    end
end

function snake.draw()
    for i, segment in ipairs(snake.body) do
        -- Gradient color effect with smoother transition
        local r = 0.1 + (i * 0.02)
        local g = 0.9 - (i * 0.02)
        local b = 0.1

        -- Outer glow effect for a softer appearance
        love.graphics.setColor(r, g, b, 0.3)
        love.graphics.rectangle("fill", (segment.x - 1) * settings.gridSize - 2, (segment.y - 1) * settings.gridSize - 2, settings.gridSize, settings.gridSize, 6, 6)

        -- Main body with rounded corners for smoothness
        love.graphics.setColor(r, g, b, 1)
        love.graphics.rectangle("fill", (segment.x - 1) * settings.gridSize, (segment.y - 1) * settings.gridSize, settings.gridSize - 2, settings.gridSize - 2, 4, 4)

        -- Add subtle highlight for depth
        love.graphics.setColor(r + 0.1, g + 0.1, b + 0.1, 0.8)
        love.graphics.rectangle("fill", (segment.x - 1) * settings.gridSize + 2, (segment.y - 1) * settings.gridSize + 2, settings.gridSize - 6, settings.gridSize - 6, 4, 4)
    end
    -- Reset color
    love.graphics.setColor(1, 1, 1)
end


return snake