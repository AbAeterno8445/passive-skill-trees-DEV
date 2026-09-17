local loadoutsPerPage = 25
local maxLoadouts = 100

local jewelLoadoutsSubmenu = {
    menuX = 0,
    menuY = 0,
    loadoutsSprite = Sprite("gfx/ui/skilltrees/nodes/jewel_loadout_icons.anm2", true),
    hoveredLoadout = nil,

    deleteTimer = 0,

    invPage = 0
}

---@param openData? table
function jewelLoadoutsSubmenu:OnOpen(openData)
    if not openData then return end
    for k, v in pairs(openData) do
        if self[k] ~= nil then self[k] = v end
    end
end

---@param tScreen PST.treeScreen
function jewelLoadoutsSubmenu:Render(tScreen, submenusModule)
    local loadoutPages = math.ceil(maxLoadouts / loadoutsPerPage)
    self.hoveredLoadout = nil
    submenusModule:DrawNodeSubMenu(
        tScreen,
        loadoutsPerPage,
        tScreen.camCenterX, tScreen.camCenterY,
        self.menuX, self.menuY,
        PST:getLocalized("node_jewelloadouts_name"),
        function()
            for i=1,loadoutsPerPage do
                local loadoutID = i + loadoutsPerPage * self.invPage
                local nodeX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                local nodeY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32
                local loadoutData = PST.modData.starJewelLoadouts[tostring(loadoutID)]

                -- Hovered
                self.loadoutsSprite.Color.A = 1
                if self.hoveredLoadout == nil then
                    if tScreen.camCenterX > nodeX - 16 and tScreen.camCenterX < nodeX + 16 and
                    tScreen.camCenterY > nodeY - 16 and tScreen.camCenterY < nodeY + 16 then
                        self.hoveredLoadout = loadoutID
                        tScreen.cursorHighlight = true
                    elseif not isSelected then
                        self.loadoutsSprite.Color.A = 0.5
                    end
                elseif not isSelected then
                    self.loadoutsSprite.Color.A = 0.5
                end

                local finalDrawX = nodeX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                local finalDrawY = nodeY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                self.loadoutsSprite:SetFrame("Default", loadoutData and 0 or 1)
                self.loadoutsSprite:Render(Vector(finalDrawX, finalDrawY))

                PST.miniFont:DrawString(tostring(loadoutID), finalDrawX + 7, finalDrawY, PST.kcolors.WHITE)
            end

            -- Hovered loadout inputs
            if self.hoveredLoadout then
                local loadoutData = PST.modData.starJewelLoadouts[tostring(self.hoveredLoadout)]
                -- Allocate -> Save current config to this loadout
                if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    local newLoadout = {}
                    local totalEquipCount = 0
                    for jewelType, jewelList in pairs(PST.modData.starTreeInventory) do
                        if jewelType ~= PSTStarcursedType.ANCIENT then
                            local equippedJewels = {}
                            local tmpEquipCount = 0
                            for _, jewel in ipairs(jewelList) do
                                if jewel.equipped and tmpEquipCount < 4 then
                                    equippedJewels[tostring(jewel.id)] = jewel.equipped
                                    tmpEquipCount = tmpEquipCount + 1
                                    totalEquipCount = totalEquipCount + 1
                                end
                            end
                            newLoadout[jewelType] = equippedJewels
                        end
                    end
                    if totalEquipCount > 0 then
                        PST.modData.starJewelLoadouts[tostring(self.hoveredLoadout)] = newLoadout
                    end
                -- Shift + Allocate -> Switch to loadout (clears jewels if empty)
                elseif PST:isKeybindActive(PSTKeybind.SHIFT_ALLOCATE_NODE) then
                    SFXManager():Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.7)
                    for jewelType, jewelList in pairs(PST.modData.starTreeInventory) do
                        if jewelType ~= PSTStarcursedType.ANCIENT then
                            for _, jewel in ipairs(jewelList) do
                                -- Unequip all
                                jewel.equipped = nil
                                -- Set new slot if loadout exists
                                if loadoutData and loadoutData[jewelType] then
                                    local jewelSlot = loadoutData[jewelType][tostring(jewel.id)]
                                    if jewelSlot then
                                        jewel.equipped = tostring(jewelSlot)
                                    end
                                end
                            end
                        end
                    end
                -- Ctrl / Bomb -> Cycle through displayed bonuses
                elseif PST:isKeybindActive(PSTKeybind.TREE_CTRL) then
                    if loadoutData then
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    end
                    if PST.SCDisplayedLoadoutType == PSTStarcursedType.AZURE then
                        PST.SCDisplayedLoadoutType = PSTStarcursedType.CRIMSON
                    elseif PST.SCDisplayedLoadoutType == PSTStarcursedType.CRIMSON then
                        PST.SCDisplayedLoadoutType = PSTStarcursedType.VIRIDIAN
                    elseif PST.SCDisplayedLoadoutType == PSTStarcursedType.VIRIDIAN then
                        PST.SCDisplayedLoadoutType = PSTStarcursedType.AZURE
                    end
                else
                    -- Respec -> Hold for 1 second to delete loadout data
                    if PST:isKeybindActive(PSTKeybind.RESPEC_NODE, true) then
                        if loadoutData then
                            self.deleteTimer = self.deleteTimer + 1
                            if self.deleteTimer == 60 then
                                PST.modData.starJewelLoadouts[tostring(self.hoveredLoadout)] = nil
                                SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.7)
                            end
                        end
                    else
                        self.deleteTimer = 0
                    end
                end
            end
        end,
        {
            prevFunc = function()
                self.invPage = math.max(0, self.invPage - 1)
            end,
            prevDisabled = self.invPage == 0,
            nextFunc = function()
                self.invPage = math.min(loadoutPages - 1, self.invPage + 1)
            end,
            nextDisabled = self.invPage >= loadoutPages - 1,
            maxItems = maxLoadouts
        }
    )
end

return jewelLoadoutsSubmenu