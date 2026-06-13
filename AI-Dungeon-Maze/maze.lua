Maze = {}

function Maze.load()
    -- Defining maze size (number of cells)
    Maze.width = 20
    Maze.height = 20

    -- Initializing maze grid with walls (1 = wall, 0 = open path)
    Maze.grid = {}

    for y = 1, Maze.height do
        Maze.grid[y] = {}  -- Creating a row in the grid (list of cells for each y-coordinate)
        for x = 1, Maze.width do
            Maze.grid[y][x] = 1 -- Starting with all walls
        end
    end
    
    -- Generate maze paths
    Maze.generate()

    -- Randomly place the goal at an open space
    local goalPlaced = false
    while not goalPlaced do
        local randX = love.math.random(1, Maze.width)
        local randY = love.math.random(1, Maze.height)

        -- Check if the random position is an open space (value 0)
        if Maze.grid[randY][randX] == 0 then
            Maze.goalX = randX
            Maze.goalY = randY
            goalPlaced = true  -- We successfully placed the goal
        end
    end
end

function Maze.generate()
    local stack = {}

    local function isInside(x, y)
        return x > 0 and x <= Maze.width and y > 0 and y <= Maze.height
    end
    
    -- Start from a random position
    local startX, startY = 3, 3  -- Ensuring player spawns in a clear path
    Maze.grid[startY][startX] = 0
    table.insert(stack, { x = startX, y = startY })
    
    -- Directions (Right, Left, Down, Up)
    local directions = { {1,0}, {-1,0}, {0,1}, {0,-1} }
    
    while #stack > 0 do
        local current = stack[#stack]
        local x, y = current.x, current.y
    
        -- Shuffle directions
        for i = #directions, 2, -1 do
            local j = love.math.random(i)
            directions[i], directions[j] = directions[j], directions[i]
        end
    
        local found = false
        for _, dir in ipairs(directions) do
            local nx, ny = x + dir[1] * 2, y + dir[2] * 2
            if isInside(nx, ny) and Maze.grid[ny][nx] == 1 then
                -- Open path
                Maze.grid[ny][nx] = 0
                Maze.grid[y + dir[2]][x + dir[1]] = 0
                table.insert(stack, { x = nx, y = ny })
                found = true
                break
            end
        end
    
        if not found then
            table.remove(stack)
        end
    end
end    

-- Win condition check
function Maze.win()
    -- Convert goal cell position to pixel coordinates
    local goalX = (Maze.goalX - 1) * 40 + 20
    local goalY = (Maze.goalY - 1) * 40 + 20

    -- Check if the player is within the goal area
    local distance = math.sqrt((Player.x - goalX)^2 + (Player.y - goalY)^2)

    if distance < Player.size then
        return true  -- Return true when the player reaches the goal
    end

    return false
end

-- Drawing the maze and its elements with improved visuals
function Maze.draw()
    local cellSize = 40 -- Size of each cell

    -- Set background color (dark theme background)
    love.graphics.setColor(0.1, 0.1, 0.1)  -- Dark background
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- Draw the maze grid with wall and path contrast
    for y = 1, Maze.height do
        for x = 1, Maze.width do
            if Maze.grid[y][x] == 1 then
                love.graphics.setColor(0.3, 0.3, 0.3)  -- Dark gray walls
            else
                love.graphics.setColor(0.6, 0.6, 0.6)  -- Light gray paths
            end
            love.graphics.rectangle("fill", (x - 1) * cellSize, (y - 1) * cellSize, cellSize, cellSize)
        end
    end

    -- Draw the goal with a glowing effect
    love.graphics.setColor(0.0, 1.0, 0.0) -- Green for the goal
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", (Maze.goalX - 1) * cellSize, (Maze.goalY - 1) * cellSize, cellSize, cellSize)
    love.graphics.setLineWidth(1)
end

-- Draw win message with a glowing shadow effect
function Maze.drawWinMessage()
    love.graphics.setFont(love.graphics.newFont(50))
    love.graphics.setColor(0, 0, 0)  -- Shadow color for text
    love.graphics.print("You Win!", love.graphics.getWidth() / 2 + 4, love.graphics.getHeight() / 2 + 4)

    love.graphics.setColor(1, 1, 0)  -- Bright yellow for "You Win!"
    love.graphics.print("You Win!", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end
 