include ("scripts.ST_changelog")

---@enum PSTTreeScreenMenu
PSTTreeScreenMenu = {
    NONE = "",
    CHANGELOG = "changelog",
    TOTALMODS = "totalMods",
    HELP = "helpmenu",
    EXPEDITION = "expeditionMenu",
    ASTRAL_FORGE = "astralForge",
    BAZAAR = "bazaar",
    ANCIENT_WEAPON_BOUNTIES = "ancientWepBounties",
    MENU_TABBER = "menuTabber"
}

local menuScreensModule = {
    currentMenu = PSTTreeScreenMenu.NONE,
    menuScrollY = 0,

    menus = {
        [PSTTreeScreenMenu.CHANGELOG] = include("scripts.tree_screen.modules.menu_screens.changelogScreen"),
        [PSTTreeScreenMenu.TOTALMODS] = include("scripts.tree_screen.modules.menu_screens.totalmodsScreen"),
        [PSTTreeScreenMenu.HELP] = include("scripts.tree_screen.modules.menu_screens.helpScreen"),
        [PSTTreeScreenMenu.EXPEDITION] = include("scripts.tree_screen.modules.menu_screens.expeditionScreen"),
        [PSTTreeScreenMenu.ASTRAL_FORGE] = include("scripts.tree_screen.modules.menu_screens.astralForgeScreen"),
        [PSTTreeScreenMenu.BAZAAR] = include("scripts.tree_screen.modules.menu_screens.timelessBazaarScreen"),
        [PSTTreeScreenMenu.ANCIENT_WEAPON_BOUNTIES] = include("scripts.tree_screen.modules.menu_screens.ancientWepBountiesScreen"),
        [PSTTreeScreenMenu.MENU_TABBER] = include("scripts.tree_screen.modules.menu_screens.menuTabberScreen")
    }
}

---@param targetMenu PSTTreeScreenMenu
---@param openData? table
function menuScreensModule:SwitchToMenu(targetMenu, openData)
    if not self.menus[targetMenu] then self.currentMenu = PSTTreeScreenMenu.NONE end

    PST.treeScreen.modules.submenusModule:CloseSubmenu()
    self.menuScrollY = 0
    self.currentMenu = targetMenu
    if self.menus[targetMenu].OnOpen then
        self.menus[targetMenu]:OnOpen(openData)
    end
end

function menuScreensModule:CloseMenu()
    local currentMenu = self.menus[self.currentMenu]
    ---@type boolean|nil
    local closeMenu = true
    if currentMenu and currentMenu.OnClose then
        closeMenu = currentMenu:OnClose()
    end
    if closeMenu ~= false then
        self.currentMenu = PSTTreeScreenMenu.NONE
    end
end

---@param tScreen PST.treeScreen
function menuScreensModule:Update(tScreen)
    local currentMenu = self.menus[self.currentMenu]
    if currentMenu and currentMenu.Update then
        currentMenu:Update(tScreen)
    end
end

---@param tScreen PST.treeScreen
function menuScreensModule:Render(tScreen)
    local currentMenu = self.menus[self.currentMenu]
    if currentMenu and currentMenu.Render then
        currentMenu:Render(tScreen, self)
    end
end

return menuScreensModule