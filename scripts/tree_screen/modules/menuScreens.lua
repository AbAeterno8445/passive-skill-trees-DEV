include ("scripts.ST_changelog")

---@enum PSTTreeScreenMenu
PSTTreeScreenMenu = {
    NONE = "",
    CHANGELOG = "changelog",
    TOTALMODS = "totalMods",
    HELP = "helpmenu"
}

-- Hack to provide VSCode autocomplete functionality on modules (wtf?)
local moduleRequire = require
moduleRequire = include

local menuScreensModule = {
    currentMenu = PSTTreeScreenMenu.NONE,
    menuScrollY = 0,

    menus = {
        [PSTTreeScreenMenu.CHANGELOG] = moduleRequire("scripts.tree_screen.modules.menu_screens.changelogScreen"),
        [PSTTreeScreenMenu.TOTALMODS] = moduleRequire("scripts.tree_screen.modules.menu_screens.totalmodsScreen"),
        [PSTTreeScreenMenu.HELP] = moduleRequire("scripts.tree_screen.modules.menu_screens.helpScreen")
    }
}

---@param targetMenu PSTTreeScreenMenu
---@param openData? table
function menuScreensModule:SwitchToMenu(targetMenu, openData)
    if not self.menus[targetMenu] then self.currentMenu = PSTTreeScreenMenu.NONE end

    self.menuScrollY = 0
    self.currentMenu = targetMenu
    if self.menus[targetMenu].OnOpen then
        self.menus[targetMenu]:OnOpen(openData)
    end
end

function menuScreensModule:CloseMenu()
    self.currentMenu = PSTTreeScreenMenu.NONE
end

---@param tScreen PST.treeScreen
function menuScreensModule:Render(tScreen)
    local currentMenu = self.menus[self.currentMenu]
    if currentMenu and currentMenu.Render then
        currentMenu:Render(tScreen, self)
    end
end

return menuScreensModule