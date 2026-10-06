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

local tabberButtonCols = 5
local targetScreens = {
    {
        name = "Star Tree",
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
        name = "Arcane Astrolabe",
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
        name = "Sidereal Tree",
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
        name = "Astral Forge",
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
        name = "Weapon Bounties",
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
        name = "Timeless Bazaar",
        nodeFrame = 792,
        enabledFunc = function()
            return PST:isNodeNameAllocated("sidereal", "Timeless Bazaar")
        end,
        ---@param tScreen PST.treeScreen
        switchFunc = function(tScreen)
            tScreen.modules.menuScreensModule:SwitchToMenu(PSTTreeScreenMenu.BAZAAR)
        end
    },
    {
        name = "Obscure Bazaar",
        nodeFrame = 979,
        enabledFunc = function()
            return PST:isNodeNameAllocated("starTree", "Obscure Bazaar")
        end,
        ---@param tScreen PST.treeScreen
        switchFunc = function(tScreen)
            tScreen:switchCurrentTree("starTree", "Obscure Bazaar")
        end
    },
    {
        name = "Astral Companions",
        nodeFrame = 997,
        enabledFunc = function()
            return PST:isNodeNameAllocated("sidereal", "Astral Companions")
        end,
        ---@param tScreen PST.treeScreen
        switchFunc = function(tScreen)
            tScreen:switchCurrentTree("sidereal", "Astral Companions")
            PST:updateNodes("sidereal")
        end
    },
    {
        name = "S. Artifacts",
        nodeFrame = 885,
        enabledFunc = function()
            return PST:isNodeNameAllocated("sidereal", "Sidereal Artifact")
        end,
        ---@param tScreen PST.treeScreen
        switchFunc = function(tScreen)
            tScreen:switchCurrentTree("sidereal", "Sidereal Artifact")
            PST:updateNodes("sidereal")
        end
    }
}

function menuTabberScreen:GetMenuPos()
    local screenScale = 1 / Isaac.GetScreenPointScale()
    return Vector(
        math.max(0, (Isaac.GetScreenWidth() - 470 * screenScale) / 2),
        math.max(0, (Isaac.GetScreenHeight() - 280 * screenScale) / 2)
    )
end

function menuTabberScreen:OnOpen()
    self.selectedOption = 1
    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
end

function menuTabberScreen:OnInput()
    -- Menu buttons selection
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT) then
        self.selectedOption = self.selectedOption - 1
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.6, 2, false, 1.3)
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT) or PST:isKeybindActive(PSTKeybind.TREE_TAB) then
        self.selectedOption = self.selectedOption + 1
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.6, 2, false, 1.3)
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_UP) then
        self.selectedOption = self.selectedOption - tabberButtonCols
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.6, 2, false, 1.3)
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN) then
        self.selectedOption = self.selectedOption + tabberButtonCols
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.6, 2, false, 1.3)
    end
    self.selectedOption = math.max(1, math.min(#targetScreens, self.selectedOption))

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
    local tmpWidth = 250 --PST.miniFont:GetStringWidth(tmpStr) + 10
    local tmpHeight = 32 + math.ceil(#targetScreens / tabberButtonCols) * 40

    local tmpDrawX = tScreen.screenW / 2 - tmpWidth / 2
    local tmpDrawY = tScreen.screenH / 2 - tmpHeight / 2

    -- Draw screen background
    self.BGSprite.Scale = Vector(tmpWidth, tmpHeight)
    self.BGSprite:Render(Vector(tmpDrawX, tmpDrawY))

    -- Info text
    PST.miniFont:DrawStringUTF8(tmpStr, tmpDrawX + 3, tmpDrawY + 1, PST.kcolors.WHITE)
    tmpDrawY = tmpDrawY + 15

    -- Draw target screen selections
    local renderPos = self:GetMenuPos()
    local nodeSprite = tScreen.modules.nodeDrawingModule.nodesSprite
    for i, tmpTarget in ipairs(targetScreens) do
        local screenScale = 1 / Isaac.GetScreenPointScale()

        local buttonX = renderPos.X + (16 + ((i - 1) % tabberButtonCols) * (456 / tabberButtonCols)) * screenScale
        local buttonY = renderPos.Y + (62 + math.floor((i - 1) / tabberButtonCols) * 80) * screenScale
        local isSelected = self.selectedOption == i
        local isEnabled = tmpTarget:enabledFunc()

        -- Draw node
        if tmpTarget.nodeFrame ~= nil then
            local oldAlpha = nodeSprite.Color.A
            local oldScaleX, oldScaleY = nodeSprite.Scale.X, nodeSprite.Scale.Y
            if not isEnabled or not isSelected then
                nodeSprite.Color.A = 0.5
            end
            nodeSprite.Scale.X = 0.5
            nodeSprite.Scale.Y = 0.5
            nodeSprite:SetFrame("Default", tmpTarget.nodeFrame)
            nodeSprite:Render(Vector(buttonX + 32 * screenScale, buttonY + 32 * screenScale))
            nodeSprite.Color.A = oldAlpha
            nodeSprite.Scale.X = oldScaleX
            nodeSprite.Scale.Y = oldScaleY
        end

        -- Draw title
        local tmpColor = PST.kcolors.WHITE
        if isSelected then
            tmpColor = PST.kcolors.TEAL1
        end
        if not isEnabled then
            tmpColor = PST.kcolors.RED1
        end
        local tmpTitle = tmpTarget.name
        if isSelected then
            tmpTitle = "> " .. tmpTarget.name .. " <"
        end
        local titlePosX = buttonX + (31 - PST.miniFont:GetStringWidth(tmpTitle) / 2) * screenScale
        local titlePosY = buttonY + 50 * screenScale
        PST.miniFont:DrawStringScaledUTF8(tmpTitle, titlePosX, titlePosY, screenScale, screenScale, tmpColor)
        if not isEnabled then
            local tmpText = PST:getLocalized("ui_Locked")
            titlePosX = buttonX + (31 - PST.miniFont:GetStringWidth(tmpText) / 2) * screenScale
            PST.miniFont:DrawStringScaledUTF8(tmpText, titlePosX, titlePosY + 7, 0.5, 0.5, PST.kcolors.RED1)
        end
    end
end

return menuTabberScreen