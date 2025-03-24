Resolution = { 480, 272 }
ReturnCode = {
    exit = 0,
    game = 1,
    main_menu = 2,
}
local scenes = {
    "game.lua",
    "main_menu.lua",
}
local nextScene = ReturnCode.main_menu

require "resources"
require "updateable"
require "utils"
os.cpu(333)
screen.bilinear(0)

while nextScene ~= 0 do
    if nextScene == ReturnCode.main_menu then
        nextScene = dofile("main_menu.lua")
    elseif nextScene == ReturnCode.game then
        nextScene = dofile("minesweeper.lua")
    end
    collectgarbage()
end
os.exit();
