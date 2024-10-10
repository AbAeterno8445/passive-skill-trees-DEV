---@enum PSTSubmenu
PSTSubmenu = {
    NONE = "",
    COSMICREALIGNMENT = "cosmicRealignment",
    STARJEWELINV = "starJewelInventory"
}

-- Hack to provide VSCode autocomplete functionality on modules (wtf?)
local moduleRequire = require
moduleRequire = include

-- Submenus refer to the smaller interactable menus that show up for e.g. Cosmic Realignment or starcursed jewel inventories
local submenusModule = {
    currentSubmenu = PSTSubmenu.NONE,

    BGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true),

    submenus = {
        [PSTSubmenu.COSMICREALIGNMENT] = moduleRequire("scripts.tree_screen.modules.submenus.cosmicRSubmenu"),
        [PSTSubmenu.STARJEWELINV] = moduleRequire("scripts.tree_screen.modules.submenus.starcursedInvSubmenu")
    },
}

-- Init
submenusModule.BGSprite:Play("Pixel", true)
submenusModule.BGSprite.Color.A = 0.7

---@param tScreen PST.treeScreen
---@param menuRows number
---@param centerX number
---@param centerY number
---@param menuX number
---@param menuY number
---@param title string
---@param itemDrawFunc function
---@param pagination? table -- If provided, "prev" and "next" buttons will be drawn. Table can contain prevFunc and nextFunc which will run when clicking the corresponding button.
function submenusModule:DrawNodeSubMenu(tScreen, menuRows, centerX, centerY, menuX, menuY, title, itemDrawFunc, pagination)
    -- Draw BG
    self.BGSprite.Scale.X = 168
    self.BGSprite.Scale.Y = 24 + 32 * math.ceil(menuRows / 5)
    self.BGSprite.Color.A = 0.9
    local tmpBGX = menuX * tScreen.zoomScale - 84
    local tmpBGY = menuY * tScreen.zoomScale + 14
    self.BGSprite:Render(Vector(tmpBGX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, tmpBGY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y))

    -- Stop node hovering while cursor is in this menu
    if centerX >= tmpBGX and centerX <= tmpBGX + self.BGSprite.Scale.X and
    centerY >= tmpBGY and centerY <= tmpBGY + self.BGSprite.Scale.Y then
        tScreen.hoveredNode = nil
    end

    Isaac.RenderText(
        title,
        menuX * tScreen.zoomScale - 54 - tScreen.treeCamera.X - tScreen.camZoomOffset.X,
        menuY * tScreen.zoomScale + 20 - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y,
        1, 1, 1, 1
    )

    if pagination then
        local tmpColor = {1, 1, 1, 1}

        -- Prev page button
        tmpBGX = menuX * tScreen.zoomScale - 48
        tmpBGY = tmpBGY + self.BGSprite.Scale.Y + 1
        self.BGSprite.Scale.X = 40
        self.BGSprite.Scale.Y = 18
        if pagination.prevDisabled then
            tmpColor = {0.5, 0.5, 0.5, 1}
        end
        if centerX >= tmpBGX and centerX <= tmpBGX + self.BGSprite.Scale.X and
        centerY >= tmpBGY and centerY <= tmpBGY + self.BGSprite.Scale.Y then
            hoveredNode = nil
            if not pagination.prevDisabled then
                tScreen.cursorHighlight = true
                tmpColor = {0.8, 0.8, 1, 1}
                if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) and pagination.prevFunc then
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    pagination.prevFunc()
                end
            end
        end

        self.BGSprite:Render(Vector(tmpBGX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, tmpBGY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y))
        Isaac.RenderText(
            "Prev",
            tmpBGX - tScreen.treeCamera.X - tScreen.camZoomOffset.X + 8,
            tmpBGY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y + 3,
            table.unpack(tmpColor)
        )

        -- Next page button
        tmpColor = {1, 1, 1, 1}
        tmpBGX = menuX * tScreen.zoomScale
        if pagination.nextDisabled then
            tmpColor = {0.5, 0.5, 0.5, 1}
        end
        if centerX >= tmpBGX and centerX <= tmpBGX + self.BGSprite.Scale.X and
        centerY >= tmpBGY and centerY <= tmpBGY + self.BGSprite.Scale.Y then
            hoveredNode = nil
            if not pagination.nextDisabled then
                tScreen.cursorHighlight = true
                tmpColor = {0.8, 1, 1, 1}
                if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) and pagination.nextFunc then
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    pagination.nextFunc()
                end
            end
        end

        self.BGSprite:Render(Vector(tmpBGX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, tmpBGY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y))
        Isaac.RenderText(
            "Next",
            tmpBGX - tScreen.treeCamera.X - tScreen.camZoomOffset.X + 9,
            tmpBGY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y + 3,
            table.unpack(tmpColor)
        )

        -- Page counter if provided
        if pagination.itemNum and pagination.maxItems then
            local tmpStr = tostring(pagination.itemNum) .. "/" .. tostring(pagination.maxItems)
            tmpColor = {1, 1, 1, 1}
            if pagination.itemNum >= pagination.maxItems then
                tmpColor = {0.9, 0.2, 0.2, 1}
            end
            Isaac.RenderText(
                tmpStr,
                tmpBGX - tScreen.treeCamera.X - tScreen.camZoomOffset.X - 81,
                tmpBGY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y + 3,
                table.unpack(tmpColor)
            )
        end
    end
    if itemDrawFunc then itemDrawFunc() end
end

---@param newSubmenu PSTSubmenu
---@param openData? table Data table given to the chosen submenu's OnOpen function
---@param keep? boolean If true, keeps current submenu open if set again (and calls OnOpen again)
function submenusModule:SwitchSubmenu(newSubmenu, openData, keep)
    local tmpSubmenu = self.submenus[newSubmenu]
    if not tmpSubmenu then return end

    if self.currentSubmenu ~= newSubmenu or keep then
        self.currentSubmenu = newSubmenu
        if tmpSubmenu.OnOpen then tmpSubmenu:OnOpen(openData) end
    elseif not keep then
        self.currentSubmenu = PSTSubmenu.NONE
    end
end

function submenusModule:CloseSubmenu()
    local tmpSubmenu = self.submenus[self.currentSubmenu]
    if tmpSubmenu and tmpSubmenu.OnClose then tmpSubmenu:OnClose() end
    self.currentSubmenu = PSTSubmenu.NONE
end

---@param tScreen PST.treeScreen
function submenusModule:Update(tScreen)
    local tmpSubmenu = self.submenus[self.currentSubmenu]
    if tmpSubmenu and tmpSubmenu.Update then
        tmpSubmenu:Update(tScreen, self)
    end
end

---@param tScreen PST.treeScreen
function submenusModule:Render(tScreen)
    local tmpSubmenu = self.submenus[self.currentSubmenu]
    if tmpSubmenu and tmpSubmenu.Render then
        tmpSubmenu:Render(tScreen, self)
    end
end

return submenusModule