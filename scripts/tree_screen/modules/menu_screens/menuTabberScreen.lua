local menuTabberScreen = {
    BGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true),
    selectedOption = 1,

    inputOverrides = {
        PSTKeybind.TREE_PAN_DOWN, PSTKeybind.TREE_PAN_LEFT, PSTKeybind.TREE_PAN_RIGHT, PSTKeybind.TREE_PAN_UP,
        PSTKeybind.CENTER_CAMERA, PSTKeybind.PAN_FASTER, PSTKeybind.TREE_TAB,
        PSTKeybind.ALLOCATE_NODE, PSTKeybind.RESPEC_NODE, PSTKeybind.SWITCH_TREE
    }
}

-- Init
menuTabberScreen.BGSprite:Play("Pixel", true)

local targetScreens = {
    {
        name = PST:getLocalized("ui_starTree"),
        nodeFrame = 319,
        enabledFunc = function()
            return PST:isNodeNameAllocated("global", "Star Tree")
        end,
        ---@param tScreen PST.treeScreen
        switchFunc = function(tScreen)
            tScreen:switchCurrentTree("starTree")
        end
    },
    {
        name = PST:getLocalized("ui_arcaneAstrolabe"),
        nodeFrame = 757,
        enabledFunc = function()
            return PST:isNodeNameAllocated("starTree" ,"Arcane Astrolabe")
        end,
        ---@param tScreen PST.treeScreen
        switchFunc = function(tScreen)
            tScreen.modules.menuScreensModule:SwitchToMenu(PSTTreeScreenMenu.EXPEDITION)
        end
    },
    {
        name = PST:getLocalized("ui_siderealTree"),
        nodeFrame = 758,
        enabledFunc = function()
            return PST:isNodeNameAllocated("starTree", "Sidereal Tree")
        end,
        ---@param tScreen PST.treeScreen
        switchFunc = function(tScreen)
            tScreen:switchCurrentTree("sidereal")
            PST:updateNodes("sidereal")
        end
    },
    {
        name = PST:getLocalized("ui_astralForge"),
        nodeFrame = 761,
        enabledFunc = function()
            return PST:isNodeNameAllocated("sidereal", "Astral Forge")
        end,
        ---@param tScreen PST.treeScreen
        switchFunc = function(tScreen)
            tScreen.modules.menuScreensModule:SwitchToMenu(PSTTreeScreenMenu.ASTRAL_FORGE)
        end
    },
    {
        name = PST:getLocalized("ui_ancwepBounties"),
        nodeFrame = 845,
        enabledFunc = function()
            return PST:isNodeNameAllocated("sidereal", "Ancient Weapon Bounties")
        end,
        ---@param tScreen PST.treeScreen
        switchFunc = function(tScreen)
            tScreen.modules.menuScreensModule:SwitchToMenu(PSTTreeScreenMenu.ANCIENT_WEAPON_BOUNTIES)
        end
    },
    {
        name = PST:getLocalized("ui_timelessBazaar"),
        nodeFrame = 792,
        enabledFunc = function()
            return PST:isNodeNameAllocated("sidereal", "Timeless Bazaar")
        end,
        ---@param tScreen PST.treeScreen
        switchFunc = function(tScreen)
            tScreen.modules.menuScreensModule:SwitchToMenu(PSTTreeScreenMenu.BAZAAR)
        end
    }
}

function menuTabberScreen:OnOpen()
    self.selectedOption = 1
    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
end

function menuTabberScreen:OnInput()
    -- Input: Directional keys/buttons
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP) then
        -- UP
        self.selectedOption = self.selectedOption - 1
        if self.selectedOption <= 0 then
            self.selectedOption = #targetScreens
        end
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.5, 2, false, 1.3)
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN) or PST:isKeybindActive(PSTKeybind.TREE_TAB) then
        -- DOWN
        self.selectedOption = self.selectedOption + 1
        if self.selectedOption > #targetScreens then
            self.selectedOption = 1
        end
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.5, 2, false, 1.3)
    end

    -- Input: Allocate, try to switch to selected tree/screen
    if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
        local tmpOpt = targetScreens[self.selectedOption]
        if tmpOpt and tmpOpt.enabledFunc() then
            PST.treeScreen.modules.menuScreensModule:CloseMenu()
            tmpOpt.switchFunc(PST.treeScreen)
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
        else
            SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
        end
    end
end

---@param tScreen PST.treeScreen
function menuTabberScreen:Render(tScreen)
    local tmpStr = PST:getLocalized("ui_selScreenToSwitch") .. ":"
    local tmpWidth = PST.miniFont:GetStringWidth(tmpStr) + 10
    local tmpHeight = 21 + #targetScreens * 34

    local tmpDrawX = tScreen.screenW / 2 - tmpWidth / 2
    local tmpDrawY = tScreen.screenH / 2 - tmpHeight / 2

    -- Draw screen background
    self.BGSprite.Scale = Vector(tmpWidth, tmpHeight)
    self.BGSprite:Render(Vector(tmpDrawX, tmpDrawY))

    -- Info text
    PST.miniFont:DrawString(tmpStr, tmpDrawX + 3, tmpDrawY + 1, PST.kcolors.WHITE)
    tmpDrawY = tmpDrawY + 15

    -- Draw target screen selections
    local nodeSprite = tScreen.modules.nodeDrawingModule.nodesSprite
    local tmpDrawn = 0
    for i, tmpTarget in ipairs(targetScreens) do
        local nodeY = tmpDrawY + 15 + tmpDrawn * 35
        local isSelected = self.selectedOption == i
        local isEnabled = tmpTarget:enabledFunc()

        -- Draw node
        local oldAlpha = nodeSprite.Color.A
        local oldScaleX, oldScaleY = nodeSprite.Scale.X, nodeSprite.Scale.Y
        if not isEnabled then
            nodeSprite.Color.A = 0.5
        end
        nodeSprite.Scale.X = 1
        nodeSprite.Scale.Y = 1
        nodeSprite:SetFrame("Default", tmpTarget.nodeFrame)
        nodeSprite:Render(Vector(tmpDrawX + 20, nodeY))
        nodeSprite.Color.A = oldAlpha
        nodeSprite.Scale.X = oldScaleX
        nodeSprite.Scale.Y = oldScaleY

        -- Node text
        local tmpNodeTxt = tmpTarget.name
        local tmpColor = PST.kcolors.WHITE
        if isSelected then
            tmpNodeTxt = "> " .. tmpNodeTxt
            tmpColor = PST.kcolors.TEAL1
        end
        if not isEnabled then
            tmpColor = PST.kcolors.RED1
        end
        PST.miniFont:DrawString(tmpNodeTxt, tmpDrawX + 40, nodeY - 7, tmpColor)
        if not isEnabled then
            PST.miniFont:DrawStringScaled(PST:getLocalized("ui_locked"), tmpDrawX + 40, nodeY + 5, 0.5, 0.5, PST.kcolors.RED1)
        end

        tmpDrawn = tmpDrawn + 1
    end
end

return menuTabberScreen