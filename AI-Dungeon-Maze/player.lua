Player = {
    x = 2 * 40 + 20,  -- Start position inside a valid path (converted to pixels)
    y = 2 * 40 + 20,
    speed = 200,  -- pixels per second
    size = 12  -- Player size (radius)
}

function Player.move(dt)
    local moveX, moveY = 0, 0

    -- Move based on key input
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then moveY = -1 end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then moveY = 1 end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then moveX = -1 end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then moveX = 1 end

    -- Calculating new position
    local newX = Player.x + moveX * Player.speed * dt
    local newY = Player.y + moveY * Player.speed * dt

    -- Checking collision (ensuring player doesn't go into the walls)
    local cellSize = 40
    local cellX1 = math.floor((newX - Player.size) / cellSize) + 1
    local cellY1 = math.floor((newY - Player.size) / cellSize) + 1
    local cellX2 = math.floor((newX + Player.size) / cellSize) + 1
    local cellY2 = math.floor((newY + Player.size) / cellSize) + 1

    -- Check if all 4 corners of the player are in an open space
    if Maze.grid[cellY1] and Maze.grid[cellY1][cellX1] == 0 and
       Maze.grid[cellY1] and Maze.grid[cellY1][cellX2] == 0 and
       Maze.grid[cellY2] and Maze.grid[cellY2][cellX1] == 0 and
       Maze.grid[cellY2] and Maze.grid[cellY2][cellX2] == 0 then
        -- Only update the position if there is no wall
        Player.x = newX
        Player.y = newY
    end
end

function Player.draw()
    -- Drawing the player with a glowing effect
    love.graphics.setColor(1, 0, 0)  -- Red color for the player
    love.graphics.circle("fill", Player.x, Player.y, Player.size)

    -- Optional: Draw a glow effect around the player
    love.graphics.setColor(1, 0, 0, 0.1)  -- Semi-transparent red glow
    love.graphics.circle("fill", Player.x, Player.y, Player.size + 2)  -- Larger circle for glow effect
end
