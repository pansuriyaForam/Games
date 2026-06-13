require("player")
require("maze")

function love.load()
    love.window.setTitle("AI_Dungeon_Maze")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)  -- Dark background for the window

    Maze.load()

    local cellSize = 40
    love.window.setMode(Maze.width * cellSize, Maze.height * cellSize)
end

function love.update(dt)
    if not Maze.win() then
        Player.move(dt)
    end
end

function love.draw()
    Maze.draw()
    Player.draw()

    if Maze.win() then
        Maze.drawWinMessage()
    end
end
