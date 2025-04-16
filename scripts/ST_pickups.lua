-- Check for the grabBag tree mod, and roll to spawn one on the player
function PST:tryGrabBag()
    local player = PST:getPlayer()
    local grabBagChance = PST:getTreeSnapshotMod("grabBag", 0)
    if grabBagChance > 0 and 100 * math.random() < grabBagChance then
        Game():Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_GRAB_BAG,
            player.Position,
            Vector.Zero,
            nil,
            SackSubType.SACK_NORMAL,
            PST:getRoom():GetSpawnSeed()
        )
    end
end

function PST:isPickupChest(variant)
    return PST:arrHasValue(PST.regularChests, variant) or PST:arrHasValue(PST.lockedChests, variant) or
    variant == PickupVariant.PICKUP_BOMBCHEST or variant == Isaac.GetEntityVariantByName("Sidereal Cache")
end

---@param pickup EntityPickup
function PST:isGoldenPickup(pickup)
    return (pickup.Variant == PickupVariant.PICKUP_COIN and pickup.SubType == CoinSubType.COIN_GOLDEN or
    pickup.Variant == PickupVariant.PICKUP_BOMB and pickup.SubType == BombSubType.BOMB_GOLDEN or
    pickup.Variant == PickupVariant.PICKUP_KEY and pickup.SubType == KeySubType.KEY_GOLDEN)
end

---@param pickup EntityPickup
function PST:vanishPickup(pickup)
    Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, pickup.Position, Vector.Zero, nil, 1, Random() + 1)
    pickup:Remove()
end

local jewelCollisionTimer = 0
---@param pickup EntityPickup
---@param collider Entity
---@param low boolean
function PST:prePickup(pickup, collider, low)
    local variant = pickup.Variant
    local subtype = pickup.SubType

    if collider.Type == EntityType.ENTITY_PLAYER then
        local player = collider:ToPlayer()
        if player then
            -- Sidereal Cache opening
            local canOpenLock = player:GetNumKeys() > 0 or player:HasGoldenKey()

            -- Epiphany multitool support for sidereal caches
            local usedMultitool = false
            if Epiphany then
                local multitool = Epiphany.Pickup.MULTITOOL
                if multitool and multitool:HasMultiTool() and Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex) then
                    usedMultitool = true
                    canOpenLock = true
                end
            end

            if variant == Isaac.GetEntityVariantByName("Sidereal Cache") and canOpenLock and pickup.SubType ~= 1 and
            pickup:GetSprite():GetAnimation() == "Idle" then
                -- Sidereal Cache opened
                local saveKey = false
                local tmpMod = PST:getTreeSnapshotMod("sideCacheNoKey", 0)
                saveKey = tmpMod > 0 and 100 * math.random() < tmpMod
                if not saveKey and not player:HasGoldenKey() then
                    player:AddKeys(-1)
                end
                -- Chance for sidereal caches to return 1-2 keys when opened
                tmpMod = PST:getTreeSnapshotMod("sideCacheKeyReturn", 0)
                if tmpMod > 0 and 100 * math.random() < tmpMod then
                    player:AddKeys(math.random(2))
                end

                pickup:GetSprite():Play("Open", true)
                pickup.SubType = 1
                SFXManager():Play(Isaac.GetSoundIdByName("unlock cosmic"), 1, 2, false, 0.9 + 0.2 * math.random())

                if usedMultitool then
                    Epiphany.Pickup.MULTITOOL:AddMultiTool(-1)
                    Epiphany.sfxman:Play(Isaac.GetSoundIdByName("Multitool Use"))
                end

                if PST:isRunSidereal() then
                    local depth = PST:getTreeSnapshotMod("expedDepth", 1)
                    local obolsAmt = PST.obolEvents.siderealCache(depth)
                    PST:expedDropObolsAt(pickup.Position, obolsAmt)

                    -- Expedition objective: open any chest
                    PST:expedAddProgInRun("chests", 1)
                    -- Expedition order objective: open chests without taking damage in-between
                    PST:expedAddOrderProgInRun("expedOrd_chests", 1)
                end

                -- Start challenge room
                if PST:getRoom():GetType() == RoomType.ROOM_CHALLENGE and not PST:getTreeSnapshotMod("challRoomClear", false) then
                    Ambush.StartChallenge()
                end

                -- Chance for Sidereal Caches to drop 1-2 sacks
                tmpMod = PST:getTreeSnapshotMod("sideCacheSacks", 0)
                if tmpMod > 0 and 100 * math.random() < tmpMod then
                    local maxSacks = math.random(1, 2)
                    for _=1,maxSacks do
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, pickup.Position, RandomVector() * 3 * math.random(), nil)
                    end
                end

                -- Chance for Sidereal Caches to drop an additional cache, once per room
                tmpMod = PST:getTreeSnapshotMod("sideCacheReplica", 0)
                if tmpMod > 0 and not PST:getTreeSnapshotMod("sideCacheReplicaProc", false) and 100 * math.random() < tmpMod then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, Isaac.GetEntityVariantByName("Sidereal Cache"), 0, pickup.Position, Vector.Zero, nil)
                    PST:addModifiers({ sideCacheReplicaProc = true }, true)
                end

                -- Chance for Sidereal Caches to drop a random Astral Weapon - above 100% roll multiple times
                tmpMod = PST:getTreeSnapshotMod("sideCacheAstralWep", 0)
                while tmpMod > 0 do
                    if 100 * math.random() < tmpMod then
                        PST:dropRandAstralWepAt(pickup.Position, PST:getTreeSnapshotMod("astralWepTierDrops", 1), true, RandomVector() * 3 * math.random())
                    end
                    tmpMod = tmpMod - 100
                end

                -- Chance for Sidereal Caches to drop a Starcursed Jewel
                tmpMod = PST:getTreeSnapshotMod("sideCacheJewel", 0)
                if tmpMod > 0 and 100 * math.random() < tmpMod then
                    PST:SC_dropRandomJewelAt(pickup.Position, PST.SCDropRates.curseRoom(PST:getLevel():GetStage()).ancient, RandomVector() * 3 * math.random())
                end

                -- Sidereal Artifact objective: open sidereal caches
                PST:sideArtiObjProgress("siderealMeridion", 1)
            end

            -- Collectibles
            if variant == PickupVariant.PICKUP_COLLECTIBLE and not player:IsHoldingItem() then
                local removeOtherRoomItems = false
                -- Ancient starcursed jewel: Opalescent Purity
                if player ~= nil and PST:SC_getSnapshotMod("opalescentPurity", false) and not PST:getTreeSnapshotMod("SC_opalescentProc", false) and
                not pickup:IsShopItem() then
                    if variant == PickupVariant.PICKUP_COLLECTIBLE and not PST:arrHasValue(PST.progressionItems, subtype) then
                        removeOtherRoomItems = true
                        PST:addModifiers({ SC_opalescentProc = true }, true)
                    end
                end

                -- Ancient starcursed jewel: Astral Insignia
                if PST:SC_getSnapshotMod("astralInsignia", false) and PST:getRoom():GetType() == RoomType.ROOM_PLANETARIUM and
                PST:arrHasValue(PST.planetariumItems, subtype) then
                    local oldItem = PST:getTreeSnapshotMod("SC_astralInsigniaItem", 0)
                    if oldItem ~= 0 then
                        player:RemoveCollectible(oldItem)
                    end
                    PST:addModifiers({ SC_astralInsigniaItem = subtype }, true)
                end

                -- Ancient starcursed jewel: Crystallized Anamnesis
                if PST:SC_getSnapshotMod("crystallizedAnamnesis", false) and not PST:arrHasValue(PST.progressionItems, subtype) and (not pickup:IsShopItem() or
                pickup:IsShopItem() and player:GetNumCoins() >= pickup.Price) and PST.specialNodes.SC_anamnesisItemPicked == 0 then
                    PST.specialNodes.SC_anamnesisItemPicked = subtype
                end

                -- Impromptu Gambler node (Cain's tree)
                if PST:getTreeSnapshotMod("impromptuGambler", false) and PST:getRoom():GetType() == RoomType.ROOM_TREASURE then
                    local IG_roomItemsRemoved = PST:getTreeSnapshotMod("impromptuGamblerItemsRemoved", nil)
                    local roomIdx = PST:getLevel():GetCurrentRoomDesc().SafeGridIndex
                    if IG_roomItemsRemoved and not PST:arrHasValue(IG_roomItemsRemoved, roomIdx) then
                        -- Remove crane games
                        local craneGames = Isaac.FindByType(EntityType.ENTITY_SLOT, SlotVariant.CRANE_GAME)
                        for _, tmpCrane in ipairs(craneGames) do
                            Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpCrane.Position, Vector.Zero, nil, 0, Random() + 1)
                            tmpCrane:Remove()
                        end

                        table.insert(IG_roomItemsRemoved, roomIdx)
                    end
                end

                -- Chaotic Treasury node (Eden's tree)
                if PST:getTreeSnapshotMod("chaoticTreasury", false) and not PST:arrHasValue(PST.progressionItems, subtype)
                and PST:getRoom():GetType() == RoomType.ROOM_TREASURE and (not pickup:IsShopItem() or (pickup:IsShopItem() and player:GetNumCoins() >= pickup.Price)) then
                    -- When grabbing an item in a treasure room, remove all other items
                    removeOtherRoomItems = true
                end

                -- Dextral Runemaster: Berkano innate Hive Mind
                if PST:getTreeSnapshotMod("berkanoHivemind", false) and subtype == CollectibleType.COLLECTIBLE_HIVE_MIND then
                    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND, -1)
                    PST:addModifiers({ berkanoHivemind = false }, true)
                end

                -- Mod: chance for additional pickups when collecting an item pedestal (T. Cain)
                local tmpMod = PST:getTreeSnapshotMod("additionalPedestalPickup", 0)
                if subtype ~= 0 and not pickup:IsShopItem() and not PST:arrHasValue(PST.progressionItems, subtype) and tmpMod > 0 and
                player:GetPlayerType() == PlayerType.PLAYER_CAIN_B then
                    while tmpMod > 0 do
                        if 100 * math.random() < tmpMod then
                            local newPickup = PST:getTCainRandPickup()
                            Game():Spawn(EntityType.ENTITY_PICKUP, newPickup[1], pickup.Position, RandomVector() * 3, nil, newPickup[2], Random() + 1)
                        end
                        tmpMod = tmpMod - 100
                    end
                end

                if removeOtherRoomItems then
                    table.insert(PST.specialNodes.itemRemovalProtected, pickup.InitSeed)
                    PST:removeRoomItems(true)
                end

                -- Serendipitous Soul node (T. Eden's tree)
                if PST:getTreeSnapshotMod("serendipitousSoul", false) then
                    local itemCfg = Isaac.GetItemConfig():GetCollectible(subtype)
                    if itemCfg and itemCfg.Type == ItemType.ITEM_ACTIVE and not PST:getTreeSnapshotMod("serendSoulUsed", false) then
                        return { Collide = true, SkipCollisionEffects = true }
                    end
                end

                -- Helping Hands node (T. Lost's tree)
                if PST:getTreeSnapshotMod("helpingHands", false) then
                    local roomType = PST:getRoom():GetType()
                    if variant == PickupVariant.PICKUP_COLLECTIBLE and (roomType == RoomType.ROOM_ANGEL or roomType == RoomType.ROOM_DEVIL) and not pickup:IsShopItem() then
                        -- Remove holy cards when grabbing items in devil/angel rooms
                        local tmpCards = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_HOLY)
                        for _, tmpCard in ipairs(tmpCards) do
                            if not tmpCard:ToPickup():IsShopItem() then
                                Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, tmpCard.Position, Vector.Zero, nil, 0, Random() + 1)
                                tmpCard:Remove()
                            end
                        end
                    end
                end

                -- Mod: % chance to gain a destroyed wisp's item for the rest of the floor (remove item from list so it's not lost on next floor)
                tmpMod = PST:getTreeSnapshotMod("destroyedWispItemList", nil)
                if tmpMod and #tmpMod > 0 then
                    for i, tmpItem in ipairs(tmpMod) do
                        if tmpItem == subtype then
                            table.remove(tmpMod, i)
                            break
                        end
                    end
                end

                -- Spin-down node (T. Lost's tree)
                if PST:getTreeSnapshotMod("spindown", false) and subtype == CollectibleType.COLLECTIBLE_SPINDOWN_DICE then
                    -- Set uses >2 to prevent removal
                    PST:addModifiers({ spindownUses = { value = 3, set = true } }, true)
                end
            -- Trinkets
            elseif variant == PickupVariant.PICKUP_TRINKET then
                -- Arcane Obols pickup (astral expeditions)
                for i, obolValue in ipairs(PST.expedObolDropValues) do
                    local tmpName = "Arcane Obols " .. i
                    if subtype == Isaac.GetTrinketIdByName(tmpName) or subtype == Isaac.GetTrinketIdByName(tmpName) | TrinketType.TRINKET_GOLDEN_FLAG then
                        local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                        tmpFX.Color = Color(1, 1, 1, 1, 0.85, 0.35, 1)
                        pickup:Remove()
                        SFXManager():Play(SoundEffect.SOUND_LUCKYPICKUP, 0.6, 2, false, 0.8)

                        PST:addCurrentCharObols(obolValue)
                        PST:createFloatTextFX("+" .. obolValue .. " " .. PST:getLocalized("ui_arcaneObols"), Vector.Zero, Color(0.8, 0.35, 1, 1), 0.13, 70, true)

                        -- Expedition objective: collect Arcane Obols
                        PST:expedAddProgInRun("obols", obolValue)

                        -- Mod: obol sharing
                        local tmpMod = PST:getTreeSnapshotMod("obolSharing", 0)
                        if tmpMod > 0 and 100 * math.random() < tmpMod then
                            local obolShareRate = 0.33
                            if PST:getTreeSnapshotMod("cosmicAltruism", false) then
                                obolShareRate = 0.7
                            end
                            local currentCharName = PST:getCurrentCharName()
                            for charName, tmpCharData in pairs(PST.modData.charData) do
                                if charName ~= currentCharName then
                                    if not tmpCharData.arcaneObols then tmpCharData.arcaneObols = 0 end
                                    tmpCharData.arcaneObols = tmpCharData.arcaneObols + math.max(1, math.floor(obolValue * obolShareRate))
                                end
                            end
                        end

                        return { Collide = false, SkipCollisionEffects = true }
                    end
                end

                -- Astral weapon pickup
                local itemCfg = Isaac.GetItemConfig():GetTrinket(subtype)
                if itemCfg and PST:strStartsWith(itemCfg.Name, "Astral weapon") then
                    local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                    tmpFX.Color = Color(1, 1, 1, 1, 0.7, 0.7, 1)
                    pickup:Remove()
                    SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN, 0.8, 2, false, 1.1 + math.random())
                    PST:createFloatTextFX("+ " .. itemCfg.Name, Vector.Zero, Color(0.6, 0.6, 1, 1), 0.13, 100, true)

                    PST:astralWepTrinketPickup(itemCfg.Name)
                    return { Collide = false, SkipCollisionEffects = true }
                end

                -- Starcursed jewel pickups
                local jewelInvFull = nil
                local isMighty = 100 * math.random() < PST:getTreeSnapshotMod("SC_SMMightyChance", 0)
                if subtype == Isaac.GetTrinketIdByName("Azure Starcursed Jewel") or subtype == Isaac.GetTrinketIdByName("Azure Starcursed Jewel") | TrinketType.TRINKET_GOLDEN_FLAG then
                    if not PST:SC_isInvFull(PSTStarcursedType.AZURE) then
                        -- Azure Starcursed Jewel pickup
                        local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                        tmpFX.Color = Color(1, 1, 1, 1, 1, 1, 1)
                        pickup:Remove()
                        PST:SC_addJewel(PSTStarcursedType.AZURE, isMighty, 0)
                        PST:createFloatTextFX("+ " .. PST:getLocalized("ui_azureJewel"), Vector.Zero, Color(0.7, 0.7, 1, 1), 0.12, 90, true)
                        SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.9, 2, false, 1.6 + 0.1 * math.random())
                        jewelCollisionTimer = 0
                        return { Collide = false, SkipCollisionEffects = true }
                    else
                        jewelInvFull = PSTStarcursedType.AZURE
                    end
                elseif subtype == Isaac.GetTrinketIdByName("Crimson Starcursed Jewel") or subtype == Isaac.GetTrinketIdByName("Crimson Starcursed Jewel") | TrinketType.TRINKET_GOLDEN_FLAG then
                    if not PST:SC_isInvFull(PSTStarcursedType.CRIMSON) then
                        -- Crimson Starcursed Jewel pickup
                        local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                        tmpFX.Color = Color(1, 1, 1, 1, 1, 1, 1)
                        pickup:Remove()
                        PST:SC_addJewel(PSTStarcursedType.CRIMSON, isMighty, 0)
                        PST:createFloatTextFX("+ " .. PST:getLocalized("ui_crimsonJewel"), Vector.Zero, Color(1, 0.7, 0.7, 1), 0.12, 90, true)
                        SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.9, 2, false, 1.6 + 0.1 * math.random())
                        jewelCollisionTimer = 0
                        return { Collide = false, SkipCollisionEffects = true }
                    else
                        jewelInvFull = PSTStarcursedType.CRIMSON
                    end
                elseif subtype == Isaac.GetTrinketIdByName("Viridian Starcursed Jewel") or subtype == Isaac.GetTrinketIdByName("Viridian Starcursed Jewel") | TrinketType.TRINKET_GOLDEN_FLAG then
                    if not PST:SC_isInvFull(PSTStarcursedType.VIRIDIAN) then
                        -- Viridian Starcursed Jewel pickup
                        local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                        tmpFX.Color = Color(1, 1, 1, 1, 1, 1, 1)
                        pickup:Remove()
                        PST:SC_addJewel(PSTStarcursedType.VIRIDIAN, isMighty, 0)
                        PST:createFloatTextFX("+ " .. PST:getLocalized("ui_viridianJewel"), Vector.Zero, Color(0.7, 1, 0.7, 1), 0.12, 90, true)
                        SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.9, 2, false, 1.6 + 0.1 * math.random())
                        jewelCollisionTimer = 0
                        return { Collide = false, SkipCollisionEffects = true }
                    else
                        jewelInvFull = PSTStarcursedType.VIRIDIAN
                    end
                elseif subtype == Isaac.GetTrinketIdByName("Ancient Starcursed Jewel") or subtype == Isaac.GetTrinketIdByName("Ancient Starcursed Jewel") | TrinketType.TRINKET_GOLDEN_FLAG then
                    -- Ancient Starcursed Jewel pickup
                    local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                    tmpFX.Color = Color(1, 1, 1, 1, 1, 1, 1)
                    pickup:Remove()
                    PST:SC_addJewel(PSTStarcursedType.ANCIENT, false, 0)
                    PST:createFloatTextFX("+ " .. PST:getLocalized("ui_ancientJewel"), Vector.Zero, Color(1, 0.65, 0.1, 1), 0.12, 120, true)
                    SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 0.9, 2, false, 1.4 + 0.1 * math.random())
                    jewelCollisionTimer = 0
                    return { Collide = false, SkipCollisionEffects = true }
                end

                -- Jewel inventory full
                if jewelInvFull ~= nil then
                    if jewelCollisionTimer == 0 then
                        PST:createFloatTextFX(PST:getLocalized("ftxt_jewelInvFull"), Vector.Zero, Color(0.9, 0.2, 0.2, 1), 0.12, 90, true)
                        jewelCollisionTimer = 40
                    else
                        jewelCollisionTimer = jewelCollisionTimer - 1
                    end
                    return { Collide = false, SkipCollisionEffects = true }
                else
                    -- Trinket picked up
                    if not player:IsHoldingItem() then
                        -- Mod: chance for trinkets to turn golden when first collected, if you have them unlocked
                        if Isaac.GetPersistentGameData():Unlocked(Achievement.GOLDEN_TRINKET) then
                            local tmpTrinketList = PST:getTreeSnapshotMod("gildedTrinkets", nil)
                            if tmpTrinketList and not PST:arrHasValue(tmpTrinketList, subtype) then
                                table.insert(tmpTrinketList, subtype)

                                local tmpMod = PST:getTreeSnapshotMod("goldenTrinkets", 0)
                                if tmpMod > 0 and 100 * math.random() < tmpMod and (subtype & TrinketType.TRINKET_GOLDEN_FLAG) == 0 then
                                    pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, subtype | TrinketType.TRINKET_GOLDEN_FLAG)

                                    local poofFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, player.Position, Vector.Zero, nil, 0, Random() + 1)
                                    poofFX.Color = Color(1, 1, 0.5, 1)
                                    SFXManager():Play(SoundEffect.SOUND_GOLD_HEART, 0.9)
                                    PST:createFloatTextFX(PST:getLocalized("ftxt_trinketGilded"), Vector.Zero, Color(1, 1, 0.6, 1), 0.13, 100, true)
                                    return
                                end
                            end
                        end
                    end
                end
            else
                -- Keeper's Blessing node (Keeper's tree)
                if PST:getTreeSnapshotMod("keeperBlessing", false) then
                    if variant == PickupVariant.PICKUP_COIN and player:GetHearts() < player:GetMaxHearts() and PST:getTreeSnapshotMod("keeperBlessingHeals") < 4 then
                        player:AddCoins(1)
                        PST:addModifiers({ keeperBlessingHeals = 1 }, true)
                    end
                end

                -- Ancient starcursed jewel: Crimson Warpstone
                if PST:SC_getSnapshotMod("crimsonWarpstone", false) or PST:getTreeSnapshotMod("crackedKeyStacking", false) then
                    if pickup.Variant == PickupVariant.PICKUP_TAROTCARD and pickup.SubType == Card.CARD_CRACKED_KEY and not pickup:IsShopItem() and
                    (player:GetCard(0) == Card.CARD_CRACKED_KEY or player:GetCard(1) == Card.CARD_CRACKED_KEY) then
                        local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                        tmpFX.Color = Color(1, 0.2, 0.2, 1, 1, 0.2, 0.2)
                        pickup:Remove()
                        PST:addModifiers({ SC_crimsonWarpKeyStacks = 1 }, true)
                        PST:createFloatTextFX("+ " .. PST:getLocalized("ui_crackedKey"), Vector.Zero, Color(1, 0.7, 0.7, 1), 0.12, 100, true)
                        SFXManager():Play(SoundEffect.SOUND_UNLOCK00, 0.8, 2, false, 1.2)
                        return { Collide = false, SkipCollisionEffects = true }
                    end
                end

                -- Starcursed mod: chance for coins, keys or bombs to vanish on pickup
                local tmpMod = PST:SC_getSnapshotMod("pickupsVanish", 0)
                if tmpMod > 0 and (variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_BOMB or
                variant == PickupVariant.PICKUP_KEY) and 100 * math.random() < tmpMod then
                    PST:vanishPickup(pickup)
                    return false
                end
                -- Starcursed mod: chance for heart pickups to vanish when collected
                tmpMod = PST:SC_getSnapshotMod("heartsVanish", 0)
                if tmpMod > 0 and variant == PickupVariant.PICKUP_HEART and 100 * math.random() < tmpMod then
                    PST:vanishPickup(pickup)
                    return false
                end

                -- Mod: rune shards can stack + rune assembly
                if PST:getTreeSnapshotMod("runeshardStacking", false) then
                    if variant == PickupVariant.PICKUP_TAROTCARD and subtype == Card.RUNE_SHARD and not pickup:IsShopItem() and
                    (PST:arrHasValue(PST.allRunes, player:GetCard(0)) or PST:arrHasValue(PST.allRunes, player:GetCard(1))) then
                        local tmpFX = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                        tmpFX.Color = Color(0.2, 0.5, 0.8, 1, 0.2, 0.5, 0.8)
                        pickup:Remove()
                        PST:addModifiers({ runeshardStacks = 1 }, true)

                        -- Create new random rune once collecting enough stacks
                        local runeStacks = PST:getTreeSnapshotMod("runeshardStacks", 0) + 1
                        local stacksReq = PST:getTreeSnapshotMod("runeshardStacksReq", 0)
                        if stacksReq == 0 then stacksReq = 15 end
                        local tmpColor = Color(0.7, 0.8, 1, 1)
                        if runeStacks >= stacksReq then
                            tmpColor = Color(0.7, 1, 0.8, 1)
                            PST:addModifiers({ runeshardStacks = { value = 0, set = true } }, true)
                            local tmpPos = PST:getRoom():FindFreePickupSpawnPosition(player.Position, 20)

                            -- Mod: chance for assembled rune to be a Black Rune
                            local newRune = PST:getRandRuneWeighted()
                            tmpMod = PST:getTreeSnapshotMod("blackRuneAssembly", 0)
                            if tmpMod > 0 and 100 * math.random() < tmpMod then
                                newRune = Card.RUNE_BLACK
                            end

                            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, newRune, Random() + 1)
                            SFXManager():Play(SoundEffect.SOUND_THUMBSUP, 0.8)
                        else
                            SFXManager():Play(SoundEffect.SOUND_UNLOCK00, 0.8, 2, false, 1.4)
                        end
                        PST:createFloatTextFX("+ " .. PST:getLocalized("ui_runeShard") .. " (" .. tostring(runeStacks) .. "/" .. tostring(stacksReq) .. ")", Vector.Zero, tmpColor, 0.12, 100, true)
                        return { Collide = false, SkipCollisionEffects = true }
                    end
                end

                -- Helping Hands node (T. Lost's tree)
                if PST:getTreeSnapshotMod("helpingHands", false) then
                    local roomType = PST:getRoom():GetType()
                    if variant == PickupVariant.PICKUP_TAROTCARD and subtype == Card.CARD_HOLY and not pickup:IsShopItem() then
                        -- Remove other items in angel/devil rooms
                        if roomType == RoomType.ROOM_ANGEL or roomType == RoomType.ROOM_DEVIL then
                            PST:removeRoomItems()
                        end

                        -- Holy Card stacking
                        if player:GetCard(0) == Card.CARD_HOLY or player:GetCard(1) == Card.CARD_HOLY then
                            Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
                            pickup:Remove()
                            PST:addModifiers({ holyCardStacks = 1 }, true)
                            PST:createFloatTextFX("+ " .. PST:getLocalized("ui_holyCard"), Vector.Zero, Color(0.6, 0.9, 1, 1), 0.12, 100, true)
                            SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12, 0.8, 2, false, 1.3)
                            return { Collide = false, SkipCollisionEffects = true }
                        end
                    end
                end

                -- Marquess of Flies node (T. Keeper's tree)
                if PST:getTreeSnapshotMod("marquessOfFlies", false) then
                    if variant == PickupVariant.PICKUP_COIN and player:GetHearts() < player:GetMaxHearts() and not PST:getTreeSnapshotMod("marquessOfFliesHive", false) and
                    not player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) and 100 * math.random() < 20 then
                        player:AddCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND)
                        PST:addModifiers({ marquessOfFliesHive = true }, true)
                    end
                end

                -- Cosmic Realignment node
                local isKeeper = player:GetPlayerType() == PlayerType.PLAYER_KEEPER or player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
                local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
                if PST:cosmicRCharPicked(PlayerType.PLAYER_BLUEBABY) then
                    -- Blue baby, make first 2 non soul heart pickups vanish
                    if cosmicRCache.blueBabyHearts < 2 then
                        if (variant == PickupVariant.PICKUP_HEART and subtype ~= HeartSubType.HEART_SOUL) or
                        variant == PickupVariant.PICKUP_BOMB or variant == PickupVariant.PICKUP_KEY or
                        variant == PickupVariant.PICKUP_COIN then
                            PST:vanishPickup(pickup)

                            cosmicRCache.blueBabyHearts = cosmicRCache.blueBabyHearts + 1
                            return false
                        end
                    end
                elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST) then
                    -- The Lost, non-red hearts vanish on pickup
                    if variant == PickupVariant.PICKUP_HEART and subtype ~= HeartSubType.HEART_FULL and
                    subtype ~= HeartSubType.HEART_HALF and subtype ~= HeartSubType.HEART_SCARED then
                        PST:vanishPickup(pickup)
                        return false
                    end
                elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER) then
                    -- Keeper, 25% chance for coins to vanish, 25% chance to deal 1/2 heart dmg on vanish
                    if variant == PickupVariant.PICKUP_COIN then
                        if 100 * math.random() < 25 then
                            PST:vanishPickup(pickup)
                            if 100 * math.random() < 25 then
                                player:TakeDamage(1, 0, EntityRef(player), 0)
                            end
                            return false
                        else
                            -- Track collected coins for next floor
                            cosmicRCache.keeperFloorCoins = cosmicRCache.keeperFloorCoins + 1
                            if cosmicRCache.keeperFloorCoins <= 5 then
                                local tmpColor = Color()
                                if cosmicRCache.keeperFloorCoins == 5 then
                                    tmpColor = Color(0.7, 1, 0.7, 1)
                                end
                                PST:createFloatTextFX(PST:getLocalized("ftxt_keeperCurse") .. ": " .. cosmicRCache.keeperFloorCoins .. "/5", Vector.Zero, tmpColor, 0.1, 50, true)
                            end
                        end
                    end
                elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS_B) then
                    -- Tainted Judas, as Keeper: coins have a 50% chance to grant +0.2 damage for the current room instead of healing, up to +1
                    if isKeeper and variant == PickupVariant.PICKUP_COIN then
                        if player:GetHearts() < player:GetMaxHearts() and 100 * math.random() < 50 then
                            if cosmicRCache.TJudasDmgUps < 5 then
                                cosmicRCache.TJudasDmgUps = cosmicRCache.TJudasDmgUps + 1
                                PST:addModifiers({ damage = 0.2 }, true)
                            end
                            player:AddHearts(-2)
                        end
                    end
                elseif PST:cosmicRCharPicked(PlayerType.PLAYER_LAZARUS_B) then
                    -- Tainted Lazarus, as Keeper: 33% chance for coins to spawn a blue fly instead of healing you
                    if isKeeper and variant == PickupVariant.PICKUP_COIN then
                        if player:GetHearts() < player:GetMaxHearts() then
                            if 100 * math.random() < 33 then
                                Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, player.Position, Vector.Zero, nil, 0, Random() + 1)
                                player:AddHearts(-2)
                            elseif player:GetNumBlueFlies() > 0 then
                                player:AddHearts(-2)
                            end
                        end
                    end
                elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
                    -- Tainted Lost, as Keeper: coins will only heal you up to 3 times per floor
                    if isKeeper and variant == PickupVariant.PICKUP_COIN and player:GetHearts() < player:GetMaxHearts() then
                        if cosmicRCache.TLostKeeperCoins < 3 then
                            cosmicRCache.TLostKeeperCoins = cosmicRCache.TLostKeeperCoins + 1
                        else
                            player:AddHearts(-2)
                        end
                    end
                elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN_B) then
                    -- Tainted Forgotten, as Keeper: first coin per room doesn't heal you
                    if isKeeper and variant == PickupVariant.PICKUP_COIN then
                        if not cosmicRCache.TForgottenTracker.keeperCoin then
                            cosmicRCache.TForgottenTracker.keeperCoin = true
                            player:AddCacheFlags(PST.allstatsCache, true)
                        end
                        if player:GetHearts() < player:GetMaxHearts() and not cosmicRCache.TForgottenTracker.keeperHeal then
                            player:AddHearts(-2)
                            cosmicRCache.TForgottenTracker.keeperHeal = true
                        end
                    end
                end
            end
        end
    end
end

local redHeartWorth = {
    [HeartSubType.HEART_HALF] = 1,
    [HeartSubType.HEART_FULL] = 2,
    [HeartSubType.HEART_SCARED] = 2,
    [HeartSubType.HEART_DOUBLEPACK] = 4
}

---@param pickup EntityPickup
---@param collider Entity
---@param low boolean
---@param forced boolean
function PST:onPickup(pickup, collider, low, forced)
    local player = collider:ToPlayer()
    local variant = pickup.Variant
    local subtype = pickup.SubType

    -- Ancient weapon mod: Ivory Vampire (force red heart pickups)
    local tmpMod = PST:getSnapAstralWepMod("ivoryVampire")
    if player and tmpMod and variant == PickupVariant.PICKUP_HEART and (subtype == HeartSubType.HEART_FULL or
    subtype == HeartSubType.HEART_HALF or subtype == HeartSubType.HEART_DOUBLEPACK or subtype == HeartSubType.HEART_SCARED) then
        -- Force pickup if necessary
        if player:GetHearts() >= player:GetMaxHearts() then
            pickup:GetSprite():Play("Collect")
            pickup:PlayPickupSound()
            pickup:Die()
        end
        -- Apply buff
        PST.specialNodes.ancwep_ivoryVampTimer = math.floor(tmpMod[2] * 30)
        PST.specialNodes.ancwep_ivoryVampStacks = math.min(8, PST.specialNodes.ancwep_ivoryVampStacks + (redHeartWorth[subtype] or 1))
        PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED)
    end

    -- Exit if not collecting
    if pickup:GetSprite():GetAnimation() ~= "Collect" and not forced then return end

    if player and (not pickup:IsShopItem() or forced) then
        -- On pickup coin
        if variant == PickupVariant.PICKUP_COIN then
            local coinChance = PST:getTreeSnapshotMod("coinDupe", 0)
            if coinChance > 0 and 100 * math.random() < coinChance then
                player:AddCoins(1)
            end
            PST:tryGrabBag()

            -- Expedition objective: grab coins
			PST:expedAddProgInRun("coins", pickup:GetCoinValue())

            -- Grand Consonance node (T. Siren's tree) - Bum Friend
            if PST:getTreeSnapshotMod("grandConsonance", false) and player:HasCollectible(CollectibleType.COLLECTIBLE_BUM_FRIEND) then
                local consonanceCache = PST:getTreeSnapshotMod("grandConsonanceCache", nil)
                if consonanceCache then
                    if consonanceCache.bumFriendCoins == nil then consonanceCache.bumFriendCoins = 0 end
                    consonanceCache.bumFriendCoins = consonanceCache.bumFriendCoins + pickup:GetCoinValue()
                    if consonanceCache.bumFriendCoins >= 12 then
                        local bumQuery = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BUM_FRIEND)
                        if #bumQuery > 0 then
                            local rewarded = false
                            for _, tmpBum in ipairs(bumQuery) do
                                local tmpAnim = tmpBum:GetSprite():GetAnimation()
                                if tmpAnim ~= "PreSpawn" and tmpAnim ~= "Spawn" then
                                    tmpBum:GetSprite():Play("PreSpawn")
                                    rewarded = true
                                end
                            end

                            if rewarded then
                                local tmpSprite = Sprite("gfx/003.024_bum fiend.anm2", true)
                                tmpSprite:SetFrame("Spawn", 1)
                                PST:createFloatIconFX(tmpSprite, Vector.Zero, 0.25, 50, true)
                                SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                                consonanceCache.bumFriendCoins = consonanceCache.bumFriendCoins - 12
                            end
                        end
                    end
                end
            end

            -- Astral weapon mod: +% damage for X seconds when picking up any coin
            local tmpMod = PST:getSnapAstralWepMod("coinPickupDmg")
            if tmpMod then
                PST.specialNodes.astralwep_coinBuff = math.min(tmpMod[3], PST.specialNodes.astralwep_coinBuff + tmpMod[1])
                PST.specialNodes.astralwep_coinTimer = math.ceil(tmpMod[2] * 30)
            end

            -- Astral weapon mod: +% permanent damage after picking up any coin worth at least 5
            tmpMod = PST:getSnapAstralWepMod("coinPermDmg")
            if tmpMod and pickup:GetCoinValue() >= 5 then
                local tmpAdd = math.min(tmpMod[1], tmpMod[2] - PST:getTreeSnapshotMod("astralwep_coinPermDmgBuff", 0))
                if tmpAdd > 0 then
                    PST:addModifiers({ damagePerc = tmpAdd, astralwep_coinPermDmgBuff = tmpAdd }, true)
                end
            end

            -- Ancient weapon mod: Auric Persecutor
            tmpMod = PST:getSnapAstralWepMod("auricPersecutor")
            if tmpMod and pickup:GetCoinValue() >= 5 then
                local tmpAdd = math.min(tmpMod[2], tmpMod[3] - PST:getTreeSnapshotMod("ancwep_auricPersecutorBuff", 0))
                if tmpAdd > 0 then
                    PST:addModifiers({ damagePerc = tmpAdd, ancwep_auricPersecutorBuff = tmpAdd }, true)
                end
            end

            -- Ancient weapon mod: Gilded Seeker
            tmpMod = PST:getSnapAstralWepMod("gildedSeeker")
            if tmpMod and PST:getRoom():GetAliveEnemiesCount() > 0 and PST:getTreeSnapshotMod("ancwep_gildedSeekerBuff", 0) < tmpMod[1] then
                PST:addModifiers({ damagePerc = 1, ancwep_gildedSeekerBuff = 1 }, true)
            end

            -- Mod: +% speed per coin picked up
            tmpMod = PST:getTreeSnapshotMod("pickupBoons", 0)
            if tmpMod and PST:getTreeSnapshotMod("pickupBoonsCoinBuff", 0) < 10 then
                PST:addModifiers({ speedPerc = tmpMod, pickupBoonsCoinBuff = tmpMod }, true)
            end

            -- Boon of the Ordinary node (Isaac's tree)
            if PST:getTreeSnapshotMod("boonOrdinary", false) then
                PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
            end
        -- On pickup key
        elseif variant == PickupVariant.PICKUP_KEY then
            local keyChance = PST:getTreeSnapshotMod("keyDupe", 0)
            if keyChance > 0 and 100 * math.random() < keyChance then
                player:AddKeys(1)
            end
            PST:tryGrabBag()

            -- Mod: +% tears per key picked up
            tmpMod = PST:getTreeSnapshotMod("pickupBoons", 0)
            if tmpMod and PST:getTreeSnapshotMod("pickupBoonsKeyBuff", 0) < 10 then
                PST:addModifiers({ tearsPerc = tmpMod, pickupBoonsKeyBuff = tmpMod }, true)
            end
        -- On pickup bomb
        elseif variant == PickupVariant.PICKUP_BOMB then
            local bombChance = PST:getTreeSnapshotMod("bombDupe", 0)
            if bombChance > 0 and 100 * math.random() < bombChance then
                player:AddBombs(1)
            end
            PST:tryGrabBag()

            -- Mod: +% damage per coin picked up
            tmpMod = PST:getTreeSnapshotMod("pickupBoons", 0)
            if tmpMod and PST:getTreeSnapshotMod("pickupBoonsBombBuff", 0) < 10 then
                PST:addModifiers({ damagePerc = tmpMod, pickupBoonsBombBuff = tmpMod }, true)
            end
        -- On pickup hearts
        elseif variant == PickupVariant.PICKUP_HEART then
            -- Black heart pickup
            if subtype == HeartSubType.HEART_BLACK then
                -- Sacrifice Darkness node (Judas' tree)
                if PST:getTreeSnapshotMod("sacrificeDarkness", false) then
                    player:AddBlackHearts(-2)
                    player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, UseFlag.USE_NOANIM)
                    player:ResetDamageCooldown()
                    player:AddSoulHearts(2)
                    if PST:getTreeSnapshotMod("blackHeartSacrifices", 0) < 6 then
                        PST:addModifiers({ blackHeartSacrifices = 1 }, true)
                    end
                end

                -- Heartseeker Phantasm node (The Lost's tree)
                if PST:getTreeSnapshotMod("heartseekerPhantasm", false) then
                    -- +0.1 luck when collecting soul or black hearts. +1% all stats for every 3 hearts collected
                    PST:addModifiers({ heartseekerPhantasmCollected = 1 }, true)
                    local tmpCollected = PST:getTreeSnapshotMod("heartseekerPhantasmCollected", 0)
                    if tmpCollected <= 30 then
                        PST:addModifiers({ luck = 0.1 }, true)
                    end
                    if tmpCollected % 3 == 0 and tmpCollected <= 60 then
                        PST:addModifiers({ allstatsPerc = 1 }, true)
                    end
                end

                -- Mod: Black hearts grant +damage when collected, up to a total +3
                tmpBonus = PST:getTreeSnapshotMod("blackHeartDamage", 0)
                if tmpBonus ~= 0 and PST:getTreeSnapshotMod("blackHeartDamageTotal", 0) < 3 then
                    PST:addModifiers({ damage = tmpBonus, blackHeartDamageTotal = tmpBonus }, true)
                end
            end
            -- Soul heart pickup
            if subtype == HeartSubType.HEART_SOUL or subtype == HeartSubType.HEART_HALF_SOUL or subtype == HeartSubType.HEART_BLENDED then
                -- Mod: +% tears and range when picking up a soul heart. Resets every floor
                local tmpBonus = PST:getTreeSnapshotMod("soulHeartTearsRange", 0)
                if tmpBonus > 0 and PST:getTreeSnapshotMod("soulHeartTearsRangeTotal", 0) < 10 then
                    PST:addModifiers({
                        tearsPerc = tmpBonus,
                        rangePerc = tmpBonus,
                        soulHeartTearsRangeTotal = tmpBonus
                    }, true)
                end

                -- Heartseeker Phantasm node (The Lost's tree)
                if PST:getTreeSnapshotMod("heartseekerPhantasm", false) then
                    -- +0.1 luck when collecting soul or black hearts. +1% all stats for every 3 hearts collected
                    PST:addModifiers({ heartseekerPhantasmCollected = 1 }, true)
                    local tmpCollected = PST:getTreeSnapshotMod("heartseekerPhantasmCollected", 0)
                    if tmpCollected <= 30 then
                        PST:addModifiers({ luck = 0.1 }, true)
                    end
                    if tmpCollected % 3 == 0 and tmpCollected <= 60 then
                        PST:addModifiers({ allstatsPerc = 1 }, true)
                    end
                end

                -- Mod: Soul hearts grant +tears when collected, up to a total +1
                tmpBonus = PST:getTreeSnapshotMod("soulHeartTears", 0)
                if tmpBonus ~= 0 and PST:getTreeSnapshotMod("soulHeartTearsTotal", 0) < 1 then
                    PST:addModifiers({ tears = tmpBonus, soulHeartTearsTotal = tmpBonus }, true)
                end

                -- Soul Trickle node (Bethany's tree)
                if PST:getTreeSnapshotMod("soulTrickle", false) then
                    player:AddHearts(1)
                end
            end
            -- Red heart pickups
            if subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_HALF or subtype == HeartSubType.HEART_BLENDED or subtype == HeartSubType.HEART_DOUBLEPACK or
            subtype == HeartSubType.HEART_SCARED then
                -- Mod: chance to gain a soul charge when picking up a red heart
                if 100 * math.random() < PST:getTreeSnapshotMod("redHeartsSoulCharge", 0) then
                    SFXManager():Play(SoundEffect.SOUND_BEEP)
                    player:AddSoulCharge(1)
                end

                -- Bloodful node (T. Magdalene's tree)
                if PST:getTreeSnapshotMod("bloodful", false) then
                    local tmpMods = { allstatsPerc = 0 }
                    if PST:getTreeSnapshotMod("bloodfulBuff", 0) < 10 then
                        tmpMods.allstatsPerc = tmpMods.allstatsPerc + 1
                        tmpMods.bloodfulBuff = 1
                    end
                    if not PST:getTreeSnapshotMod("bloodfulDebuffProc", false) then
                        tmpMods.allstatsPerc = tmpMods.allstatsPerc + 5
                        tmpMods.bloodfulDebuffProc = true
                    end
                    if tmpMods.allstatsPerc ~= 0 then
                        PST:addModifiers(tmpMods, true)
                    end
                end

                -- Mod: chance to gain +luck when picking up red hearts, triple chance for vanishing red hearts
                tmpMod = PST:getTreeSnapshotMod("redHeartLuckSamson", 0)
                if pickup.Timeout > 0 then
                    tmpMod = tmpMod * 3
                end
                if tmpMod > 0 and PST:getTreeSnapshotMod("redHeartLuckBuff", 0) < 1 and 100 * math.random() < tmpMod then
                    local tmpAdd = math.min(0.03, 1 - PST:getTreeSnapshotMod("redHeartLuckBuff", 0))
                    PST:addModifiers({ luck = tmpAdd, redHeartLuckBuff = tmpAdd }, true)
                end

                -- Temporary red heart pickup
                if pickup.Timeout > 0 then
                    -- Mod: +% damage/tears when picking up a temporary red heart
                    tmpMod = PST:getTreeSnapshotMod("temporaryHeartDmg", 0)
                    if tmpMod > 0 then
                        PST.specialNodes.temporaryHeartDmgStacks = PST.specialNodes.temporaryHeartDmgStacks + 1
                        PST.specialNodes.temporaryHeartBuffTimer = 60 + math.floor(PST:getTreeSnapshotMod("temporaryHeartTime", 0) * 30)
                        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
                    end
                    tmpMod = PST:getTreeSnapshotMod("temporaryHeartTears", 0)
                    if tmpMod > 0 then
                        PST.specialNodes.temporaryHeartTearStacks = PST.specialNodes.temporaryHeartTearStacks + 1
                        PST.specialNodes.temporaryHeartBuffTimer = 60 + math.floor(PST:getTreeSnapshotMod("temporaryHeartTime", 0) * 30)
                        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY, true)
                    end

                    -- Mod: +luck if temporary heart has 2 seconds or more remaining
                    tmpMod = PST:getTreeSnapshotMod("temporaryHeartLuck", 0)
                    if tmpMod > 0 and PST:getRoom():IsFirstVisit() and pickup.Timeout >= 54 and 100 * math.random() < 40 then
                        PST:addModifiers({ luck = tmpMod, temporaryHeartLuckBuff = tmpMod }, true)
                    end
                end

                -- Mod: +% damage for the current room when picking up red hearts
                tmpMod = PST:getTreeSnapshotMod("redHeartRoomDmg", 0)
                if tmpMod > 0 then
                    local tmpTotal = PST:getTreeSnapshotMod("redHeartRoomDmgBuff", 0)
                    if tmpTotal < 15 then
                        local tmpAdd = math.min(tmpMod, 15 - tmpTotal)
                        PST:addModifiers({ damagePerc = tmpAdd, redHeartRoomDmgBuff = tmpAdd }, true)
                    end
                end

                -- Grand Consonance node (T. Siren's tree) - Dark Bum
                if PST:getTreeSnapshotMod("grandConsonance", false) and player:HasCollectible(CollectibleType.COLLECTIBLE_DARK_BUM) then
                    local consonanceCache = PST:getTreeSnapshotMod("grandConsonanceCache", nil)
                    if consonanceCache then
                        if consonanceCache.darkBumHearts == nil then consonanceCache.darkBumHearts = 0 end
                        if subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_SCARED then
                            consonanceCache.darkBumHearts = consonanceCache.darkBumHearts + 2
                        elseif subtype == HeartSubType.HEART_DOUBLEPACK then
                            consonanceCache.darkBumHearts = consonanceCache.darkBumHearts + 4
                        else
                            consonanceCache.darkBumHearts = consonanceCache.darkBumHearts + 1
                        end
                        if consonanceCache.darkBumHearts >= 8 then
                            local bumQuery = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DARK_BUM)
                            if #bumQuery > 0 then
                                local rewarded = false
                                for _, tmpBum in ipairs(bumQuery) do
                                    local tmpAnim = tmpBum:GetSprite():GetAnimation()
                                    if tmpAnim ~= "PreSpawn" and tmpAnim ~= "Spawn" then
                                        tmpBum:GetSprite():Play("PreSpawn")
                                        rewarded = true
                                    end
                                end

                                if rewarded then
                                    local tmpSprite = Sprite("gfx/003.278_darkbum.anm2", true)
                                    tmpSprite:SetFrame("Spawn", 1)
                                    PST:createFloatIconFX(tmpSprite, Vector.Zero, 0.25, 50, true)
                                    SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
                                    consonanceCache.darkBumHearts = consonanceCache.darkBumHearts - 8
                                end
                            end
                        end
                    end
                end

                -- Mod: % chance for scared hearts to heal an additional 1/2 heart
                tmpMod = PST:getTreeSnapshotMod("scaredHeartConv", 0) * 10
                if tmpMod > 0 and subtype == HeartSubType.HEART_SCARED and 100 * math.random() < tmpMod then
                    player:AddHearts(1)
                end
            end

            -- Heartless node (Eve's tree)
            if PST:getTreeSnapshotMod("heartless", false) then
                local heartlessTotal = PST:getTreeSnapshotMod("heartlessTotal", 0)
                if heartlessTotal > 0 then
                    PST:addModifiers({ allstatsPerc = -heartlessTotal / 2, heartlessTotal = -heartlessTotal / 2 }, true)
                end
            end

            -- The Forgotten mod updates
            if PST:getTreeSnapshotMod("forgottenSoulDamage", 0) ~= 0 or PST:getTreeSnapshotMod("forgottenSoulTears", 0) ~= 0 or
            PST:getTreeSnapshotMod("theSoulBoneDamage", 0) ~= 0 or PST:getTreeSnapshotMod("theSoulBoneTears", 0) ~= 0 then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY, true)
            end

            -- Expedition objective: pick up hearts of any type
            PST:expedAddProgInRun("hearts", 1)

            -- Uber expedition entropy mod
            if PST:getTreeSnapshotMod("expedEnt_hearts", false) and not (subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_HALF or subtype == HeartSubType.HEART_DOUBLEPACK or
            subtype == HeartSubType.HEART_SCARED) then
                local totalHearts = player:GetMaxHearts() / 2 + player:GetSoulHearts() / 2 + player:GetRottenHearts() + player:GetBoneHearts()
                if totalHearts >= 5 then
                    PST:expedAddEntropy(
						PST:getTreeSnapshotMod("expedDepth", 1),
						PST.expedEntropyMods.expedEnt_hearts.entropy
					)
                end
            end
        -- On pickup poops
        elseif variant == PickupVariant.PICKUP_POOP then
            -- Mod: chance to transmute a random poop in your bar to a different one when obtaining a poop pickup
            local tmpMod = PST:getTreeSnapshotMod("poopTransmutation", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local poopOrder = {
                    PoopSpellType.SPELL_POOP,
                    PoopSpellType.SPELL_FART,
                    PoopSpellType.SPELL_BOMB,
                    PoopSpellType.SPELL_CORNY,
                    PoopSpellType.SPELL_STONE,
                    PoopSpellType.SPELL_BURNING,
                    PoopSpellType.SPELL_STINKY,
                    PoopSpellType.SPELL_DIARRHEA,
                    PoopSpellType.SPELL_LIQUID,
                    PoopSpellType.SPELL_BLACK,
                    PoopSpellType.SPELL_HOLY
                }
                local randSpell = math.random(Isaac.GetPlayer():GetMaxPoopMana()) - 1
                local plSpell = player:GetPoopSpell(randSpell)
                for i, tmpPoop in ipairs(poopOrder) do
                    if plSpell == tmpPoop and poopOrder[i + 1] ~= nil then
                        player:SetPoopSpell(randSpell, poopOrder[i + 1])
                        PST:createFloatTextFX(PST:getLocalized("ftxt_transmuted"), Vector.Zero, Color(0.8, 0.9, 1, 1), 0.12, 40, true)
                        break
                    end
                end
            end
        end

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_BETHANY) then
            -- Bethany, halve soul and black heart pickups, and give -0.02 luck
            if variant == PickupVariant.PICKUP_HEART then
                if subtype == HeartSubType.HEART_BLACK then
                    player:AddBlackHearts(-1)
                    PST:addModifiers({ luck = -0.02 }, true)
                elseif subtype == HeartSubType.HEART_SOUL then
                    player:AddSoulHearts(-1)
                    PST:addModifiers({ luck = -0.02 }, true)
                end
            end
        elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS_B) then
            -- Tainted Judas, take 1 heart of damage when picking up a black heart
            if variant == PickupVariant.PICKUP_HEART and subtype == HeartSubType.HEART_BLACK then
                player:TakeDamage(2, 0, EntityRef(player), 0)
                local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
                if cosmicRCache.TJudasDmgUps < 3 then
                    cosmicRCache.TJudasDmgUps = cosmicRCache.TJudasDmgUps + 1
                    PST:addModifiers({ damage = 0.4 }, true)
                end
            end
        end
    end
    -- Remove from entity data cache if present
    if PST.entDataCache[pickup.InitSeed] then
        PST.entDataCache[pickup.InitSeed] = nil
    end
end

--- @param pickup EntityPickup
local function PST_expedOpenChest(pickup)
    -- Expedition objective: open any chest
    PST:expedAddProgInRun("chests", 1)

    local pedestal = pickup:GetAlternatePedestal()
    -- Locked chests
    if pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST or pedestal == PedestalType.GOLDEN_CHEST or pedestal == PedestalType.GOLDEN_CHEST_COIN_SLOT then
        -- Expedition objective: open locked chests
        PST:expedAddProgInRun("goldChests", 1)
    -- Red chests
    elseif pickup.Variant == PickupVariant.PICKUP_REDCHEST or pedestal == PedestalType.RED_CHEST then
        -- Expedition objective: open red chests
        PST:expedAddProgInRun("redChests", 1)
    -- Stone chests
    elseif pickup.Variant == PickupVariant.PICKUP_BOMBCHEST or pedestal == PedestalType.STONE_CHEST then
        -- Expedition objective: open stone/bomb chests
        PST:expedAddProgInRun("stoneChests", 1)
    end

    -- Any special chest
    if pickup.Variant ~= PickupVariant.PICKUP_CHEST or (pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and pickup:GetAlternatePedestal() ~= -1 and
    pickup:GetAlternatePedestal() ~= PedestalType.CHEST) then
        if PST:getTreeSnapshotMod("isExpedRun", false) then
            local tmpObols = PST.obolEvents.chests(PST:getTreeSnapshotMod("expedDepth", 1))
            if tmpObols > 0 then PST:expedDropObolsAt(pickup.Position, tmpObols) end
        end
    end

    -- Uber expedition entropy mod
    if PST:getTreeSnapshotMod("expedEnt_chests", false) then
        PST:addModifiers({ expedEnt_chestCounter = 1 }, true)
        if PST:getTreeSnapshotMod("expedEnt_chestCounter", 0) > 5 then
            PST:expedAddEntropy(
                PST:getTreeSnapshotMod("expedDepth", 1),
                PST.expedEntropyMods.expedEnt_chests.entropy
            )
        end
    end
end

---@param pickup EntityPickup
function PST:onPickupInit(pickup, firstSpawn)
    local room = PST:getRoom()
    local isShop = room:GetType() == RoomType.ROOM_SHOP
    local variant = pickup.Variant
    local subtype = pickup.SubType

    local pickupGone = false
    -- Ancient starcursed jewel: Opalescent Purity
    if PST:SC_getSnapshotMod("opalescentPurity", false) and PST:getTreeSnapshotMod("SC_opalescentProc", false) and
    variant == PickupVariant.PICKUP_COLLECTIBLE and not PST:arrHasValue(PST.progressionItems, subtype) then
        pickup:Remove()
        pickupGone = true
    end

    -- Ancient starcursed jewel: Baubleseeker
    if not pickupGone and PST:SC_getSnapshotMod("baubleseeker", false) and variant == PickupVariant.PICKUP_COLLECTIBLE and
    subtype ~= CollectibleType.COLLECTIBLE_MOMS_BOX and not PST:arrHasValue(PST.progressionItems, subtype) then
        local tmpTrinket = Game():GetItemPool():GetTrinket()
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpTrinket, true, true, true)
        if room:GetType() == RoomType.ROOM_CHALLENGE then
            local tmpPos = room:FindFreePickupSpawnPosition(pickup.Position, 20)
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, tmpPos, Vector.Zero, nil, 0, Random() + 1)
        end
    end

    -- Ancient starcursed jewel: Crimson Warpstone
    if not pickupGone and PST:SC_getSnapshotMod("crimsonWarpstone", false) and variant == PickupVariant.PICKUP_COLLECTIBLE and
    not PST:arrHasValue(PST.progressionItems, subtype) then
        if room:GetType() == RoomType.ROOM_TREASURE or room:GetType() == RoomType.ROOM_SHOP or room:GetType() == RoomType.ROOM_ANGEL then
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, true, true, true)
        end
    end

    -- Ancient starcursed jewel: Twisted Emperor's Heirloom
    if not pickupGone and PST:SC_getSnapshotMod("twistedEmperorHeirloom", false) and room:GetType() == RoomType.ROOM_BOSS and
    variant == PickupVariant.PICKUP_COLLECTIBLE and not PST:arrHasValue(PST.progressionItems, subtype) then
        local heirloomRoom = PST:getTreeSnapshotMod("SC_empHeirloomRoomID", -1)
        if heirloomRoom ~= -1 and heirloomRoom == PST:getLevel():GetCurrentRoomDesc().SafeGridIndex then
            if PST:getLevel():GetStage() < 7 and not PST:getLevel():IsAscent() then
                pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 0, false, false, true)
            else
                pickup:Remove()
            end
            pickupGone = true
        end
    end

    -- Sidereal Cache spawn SFX
    if variant == Isaac.GetEntityVariantByName("Sidereal Cache") and pickup:GetSprite():GetAnimation() == "Appear" then
        SFXManager():Play(SoundEffect.SOUND_CHEST_DROP, 1, 2, false, 1.2)
    end

    -- Chance to replace regular chest with Sidereal Cache, up to twice per room
    local tmpMod = PST:getTreeSnapshotMod("sideCacheRegChest", 0) + PST:getTreeSnapshotMod("sideCacheFloorChanceTotal", 0)
    if tmpMod > 0 and variant == PickupVariant.PICKUP_CHEST and subtype == ChestSubType.CHEST_CLOSED and firstSpawn and
    PST:getTreeSnapshotMod("sideCacheRegChestProcs", 0) < 2 and 100 * math.random() < tmpMod then
        Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
        pickup:Morph(EntityType.ENTITY_PICKUP, Isaac.GetEntityVariantByName("Sidereal Cache"), 0)
        SFXManager():Play(SoundEffect.SOUND_CHEST_DROP, 1, 2, false, 1.2)
        PST:addModifiers({ sideCacheRegChest = 1 }, true)
    end

    -- Mod: old chest conversion
    tmpMod = PST:getTreeSnapshotMod("oldChestConvChance", 0)
    local isChestStage = PST:getLevel():GetStage() == 11
    if tmpMod > 0 and not isChestStage and variant == PickupVariant.PICKUP_LOCKEDCHEST and subtype == ChestSubType.CHEST_CLOSED and firstSpawn and
    PST:getTreeSnapshotMod("oldChestConvProcs", 0) < 5 and 100 * math.random() < tmpMod then
        Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, pickup.Position, Vector.Zero, nil, 0, Random() + 1)
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_OLDCHEST, 0)
        SFXManager():Play(SoundEffect.SOUND_CHEST_DROP, 1, 2, false, 1.2)
        PST:addModifiers({ oldChestConvProcs = 1 }, true)
    end

    -- Chest pedestal first spawn
    local openedChests = PST:getTreeSnapshotMod("openedChests", nil)
    if not openedChests then
        PST.modData.treeModSnapshot.openedChests = {}
        openedChests = PST.modData.treeModSnapshot.openedChests
    end
    if variant == PickupVariant.PICKUP_COLLECTIBLE and PST:arrHasValue(PST.chestPedestals, pickup:GetAlternatePedestal()) and
    not PST:arrHasValue(openedChests, pickup.InitSeed) then
        table.insert(openedChests, pickup.InitSeed)
        PST_expedOpenChest(pickup)
    end

    -- Mod: % chance for chests to become heart-blessed when appearing
    tmpMod = PST:getTreeSnapshotMod("heartblessedChests", 0)
    if tmpMod > 0 and PST:isPickupChest(variant) and 100 * math.random() < tmpMod then
        local heartblessedList = PST:getTreeSnapshotMod("heartblessedList", {})
        if not PST:arrHasValue(heartblessedList, pickup.InitSeed) then
            table.insert(heartblessedList, pickup.InitSeed)
        end
    end

    -- Trinkets
    if variant == PickupVariant.PICKUP_TRINKET then
        -- Fickle Fortune node (Cain's tree), vanish proc
        if PST.specialNodes.fickleFortuneVanish then
            PST:vanishPickup(pickup)
            PST.specialNodes.fickleFortuneVanish = false
            pickupGone = true
        end
    -- Pills
    elseif variant == PickupVariant.PICKUP_PILL then
        -- Blue Gambit node (Blue Baby's tree)
        if PST:getTreeSnapshotMod("blueGambit", false) and not PST:getTreeSnapshotMod("blueGambitPillProc", false) then
            local player = PST:getPlayer()
            ---@diagnostic disable-next-line: undefined-field
            local newColor = Game():GetItemPool():GetPillColor(PillEffect.PILLEFFECT_BALLS_OF_STEEL)
            PST:blueGambitPillSwap(subtype, Game():GetItemPool():GetPillEffect(subtype, player), newColor)
        end
    -- Cards
    elseif variant == PickupVariant.PICKUP_TAROTCARD then
        -- Re-roll Soul of the Siren drop if not unlocked
        local sirenSoulID = Isaac.GetCardIdByName("SoulOfTheSiren")
        if sirenSoulID ~= -1 and pickup.SubType == sirenSoulID and not PST:isSoulOfTheSirenUnlocked() then
            local newCard = Game():GetItemPool():GetCard(Random() + 1, false, true, true)
            local failsafe = 0
            while newCard == sirenSoulID and failsafe < 300 do
                newCard = Game():GetItemPool():GetCard(Random() + 1, false, true, true)
                failsafe = failsafe + 1
            end
            if failsafe >= 300 then
                newCard = Card.RUNE_SHARD
            end
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, newCard, true, true, true)
        end

        -- Blue Gambit node (Blue Baby's tree)
        if PST:getTreeSnapshotMod("blueGambit", false) and not PST:getTreeSnapshotMod("blueGambitCardProc", false) and PST:arrHasValue(PST.blueGambitCards, pickup.SubType) then
            PST:addModifiers({ blueGambitCardProc = true }, true)
            pickup:Remove()
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, pickup.Position, pickup.Velocity, nil, Card.CARD_HIEROPHANT, Random() + 1)
            pickupGone = true
        end
    -- Poops
    elseif variant == PickupVariant.PICKUP_POOP then
        -- Mod: chance to turn dropped small poop pickups into large poops
        tmpMod = PST:getTreeSnapshotMod("poopPickupEnlarge", 0)
        if firstSpawn and tmpMod > 0 and subtype == PoopPickupSubType.POOP_SMALL and 100 * math.random() < tmpMod then
            pickup:Morph(pickup.Type, variant, PoopPickupSubType.POOP_BIG, true, true)
        end
    else
        -- Starcursed mod: coin, key and bomb scarcity
        tmpMod = PST:SC_getSnapshotMod("pickupScarcity", 0)
        -- Expedition implicit: pickup scarcity
        tmpMod = tmpMod + PST:getTreeSnapshotMod("expedImp_pickupScarcity", 0)
        -- Deep-Space Distortion mod: pickup scarcity
        if PST:getTreeSnapshotMod("dsdMod_pickupScarcity", false) then
            tmpMod = tmpMod + 33
        end
        -- Disable scarcity mods in mineshaft sequence
        if PST:inMineshaftPuzzle() then tmpMod = 0 end

        if firstSpawn and (variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_BOMB or
        variant == PickupVariant.PICKUP_KEY) and tmpMod > 0 and 100 * math.random() < tmpMod then
            pickup:Remove()
            pickupGone = true
        end

        -- Expedition curse: ephemeral pieces
        tmpMod = PST:getTreeSnapshotMod("curseEphPieces", 0)
        if tmpMod > 0 and firstSpawn and pickup.Timeout == -1 and not isShop and (variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_BOMB or
        variant == PickupVariant.PICKUP_KEY or variant == PickupVariant.PICKUP_HEART) then
            pickup.Timeout = math.ceil(tmpMod * 30)
        end

        -- Hearts
        if variant == PickupVariant.PICKUP_HEART then
            -- Starcursed mod: heart scarcity
            tmpMod = PST:SC_getSnapshotMod("heartScarcity", 0)
            -- Expedition implicit: pickup scarcity
            tmpMod = tmpMod + PST:getTreeSnapshotMod("expedImp_pickupScarcity", 0)
            -- Deep-Space Distortion mod: heart scarcity
            if PST:getTreeSnapshotMod("dsdMod_heartScarcity", false) then
                tmpMod = tmpMod + 33
            end
            -- Disable scarcity mods in mineshaft sequence
            if PST:inMineshaftPuzzle() then tmpMod = 0 end

            if firstSpawn and tmpMod > 0 and 100 * math.random() < tmpMod then
                pickup:Remove()
                pickupGone = true
            end

            -- Sacrifice Darkness node (Judas' tree)
            if not pickupGone and PST:getTreeSnapshotMod("sacrificeDarkness", false) then
                -- 35% chance to replace dropped soul hearts with black hearts
                if firstSpawn and not isShop and subtype == HeartSubType.HEART_SOUL and 100 * math.random() < 35 then
                    pickup:Remove()
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_BLACK, Random() + 1)
                    pickupGone = true
                end
            end

            -- Mod: chance to replace any heart drops with black hearts
            if firstSpawn and not isShop and not pickupGone and subtype ~= HeartSubType.HEART_BLACK and
            100 * math.random() < PST:getTreeSnapshotMod("heartsToBlack", 0) then
                pickup:Remove()
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_BLACK, Random() + 1)
                pickupGone = true
            end

            -- Heartseeker Phantasm node (The Lost's tree)
            if PST:getTreeSnapshotMod("heartseekerPhantasm", false) and not isShop and not pickupGone then
                -- Convert red and eternal hearts to soul hearts
                if subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_HALF or subtype == HeartSubType.HEART_ETERNAL or subtype == HeartSubType.HEART_SCARED then
                    pickup:Remove()
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_SOUL, Random() + 1)
                    pickupGone = true
                end
            end

            -- Soul Trickle node (Bethany's tree)
            if firstSpawn and not pickupGone and PST:getTreeSnapshotMod("soulTrickle", false) and
            (subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_HALF or subtype == HeartSubType.HEART_SCARED) then
                local player = PST:getPlayer()
                if player:GetHearts() == player:GetMaxHearts() and not isShop and 100 * math.random() < 30 then
                    pickup:Remove()
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_SOUL, Random() + 1)
                    pickupGone = true
                end
            end

            -- Mod: chance to convert half red heart pickups to full hearts
            if room:IsFirstVisit() and not isShop and not pickupGone and subtype == HeartSubType.HEART_HALF and
            100 * math.random() < PST:getTreeSnapshotMod("halfHeartPickupToFull", 0) then
                pickup:Morph(pickup.Type, variant, HeartSubType.HEART_FULL)
            end

            -- Mod: chance to convert dropped red hearts to eternal hearts while T. Jacob is in dead spirit state
            if firstSpawn and not pickupGone and (subtype == HeartSubType.HEART_HALF or subtype == HeartSubType.HEART_FULL) and
            PST:getPlayer():GetPlayerType() == PlayerType.PLAYER_JACOB2_B and 100 * math.random() < PST:getTreeSnapshotMod("heartEternalConv", 0) then
                pickup:Morph(pickup.Type, variant, HeartSubType.HEART_ETERNAL)
            end

            -- Mod: chance to convert dropped full hearts into bone hearts while The Forgotten has less than 2 bone hearts
            tmpMod = PST:getTreeSnapshotMod("redFullToBone", 0)
            if tmpMod > 0 and firstSpawn and not pickupGone and subtype == HeartSubType.HEART_FULL and not PST:getTreeSnapshotMod("redFullToBoneProc", false) and
            100 * math.random() < tmpMod then
                local tmpForg = PST:getPlayer():GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN and PST:getPlayer() or PST:getPlayer():GetSubPlayer()
                if tmpForg:GetBoneHearts() <= 2 then
                    pickup:Morph(pickup.Type, variant, HeartSubType.HEART_BONE, true)
                    PST:addModifiers({ redFullToBoneProc = true }, true)
                end
            end

            -- Mod: chance to convert full red hearts into scared hearts
            tmpMod = PST:getTreeSnapshotMod("scaredHeartConv", 0) / 2
            if tmpMod > 0 and firstSpawn and not pickupGone and not isShop and subtype == HeartSubType.HEART_FULL and 100 * math.random() < tmpMod then
                pickup:Morph(pickup.Type, variant, HeartSubType.HEART_SCARED)
            end
        -- Coins
        elseif variant == PickupVariant.PICKUP_COIN then
            -- Mod: chance to replace pennies with lucky pennies
            local tmpChance = PST:getTreeSnapshotMod("luckyPennyChance", 0)
            if tmpChance > 0 then
                if PST:getPlayer():GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                    tmpChance = tmpChance / 3
                end
                if not pickupGone and firstSpawn and subtype == CoinSubType.COIN_PENNY and 100 * math.random() < tmpChance then
                    pickup:Morph(pickup.Type, variant, CoinSubType.COIN_LUCKYPENNY)
                    pickupGone = true
                end
            end

            -- Mod: % chance to replace dropped pennies with a Blessed Penny if you don't already have one, once per floor
            tmpMod = PST:getTreeSnapshotMod("pennyToBlessed", 0)
            if not pickupGone and tmpMod > 0 and not PST:getTreeSnapshotMod("pennyToBlessedProc", false) and subtype == CoinSubType.COIN_PENNY and
            100 * math.random() < tmpMod then
                pickup:Morph(pickup.Type, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_BLESSED_PENNY)
                PST:addModifiers({ pennyToBlessedProc = true }, true)
                pickupGone = true
            end
        -- Keys
        elseif variant == PickupVariant.PICKUP_KEY then
            -- Mod: chance to replace keys with golden keys, once per floor
            if not pickupGone and firstSpawn and subtype == KeySubType.KEY_NORMAL and 100 * math.random() < PST:getTreeSnapshotMod("goldenKeyConvert", 0) and
            not PST:getTreeSnapshotMod("goldenKeyConvertProc", false) then
                pickup:Remove()
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, pickup.Position, pickup.Velocity, nil, KeySubType.KEY_GOLDEN, Random() + 1)
                PST:addModifiers({ goldenKeyConvertProc = true }, true)
                pickupGone = true
            end

            if not pickupGone and firstSpawn and not isShop then
                -- Mod: chance to replace keys with charged keys if you have any uncharged active item
                tmpMod = PST:getTreeSnapshotMod("chargedKeyConv", 0)
                if tmpMod > 0 then
                    local tmpUncharged = false
                    for i=0,3 do
                        local tmpCharge = PST:getPlayer():GetActiveMaxCharge(i)
                        if tmpCharge > 0 and PST:getPlayer():GetActiveCharge(i) < tmpCharge then
                            tmpUncharged = true
                            break
                        end
                    end
                    if tmpUncharged and 100 * math.random() < tmpMod then
                        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_CHARGED, true)
                    end
                end
            end
        -- Batteries
        elseif variant == PickupVariant.PICKUP_LIL_BATTERY then
            -- Mod: Battery scarcity
            tmpMod = PST:getTreeSnapshotMod("cursePowerDemandScarcity", 0)
            -- Disable scarcity mods in mineshaft sequence
            if PST:inMineshaftPuzzle() then
                tmpMod = 0
            end
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                pickup:Remove()
                pickupGone = true
            end
        end

        -- Sinistral Runemaster node (T. Isaac's tree) - Jera effect
        if not pickupGone and PST:getTreeSnapshotMod("sinistralRunemaster", false) and PST.specialNodes.jeraUseFrame == Game():GetFrameCount()
        and 100 * math.random() < 8 then
            if variant == PickupVariant.PICKUP_COIN then
                if subtype == CoinSubType.COIN_PENNY then
                    pickupGone = true
                    if 100 * math.random() < 3 then
                        pickup:Morph(pickup.Type, variant, CoinSubType.COIN_GOLDEN)
                    elseif 100 * math.random() < 50 then
                        pickup:Morph(pickup.Type, variant, CoinSubType.COIN_DOUBLEPACK)
                    elseif 100 * math.random() < 25 then
                        pickup:Morph(pickup.Type, variant, CoinSubType.COIN_LUCKYPENNY)
                    else
                        pickup:Morph(pickup.Type, variant, CoinSubType.COIN_NICKEL)
                    end
                elseif subtype == CoinSubType.COIN_NICKEL then
                    pickupGone = true
                    if 100 * math.random() < 5 then
                        pickup:Morph(pickup.Type, variant, CoinSubType.COIN_GOLDEN)
                    else
                        pickup:Morph(pickup.Type, variant, CoinSubType.COIN_DIME)
                    end
                end
            elseif variant == PickupVariant.PICKUP_BOMB then
                if subtype == BombSubType.BOMB_NORMAL then
                    pickupGone = true
                    if 100 * math.random() < 3 then
                        pickup:Morph(pickup.Type, variant, BombSubType.BOMB_GOLDEN)
                    else
                        pickup:Morph(pickup.Type, variant, BombSubType.BOMB_DOUBLEPACK)
                    end
                end
            elseif variant == PickupVariant.PICKUP_KEY then
                if subtype == KeySubType.KEY_NORMAL then
                    pickupGone = true
                    if 100 * math.random() < 25 then
                        pickup:Morph(pickup.Type, variant, KeySubType.KEY_CHARGED)
                    elseif 100 * math.random() < 3 then
                        pickup:Morph(pickup.Type, variant, KeySubType.KEY_GOLDEN)
                    else
                        pickup:Morph(pickup.Type, variant, KeySubType.KEY_DOUBLEPACK)
                    end
                end
            end
        end

        if not pickupGone then
            -- Mod: chance for dropped pickups to be a special variant
            tmpMod = PST:getTreeSnapshotMod("droppedSpecialPickups", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                if variant == PickupVariant.PICKUP_COIN then
                    if subtype == CoinSubType.COIN_PENNY then
                        if 100 * math.random() < 7 then
                            pickup:Morph(pickup.Type, variant, CoinSubType.COIN_GOLDEN)
                        else
                            pickup:Morph(pickup.Type, variant, CoinSubType.COIN_LUCKYPENNY)
                        end
                    end
                elseif variant == PickupVariant.PICKUP_KEY then
                    if subtype == KeySubType.KEY_NORMAL then
                        if 100 * math.random() < 7 then
                            pickup:Morph(pickup.Type, variant, KeySubType.KEY_GOLDEN)
                        else
                            pickup:Morph(pickup.Type, variant, KeySubType.KEY_CHARGED)
                        end
                    end
                elseif variant == PickupVariant.PICKUP_BOMB then
                    if subtype == BombSubType.BOMB_NORMAL then
                        if 100 * math.random() < 2 then
                            pickup:Morph(pickup.Type, variant, BombSubType.BOMB_GIGA)
                        elseif 100 * math.random() < 40 then
                            pickup:Morph(pickup.Type, variant, BombSubType.BOMB_GOLDEN)
                        else
                            pickup:Morph(pickup.Type, variant, BombSubType.BOMB_DOUBLEPACK)
                        end
                    end
                elseif variant == PickupVariant.PICKUP_HEART then
                    if subtype == HeartSubType.HEART_HALF or subtype == HeartSubType.HEART_FULL or subtype == HeartSubType.HEART_SCARED then
                        if 100 * math.random() < 50 then
                            pickup:Morph(pickup.Type, variant, HeartSubType.HEART_GOLDEN)
                        else
                            pickup:Morph(pickup.Type, variant, HeartSubType.HEART_BLENDED)
                        end
                    elseif subtype == HeartSubType.HEART_SOUL or subtype == HeartSubType.HEART_HALF_SOUL then
                        if 100 * math.random() < 50 then
                            pickup:Morph(pickup.Type, variant, HeartSubType.HEART_BLENDED)
                        end
                    end
                end
            end

            -- Mod: % chance to replace spiked and mimic chests with regular chests
            tmpMod = PST:getTreeSnapshotMod("spikedChestReplace", 0)
            if firstSpawn and tmpMod > 0 and (variant == PickupVariant.PICKUP_SPIKEDCHEST or variant == PickupVariant.PICKUP_MIMICCHEST) and
            100 * math.random() < tmpMod then
                pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, subtype)
            end

            -- Cosmic Realignment node
            if PST:cosmicRCharPicked(PlayerType.PLAYER_MAGDALENE_B) then
                -- Tainted Magdalene, 15% chance to turn coins, bombs, keys or chests into a half red heart
                if firstSpawn and not isShop and variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_BOMB or
                variant == PickupVariant.PICKUP_KEY or PST:isPickupChest(variant) then
                    if 100 * math.random() < 15 then
                        pickup:Remove()
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_HALF, Random() + 1)
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_JUDAS_B) then
                -- Tainted Judas, convert soul hearts to black hearts
                if variant == PickupVariant.PICKUP_HEART and not isShop then
                    if subtype == HeartSubType.HEART_SOUL or subtype == HeartSubType.HEART_HALF_SOUL then
                        pickup:Remove()
                        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, pickup.Position, pickup.Velocity, nil, HeartSubType.HEART_BLACK, Random() + 1)
                    end
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THELOST_B) then
                -- Tainted Lost, remove eternal hearts
                if variant == PickupVariant.PICKUP_HEART and subtype == HeartSubType.HEART_ETERNAL then
                    pickup:Remove()
                end
            elseif PST:cosmicRCharPicked(PlayerType.PLAYER_KEEPER_B) then
                -- Tainted Keeper, convert bombs, keys, hearts and chests to coins
                if not isShop and (variant == PickupVariant.PICKUP_HEART or variant == PickupVariant.PICKUP_KEY or
                variant == PickupVariant.PICKUP_BOMB or PST:isPickupChest(variant)) then
                    pickup:Remove()
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, pickup.Position, pickup.Velocity, nil, CoinSubType.COIN_PENNY, Random() + 1)
                end
            end

            local charData = PST:getCurrentCharData()
            if firstSpawn and charData then
                -- Crimson Convergence buff: % chance to duplicate coin/key/bomb
                if PST:getTreeSnapshotMod("crimConvBuff", "") == "abundanceGoods" then
                    local tmpChance = charData.crimsonStarcores
                    if pickup.Timeout > 0 then
                        tmpChance = tmpChance * 3
                    end
                    if not isShop and (variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_KEY or
                    variant == PickupVariant.PICKUP_BOMB) and not PST:isGoldenPickup(pickup) and 100 * math.random() < tmpChance then
                        local newPickup = Isaac.Spawn(pickup.Type, variant, subtype, pickup.Position, 2 * RandomVector(), nil)
                        PST:getEntData(newPickup).PST_duped = true
                    end
                end

                -- Crimson Convergence buff: % chance to duplicate hearts
                if PST:getTreeSnapshotMod("crimConvBuff", "") == "abundanceVitality" then
                    local tmpChance = charData.crimsonStarcores
                    if pickup.Timeout > 0 then
                        tmpChance = tmpChance * 2
                    end
                    if not isShop and variant == PickupVariant.PICKUP_HEART and 100 * math.random() < tmpChance then
                        local newPickup = Isaac.Spawn(pickup.Type, variant, subtype, pickup.Position, 2 * RandomVector(), nil)
                        PST:getEntData(newPickup).PST_duped = true
                    end
                end
            end

            -- Mod: % chance to duplicate dropped coins/keys/bombs
            tmpMod = PST:getTreeSnapshotMod("pickupDupe", 0)
            if tmpMod > 0 and firstSpawn and not isShop and (variant == PickupVariant.PICKUP_COIN or variant == PickupVariant.PICKUP_KEY or
            variant == PickupVariant.PICKUP_BOMB) and not PST:isGoldenPickup(pickup) and 100 * math.random() < tmpMod then
                local newPickup = Isaac.Spawn(pickup.Type, variant, subtype, pickup.Position, 2 * RandomVector(), nil)
                PST:getEntData(newPickup).PST_duped = true
            end

            -- Mod: % chance to convert dropped sacks into a special variant
            tmpMod = PST:getTreeSnapshotMod("specialSacks", 0)
            if tmpMod > 0 and firstSpawn and variant == PickupVariant.PICKUP_GRAB_BAG and subtype == SackSubType.SACK_NORMAL and
            100 * math.random() < tmpMod then
                local newBag = PST.specialSacks[math.random(#PST.specialSacks)]
                pickup:Morph(pickup.Type, pickup.Variant, newBag, true)
            end
        end
    end
end

---@param pickup EntityPickup
function PST:onPickupUpdate(pickup)
    -- Init pickup
    if pickup.FrameCount == 1 then
        local room = PST:getRoom()
        local pickupData = PST:getEntData(pickup)
        local isFirstSpawn = not pickupData.PST_init and not pickupData.PST_duped and (room:IsFirstVisit() or room:GetFrameCount() > 1)
        PST:onPickupInit(pickup, isFirstSpawn)
        pickupData.PST_init = true
    end

    if pickup.Timeout > 0 then
        -- Mod: +time for temporary heart pickups
        if pickup.Variant == PickupVariant.PICKUP_HEART then
            local tempFirstSpawn = not PST.specialNodes.temporaryHearts[pickup.InitSeed]
            local tmpMod = PST:getTreeSnapshotMod("temporaryHeartTime", 0)
            if tmpMod > 0 and tempFirstSpawn then
                pickup.Timeout = pickup.Timeout + math.floor(tmpMod * 30)
                PST.specialNodes.temporaryHearts[pickup.InitSeed] = true
            end
        -- Mod: +time for temporary coin pickups
        elseif pickup.Variant == PickupVariant.PICKUP_COIN then
            local tempFirstSpawn = not PST.specialNodes.temporaryCoins[pickup.InitSeed]
            local tmpMod = PST:getTreeSnapshotMod("vanishCoinTimer", 0)
            if tmpMod > 0 and tempFirstSpawn then
                pickup.Timeout = pickup.Timeout + math.floor(tmpMod * 30)
                PST.specialNodes.temporaryCoins[pickup.InitSeed] = true
            end
        end

        -- Re-closing chests
        local pickupData = PST:getEntData(pickup)
        if pickupData.PST_recloseProc then
            if pickup.Timeout == 1 then
                local newChest = Isaac.Spawn(pickup.Type, pickup.Variant, 0, pickup.Position, Vector.Zero, nil)
                PST:getEntData(newChest).PST_recloseTotal = pickupData.PST_recloseTotal
                pickup:Remove()
            end
        end
    else
        -- Ancient starcursed jewel: Embered Azurite
        if PST:SC_getSnapshotMod("emberedAzurite", false) and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and not
        PST:arrHasValue(PST.progressionItems, pickup.SubType) then
            -- Embered Azurite was deliberately avoiding active item pedestals... but why? Remove this check for now
            --local itemCfg = Isaac.GetItemConfig():GetCollectible(pickup.SubType)
            --if itemCfg and itemCfg.Type ~= ItemType.ITEM_ACTIVE then
                local emberAzuriteItems = PST:getTreeSnapshotMod("SC_emberAzuriteItems", nil)
                if emberAzuriteItems and not PST:arrHasValue(emberAzuriteItems, pickup.InitSeed) then
                    local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET)
                    if newItem ~= CollectibleType.COLLECTIBLE_NULL then
                        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true, true, true)
                        table.insert(emberAzuriteItems, pickup.InitSeed)

                        local newBlueItem = Game():GetItemPool():GetCollectibleFromList(PST.blueItemPool)
                        if newBlueItem ~= CollectibleType.COLLECTIBLE_BREAKFAST then
                            ---@diagnostic disable-next-line: undefined-field
                            pickup:RemoveCollectibleCycle()
                            pickup:AddCollectibleCycle(newBlueItem)
                        end
                    end
                end
            --end
        end

        -- Chests
        if PST:isPickupChest(pickup.Variant) then
            local pickupSpr = pickup:GetSprite()
            -- Opened chest
            if pickupSpr:GetAnimation() == "Open" and pickupSpr:GetFrame() == 1 then
                PST_expedOpenChest(pickup)

                -- Mod: % chance for chests to re-close after opening, up to twice per room
                local tmpMod = PST:getTreeSnapshotMod("chestReclose", 0)
                local pickupData = PST:getEntData(pickup)
                local rTotal = pickupData.PST_recloseTotal
                if tmpMod > 0 and (not rTotal or (rTotal and rTotal < 2)) and
                100 * math.random() < tmpMod then
                    pickupData.PST_recloseProc = true
                    if not rTotal then
                        pickupData.PST_recloseTotal = 0
                    end
                    pickupData.PST_recloseTotal = pickupData.PST_recloseTotal + 1
                    pickup.Timeout = 60
                end

                -- Heartblessed chests
                local heartblessedList = PST:getTreeSnapshotMod("heartblessedList", {})
                if PST:arrHasValue(heartblessedList, pickup.InitSeed) then
                    -- Drop extra hearts
                    local heartTypes = {HeartSubType.HEART_SOUL, HeartSubType.HEART_BLACK}
                    local maxHearts = math.random(2)
                    for _=1,maxHearts do
                        local heartSub = heartTypes[math.random(#heartTypes)]
                        if math.random() < 0.7 then
                            heartSub = HeartSubType.HEART_FULL
                            if math.random() < 0.3 then
                                heartSub = HeartSubType.HEART_HALF
                            end
                        end
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, heartSub, pickup.Position, 3 * RandomVector(), nil)

                        for i, tmpID in ipairs(heartblessedList) do
                            if tmpID == pickup.InitSeed then
                                table.remove(heartblessedList, i)
                                break
                            end
                        end
                    end

                    -- Mod: +% speed for the current floor when opening a heartblessed chest
                    tmpMod = PST:getTreeSnapshotMod("heartblessedSpeed", 0)
                    if tmpMod > 0 and PST:getTreeSnapshotMod("heartblessedSpeedBuff", 0) < 12 then
                        PST:addModifiers({ speedPerc = tmpMod, heartblessedSpeedBuff = tmpMod }, true)
                    end
                end
            end
        end

        -- Arcane Obols
        if PST:getTreeSnapshotMod("obolMagnetism", false) then
            for i, _ in ipairs(PST.expedObolDropValues) do
                local tmpName = "Arcane Obols " .. tostring(i)
                if pickup.SubType == Isaac.GetTrinketIdByName(tmpName) or pickup.SubType == Isaac.GetTrinketIdByName(tmpName) | TrinketType.TRINKET_GOLDEN_FLAG then
                    local tmpMove = (PST:getPlayer().Position - pickup.Position):Normalized() * 1.5
                    pickup.Position = pickup.Position + tmpMove
                    break
                end
            end
        end
    end
end

local baubleseekerProc = false
---@param player EntityPlayer
---@param type TrinketType
---@param firstTime boolean
function PST:onTrinketAdd(player, type, firstTime)
    -- Demonic Souvenirs node (Azazel's tree)
    if PST:getTreeSnapshotMod("demonicSouvenirs", false) and PST:arrHasValue(PST.evilTrinkets, type) then
        PST:addModifiers({ damagePerc = 6, tearsPerc = 6 }, true)
    end

    -- Mod: +luck while holding an evil trinket
    if PST:getTreeSnapshotMod("evilTrinketLuck", 0) > 0 then
        PST:addModifiers({ luck = PST:getTreeSnapshotMod("evilTrinketLuck", 0) }, true)
    end

    -- Mod: +- luck when first obtaining any trinket
    if firstTime then
        local tmpBonus = PST:getTreeSnapshotMod("trinketRandLuck", 0)
        if tmpBonus ~= 0 then
            PST:addModifiers({ luck = (-tmpBonus / 2) + tmpBonus * 2 * math.random() }, true)
        end
    end

    -- Ancient starcursed jewel: Baubleseeker
    if PST:SC_getSnapshotMod("baubleseeker", false) then
        if not baubleseekerProc then
            baubleseekerProc = true
            player:TryRemoveTrinket(type)
            local wasAdded = player:AddSmeltedTrinket(type, firstTime)
            if wasAdded then
                local tmpMod = PST:getTreeSnapshotMod("SC_baubleSeekerBuff", 0)
                if tmpMod < 15 then
                    PST:addModifiers({ allstatsPerc = 1, SC_baubleSeekerBuff = 1 }, true)
                end
            end
        else
            baubleseekerProc = false
        end
    end

    PST:updateCacheDelayed()
end
function PST:onTrinketRemove(player, type)
    -- Demonic Souvenirs node (Azazel's tree)
    if PST:getTreeSnapshotMod("demonicSouvenirs", false) and PST:arrHasValue(PST.evilTrinkets, type) then
        PST:addModifiers({ damagePerc = -6, tearsPerc = -6 }, true)
    end

    -- Mod: +luck while holding an evil trinket
    if PST:getTreeSnapshotMod("evilTrinketLuck", 0) > 0 then
        PST:addModifiers({ luck = -PST:getTreeSnapshotMod("evilTrinketLuck", 0) }, true)
    end

    -- Uber expedition entropy mod
    if PST:getTreeSnapshotMod("expedEnt_trinketSwap", false) and not PST:arrHasValue(PST.expedEntropyTrinketBlacklist, type) then
        PST:expedAddEntropy(
            PST:getTreeSnapshotMod("expedDepth", 1),
            PST.expedEntropyMods.expedEnt_trinketSwap.entropy
        )
    end

    PST:updateCacheDelayed()
end

function PST:onPickupVoided(pickup, isBlackRune)
    -- Collectible voided
    if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE and pickup.SubType ~= 0 then
        -- Black rune consumes collectible
        if isBlackRune then
            -- Mod: chance for items consumed by Black Rune to be obtained as innate items
            local tmpMod = PST:getTreeSnapshotMod("blackRuneAbsorb", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                if PST.modData.treeModSnapshot.blackRuneInnateItems then
                    table.insert(PST.modData.treeModSnapshot.blackRuneInnateItems, pickup.SubType)
                end
            end

        -- Void consumes collectible
        else
            -- Consuming Void node (T. Isaac node)
            if PST:getTreeSnapshotMod("consumingVoid", false) then
                PST:addModifiers({ consumingVoidBuff = { value = 20, set = true } }, true)
                PST:updateCacheDelayed(PST.allstatsCache)
            end

            -- Mod: +luck when consuming an item with Void
            local tmpMod = PST:getTreeSnapshotMod("voidConsumeLuck", 0)
            if tmpMod > 0 then
                PST:addModifiers({ luck = tmpMod }, true)
            end
        end
    end
end

---@param pickup EntityPickup
function PST:onPickupRender(pickup)
    -- Heartblessed chests FX
    if PST:isPickupChest(pickup.Variant) and PST:arrHasValue(PST:getTreeSnapshotMod("heartblessedList", {}), pickup.InitSeed) and
    (pickup:GetSprite():GetAnimation() == "Appear" or pickup:GetSprite():GetAnimation() == "Idle") then
        PST.specialFX.heartbless:Render(PST:getRoom():WorldToScreenPosition(pickup.Position + Vector(0, -16)))
    end
end