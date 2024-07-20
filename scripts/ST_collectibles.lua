function PST:onRollCollectible(selected, itemPoolType, decrease, seed)
    local itemPool = Game():GetItemPool()

    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_LILITH) then
        -- Lilith, 75% chance to reroll follower items
        if 100 * math.random() <= 75 then
            if PST:arrHasValue(PST.babyFamiliarItems, selected) then
                return itemPool:GetCollectible(itemPool:GetLastPool())
            end
        end
    end
end

function PST:onGrabCollectible(type, charge, firstTime, slot, varData, player)
    -- Cosmic Realignment node
    if PST:cosmicRCharPicked(PlayerType.PLAYER_APOLLYON) then
        -- Apollyon, -0.04 to a random stat (except speed) when picking up a passive item
        if charge == 0 then
            local randomStat = PST:getRandomStat({"speed"})
            PST:addModifiers({ [randomStat] = -0.04 }, true)
        end
    end
end