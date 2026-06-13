local settings = require "settings"
local snake = require "snake"
local food = require "food"
local particles = require "particles"
local background = require "background"
local ui = require "ui"
local utils = require "utils"

function love.load()
    love.window.setTitle("✨🐍Cosmic Snake Game🐍✨")
    love.window.setMode(settings.gridSize * settings.gridWidth, settings.gridSize * settings.gridHeight, {resizable=false})
    
    -- Load sounds
    sounds = {
        eatFood = love.audio.newSource("eat_food.mp3", "static"),
        gameOver = love.audio.newSource("game_over.wav", "static")
    }
    
    -- Set background
    love.graphics.setBackgroundColor(0.05, 0.05, 0.1)  -- Dark space-like background
    
    -- Generate stars
    background.generateBackgroundStars()

    -- Load high score
    ui.loadHighScore()

    -- Start on the title screen
    ui.gameState = "start"
end

function resetGame()
    snake.reset()
    food.reset(snake.body)
    particles.reset()
    ui.reset()
    ui.gameState = "playing"
end

function love.update(dt)
    background.update(dt)
    particles.update(dt)
    ui.updateScreenShake(dt)

    if ui.gameState == "playing" and not ui.gameOver then
        snake.update(dt)
    end
end

function love.keypressed(key)
    if ui.gameState == "start" and key == "return" then
        resetGame()
    elseif ui.gameState == "playing" then
        snake.handleInput(key)
        if key == "r" and ui.gameOver then 
            resetGame()
        end
    elseif ui.gameState == "gameOver" and key == "r" then
        resetGame()
    end
end

function love.draw()
    -- Apply screen shake
    love.graphics.push()
    love.graphics.translate(ui.screenShake.x, ui.screenShake.y)

    background.draw()

    if ui.gameState == "start" then
        ui.drawStartScreen()
    elseif ui.gameState == "playing" then
        food.draw()
        snake.draw()
        particles.draw()
        ui.draw()
    elseif ui.gameState == "gameOver" then
        ui.drawGameOverScreen()
    end

    -- Reset graphics state
    love.graphics.pop()
end
