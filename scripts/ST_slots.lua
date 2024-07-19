local lastResources = { hearts = 0, coins = 0, keys = 0, bombs = 0 }
function SkillTrees:onSlotUpdate(slot)
    local updateResources = lastResources.hearts == 0

    -- Player collided with slot
    local player = Isaac.GetPlayer()
    if slot:GetTouch() > 0 then
        local beggarLuck = SkillTrees:getTreeSnapshotMod("beggarLuck", 0)

        -- Beggar luck mod
        if beggarLuck > 0 then
            local spentCoins = (slot.Variant == SlotVariant.BEGGAR or slot.Variant == SlotVariant.BATTERY_BUM or
            slot.Variant == SlotVariant.ROTTEN_BEGGAR) and player:GetNumCoins() < lastResources.coins
            local spentHearts = slot.Variant == SlotVariant.DEVIL_BEGGAR and player:GetHearts() < lastResources.hearts
            local spentKeys = slot.Variant == SlotVariant.KEY_MASTER and player:GetNumKeys() < lastResources.keys
            local spentBombs = slot.Variant == SlotVariant.BOMB_BUM and player:GetNumBombs() < lastResources.bombs
            
            if spentCoins or spentHearts or spentKeys or spentBombs then
                SkillTrees:addModifier({ luck = beggarLuck }, true)
            end
        end
        updateResources = true
    end

    if updateResources then
        lastResources.hearts = player:GetHearts()
        lastResources.coins = player:GetNumCoins()
        lastResources.keys = player:GetNumKeys()
        lastResources.bombs = player:GetNumBombs()
    end
end