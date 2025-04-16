local lastResources = { hearts = 0, coins = 0, keys = 0, bombs = 0 }

function PST:preSlotCollision(slot, collider, low)
    local player = collider:ToPlayer()
    if player then
        local playerHearts = player:GetHearts() + player:GetSoulHearts() + player:GetEternalHearts() + player:GetBoneHearts() + player:GetRottenHearts()
        lastResources.hearts = playerHearts
        lastResources.coins = player:GetNumCoins()
        lastResources.keys = player:GetNumKeys()
        lastResources.bombs = player:GetNumBombs()
    end
end

---@param slot EntitySlot
function PST:onSlotUpdate(slot)
    -- Gilded machines
    local tmpMod = PST:getTreeSnapshotMod("gildedMachines", 0)
    if tmpMod > 0 and PST:arrHasValue(PST.coinMachines, slot.Variant) and slot.FrameCount == 1 then
        local initMachines = PST:getTreeSnapshotMod("gildedMachineInit", {})
        local gildedMachines = PST:getTreeSnapshotMod("gildedMachineList", {})

        -- Init
        if not PST:arrHasValue(initMachines, slot.InitSeed) then
            -- Gild coin machine
            if 100 * math.random() < tmpMod then
                table.insert(gildedMachines, slot.InitSeed)
                SFXManager():Play(SoundEffect.SOUND_GOLD_HEART)
                local tmpFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, 0, slot.Position, Vector.Zero, nil)
                tmpFX:GetSprite().Scale = Vector(1.15, 1.15)
                tmpFX.Color = Color(1, 1, 0.25, 1)
            end
            table.insert(initMachines, slot.InitSeed)
        end

        -- Gilded FX
        if PST:arrHasValue(gildedMachines, slot.InitSeed) then
            slot:GetSprite():SetRenderFlags(slot:GetSprite():GetRenderFlags() | AnimRenderFlags.GOLDEN)
        end
    end

    -- Player collided with slot
    if slot:GetTouch() > 0 then
        local player = PST:getPlayer()
        local playerHearts = player:GetHearts() + player:GetSoulHearts() + player:GetEternalHearts() + player:GetBoneHearts() + player:GetRottenHearts()

        local spentCoins = player:GetNumCoins() < lastResources.coins
        local spentHearts = playerHearts < lastResources.hearts
        local spentKeys = player:GetNumKeys() < lastResources.keys
        local spentBombs = player:GetNumBombs() < lastResources.bombs

        local freeUse = false

        -- Gilded machine use
        local gildedMachines = PST:getTreeSnapshotMod("gildedMachineList", {})
        if PST:arrHasValue(gildedMachines, slot.InitSeed) and spentCoins then
            -- 50% chance to be free
            if math.random() < 0.5 then freeUse = true end

            -- +0.5% luck for the current floor
            PST:addModifiers({ luckPerc = 0.5, gildedMachineBuff = 0.5 }, true)

            -- Golden Gimmick node (Cain's tree)
            if PST:getTreeSnapshotMod("goldenGimmick", false) then
                PST.specialNodes.goldenGimmickUses = PST.specialNodes.goldenGimmickUses + 1
                if PST.specialNodes.goldenGimmickUses >= 4 then
                    if PST:getTreeSnapshotMod("goldenGimmickBuff", 0) < 12 then
                        player:AddCoins(-1)
                        PST:addModifiers({ damagePerc = 2, goldenGimmickBuff = 2 }, true)
                    end
                    PST.specialNodes.goldenGimmickUses = 0
                end
            end
        end

        -- Blood donation machine
        if slot.Variant == SlotVariant.BLOOD_DONATION_MACHINE and spentHearts then
            -- Blood Donor node (Magdalene's tree)
            if PST:getTreeSnapshotMod("bloodDonor", false) then
                SFXManager():Play(SoundEffect.SOUND_BEEP)
                player:AddActiveCharge(1, 0, true, false, false)
                if player:GetActiveItem(0) == CollectibleType.COLLECTIBLE_YUM_HEART and 100 * math.random() < 50 then
                    player:AddActiveCharge(1, 0, true, false, false)
                end
            end

            -- Mod: +luck when using a Blood Donation Machine
            local tmpTreeMod = PST:getTreeSnapshotMod("bloodDonationLuck", 0)
            if tmpTreeMod > 0 then
                PST:addModifiers({ luck = tmpTreeMod, bloodDonationLuckBuff = tmpTreeMod }, true)
            end

            -- Mod: chance to spawn an additional nickel when using a Blood Donation Machine
            tmpTreeMod = PST:getTreeSnapshotMod("bloodDonationNickel", 0)
            if tmpTreeMod > 0 and 100 * math.random() < tmpTreeMod then
                local tmpPos = Isaac.GetFreeNearPosition(slot.Position, 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_NICKEL, Random() + 1)
            end

            -- Mod: chance to spawn a temporary half red heart when using a Blood Donation Machine
            tmpTreeMod = PST:getTreeSnapshotMod("bloodDonoTempHeart", 0)
            if tmpTreeMod > 0 and 100 * math.random() < tmpTreeMod then
                local tmpHeart = Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, slot.Position, RandomVector() * 3, nil, HeartSubType.HEART_HALF, Random() + 1)
                tmpHeart:ToPickup().Timeout = 60 + math.floor(PST:getTreeSnapshotMod("temporaryHeartTime", 0) * 30)
            end

            -- Ancient weapon mod: Crimson Altruist
            tmpTreeMod = PST:getSnapAstralWepMod("crimsonAltruist")
            if tmpTreeMod then
                local tmpAdd = math.min(tmpTreeMod[1], 100 - PST:getTreeSnapshotMod("ancwep_altruistDmg", 0))
                if tmpAdd > 0 then
                    PST:addModifiers({ damagePerc = tmpAdd, ancwep_altruistDmg = tmpAdd }, true)
                end

                PST:addModifiers({ ancwep_altruistUses = 1 }, true)
                if PST:getTreeSnapshotMod("ancwep_altruistUses", 0) >= tmpTreeMod[3] then
                    PST:addModifiers({ tears = tmpTreeMod[2], ancwep_altruistUses = { value = 0, set = true } }, true)
                end
            end
        -- Crane game
        elseif slot.Variant == SlotVariant.CRANE_GAME and spentCoins then
            -- Impromptu Gambler node (Cain's tree)
            if PST:getTreeSnapshotMod("impromptuGambler", false) then
                if PST:getRoom():GetType() == RoomType.ROOM_TREASURE then
                    if not freeUse then
                        player:AddCoins(-2)
                    end
                    lastResources.coins = player:GetNumCoins()

                    -- Remove natural treasure room items
                    local IG_roomItemsRemoved = PST:getTreeSnapshotMod("impromptuGamblerItemsRemoved", nil)
                    local roomIdx = PST:getLevel():GetCurrentRoomDesc().SafeGridIndex
                    if IG_roomItemsRemoved and not PST:arrHasValue(IG_roomItemsRemoved, roomIdx) then
                        for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                            if tmpEntity.Type == EntityType.ENTITY_PICKUP and tmpEntity.Variant == PickupVariant.PICKUP_COLLECTIBLE and
                            not PST:arrHasValue(PST.progressionItems, tmpEntity.SubType) then
                                Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpEntity.Position, Vector.Zero, nil, 0, Random() + 1)
                                tmpEntity:Remove()
                            end
                        end
                        table.insert(IG_roomItemsRemoved, roomIdx)
                    end
                end
            end
        -- Shop donation machine
        elseif slot.Variant == SlotVariant.DONATION_MACHINE and spentCoins then
            -- Generosity In Steps node
            if PST:getTreeSnapshotMod("generosityInSteps", false) then
                PST:addModifiers({ generosityInStepsCount = 1 }, true)
                if PST:getTreeSnapshotMod("generosityInStepsCount", 0) >= 10 then
                    Game():SetStateFlag(GameStateFlag.STATE_DONATION_SLOT_JAMMED, true)

                    local donoSlots = Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.DONATION_MACHINE)
                    for _, tmpSlot in ipairs(donoSlots) do
                        local newSlot = Isaac.Spawn(EntityType.ENTITY_SLOT, SlotVariant.DONATION_MACHINE, 0, tmpSlot.Position, Vector.Zero, nil)
                        newSlot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        newSlot.TargetPosition = tmpSlot.TargetPosition
                        tmpSlot:Remove()
                    end
                    PST:addModifiers({ generosityInStepsCount = { value = 0, set = true } }, true)
                    SFXManager():Play(SoundEffect.SOUND_COIN_SLOT)
                end
            end

            -- Mod: +% to a random stat every 5 coins given to the donation machine, up to 5 times per floor
            tmpMod = PST:getTreeSnapshotMod("donoMachineStatBoost", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("donoMachineStatBoostProcs", 0) < 5 then
                PST:addModifiers({ donoMachineStatBoostUses = 1 }, true)
                if PST:getTreeSnapshotMod("donoMachineStatBoostUses", 0) >= 5 then
                    local randStat = PST:getRandomStat() .. "Perc"
                    PST:addModifiers({
                        [randStat] = tmpMod,
                        donoMachineStatBoostProcs = 1,
                        donoMachineStatBoostUses = { value = 0, set = true }
                    }, true)
                end
            end

            -- Expedition objective: donate to the shop/greed donation machine
            PST:expedAddProgInRun("shopDonation", lastResources.coins - player:GetNumCoins())

        -- Greed donation machine
        elseif slot.Variant == SlotVariant.GREED_DONATION_MACHINE and spentCoins then
            -- Expedition objective: donate to the shop/greed donation machine
            PST:expedAddProgInRun("shopDonation", lastResources.coins - player:GetNumCoins())

        -- Slot machine
        elseif slot.Variant == SlotVariant.SLOT_MACHINE and spentCoins then
            -- Mod: +xp when spending coins on slot machines in the floor
            tmpMod = PST:getTreeSnapshotMod("slotMachineXP", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("slotMachineFloorUses", 0) < 50 then
                PST:addTempXP(tmpMod, true, true)
                PST:addModifiers({ slotMachineFloorUses = 1 }, true)
            end
        -- Fortune machine
        elseif slot.Variant == SlotVariant.FORTUNE_TELLING_MACHINE and spentCoins then
            -- Mod: +xp when spending coins on fortune machines in the floor
            tmpMod = PST:getTreeSnapshotMod("fortuneMachineXPmax", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("fortuneMachineFloorUses", 0) < 50 then
                local tmpXP = math.random(0, tmpMod)
                PST:addTempXP(tmpXP, true, true)
                PST:addModifiers({ fortuneMachineFloorUses = 1 }, true)
            end
        -- Shell games
        elseif slot.Variant == SlotVariant.SHELL_GAME and spentCoins then
            -- Mod: +xp when spending coins on shell games in the floor
            local tmpMod = PST:getTreeSnapshotMod("shellGameXP", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("shellGameFloorUses", 0) < 50 then
                PST:addTempXP(tmpMod, true, true)
                PST:addModifiers({ shellGameFloorUses = 1 }, true)
            end
        else
            -- Spent something helping a beggar
            if PST:arrHasValue(PST.beggarTypes, slot.Variant) and (spentCoins or spentHearts or spentKeys or spentBombs) then
                -- Beggar luck mod
                local beggarLuck = PST:getTreeSnapshotMod("beggarLuck", 0)
                local tmpTotal = PST:getTreeSnapshotMod("beggarLuckTotal", 0)
                if beggarLuck > 0 and tmpTotal < 1 then
                    PST:addModifiers({ luck = beggarLuck, beggarLuckTotal = beggarLuck }, true)
                end

                -- Expedition objective: help any type of beggar
				PST:expedAddProgInRun("beggars", 1)
            end

            -- Mod: chance for devil beggar to grant half a black heart when helped
            if PST:getTreeSnapshotMod("devilBeggarBlackHeart", 0) > 0 then
                if slot.Variant == SlotVariant.DEVIL_BEGGAR and spentHearts and 100 * math.random() < PST:getTreeSnapshotMod("devilBeggarBlackHeart", 0) then
                    player:AddBlackHearts(1)
                end
            end

            -- Reduce troll bomb disarm proc chance on bomb bums
            if slot.Variant == SlotVariant.BOMB_BUM then
                PST.specialNodes.trollBombDisarmDebuffTimer = 45
            end
        end

        -- Machine-specific
        if spentCoins and (slot.Variant == SlotVariant.FORTUNE_TELLING_MACHINE or slot.Variant == SlotVariant.SHOP_RESTOCK_MACHINE or
        slot.Variant == SlotVariant.SLOT_MACHINE or slot.Variant == SlotVariant.CRANE_GAME) then
            -- Mod: chance for machines that use coins to cost nothing on use
            tmpMod = PST:getTreeSnapshotMod("freeMachinesChance", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                freeUse = true
                PST:createFloatTextFX(PST:getLocalized("ftxt_freeUse"), Vector.Zero, Color(1, 1, 0.5, 1), 0.12, 50, true)
                SFXManager():Play(SoundEffect.SOUND_PENNYPICKUP)
            end
        end

        if freeUse then
            player:AddCoins(lastResources.coins - player:GetNumCoins())
        end
    end

    -- Beggar gives prize
    local slotSpr = slot:GetSprite()
    if slotSpr:GetAnimation() == "Teleport" and slotSpr:GetFrame() == 1 then
        -- Demon Helpers node (Azazel's tree)
        if PST:getTreeSnapshotMod("demonHelpers", false) then
            if slot.Variant == SlotVariant.DEVIL_BEGGAR and 100 * math.random() < 33 then
                local tmpPos = Isaac.GetFreeNearPosition(slot.Position, 40)
                local tmpItem = PST.demonFamiliars[math.random(#PST.demonFamiliars)]
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, tmpItem, Random() + 1)
            end
        end

        -- Obols on beggar help
        if PST:getTreeSnapshotMod("isExpedRun", false) then
            local tmpObols = PST.obolEvents.beggarHelp(PST:getTreeSnapshotMod("expedDepth", 1))
            if tmpObols > 0 then PST:expedDropObolsAt(slot.Position, tmpObols) end
        end

        -- Mod: +xp when fully helping beggar
        tmpMod = PST:getTreeSnapshotMod("beggarHelpXP", 0)
        if tmpMod > 0 then
            PST:addTempXP(tmpMod, true, true)
        end

        -- Expedition order objective: fully help beggar
        PST:expedAddOrderProgInRun("expedOrd_beggars", 1)
    end

    -- Crane game regenerates item
    if slot.Variant == SlotVariant.CRANE_GAME and slotSpr:GetAnimation() == "Regenerate" and slotSpr:GetFrame() == 1 then
        -- Impromptu Gambler node (Cain's tree)
        if PST:getTreeSnapshotMod("impromptuGambler", false) then
            local randPool = PST.impromptuGamblerPools[math.random(#PST.impromptuGamblerPools)]
			local newItem = Game():GetItemPool():GetCollectible(randPool, false, Random() + 1)
            slot:SetPrizeCollectible(newItem)
        end
    end
end