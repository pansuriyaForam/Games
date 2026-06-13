local utils = {}

function utils.checkCollision(x, y, body)
    for i = 1, #body do
        if body[i].x == x and body[i].y == y then
            return true
        end
    end
    return false
end

return utils