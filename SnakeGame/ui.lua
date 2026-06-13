local settings = require "settings"

local ui = {
    score = 0,
    highscore = 0,
    gameOver = false,
    gameState = "start", -- "start", "playing", "gameOver"
    screenShake = {x = 0, y = 0, timer = 0, intensity = 0}
}

function ui.loadHighScore()
    if love.filesystem.getInfo("highscore.txt") then
        local data = love.filesystem.read("highscore.txt")
        ui.highscore = tonumber(data) or 0
    end
end

function ui.reset()
    ui.score = 0
    ui.gameOver = false
    ui.screenShake = {x = 0, y = 0, timer = 0, intensity = 0}
end

function ui.triggerScreenShake(intensity)
    ui.screenShake.timer = 0.2
    ui.screenShake.intensity = intensity
end

function ui.updateScreenShake(dt)
    if ui.screenShake.timer > 0 then
        ui.screenShake.timer = ui.screenShake.timer - dt
        ui.screenShake.x = love.math.random(-ui.screenShake.intensity, ui.screenShake.intensity)
        ui.screenShake.y = love.math.random(-ui.screenShake.intensity, ui.screenShake.intensity)
    else
        ui.screenShake.x, ui.screenShake.y = 0, 0
    end
end

function ui.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. ui.score, 10, 10)
    love.graphics.print("High Score: " .. ui.highscore, 10, 30)

    if ui.gameOver then
        ui.gameState = "gameOver"
    end
end

function ui.drawStartScreen()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Cosmic Snake Game", 0, 150, 600, "center")
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.printf("Press ENTER to Start", 0, 220, 600, "center")
end

function ui.drawGameOverScreen()
    love.graphics.setColor(1, 0, 0)
    love.graphics.printf("GAME OVER!", 0, 180, 600, "center")
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Final Score: " .. ui.score, 0, 220, 600, "center")
    love.graphics.printf("Press R to Restart", 0, 260, 600, "center")
end

return ui
