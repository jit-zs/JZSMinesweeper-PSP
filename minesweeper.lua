local startTime = os.time()
local elapsedTime = os.time() - startTime
local open = true
local dead = false
local won = false
local initialized = false
local returnCode = ReturnCode.exit

local gridDimensions = {x=28, y=15}
local gridOffset = {x=16, y=16}
local mines = {}
local flagCount = 0
local mineCount = 0
local flaggedMineCount = 0

math.randomseed(os.time(), os.time() * 1332)
local Node = {
    veiled = true,
    bomb = false,
    flagged = false,
    numOfAdjacentBombs = 0,
}
function Node.new(bomb)
    Node.__index = Node
    local tbl = {}
    setmetatable(tbl, Node)
    return tbl
end

local Minesweeper = { cursorPos = { x = 1, y = 1 } }
function Minesweeper:hoveredMine()
    return mines[self.cursorPos.x][self.cursorPos.y]
end

local function surroundingCells(px, py)
    local cells = {}
    for i = -1, 1 do
        for j = -1, 1 do
            local pos = { x = px + i, y = py + j }
            if pos.x >= 1 and pos.x <= gridDimensions.x and pos.y >= 1 and pos.y <= gridDimensions.y then
                table.insert(cells, mines[pos.x][pos.y])
            end
        end
    end
    return cells
end

local function surroundingBombs(px, py)
    local bombs = 0
    local surrCells = surroundingCells(px, py)
    for i = 1, #surrCells do
        if surrCells[i].bomb then bombs += 1 end
    end
    return bombs
end
local function checkNeigboringUnveiled(px, py)
    local cells = surroundingCells(px, py)
    for i = 1, #cells do
        if not cells[i].veiled then return true end
    end
    return false
end
local function revealAdjacent(px, py)
    if not math.inarrbounds(gridDimensions.x, px) or not math.inarrbounds(gridDimensions.y, py) or mines[px][py].veiled == false then return end
    mines[px][py].veiled = false
    local bombCount = surroundingBombs(px, py)
    screen.print(0, 0, tostring(bombCount))
    if bombCount == 0 then
        revealAdjacent(px, py + 1)
        revealAdjacent(px, py - 1)
        revealAdjacent(px + 1, py)
        revealAdjacent(px - 1, py)
        revealAdjacent(px + 1, py + 1)
        revealAdjacent(px - 1, py - 1)
        revealAdjacent(px + 1, py - 1)
        revealAdjacent(px - 1, py + 1)
    end
end

local function init(clickPos)
    initialized = true
    for i = 1, gridDimensions.x do
        table.insert(mines, {})
        for j = 1, gridDimensions.y do
            table.insert(mines[i], Node.new())
        end
        for j = 1, 3 do mines[i][j].bomb = true ; mineCount += 1 end
        table.randomizearray(mines[i])
    end
end

function Minesweeper.new(t)
    Minesweeper.__index = Minesweeper
    setmetatable(Minesweeper, { __index = Updateable })
    local tbl = Updateable.new(t)
    setmetatable(tbl, Minesweeper)

    return tbl
end

init()

function Minesweeper:update()
    buttons.read()

    self.cursorPos.x += Bool2Int(buttons.right) - Bool2Int(buttons.left)
    self.cursorPos.y += Bool2Int(buttons.down) - Bool2Int(buttons.up)
    if self.cursorPos.x > gridDimensions.x then self.cursorPos.x = 1 end
    if self.cursorPos.x < 1 then self.cursorPos.x = gridDimensions.x end
    if self.cursorPos.y > gridDimensions.y then self.cursorPos.y = 1 end
    if self.cursorPos.y < 1 then self.cursorPos.y = gridDimensions.y end

    if buttons.start then
        open = false
        returnCode = ReturnCode.game
    elseif buttons.select then
        open = false
        returnCode = ReturnCode.main_menu
    end

    if dead or won then return end

    if buttons.cross and not self:hoveredMine().flagged then
        if self:hoveredMine().bomb == true then
            dead = true
        else
            revealAdjacent(self.cursorPos.x, self.cursorPos.y)
        end
    end
    if buttons.square and self:hoveredMine().veiled then
        self:hoveredMine().flagged = not self:hoveredMine().flagged
        if self:hoveredMine().flagged then
            if self:hoveredMine().bomb then flaggedMineCount += 1 end
            flagCount += 1
        else
            if self:hoveredMine().bomb then flaggedMineCount -= 1 end
            flagCount -= 1
         end
         if flaggedMineCount == mineCount == flagCount then
            -- Add won code
            won = true
         end
    end
    if not won and not dead then elapsedTime = os.time() - startTime end
end

function Minesweeper:draw()
    for i = 1, gridDimensions.x do
        for j = 1, gridDimensions.y do
            local pos = { x = (i - 1) * 16 + gridOffset.x, y = (j - 1) * 16 + gridOffset.y}
            if mines[i][j].veiled then
                Minefield.DrawVeiled(pos.x, pos.y)
            else
                Minefield.DrawUnveiled(pos.x, pos.y)
                if not mines[i][j].bomb then
                    Minefield.DrawNumber(pos.x, pos.y, surroundingBombs(i, j))
                end
            end


            if dead then
                if mines[i][j].bomb then
                    Minefield.DrawMine(pos.x, pos.y)
                end

                if mines[i][j].flagged then
                    if not mines[i][j].bomb then
                        Minefield.DrawX(pos.x, pos.y)
                    end
                end
            else
                if mines[i][j].flagged then
                    Minefield.DrawFlag(pos.x, pos.y)
                end
            end
        end
    end
    Minefield.DrawMineSelector((self.cursorPos.x - 1) * 16 + gridOffset.x, (self.cursorPos.y - 1) * 16 + gridOffset.y)
    screen.print(0, 0, dead and "YOU LOST." or "")
    screen.print(0, 0, won and "YOU WON." or "")
    screen.print(300, 0, "start: restart", .5)
    screen.print(375, 0, "select: main menu", .5)
    screen.print(220, 0, tostring(elapsedTime))
    screen.print(256, 0,"FPS: " .. tostring(screen.fps()))
    screen.flip()
end

local game = Minesweeper.new()

while open do
    Updateable.updateAll()
    Updateable.drawAll()
end
screen.flip()
game = nil

return returnCode
