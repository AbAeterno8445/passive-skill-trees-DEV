---@enum PSTProgUpdateType
PSTProgUpdateType = {
    LEVEL30 = 0,
    LEVEL60 = 1,
    ARTIFACT_UNLOCK = 2,
    EGG_HATCH = 3,
    COMP_LEVEL = 4,
    EXPED_LOSE = 6,
    EXPED_RESET = 7,
    UBEREXP_DEEPSP = 9
}

local maxUpdateLines = 15

local progUpdatesScreen = {
    BGSprite = Sprite("gfx/ui/skilltrees/tree_bg.anm2", true),
    UILinkSprite = Sprite("gfx/ui/skilltrees/nodes/expedition_node_link.anm2", true),

    inputOverrides = {
        PSTKeybind.TREE_PAN_DOWN, PSTKeybind.TREE_PAN_LEFT, PSTKeybind.TREE_PAN_RIGHT, PSTKeybind.TREE_PAN_UP,
        PSTKeybind.CENTER_CAMERA, PSTKeybind.PAN_FASTER, PSTKeybind.TREE_TAB,
        PSTKeybind.ALLOCATE_NODE, PSTKeybind.RESPEC_NODE, PSTKeybind.SWITCH_TREE
    },

    selectedTab = 1,
    currentScroll = 0,
    tabDelay = 0,

    tabUpdateLists = {}
}

-- Init
progUpdatesScreen.BGSprite:Play("Pixel", true)
progUpdatesScreen.UILinkSprite:SetFrame("DescBoxBlueUI", 1)

local progUpdatePhrases = {
    [PSTProgUpdateType.LEVEL30] = {"A character has reached level 30: The Star Tree is now allocatable.", PST.kcolors.PROGUP_ORANGE},
    [PSTProgUpdateType.LEVEL60] = {"{{charName}} has reached level 60 and can now access the Sidereal Tree.", PST.kcolors.PROGUP_ORANGE},
    [PSTProgUpdateType.ARTIFACT_UNLOCK] = {"Unlocked the {{artifactName}} in the Sidereal Tree.", PST.kcolors.PROGUP_PURPLE},
    [PSTProgUpdateType.EGG_HATCH] = {"{{eggName}} has hatched into {{compName}}!", PST.kcolors.PROGUP_PURPLE},
    [PSTProgUpdateType.COMP_LEVEL] = {"{{compName}} is ready to level up to {{compLevel}}.", PST.kcolors.PROGUP_PURPLE},
    [PSTProgUpdateType.EXPED_LOSE] = {"Lost attempt for {{uber}}expedition depth {{expDepth}}.", PST.kcolors.LIGHTRED1},
    [PSTProgUpdateType.EXPED_RESET] = {"All attempts lost, {{uber}}expedition depth {{expDepth}} has been reset!", PST.kcolors.LIGHTRED1},
    [PSTProgUpdateType.UBEREXP_DEEPSP] = {"Uber expedition depth {{expDepth}} has accrued enough entropy and gained a deep-space distortion modifier!", PST.kcolors.LIGHTRED1}
}
local progUpdateTabs = {
    {
        name = "General",
        excluded = {
            PSTProgUpdateType.EXPED_LOSE,
            PSTProgUpdateType.EXPED_RESET,
            PSTProgUpdateType.UBEREXP_DEEPSP
        }
    },
    {
        name = "Sidereal",
        events = {
            PSTProgUpdateType.ARTIFACT_UNLOCK,
            PSTProgUpdateType.EGG_HATCH,
            PSTProgUpdateType.COMP_LEVEL
        }
    },
    {
        name = "Expeditions",
        events = {
            PSTProgUpdateType.EXPED_LOSE,
            PSTProgUpdateType.EXPED_RESET,
            PSTProgUpdateType.UBEREXP_DEEPSP
        }
    }
}

function progUpdatesScreen:OnOpen()
    -- Create update entries list for each category tab
    for _, tmpTab in ipairs(progUpdateTabs) do
        self.tabUpdateLists[tmpTab.name] = {}
        for _, tmpUpdate in ipairs(PST.modData.progUpdates) do
            local updateType = tmpUpdate[1]
            if (not tmpTab.events or tmpTab.events and PST:arrHasValue(tmpTab.events, updateType)) and
            not (tmpTab.excluded and PST:arrHasValue(tmpTab.excluded, updateType)) then
                table.insert(self.tabUpdateLists[tmpTab.name], tmpUpdate)
            end
        end
    end
    self.tabDelay = 0
    self.currentScroll = 0
end

function progUpdatesScreen:OnClose()
    for _, tmpUpdate in ipairs(PST.modData.progUpdates) do
        if tmpUpdate[3] then tmpUpdate[3] = nil end
    end
end

function progUpdatesScreen:DrawUIBox(x, y, w, h)
    self.BGSprite.Scale.X = w
    self.BGSprite.Scale.Y = h
    self.BGSprite:Render(Vector(x, y))

    -- Top decor beam
    local linkBeam = Beam(self.UILinkSprite, 0, false, false)
    local startPos = Vector(x, y)
    local endPos = Vector(x + w, y)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()

    -- Left decor beam
    startPos = Vector(x, y)
    endPos = Vector(x, y + h)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()

    -- Right decor beam
    startPos = Vector(x + w, y + h)
    endPos = Vector(x + w, y)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()

    -- Bottom decor beam
    startPos = Vector(x + w, y + h)
    endPos = Vector(x, y + h)
    linkBeam:Add(startPos, 0)
    linkBeam:Add(endPos, 129)
    linkBeam:Render()
end

function progUpdatesScreen:OnInput()
    -- Input: Directional keys/buttons
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT) then
        -- LEFT
        self.selectedTab = self.selectedTab - 1
        if self.selectedTab <= 0 then
            self.selectedTab = #progUpdateTabs
        end
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.6, 2, false, 1.2)
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT) or PST:isKeybindActive(PSTKeybind.TREE_TAB) then
        -- RIGHT / TAB
        self.selectedTab = self.selectedTab + 1
        if self.selectedTab > #progUpdateTabs then
            self.selectedTab = 1
        end
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.6, 2, false, 1.2)
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_UP, true) then
        -- UP
        if self.tabDelay == 0 then
            self.currentScroll = math.max(0, self.currentScroll - 1)
            self.tabDelay = 5
            if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then self.tabDelay = 2 end
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN, true) then
        -- DOWN
        local tabData = progUpdateTabs[self.selectedTab]
        if tabData and self.tabUpdateLists[tabData.name] and self.tabDelay == 0 then
            local tabLimit = math.max(0, #self.tabUpdateLists[tabData.name] - maxUpdateLines)
            self.currentScroll = math.min(tabLimit, self.currentScroll + 1)
            self.tabDelay = 5
            if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then self.tabDelay = 2 end
        end
    end
end

---@param tScreen PST.treeScreen
function progUpdatesScreen:Render(tScreen)
    local boxW, boxH = 400, 190
    local startX = tScreen.screenW / 2 - boxW / 2
    local startY = tScreen.screenH / 2 - boxH / 2
    self:DrawUIBox(startX, startY, boxW, boxH)
    PST.miniFont:DrawStringUTF8("Progression Updates", startX + 4, startY, PST.kcolors.LIGHTBLUE1)

    -- Decor prog updates icon at the top
    local nodeSprite = tScreen.modules.nodeDrawingModule.nodesSprite
    local oldScaleX, oldScaleY, oldAlpha = nodeSprite.Scale.X, nodeSprite.Scale.Y, nodeSprite.Color.A
    nodeSprite.Scale.X = 1
    nodeSprite.Scale.Y = 1

    nodeSprite:SetFrame("Default", 1005)
    nodeSprite:Render(Vector(startX + boxW / 2, startY))

    local textX = startX + 3
    local textY = startY + 20
    for i, tmpTab in ipairs(progUpdateTabs) do
        local tmpColor = PST.kcolors.LIGHTGRAY1
        if self.selectedTab == i then
            tmpColor = PST.kcolors.TEAL1
        end
        local tmpText = "[" .. tmpTab.name .. "]"
        local tmpTabDist = 6 * string.len(tmpText) + 7
        PST.normalFont:DrawStringScaledUTF8(tmpText, textX, textY, 1, 1, tmpColor)
        textX = textX + tmpTabDist
    end

    textX = startX + 4
    textY = textY + 18
    local tabData = progUpdateTabs[self.selectedTab]
    local updatesTable = self.tabUpdateLists[tabData.name]

    local listStart = #updatesTable - self.currentScroll
    local listEnd = math.max(1, #updatesTable - maxUpdateLines - self.currentScroll)
    for i=listStart,listEnd,-1 do
        local tmpUpdate = updatesTable[i]
        if tmpUpdate and tabData then
            local tmpColor = PST.kcolors.WHITE_FADED1
            local updateType = tmpUpdate[1]
            local updatePhrase
            if type(progUpdatePhrases[updateType]) == "table" then
                tmpColor = progUpdatePhrases[updateType][2]
                updatePhrase = progUpdatePhrases[updateType][1]
            else
                updatePhrase = progUpdatePhrases[updateType]
            end

            if tmpUpdate[2] then
                local tmpParams = PST:copyTable(tmpUpdate[2])
                -- Fetch companion/egg names for companion updates
                if tmpParams.compName then
                    local compData = PST.astralCompanions[tmpParams.compName]
                    if compData then
                        tmpParams.compName = PST:getLocalized(compData.identifier .. "_name")
                        tmpParams.eggName = PST:getLocalized(compData.identifier .. "_eggname")
                    end
                end
                -- Uber expedition updates' prefix
                if tmpParams.isUber then
                    tmpParams.uber = "uber "
                end
                local tmpFormatted = PST:formatString(updatePhrase, tmpParams)
                updatePhrase = tmpFormatted
            end

            if updatePhrase then
                local isNewUpdate = tmpUpdate[3]
                if isNewUpdate then
                    updatePhrase = "[NEW] " .. updatePhrase
                end
                PST.normalFont:DrawStringScaledUTF8("> " .. updatePhrase, textX, textY, 0.5, 0.5, tmpColor)
                textY = textY + 9
            end
        end
    end

    textY = startY + boxH - 10
    PST.miniFont:DrawStringScaledUTF8("Left/Right to switch tab, Up/Down to scroll through updates. Shift to scroll faster", textX, textY, 0.5, 0.5, PST.kcolors.WHITE)

    -- Reset tree nodes sprite
    nodeSprite.Scale.X = oldScaleX
    nodeSprite.Scale.Y = oldScaleY
    nodeSprite.Color.A = oldAlpha

    if self.tabDelay > 0 then self.tabDelay = self.tabDelay - 1 end
end

---@param updateType PSTProgUpdateType
---@param updateData table|nil
function PST:addProgressionUpdate(updateType, updateData)
    if not updateData then updateData = {} end
    if PST:isNodeNameAllocated("global", "Progression Updates") then
        table.insert(PST.modData.progUpdates, {updateType, updateData, true})
        if #PST.modData.progUpdates > PST.config.maxProgUpdates then
            table.remove(PST.modData.progUpdates, 1)
        end
    end
end

function PST:getNewProgUpdateCount()
    local newUpdateCount = 0
    for _, tmpUpdate in ipairs(PST.modData.progUpdates) do
        if tmpUpdate[3] then newUpdateCount = newUpdateCount + 1 end
    end
    return newUpdateCount
end

return progUpdatesScreen