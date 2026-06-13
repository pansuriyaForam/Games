local settings = require "settings"
local utils = require "utils"

local food = {}

function food.reset(snakeBody)
    food.spawn(snakeBody)  -- Pass the snake's body here for collision checking
end

function food.spawn(snakeBody)
    local newFood
    repeat
        newFood = {x=math.random(1, settings.gridWidth), y=math.random(1, settings.gridHeight)}
    until not utils.checkCollision(newFood.x, newFood.y, snakeBody)  -- Use snake's body to check for collisions
    food.x, food.y = newFood.x, newFood.y
end

function food.draw()
    -- Outer glow effect
    love.graphics.setColor(1, 0.2, 0.2, 0.2)  
    love.graphics.circle("fill", (food.x - 0.5) * settings.gridSize, (food.y - 0.5) * settings.gridSize, settings.gridSize * 0.6)

    -- Main food body with soft shading
    love.graphics.setColor(1, 0.2, 0.2, 0.8)
    love.graphics.circle("fill", (food.x - 0.5) * settings.gridSize, (food.y - 0.5) * settings.gridSize, settings.gridSize * 0.4)

    -- Highlight effect for depth
    love.graphics.setColor(1, 0.5, 0.5, 1)
    love.graphics.circle("fill", (food.x - 0.45) * settings.gridSize, (food.y - 0.55) * settings.gridSize, settings.gridSize * 0.15)

    -- Reset color
    love.graphics.setColor(1, 1, 1)
end


return food
