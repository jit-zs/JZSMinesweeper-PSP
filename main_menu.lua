local menuItems = {
    "Start",
    "Options",
    "Quit",
}
local menuItemsDrawLookup = {
    Start = UI.DrawStart,
    Options = UI.DrawOptions,
    Quit = UI.DrawQuit,
}

local MainMenu = Updateable.new()
local menuOffset = {x = 480 / 2 - 32, y = 272 / 2 + 32}
local open = true
MainMenu.menuItems = menuItems
MainMenu.mainIndex = 1


local returnCode = ReturnCode.exit

function MainMenu.new()
    local tbl = setmetatable({}, MainMenu)
    tbl.mainIndex = 1
    tbl.menuItems = menuItems
    return tbl
end

function MainMenu:update()
    buttons.read()
    if (buttons.up) then self.mainIndex -= 1 end
    if (buttons.down) then self.mainIndex += 1 end
    if (self.mainIndex > #menuItems) then self.mainIndex = 1 end
    if (self.mainIndex < 1) then self.mainIndex = #menuItems end
    if buttons.cross then
        if self.mainIndex == 1 then
            returnCode = ReturnCode.game
            open = false
            screen.print(100, 100, "Let me play the game man")
        elseif self.mainIndex == 2 then


        elseif self.mainIndex == 3 then
            returnCode = ReturnCode.exit
            open = false
        end
    end
end

function MainMenu:draw()
    for i = 1, #menuItems do
        menuItemsDrawLookup[menuItems[i]](0 + menuOffset.x, ((i - 1) * 16) + menuOffset.y)
    end
    UI.DrawSelectedBox(0 + menuOffset.x, ((self.mainIndex - 1) * 16) + menuOffset.y)
    screen.print(300, 0, tostring(os.totalram() - os.ram()))
    screen.flip()
end


local mainMenu = MainMenu.new()
while open do
    Updateable.updateAll()
    Updateable.drawAll()
end
mainMenu = nil

return returnCode
