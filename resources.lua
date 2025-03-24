MinefieldSourceImage = image.load("res/source.png")
UISourceImage = image.load("res/UIButtons.png")

Minefield = {}
UI = {}

--Minefield draw functions
function Minefield.DrawX(x, y)
    MinefieldSourceImage:blit(x, y, 16, 16, 16, 16)
end

function Minefield.DrawExplosion(x, y)
    MinefieldSourceImage:blit(x, y, 0, 0, 16, 16)
end

function Minefield.DrawMine(x, y)
    MinefieldSourceImage:blit(x, y, 0, 16, 16, 16)
end

function Minefield.DrawFlag(x, y)
    MinefieldSourceImage:blit(x, y, 0, 32, 16, 16)
end

function Minefield.DrawVeiled(x, y)
    MinefieldSourceImage:blit(x, y, 0, 48, 16, 16)
end

function Minefield.DrawUnveiled(x, y)
    MinefieldSourceImage:blit(x, y, 16, 48, 16, 16)
end

function Minefield.DrawMineSelector(x, y)
    MinefieldSourceImage:blit(x, y, 16, 32, 16, 16, 128)
end

function Minefield.DrawNumber(x, y, num)
    MinefieldSourceImage:blit(x, y, 32 + (num % 2 == 0 and 16 or 0), 48 - (math.floor((num - 1) / 2) * 16), 16, 16)
end

--UI draw functions
function UI.DrawStart(x, y)
    UISourceImage:blit(x, y, 0, 0, 64, 16)
end

function UI.DrawOptions(x, y)
    UISourceImage:blit(x, y, 0, 16, 64, 16)
end

function UI.DrawQuit(x, y)
    UISourceImage:blit(x, y, 0, 32, 64, 16)
end

function UI.DrawSelectedBox(x, y)
    UISourceImage:blit(x, y, 64, 0, 64, 16)
end

UISourceImage:move()
MinefieldSourceImage:move()