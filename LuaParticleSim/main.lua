local particles = {}

function love.load() 
    love.window.setTitle("Cosmic Particles")
    love.window.setMode(600, 800, {resizable = false})
    love.graphics.setBackgroundColor(0, 0, 0)
end

function love.update(dt)
    if love.mouse.isDown(1) then 
        local x, y = love.mouse.getPosition()
        local speedBoost = math.random(100, 150) / 100  

        table.insert(particles, {
            x = x,
            y = y,
            size = math.random(2, 6),
            alpha = 1,
            lifespan = math.random(1, 3),
            speedX = math.random(-150, 150) * dt * speedBoost * math.random(1, 3),  
            speedY = math.random(-150, 150) * dt * speedBoost * math.random(1, 3),
            
            --Normalize RGB values (0-255 → 0-1)
            r = math.random(0, 255) / 255,
            g = math.random(0, 255) / 255,
            b = math.random(0, 255) / 255,
        })
    end  

    for i = #particles, 1, -1 do
        local p = particles[i]
        p.x = p.x + p.speedX
        p.y = p.y + p.speedY
        p.alpha = p.alpha - (1 / p.lifespan) * dt

        if p.x <= 0 or p.x >= 600 then p.speedX = -p.speedX end
        if p.y <= 0 or p.y >= 800 then p.speedY = -p.speedY end

        if p.alpha <= 0 then table.remove(particles, i) end
    end
end

function love.draw() 
    love.graphics.setColor(0, 0, 0, 0.05)
    love.graphics.rectangle("fill", 0, 0, 600, 800)
    love.graphics.setBlendMode("add")

    for _, p in ipairs(particles) do 
        love.graphics.setColor(p.r, p.g, p.b, p.alpha)
        love.graphics.circle("fill", p.x, p.y, p.size)
    end
    love.graphics.setBlendMode("alpha")
end
