local settings = require "settings"
local utils = require "utils"
local love = require "love"

local particles = {}

-- Create food particles
function particles.createFoodParticles(x, y)
    for i = 1, 20 do
        local particle = {
            x = (x - 1) * settings.gridSize + settings.gridSize / 2,
            y = (y - 1) * settings.gridSize + settings.gridSize / 2,
            dx = love.math.randomNormal(100, 0),
            dy = love.math.randomNormal(100, 0),
            life = 0.5,
            color = {
                r = love.math.random(200, 255) / 255,
                g = love.math.random(50, 150) / 255,
                b = love.math.random(50, 150) / 255,
                a = 1
            }
        }
        table.insert(particles, particle)
    end
end

-- Update particles
function particles.update(dt)
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.x = p.x + p.dx * dt
        p.y = p.y + p.dy * dt
        p.life = p.life - dt
        p.color.a = p.color.a * 0.95  -- Fade out

        -- Remove particles when they die
        if p.life <= 0 then
            table.remove(particles, i)
        end
    end
end

-- Draw all particles
function particles.draw()
    for _, p in ipairs(particles) do
        love.graphics.setColor(p.color.r, p.color.g, p.color.b, p.color.a)
        love.graphics.circle("fill", p.x, p.y, 2)
    end
end

-- Reset the particle system (e.g., when the game restarts)
function particles.reset()
    particles = {}
end

return particles
