local settings = require "settings"

local background = {}

function background.generateBackgroundStars()
    background.stars = {}
    for i = 1, 100 do
        table.insert(background.stars, {
            x = love.math.random(0, settings.gridSize * settings.gridWidth),
            y = love.math.random(0, settings.gridSize * settings.gridHeight),
            size = love.math.random(1, 3),
            speed = love.math.random(10, 30),
            color = {
                r = love.math.random(200, 255) / 255,
                g = love.math.random(200, 255) / 255,
                b = love.math.random(200, 255) / 255,
                a = love.math.random(50, 150) / 255
            }
        })
    end
end

function background.update(dt)
    for _, star in ipairs(background.stars) do
        star.x = star.x + (dt * 5)
        if star.x > settings.gridWidth * settings.gridSize then
            star.x = 0
            star.y = math.random(0, settings.gridHeight * settings.gridSize)
        end
    end    
end

function background.draw()
    for _, star in ipairs(background.stars) do
        love.graphics.setColor(star.color.r, star.color.g, star.color.b, star.color.a)
        love.graphics.circle("fill", star.x, star.y, star.size)
    end
end

return background