local clotHeartTypes = {
    HeartSubType.HEART_HALF,
    HeartSubType.HEART_HALF_SOUL,
    HeartSubType.HEART_BLACK,
    HeartSubType.HEART_ETERNAL,
    HeartSubType.HEART_GOLDEN,
    HeartSubType.HEART_BONE,
    HeartSubType.HEART_ROTTEN
}

-- On entity death
---@param entity Entity
function PST:onDeath(entity)
    -- Player death
    if entity.Type == EntityType.ENTITY_PLAYER then
        local player = entity:ToPlayer()
        if player then
            -- Lazarus death
            if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS then
                local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
                cosmicRCache.lazarusHasDied = true
                PST:save()
            end

            -- Soulful Awakening node (Lazarus' tree)
            if PST:getTreeSnapshotMod("soulfulAwakening", false) then
                local tmpPos = Isaac.GetFreeNearPosition(player.Position, 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, tmpPos, Vector.Zero, nil, HeartSubType.HEART_SOUL, Random() + 1)
                PST:addModifiers({ luck = -0.5 }, true)
            end

            -- Growing Contrition node (Lazarus' tree)
            if PST:getTreeSnapshotMod("growingContrition", false) and PST:getTreeSnapshotMod("growingContritionProcs", 0) < 3 then
                PST:addModifiers({ growingContritionProcs = 1 }, true)
                if PST:getTreeSnapshotMod("growingContritionProcs", false) == 3 then
                    player:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
                    PST:createFloatTextFX(PST:getLocalized("ftxt_growingContrition"), Vector.Zero, Color(0.85, 0.35, 0.35, 1), 0.12, 100, true)
                end
            end

            -- Dark Apotheosis node (Judas' tree)
            if PST:getTreeSnapshotMod("darkApotheosisProc", false) then
                PST:addModifiers({ darkApotheosisProc = false }, true)
            end
        end
    elseif entity:IsActiveEnemy(true) and entity.Type ~= EntityType.ENTITY_BLOOD_PUPPY and not EntityRef(entity).IsFriendly and
    PST:getRoom():GetFrameCount() > 1 then
        -- Enemy death
        local room = PST:getRoom()
        local tmpNPC = entity:ToNPC()
        local NPCisBoss = tmpNPC and tmpNPC:IsBoss()
        local NPCisChamp = tmpNPC and tmpNPC:IsChampion()

        local isFrozen = entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN)

        local addXP = false
        if not (NPCisBoss and entity.Parent) or entity.Type == EntityType.ENTITY_LARRYJR then
            if entity.SpawnerType ~= 0 then
                local bonusKills = 0
                if PST:SC_getSnapshotMod("unusuallySmallStarstone", false) then
                    bonusKills = 30
                end
                if PST.modData.spawnKills < 12 + bonusKills then
                    PST.modData.spawnKills = PST.modData.spawnKills + 1
                    addXP = true
                end
            else
                addXP = true
            end
        end

        if addXP and not PST:getTreeSnapshotMod("d7Proc", false) and not PST:getTreeSnapshotMod("deathTrialActive", false) then
            local mult = 1
            -- Reduce xp for certain bosses
            if entity.Type == EntityType.ENTITY_PEEP then
                mult = 0.33
            end

            if tmpNPC then
                if NPCisBoss then
                    mult = mult + PST:getTreeSnapshotMod("xpgainBoss", 0) / 100
                    local roomType = room:GetType()
                    if not roomType == RoomType.ROOM_MINIBOSS and not roomType == RoomType.ROOM_BOSS then
                        mult = mult - 0.6
                    end
                else
                    mult = mult + PST:getTreeSnapshotMod("xpgainNormalMob", 0) / 100
                end

                if NPCisChamp then
                    mult = mult + PST:getTreeSnapshotMod("championXP", 0) / 100
                end
            end

            -- Max 8% xp from frozen enemies
            if isFrozen and mult > 0.08 then mult = 0.08 end

            -- Sidereal Artifact condition: kill monsters (count only xp granting mobs)
            if PST:getTreeSnapshotMod("bloodSeptentrion", false) and not isFrozen then
                PST:sideArtiAddEnergy(PST.sideArtiData.bloodSeptentrion.energy)
            end
            -- Sidereal Artifact objective/condition: kill monsters affected by any status effect
            if PST:entityHasAnyStatus(entity) then
                PST:sideArtiObjProgress("taintbloodSeptentrion", 1)
                if PST:getTreeSnapshotMod("taintbloodSeptentrion", false) then
                    PST:sideArtiAddEnergy(PST.sideArtiData.taintbloodSeptentrion.energy)
                end
            end
            -- Sidereal Artifact objective/condition: destroy frozen monsters
            if isFrozen then
                PST:sideArtiObjProgress("icySeptentrion", 1)
                if PST:getTreeSnapshotMod("icySeptentrion", false) then
                    PST:sideArtiAddEnergy(PST.sideArtiData.icySeptentrion.energy)
                end
            end
            if tmpNPC then
                -- Sidereal Artifact objective: kill monsters that have at least 10 HP
                if tmpNPC.MaxHitPoints >= 10 and not isFrozen then
                    PST:sideArtiObjProgress("assassinSeptentrion", 1)

                    -- Sidereal Artifact objective: kill undead monsters with at least 10 HP
                    if PST:isMobUndead(tmpNPC) then
                        PST:sideArtiObjProgress("deathseekerSeptentrion", 1)
                    end
                end
                -- Sidereal Artifact objective/condition: kill champion monsters
                if NPCisChamp and not isFrozen then
                    PST:sideArtiObjProgress("slayerSeptentrion", 1)
                    if PST:getTreeSnapshotMod("slayerSeptentrion", false) then
                        PST:sideArtiAddEnergy(PST.sideArtiData.slayerSeptentrion.energy)
                    end
                end
            end
            -- Sidereal Artifact objective: kill slowed monsters
            if entity:GetSlowingCountdown() > 0 then
                PST:sideArtiObjProgress("glacialMeridion", 1)
            end
            -- Sidereal Artifact objective: kill petrified monsters
            if entity:GetFreezeCountdown() > 0 then
                PST:sideArtiObjProgress("stoneMeridion", 1)
            end
            -- Sidereal Artifact objective: kill burning monsters
            if entity:GetBurnCountdown() > 0 then
                PST:sideArtiObjProgress("infernalMeridion", 1)
            end
            -- Sidereal Artifact objective: kill Bonys or its variants
            if (entity.Type == EntityType.ENTITY_BONY or entity.Type == EntityType.ENTITY_BLACK_BONY or entity.Type == EntityType.ENTITY_REVENANT) and
            not isFrozen then
                PST:sideArtiObjProgress("osseousMeridion", 1)
            end

            -- Sidereal Artifact: Infernal Meridion
            if PST:getTreeSnapshotMod("arti_infernalProc", false) and entity:GetBurnCountdown() > 0 then
                Isaac.Explode(entity.Position, PST:getPlayer(), 20)
            end
            -- Sidereal Artifact: Gilded Meridion
            if PST.specialNodes.arti_gildedTimer > 0 then
                local newCoin = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DOUBLEPACK, entity.Position, 3 * RandomVector(), nil)
                newCoin:ToPickup().Timeout = 90
            end

            PST:addTempXP(math.max(1, math.floor(mult * entity.MaxHitPoints / 2)), true)
        end

        local isFinalBoss = PST:entityIsFinalBoss(entity)

        -- Regular final boss kill
        if isFinalBoss then
            PST:addModifiers({ finalBossKills = 1 }, true)
            -- Sidereal Artifact objective: defeat a final boss without taking damage more than once
            if PST:getTreeSnapshotMod("roomHitsReceived", 0) <= 1 then
                PST:sideArtiObjProgress("titanseekerSeptentrion", 1)
            end
            -- Sidereal Artifact objective: defeat 2 final bosses within the same run
            if not PST:isSideArtiUnlocked("executionerMeridion") then
                if PST:getTreeSnapshotMod("finalBossKills", 0) == 2 then
                    PST:sideArtiObjProgress("executionerMeridion", 1)
                end
            end

            -- Mod: % chance to gain a global SP when defeating a final boss without taking damage
            local tmpMod = PST:getTreeSnapshotMod("finalBossGSP", 0)
            if tmpMod > 0 and not PST:getTreeSnapshotMod("roomGotHitByMob", false) and 100 * math.random() < tmpMod then
                PST.modData.skillPoints = PST.modData.skillPoints + 1
                PST:createFloatTextFX("+1 " .. PST:getLocalized("ui_globalSP"), Vector.Zero, Color(0.1, 0.4, 1, 1), 0.13, 100, true)
            end

            -- Uber expedition mods
            if PST:getTreeSnapshotMod("isExpedUber", false) then
                -- Bring The Chaos node (Deep-Space tree)
                local expData = PST:getExpedData(PST:getTreeSnapshotMod("expedDepth", 0), true)
                if expData and expData.modifiers and expData.modifiers.bringTheChaos and expData.entropy and expData.entropy >= 200 and
                math.random() < 0.2 then
                    PST:addCurrentCharCrimsonStarcores(1)
                    PST:createFloatTextFX("+1 " .. PST:getLocalized("ui_crimsonCore"), Vector.Zero, Color(1, 0.3, 0.3, 1), 0.1, 150, true)
                end
            end
        end

        -- Expedition/sidereal univ
        if PST:isRunSidereal() then
            -- Expedition objective: defeat monsters
            PST:expedAddProgInRun("defeatMonsters", 1)
            -- Expedition order modifier: defeat monsters
            PST:expedAddOrderProgInRun("expedOrd_defeatMonsters", 1)

            -- Expedition objective: defeat Hush
            if entity:GetType() == EntityType.ENTITY_HUSH then
                PST:expedAddProgInRun("hush", 1)

                -- Expedition objective: defeat hush without getting hit more than twice
                if PST:getTreeSnapshotMod("roomHitsReceived", 0) <= 2 then
                    PST:expedAddProgInRun("hushNoDmgTwice", 1)
                end

                -- Expedition objective: defeat hush without getting hit more than once
                if PST:getTreeSnapshotMod("roomHitsReceived", 0) <= 1 then
                    PST:expedAddProgInRun("hushNoDmgOnce", 1)
                end

                -- Expedition order objective: defeat hush without getting hit more than 3 times
                if PST:getTreeSnapshotMod("roomHitsReceived", 0) <= 3 then
                    PST:expedAddOrderProgInRun("expedOrd_hush", 1)
                end
            end

            -- Expedition final boss kill
            if isFinalBoss then
                -- Expedition objective: defeat any final boss
                PST:expedAddProgInRun("finalBoss", 1)
            end

            -- Expedition objective: defeat Delirium or The Beast without taking damage more than once
            if (entity:GetType() == EntityType.ENTITY_DELIRIUM or entity:GetType() == EntityType.ENTITY_BEAST) and
            PST:getTreeSnapshotMod("roomHitsReceived", 0) <= 1 then
                PST:expedAddProgInRun("beastDeliNoDmg", 1)
            end

            -- Final boss kill
            if isFinalBoss then
                -- Ancient Stardust drop
                if PST:isNodeNameAllocated("sidereal", "Astral Forge") then
                    local tmpAmt = 1
                    if 100 * math.random() < PST:getTreeSnapshotMod("bossExtraAncientStardust", 0) then
                        tmpAmt = tmpAmt + 1
                    end
                    PST.modData.ancientStardust = PST.modData.ancientStardust + tmpAmt
                    PST:createFloatTextFX("+" .. tmpAmt .. " " .. PST:getLocalized("ui_ancStardust"), Vector.Zero, PST:RGBColor(255, 172, 28), 0.13, 120, true)
                    SFXManager():Play(SoundEffect.SOUND_POWERUP2, 0.25, 2, false, 1.5)
                end
            end
        end

        -- Room kills
        PST:addModifiers({ roomKills = 1 }, true)

        -- Angel kills
        if not PST:getTreeSnapshotMod("killedAngels", false) and (entity.Type == EntityType.ENTITY_GABRIEL or entity.Type == EntityType.ENTITY_URIEL) then
            PST:addModifiers({ killedAngels = true }, true)
        end

        if tmpNPC then
            -- Champion kill
            if NPCisChamp then
                -- Expedition objective: defeat champions
                PST:expedAddProgInRun("defeatChampions", 1)
                -- Expedition order objective: defeat champions
                PST:expedAddOrderProgInRun("expedOrd_defeatChampions", 1)

                -- Obols on champion kill
                if PST:getTreeSnapshotMod("isExpedRun", false) then
                    local tmpObols = PST.obolEvents.championKill(PST:getTreeSnapshotMod("expedDepth", 1))
                    if tmpObols > 0 then PST:expedDropObolsAt(entity.Position, tmpObols) end
                end

                -- Boon: +% damage for the current floor when killing a champion monster
                local tmpMod = PST:getTreeSnapshotMod("boonChampSlayDmg", 0)
                if tmpMod > 0 then
                    local tmpAdd = math.min(tmpMod, PST:getTreeSnapshotMod("boonChampSlayMax", 0) - PST:getTreeSnapshotMod("boonChampSlayBuff", 0))
                    if tmpAdd > 0 then
                        PST:addModifiers({ damagePerc = tmpAdd, boonChampSlayBuff = tmpAdd }, true)
                    end
                end

                -- Mod: % chance for champion monsters to drop a regular chest on death
                tmpMod = PST:getTreeSnapshotMod("championChest", 0)
                local maxChests = 1 + PST:getTreeSnapshotMod("championMaxChests", 0)
                if tmpMod > 0 and 100 * math.random() < tmpMod and PST:getTreeSnapshotMod("championChestDrops", 0) < maxChests then
                    local chestType = PickupVariant.PICKUP_CHEST
                    -- Mod: % chance for the regular chest dropped by champions to be a stone chest instead
                    if 100 * math.random() < PST:getTreeSnapshotMod("championStoneChest", 0) then
                        chestType = PickupVariant.PICKUP_BOMBCHEST
                    end
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, chestType, ChestSubType.CHEST_CLOSED, entity.Position, Vector.Zero, nil)
                    PST:addModifiers({ championChestDrops = 1 }, true)
                end

                -- Mod: % chance to gain Eve's Mascara for the current room when killing champion monsters
                tmpMod = PST:getTreeSnapshotMod("eveMascaraChamp", 0)
                if tmpMod > 0 and not PST:getTreeSnapshotMod("eveMascaraChampProc", false) and 100 * math.random() < tmpMod then
                    PST:getPlayer():AddCollectible(CollectibleType.COLLECTIBLE_EVES_MASCARA)
                    PST:addModifiers({ eveMascaraChampProc = true }, true)
                end
            end

            -- Boss kill
            if NPCisBoss then
                -- Boss kill counters
                PST:addModifiers({ roomBossKills = 1 }, true)

                -- Segment boss check
                if PST:arrHasValue(PST.segmentBosses, entity.Type) then
                    table.insert(PST.segmentBossKillProcs, {
                        killFrame = Game():GetFrameCount(),
                        bossType = entity.Type,
                        bossVariant = entity.Variant,
                        bossSub = entity.SubType
                    })
                else
                    -- Sidereal Artifact objective: kill 15 bosses within the same run
                    if not PST:isSideArtiUnlocked("beastseekerSeptentrion") then
                        PST:addModifiers({ artiObj_runBossKills = 1 }, true)
                        if PST:getTreeSnapshotMod("artiObj_runBossKills", 0) == 15 then
                            PST:sideArtiObjProgress("beastseekerSeptentrion", 1)
                        end
                    end
                end

                -- Sidereal run
                if PST:isRunSidereal() then
                    -- Expedition objective: defeat bosses
                    if not PST:arrHasValue(PST.segmentBosses, entity.Type) then
                        PST:expedAddProgInRun("defeatBosses", 1)
                    end

                    -- Proc up to 5 times within this room, or always on final bosses
                    if PST:getTreeSnapshotMod("roomBossKills", 0) <= 5 or isFinalBoss then
                        -- Obols on boss kill
                        local tmpObols = PST.obolEvents.bossKill(PST:getTreeSnapshotMod("expedDepth", 1))
                        if tmpObols > 0 then
                            PST:expedDropObolsAt(entity.Position, tmpObols)
                            PST:addModifiers({ bossObolDrops = 1 }, true)
                        end
                    end

                    -- Proc up to 5 times within this room
                    if PST:getTreeSnapshotMod("roomBossKills", 0) <= 5 then
                        -- Chance for Sparkling Stardust
                        if PST:isNodeNameAllocated("sidereal", "Astral Forge") then
                            local sparkStardustChance = 15 + PST:getLevel():GetStage() + PST:getTreeSnapshotMod("bossSparkStardust", 0)
                            -- Reduce chance for multi-segment bosses
                            if PST:arrHasValue(PST.segmentBosses, entity.Type) then
                                sparkStardustChance = sparkStardustChance / 12
                            end
                            if 100 * math.random() < sparkStardustChance then
                                PST.modData.sparkStardust = PST.modData.sparkStardust + 1
                                PST:createFloatTextFX("+1 " .. PST:getLocalized("ui_sparkStardust"), Vector.Zero, Color(0.7, 0.7, 1, 1), 0.13, 120, true)
                                SFXManager():Play(SoundEffect.SOUND_POWERUP3, 0.25, 2, false, 1.5)
                            end
                        end
                    end
                end

                -- Chance for bosses to drop Astral Weapons on death, up to 4 per room
                if PST:isNodeNameAllocated("sidereal", "Astral Forge") then
                    local tmpMod = PST:getTreeSnapshotMod("astralWepBossRate", 0) + PST.astralWepBossBaseRate * math.min(1, PST:getLevel():GetStage() / 9)
                    -- Reduce chance for multi-segment bosses
                    if PST:arrHasValue(PST.segmentBosses, entity.Type) then
                        tmpMod = tmpMod / 4
                    end
                    -- Reduce chance for deadly sin minibosses
                    if PST:arrHasValue(PST.deadlySinBosses, entity.Type) then
                        tmpMod = tmpMod / 4
                    end
                    while tmpMod > 0 and PST:getTreeSnapshotMod("astralWepBossRoomDrops", 0) < 4 do
                        if 100 * math.random() < tmpMod then
                            PST:dropRandAstralWepAt(entity.Position, PST:getTreeSnapshotMod("astralWepTierDrops", 1), true, RandomVector() * 3 * math.random())
                            PST:addModifiers({ astralWepBossRoomDrops = 1 }, true)
                        end
                        tmpMod = tmpMod - 100
                    end
                end

                -- Ancient weapon mod: Beastbane
                tmpMod = PST:getSnapAstralWepMod("beastbane")
                if tmpMod and PST:getTreeSnapshotMod("ancwep_beastbaneFloors", 0) == 0 then
                    PST:addModifiers({ damagePerc = tmpMod[2], ancwep_beastbaneFloors = 2 }, true)
                end

                -- Mod: % chance for deadly sin minibosses to drop a key on death (double chance for super)
                tmpMod = PST:getTreeSnapshotMod("deadlySinKey", 0)
                if entity.SubType == 1 then
                    tmpMod = tmpMod * 2
                end
                if entity.Type == EntityType.ENTITY_ENVY then
                    tmpMod = tmpMod / 8
                end
                if tmpMod > 0 and PST:arrHasValue(PST.deadlySinBosses, entity.Type) and 100 * math.random() < tmpMod then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, entity.Position, RandomVector() * 3, nil)
                end
                -- Mod: % chance for deadly sin minibosses to drop a lil battery on death (double chance for super)
                tmpMod = PST:getTreeSnapshotMod("deadlySinBattery", 0)
                if entity.SubType == 1 then
                    tmpMod = tmpMod * 2
                end
                if entity.Type == EntityType.ENTITY_ENVY then
                    tmpMod = tmpMod / 8
                end
                if tmpMod > 0 and PST:arrHasValue(PST.deadlySinBosses, entity.Type) and 100 * math.random() < tmpMod then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL, entity.Position, RandomVector() * 3, nil)
                end

                -- A True Ending? node (Lazarus' tree)
                if PST:getTreeSnapshotMod("aTrueEnding", false) and room:GetType() == RoomType.ROOM_BOSS and ((PST:isFirstOrigStage()) or (entity.Type == EntityType.ENTITY_MOM) or
                (entity.Type == EntityType.ENTITY_MOMS_HEART)) and not PST:getTreeSnapshotMod("aTrueEndingProc", false) then
                    -- Drop Suicide King card when defeating first boss, mom, or mom's heart
                    local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                    Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_SUICIDE_KING, Random() + 1)
                    PST:addModifiers({ aTrueEndingProc = true }, true)
                end
            end

            -- Chance for champions to drop a random starcursed jewel
            local levelStage = PST:getLevel():GetStage()
            if NPCisChamp and 100 * math.random() < PST.SCDropRates.championKill(levelStage).regular then
                PST:SC_dropRandomJewelAt(entity.Position, PST.SCDropRates.championKill(levelStage).ancient)
            end

            -- Mod: % chance for monsters with at least X HP to drop a black heart on death based on luck
            local tmpMod = PST:getTreeSnapshotMod("blackHeartLuckDrop", 0)
            local tmpThreshold = 50
            if PST:getPlayer().Luck >= 5 then
                tmpThreshold = 30
            end
            if tmpMod > 0 and tmpNPC.MaxHitPoints >= tmpThreshold and PST:getTreeSnapshotMod("blackHeartLuckProcs", 0) < 3 and
            100 * math.random() < ((PST:getPlayer().Luck / 0.5) * tmpMod) then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, tmpNPC.Position, 2 * RandomVector(), nil)
                PST:addModifiers({ blackHeartLuckProcs = 1 }, true)
            end
        end

        -- Starcursed mod: spawn X static hovering tears for Y seconds on death
        local tmpMod = PST:SC_getSnapshotMod("hoveringTearsOnDeath", {0, 0})
        if tmpMod[1] > 0 and tmpMod[2] > 0 then
            local proc = true
            if isFrozen then
                proc = PST:distBetweenPoints(entity.Position, PST:getPlayer().Position) > 60
            end
            if proc then
                for _=1,tmpMod[1] do
                    local newTear = Game():Spawn(
                        EntityType.ENTITY_PROJECTILE,
                        ProjectileVariant.PROJECTILE_TEAR,
                        entity.Position + Vector(-6 + 12 * math.random(), -6 + 12 * math.random()),
                        Vector.Zero,
                        entity,
                        TearVariant.BLOOD,
                        Random() + 1
                    )
                    newTear.Color = Color(1, 0.1, 0.1, 1)
                    newTear:SetPauseTime(math.max(10, 30 * tmpMod[2] - 30))
                    table.insert(PST.specialNodes.SC_hoveringTears, newTear)
                end
            end
        end
        -- Starcursed mod: X chance to release Y tears on death
        tmpMod = PST:SC_getSnapshotMod("tearExplosionOnDeath", {0, 0})
        if tmpMod[1] > 0 and tmpMod[2] > 0 and 100 * math.random() < tmpMod[1] then
            local newTear = Game():Spawn(
                EntityType.ENTITY_TEAR,
                TearVariant.BALLOON,
                entity.Position,
                Vector.Zero,
                entity,
                0,
                Random() + 1
            );
            SFXManager():Play(SoundEffect.SOUND_HEARTOUT, 0.9)
            newTear:ToTear():AddTearFlags(TearFlags.TEAR_PIERCING | TearFlags.TEAR_GROW)
            newTear:ToTear().FallingSpeed = -25
            newTear:ToTear().FallingAcceleration = 0.75
            table.insert(PST.specialNodes.SC_exploderTears, newTear.InitSeed)
        end
        -- Ancient starcursed jewel: Soul Watcher
        if PST:SC_getSnapshotMod("soulWatcher", false) then
            for i, tmpSoulEater in ipairs(PST.specialNodes.SC_soulEaterMobs) do
                if not EntityRef(tmpSoulEater.mob).IsFriendly then
                    if tmpSoulEater.mob.InitSeed == entity.InitSeed then
                        PST.specialNodes.SC_soulEaterMobs[i] = nil
                    elseif tmpSoulEater.souls < 20 then
                        local dist = PST:distBetweenPoints(tmpSoulEater.mob.Position, entity.Position)
                        if dist <= 140 then
                            tmpSoulEater.souls = tmpSoulEater.souls + 1
                            Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, tmpSoulEater.mob.Position, Vector.Zero, nil, 1, Random() + 1)
                            SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 0.3)

                            local HPBoost = 4 + tmpSoulEater.mob.MaxHitPoints * 0.04
                            tmpSoulEater.mob.MaxHitPoints = tmpSoulEater.mob.MaxHitPoints + HPBoost
                            tmpSoulEater.mob.HitPoints = math.min(tmpSoulEater.mob.MaxHitPoints, tmpSoulEater.mob.HitPoints + HPBoost)
                            if not tmpSoulEater.mob:IsBoss() or (tmpSoulEater.mob:IsBoss() and tmpSoulEater.souls < 6) then
                                tmpSoulEater.mob.Scale = tmpSoulEater.mob.Scale + 0.02
                            end
                            tmpSoulEater.mob:SetSpeedMultiplier(tmpSoulEater.mob:GetSpeedMultiplier() + tmpSoulEater.souls * 0.02)
                        end
                    end
                end
            end
        end
        -- Ancient starcursed jewel: Glace
        if PST:SC_getSnapshotMod("glace", false) then
            if isFrozen and PST:getTreeSnapshotMod("SC_glaceDebuff", 0) > 0 then
                PST:addModifiers({ speedPerc = 0.5, tearsPerc = 0.5, SC_glaceDebuff = -0.5 }, true)
            end
        end
        -- Ancient starcursed jewel: Nullstone
        if PST:SC_getSnapshotMod("nullstone", false) then
            -- Add enemy from non-boss room to nullstone list
            if tmpNPC and not PST:getTreeSnapshotMod("SC_nullstoneProc", false) and not PST:getTreeSnapshotMod("SC_nullstoneClear", false) and
            not NPCisBoss and room:GetType() ~= RoomType.ROOM_BOSS and
            ((not entity.Parent and entity.MaxHitPoints >= PST:getTreeSnapshotMod("SC_nullstoneHPThreshold", 0)) or room:GetAliveEnemiesCount() == 1) then
                local nullstoneEnemyList = PST:getTreeSnapshotMod("SC_nullstoneEnemies", nil)
                if nullstoneEnemyList then
                    table.insert(nullstoneEnemyList, {
                        type = entity.Type,
                        variant = entity.Variant,
                        subtype = entity.SubType,
                        champion = tmpNPC:GetChampionColorIdx()
                    })
                    PST:addModifiers({ SC_nullstoneProc = true }, true)
                    SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.7, 2, false, 1.08)

                    PST.specialNodes.SC_nullstonePoofFX.x = entity.Position.X
                    PST.specialNodes.SC_nullstonePoofFX.y = entity.Position.Y
                    PST.specialNodes.SC_nullstonePoofFX.sprite:Play("Poof", true)
                    PST.specialNodes.SC_nullstonePoofFX.stoneSprite.Color = Color()
                end
            -- Spawn next enemy in sequence if killing nullified enemy in boss room
            elseif not PST:getTreeSnapshotMod("SC_nullstoneClear", false) and room:GetType() == RoomType.ROOM_BOSS
            and room:GetAliveBossesCount() > 0 then
                local nullstoneList = PST:getTreeSnapshotMod("SC_nullstoneEnemies", nil)
                local currentSpawn = PST.specialNodes.SC_nullstoneCurrentSpawn
                if currentSpawn and currentSpawn.InitSeed == entity.InitSeed and nullstoneList and
                nullstoneList[PST.specialNodes.SC_nullstoneSpawned] ~= nil then
                    local spawnEntry = nullstoneList[PST.specialNodes.SC_nullstoneSpawned]
                    local tmpPos = Isaac.GetFreeNearPosition(entity.Position, 8)
                    local newSpawn = Game():Spawn(spawnEntry.type, spawnEntry.variant, tmpPos, Vector.Zero, nil, spawnEntry.subtype, Random() + 1)
                    if spawnEntry.champion >= 0 then
                        newSpawn:ToNPC():MakeChampion(newSpawn.InitSeed, spawnEntry.champion, true)
                    end
                    newSpawn.Color = Color(0.1, 0.1, 0.1, 1, 0.1, 0.1, 0.1)
                    PST.specialNodes.SC_nullstoneCurrentSpawn = newSpawn
                    PST.specialNodes.SC_nullstoneSpawned = PST.specialNodes.SC_nullstoneSpawned + 1

                    PST.specialNodes.SC_nullstonePoofFX.x = entity.Position.X
                    PST.specialNodes.SC_nullstonePoofFX.y = entity.Position.Y
                    PST.specialNodes.SC_nullstonePoofFX.stoneSprite.Color = Color()
                end
            end
        end
        -- Ancient starcursed jewel: Cause Converter
        local tmpAncient = PST:SC_getSocketedAncient("Cause Converter")
        if tmpAncient and tmpAncient.status == "seeking" and NPCisBoss and not PST:arrHasValue(PST.causeConverterBossBlacklist, entity.Type) and
        (tmpAncient.converted ~= entity.Type or tmpAncient.converted == entity.Type and tmpAncient.convertedVariant ~= entity.Variant) then
            tmpAncient.converted = entity.Type
            tmpAncient.convertedVariant = entity.Variant
            SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT, 0.9)
            PST:createFloatTextFX(PST:getLocalized("ftxt_bossConv"), entity.Position, Color(0.7, 0.85, 1, 1), 0.12, 120, false)
        end
        -- Ancient starcursed jewel: Mightstone
        if PST:SC_getSnapshotMod("mightstone", false) and tmpNPC and NPCisChamp then
            local foundMobs = false
            for _, tmpEntity in ipairs(Isaac.GetRoomEntities()) do
                otherNPC = tmpEntity:ToNPC()
                if otherNPC and not EntityRef(otherNPC).IsFriendly and otherNPC.InitSeed ~= entity.InitSeed and otherNPC:IsChampion() and
                PST:getTreeSnapshotMod("SC_mightstoneProcs", 0) < 5 then
                    local tmpPoof = Game():Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, otherNPC.Position, Vector.Zero, nil, 0, Random() + 1)
                    tmpPoof:GetSprite().Scale = Vector(1.4, 1.4)

                    local HPBoost = otherNPC.MaxHitPoints * 0.1
                    otherNPC.MaxHitPoints = otherNPC.MaxHitPoints + HPBoost
                    otherNPC.HitPoints = otherNPC.HitPoints + HPBoost * 3

                    if not otherNPC:IsBoss() then
                        otherNPC.Scale = otherNPC.Scale + 0.05
                    end
                    otherNPC:SetSpeedMultiplier(otherNPC:GetSpeedMultiplier() + (PST:getTreeSnapshotMod("SC_mightstoneProcs", 0) + 1) * 0.05)
                    foundMobs = true
                end
            end
            if foundMobs then
                SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 0.6, 2, false, 0.7)
            end
            PST:addModifiers({ SC_mightstoneProcs = 1 }, true)
        end
        -- Ancient starcursed jewel: Phantasm Prism
        if PST:SC_getSnapshotMod("phantasmPrism", false) and tmpNPC and not isFrozen and not PST:isMobUndead(tmpNPC) and entity.SpawnerType == 0 and
        not NPCisBoss and PST:getTreeSnapshotMod("SC_phantasmProcs", 0) < 12 and 100 * math.random() < PST:getTreeSnapshotMod("SC_phantasmChance", 0) then
            local npcConfig = EntityConfig.GetEntity(tmpNPC.Type, tmpNPC.Variant, tmpNPC.SubType)
            if npcConfig then
                local undeadMobTable = PST:getTreeSnapshotMod("SC_phantasmUndeadMobs", nil)
                if undeadMobTable then
                    local tmpCandidates = {}
                    local npcHP = npcConfig:GetBaseHP()
                    local hpRange = 4 + PST:getLevel():GetStage() * 3
                    if PST:getLevel():GetStage() >= 9 then
                        hpRange = 100
                    end
                    for _, tmpMob in ipairs(undeadMobTable) do
                        if math.abs(tmpMob[3] - npcHP) <= hpRange then
                            table.insert(tmpCandidates, {tmpMob[1], tmpMob[2]})
                        end
                    end
                    if #tmpCandidates > 0 then
                        local newMob = tmpCandidates[math.random(#tmpCandidates)]
                        Isaac.Spawn(newMob[1], newMob[2], 0, tmpNPC.Position, Vector.Zero, nil)
                        local tmpPos = tmpNPC.Position
                        if tmpNPC:IsFlying() then
                            tmpPos = Isaac.GetFreeNearPosition(tmpNPC.Position, 20)
                        end
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tmpPos, Vector.Zero, nil)
                        PST:addModifiers({ SC_phantasmProcs = 1 }, true)
                    end
                end
            end
        end
        -- Ancient starcursed jewel: Arachnite
        if tmpNPC and not isFrozen and tmpNPC.Type ~= EntityType.ENTITY_SWARM_SPIDER and PST:SC_getSnapshotMod("arachnite", false) and PST:getTreeSnapshotMod("SC_arachniteProcs", 0) < 12 then
            local tmpChance = math.min(90, 40 + 8 * PST:getLevel():GetStage())
            if 100 * math.random() < tmpChance then
                local minSpiders = 1 + math.floor(PST:getLevel():GetStage() / 4)
                local maxSpiders = math.max(minSpiders, math.random(5))
                for _=minSpiders,maxSpiders do
                    local tmpSpider = Isaac.Spawn(EntityType.ENTITY_SWARM_SPIDER, 0, 0, tmpNPC.Position, RandomVector() * 2, nil)
                    tmpSpider.Color = Color(1, 1, 1, 1, 0.6, 0.6, 0.6)
                end
                PST:addModifiers({ SC_arachniteProcs = 1 }, true)
            end
        end

        -- Samson temp mods
        if PST:getTreeSnapshotMod("samsonTempDamage", 0) > 0 or PST:getTreeSnapshotMod("samsonTempSpeed", 0) > 0 then
            if not PST:getTreeSnapshotMod("samsonTempActive", false) then
                PST:addModifiers({
                    damagePerc = PST:getTreeSnapshotMod("samsonTempDamage", 0),
                    speedPerc = PST:getTreeSnapshotMod("samsonTempSpeed", 0),
                    samsonTempActive = true,
                    samsonTempTime = { value = os.clock(), set = true }
                }, true)
            else
                PST:addModifiers({ samsonTempTime = { value = os.clock(), set = true } }, true)
            end
        end

        -- Mom death procs
        if entity.Type == EntityType.ENTITY_MOM and not PST.specialNodes.momDeathProc then
            PST.specialNodes.momDeathProc = true

            -- Mod: chance for Mom to drop Plan C when defeated
            if 100 * math.random() < PST:getTreeSnapshotMod("momPlanC", 0) then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_PLAN_C, Random() + 1)
            end

            -- Daemon Army node (Lilith's tree)
            if PST:getTreeSnapshotMod("daemonArmy", false) and not PST:getTreeSnapshotMod("runGotHit", false) then
                -- Mom drops an additional Incubus
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_INCUBUS, Random() + 1)
            end

            -- Harbinger Locusts node (Apollyon's tree)
			if PST:getTreeSnapshotMod("harbingerLocusts", false) then
				local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
				local tmpLocust = PST.locustTrinketsNonGold[math.random(#PST.locustTrinketsNonGold)]
				Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, tmpPos, Vector.Zero, nil, tmpLocust, Random() + 1)
			end

            -- Mod: chance for mom to additionally drop Birthright
            tmpMod = PST:getTreeSnapshotMod("jacobBirthright", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_BIRTHRIGHT, Random() + 1)
                PST:addModifiers({ jacobBirthrightProc = true }, true)
            end

            -- Helping Hands node (T. Lost's tree)
            if PST:getTreeSnapshotMod("helpingHands", false) and not PST:getTreeSnapshotMod("helpingHandsMomProc", false) and
            PST:getPlayer():GetCard(0) ~= Card.CARD_HOLY and PST:getPlayer():GetCard(1) ~= Card.CARD_HOLY then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, tmpPos, Vector.Zero, nil, Card.CARD_HOLY, Random() + 1)
                PST:addModifiers({ helpingHandsMomProc = true }, true)
            end

            -- Otherside Seeker node (T. Bethany's tree)
            if PST:getTreeSnapshotMod("othersideSeeker", false) and not PST:getTreeSnapshotMod("roomGotHitByMob", false) then
                PST:getPlayer():AddSmeltedTrinket(TrinketType.TRINKET_CRYSTAL_KEY)
            end
        -- Mom's Heart death procs
        elseif entity.Type == EntityType.ENTITY_MOMS_HEART and not PST.specialNodes.momHeartDeathProc then
            PST.specialNodes.momDeathProc = true

            -- Mod: chance for Mom's Heart to additionally drop Birthright (if Mom didn't previously drop it)
            if not PST:getTreeSnapshotMod("jacobBirthrightProc", false) and 100 * math.random() < PST:getTreeSnapshotMod("jacobBirthright", 0) / 2 then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, tmpPos, Vector.Zero, nil, CollectibleType.COLLECTIBLE_BIRTHRIGHT, Random() + 1)
                PST:addModifiers({ jacobBirthrightProc = true }, true)
            end
        -- Greed death procs
        elseif entity.Type == EntityType.ENTITY_GREED then
            -- Mod: chance for Greed to drop an additional nickel
            if 100 * math.random() < PST:getTreeSnapshotMod("greedNickelDrop", 0) then
                local tmpPos = Isaac.GetFreeNearPosition(entity.Position, 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_NICKEL, Random() + 1)
            end

            -- Mod: chance for Greed to drop an additional dime
            if 100 * math.random() < PST:getTreeSnapshotMod("greedDimeDrop", 0) then
                local tmpPos = Isaac.GetFreeNearPosition(entity.Position, 40)
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpPos, Vector.Zero, nil, CoinSubType.COIN_DIME, Random() + 1)
            end
        end

        -- Harbinger Locusts node (Apollyon's tree)
        if PST:getTreeSnapshotMod("harbingerLocusts", false) then
            -- 2% chance for champion monsters to drop a random locust trinket on kill, once per floor
            if not PST:getTreeSnapshotMod("harbingerLocustsChampDrop", false) and 100 * math.random() < 2 then
                local newLocust = PST.locustTrinketsNonGold[math.random(#PST.locustTrinketsNonGold)]
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, entity.Position, Vector.Zero, nil, newLocust, Random() + 1)
                PST:addModifiers({ harbingerLocustsChampDrop = true }, true)
            end
        end

        -- Killed charmed enemy
        if EntityRef(entity).IsCharmed then
            local tmpPlayer = PST:getPlayer()

            -- Dark Songstress node
            if PST:getTreeSnapshotMod("darkSongstress", false) and not PST:getTreeSnapshotMod("darkSongstressActive", false) then
                local tmpSlot = tmpPlayer:GetActiveItemSlot(Isaac.GetItemIdByName("Siren Song"))
				if tmpSlot ~= -1 and 100 * math.random() < 8 then
                    tmpPlayer:AddActiveCharge(1, tmpSlot, true, false, false)
				end
            end

            -- Song of Darkness node (Siren's tree) [Harmonic modifier]
            if PST:getTreeSnapshotMod("songOfDarkness", false) and PST:getTreeSnapshotMod("songOfDarknessChance", 2) < 6 and PST:songNodesAllocated(true) <= 2 then
                PST:addModifiers({ songOfDarknessChance = 0.4 }, true)
            end

            local luckBonus = 0
            -- Song of Fortune node (Siren's tree) [Harmonic modifier]
            if PST:getTreeSnapshotMod("songOfFortune", false) and PST:songNodesAllocated(true) <= 2 then
                if tmpPlayer.Luck < 4 and 100 * math.random() < 50 then
                    luckBonus = luckBonus + 0.01
                elseif tmpPlayer.Luck > 4 and 100 * math.random() < 25 then
                    luckBonus = -1
                end
            end

            -- Mod: chance for charmed enemies to grant an additional 0.01 luck on kill
            if 100 * math.random() < PST:getTreeSnapshotMod("luckOnCharmedKill", 0) then
                luckBonus = luckBonus + 0.01
            end

            -- Mod: chance for charmed enemies to explode in a cloud of pheromones on death, dealing 4 damage and charming nearby enemies
            if 100 * math.random() < PST:getTreeSnapshotMod("charmExplosions", 0) then
                Game():CharmFart(entity.Position, 80, tmpPlayer)
                for _, tmpEntity in ipairs(Isaac.FindInRadius(entity.Position, 80, EntityPartition.ENEMY)) do
                    if tmpEntity:IsVulnerableEnemy() then
                        tmpEntity:TakeDamage(4, 0, EntityRef(tmpPlayer), 0)
                    end
                end
            end

            if luckBonus > 0 then
                PST:addModifiers({ luck = luckBonus }, true)
            end
        end

        -- Killed bleeding enemy
        if entity:GetBleedingCountdown() > 0 then
            -- Ancient weapon mod: Redbeak
            tmpMod = PST:getSnapAstralWepMod("redbeak")
            if tmpMod and PST:getPlayer():GetHearts() > 0 and PST:getPlayer():GetHearts() / PST:getPlayer():GetEffectiveMaxHearts() <= 0.5 and
            100 * math.random() < tmpMod[3] then
                local tmpHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, RandomVector() * 3, nil)
                tmpHeart:ToPickup().Timeout = 60
            end
        end

        -- Killed paralyzed enemy
        if entity:GetFreezeCountdown() > 0 then
            -- Ancient weapon mod: Viper Stinger
            tmpMod = PST:getSnapAstralWepMod("viperStinger")
            if tmpMod then
                PST:createAnimFXAt("gfx/1000.034_fart.anm2", "Explode", entity.Position)
                SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.6, 2, false, 1.5)

                local tmpDmg = PST:getPlayer().Damage * (tmpMod[2] / 100)
                local nearbyEnem = Isaac.FindInRadius(entity.Position, 100, EntityPartition.ENEMY)
                for _, tmpEnemy in ipairs(nearbyEnem) do
                    tmpEnemy:TakeDamage(tmpDmg, 0, EntityRef(PST:getPlayer()), 0)
                    tmpEnemy:AddPoison(EntityRef(PST:getPlayer()), 120, PST:getPlayer().Damage)
                end
            end
        end

        -- Killed enemy with any status effect
        if PST:entityHasAnyStatus(entity) then
            -- Ancient weapon mod: Chaotic Tumult
            tmpMod = PST:getSnapAstralWepMod("chaoticTumult")
            if tmpMod and PST.specialNodes.ancwep_chaosTumultDmgStacks < tmpMod[2] then
                PST.specialNodes.ancwep_chaosTumultDmgStacks = PST.specialNodes.ancwep_chaosTumultDmgStacks + 1
                PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
            end
        end

        -- Ascetic Soul node (T. Blue Baby's tree)
        if PST:getTreeSnapshotMod("asceticSoul", false) and PST:getTreeSnapshotMod("asceticSoulDrops", 0) < 5 and PST:getPlayer():GetPoopMana() >= 8 and
        100 * math.random() < 7 then
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, entity.Position, Vector.Zero, nil, HeartSubType.HEART_HALF_SOUL, Random() + 1)
            PST:addModifiers({ asceticSoulDrops = 1 }, true)
        end

        -- Mystic Vampirism node (T. Eve's tree)
        if PST:getTreeSnapshotMod("mysticVampirism", false) then
            PST:addModifiers({ mysticVampirismKills = 1 }, true)
            if PST:getTreeSnapshotMod("mysticVampirismKills", 0) >= 13 then
                if PST:getTreeSnapshotMod("mysticVampirismProcs", 0) < 8 and 100 * math.random() < 20 then
                    local clotList = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 0)
                    if #clotList > 0 then
                        local tmpClot = clotList[math.random(#clotList)]
                        local newClot = 1
                        if math.random() < 0.4 then
                            newClot = 1 + math.random(5)
                        end
                        local newClotEnt = Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, tmpClot.Position, Vector.Zero, PST:getPlayer(), newClot, Random() + 1)
                        newClotEnt:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                        tmpClot:Remove()
                        PST:addModifiers({ mysticVampirismProcs = 1 }, true)
                    end
                end
                PST:addModifiers({ mysticVampirismKills = { value = 0, set = true } }, true)
            end
        end

        -- Mod: chance to spawn a black clot while T. Eve's whore of babylon effect is active
        tmpMod = PST:getTreeSnapshotMod("blackClotBabylon", 0)
        if tmpMod > 0 then
            local hasBabylon = false
            local plEffects = PST:getPlayer():GetEffects():GetEffectsList()
            if plEffects.Size > 0 then
                for i=0,plEffects.Size-1 do
                    local tmpEffect = plEffects:Get(i).Item
                    if tmpEffect.ID == 110 then
                        hasBabylon = true
                        break
                    end
                end
            end
            if hasBabylon and 100 * math.random() < tmpMod then
                local existingClots = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 2)
                if #existingClots < 3 then
                    local newClot = Game():Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, PST:getPlayer().Position, Vector.Zero, PST:getPlayer(), 2, Random() + 1)
                    newClot:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                end
            end
        end

        -- Mod: chance for enemies to drop a 1/2 red heart when killed while berserk, which vanishes after 2 seconds
        tmpMod = PST:getTreeSnapshotMod("berserkKillTempHeart", 0)
        if tmpMod > 0 and PST:isBerserk() and 100 * math.random() < tmpMod then
            local tmpHeart = Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, entity.Position, RandomVector() * 3, nil, HeartSubType.HEART_HALF, Random() + 1):ToPickup()
            tmpHeart.Timeout = 60
        end

        -- Brimstone mark kill
        ---@diagnostic disable-next-line: undefined-field
        if tmpNPC and tmpNPC:GetBrimstoneMarkCountdown() > 0 then
            -- Gilded Regrowth node (T. Azazel's tree)
            if PST:getTreeSnapshotMod("gildedRegrowth", false) then
                if PST:getTreeSnapshotMod("gildedRegrowthKills", 0) < 5 then
                    PST:addModifiers({ gildedRegrowthKills = 1 }, true)
                    if PST:getTreeSnapshotMod("gildedRegrowthKills", 0) == 5 and not PST:getPlayer():IsFlying() then
                        PST:getPlayer():GetEffects():AddTrinketEffect(TrinketType.TRINKET_BAT_WING)
                        PST:getPlayer():AddCostume(Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT))
                    end
                end
            end

            -- Dark Bestowal node
            if PST:getTreeSnapshotMod("darkBestowal", false) then
                local bestowalItem = PST:getTreeSnapshotMod("darkBestowalItem", 0)
                local bestowalKillReq = 20
                if bestowalItem == 0 and PST:getTreeSnapshotMod("darkBestowalKills", 0) < bestowalKillReq then
                    PST:addModifiers({ darkBestowalKills = 1 }, true)
                    if PST:getTreeSnapshotMod("darkBestowalKills", 0) == bestowalKillReq then
                        local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL)
                        local failSafe = 0
                        if newItem > 0 then
                            while Isaac.GetItemConfig():GetCollectible(newItem).Type ~= ItemType.ITEM_PASSIVE and not PST:getPlayer():HasCollectible(newItem) and failSafe < 200 do
                                newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL)
                                if newItem <= 0 then break end
                                failSafe = failSafe + 1
                            end
                            if newItem > 0 and Isaac.GetItemConfig():GetCollectible(newItem).Type == ItemType.ITEM_PASSIVE and not PST:getPlayer():HasCollectible(newItem) then
                                PST:getPlayer():AddCollectible(newItem)
                                PST:addModifiers({ darkBestowalItem = newItem, darkBestowalKills = { value = 0, set = true } }, true)
                                SFXManager():Play(SoundEffect.SOUND_DEATH_CARD, 0.9, 2, false, 1.15)
                                PST:createFloatTextFX(PST:getLocalized("ftxt_darkBestowal"), Vector.Zero, PST:RGBColor(112, 41, 99), 0.12, 90, true)
                            end
                        end
                    end
                end
            end

            -- Mod: % chance to gain +0.01 tears for the current floor when killing cursed enemies, up to +1
            tmpMod = PST:getTreeSnapshotMod("cursedKillTears", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("cursedKillTearsBuff", 0) < 1 and 100 * math.random() < tmpMod then
                PST:addModifiers({ tears = 0.01, cursedKillTearsBuff = 0.01 }, true)
            end
        end

        -- Mod: % chance for champions to drop a Holy Card on kill, once every 2 floors
        tmpMod = PST:getTreeSnapshotMod("champHolyCardDrop", 0)
        if tmpMod > 0 and tmpNPC and NPCisChamp and PST:getTreeSnapshotMod("champHolyCardDropFloors", 0) == 0 and 100 * math.random() < tmpMod then
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, entity.Position, Vector.Zero, nil, Card.CARD_HOLY, Random() + 1)
            PST:addModifiers({ champHolyCardDropFloors = { value = 2, set = true } }, true)
        end

        -- Mod: % chance to gain +luck when killing enemies within 1.5 tiles of you
        tmpMod = PST:getTreeSnapshotMod("nearbyKillLuck", 0)
        if tmpMod > 0 and tmpNPC and PST:distBetweenPoints(PST:getPlayer().Position, tmpNPC.Position) <= 60 and 100 * math.random() < tmpMod then
            PST:addModifiers({ luck = 0.03, nearbyKillLuckBuff = 0.03 }, true)
        end

        -- Gilded monster kill (T. Keeper's tree)
        if tmpNPC and (tmpNPC:GetSprite():GetRenderFlags() & AnimRenderFlags.GOLDEN) > 0 then
            -- Mod: % chance for gilded monsters to drop an additional non-vanishing penny
            tmpMod = PST:getTreeSnapshotMod("gildMonsterPenny", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, tmpNPC.Position, Vector.Zero, nil, CoinSubType.COIN_PENNY, Random() + 1)
            end

            -- Mod: % chance to gain +0.05 luck for the current floor when killing a gilded monster
            tmpMod = PST:getTreeSnapshotMod("gildMonsterLuck", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                PST:addModifiers({ luck = 0.05, gildMonsterLuckBuff = 0.05 }, true)
            end

            -- Mod: +% speed for the current room when killing a gilded monster
            tmpMod = PST:getTreeSnapshotMod("gildMonsterSpeed", 0)
            if tmpMod > 0 then
                PST:addModifiers({ speedPerc = tmpMod, gildMonsterSpeedBuff = tmpMod }, true)
            end

            -- Mod: % chance to upgrade a held trinket penny to its golden version when killing a gilded monster
            tmpMod = PST:getTreeSnapshotMod("gildMonsterPennyUpgrade", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local tmpPlayer = PST:getPlayer()
                for i=1,0,-1 do
                    local tmpTrinket = tmpPlayer:GetTrinket(i)
                    if PST:arrHasValue(PST.pennyTrinkets, tmpTrinket) then
                        tmpPlayer:TryRemoveTrinket(tmpTrinket)
                        tmpPlayer:AddTrinket(tmpTrinket | TrinketType.TRINKET_GOLDEN_FLAG)
                        SFXManager():Play(SoundEffect.SOUND_GOLD_HEART, 1, 2, false, 1.15)
                        PST:createFloatTextFX(PST:getLocalized("ftxt_gildedPennyTrinket"), Vector.Zero, Color(1, 1, 0.5, 1), 0.12, 90, true)
                        break
                    end
                end
            end
        end

        -- Blood Harvest node (T. Bethany's tree)
        if PST:getTreeSnapshotMod("bloodHarvest", false) and PST:getTreeSnapshotMod("bloodHarvestDrops", 0) < 6 and entity.MaxHitPoints >= 12 then
            local tmpChance = 25 - math.max(0, 0.3 * (PST:getPlayer():GetEffectiveBloodCharge() - 30))
            if 100 * math.random() < tmpChance then
                local tmpHeart = Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, entity.Position, RandomVector() * 3, nil, HeartSubType.HEART_HALF, Random() + 1):ToPickup()
                tmpHeart.Timeout = 90
                PST:addModifiers({ bloodHarvestDrops = 1 }, true)
            end
        end

        -- Mod: % chance to gain +luck when killing enemies while you have 1 soul/black heart or less, doubled against bosses
        tmpMod = PST:getTreeSnapshotMod("tBethKillLuck", 0)
        if NPCisBoss then
            tmpMod = tmpMod * 3
        end
        if tmpMod > 0 and PST:getPlayer():GetSoulHearts() <= 2 and 100 * math.random() < tmpMod then
            local tmpLuck = 0.03
            if NPCisBoss then
                tmpLuck = 0.1
            end
            PST:addModifiers({ luck = tmpLuck }, true)
        end

        -- Grand Consonance node (T. Siren's tree)
        if PST:getTreeSnapshotMod("grandConsonance", false) then
            local tmpPlayer = PST:getPlayer()
            -- Leech: 5% chance on kill to gain half a red heart. If this triggers but your health is full and you have less than 3 black hearts, 25% chance to gain a 1/2 black heart instead
            -- Increase both chances by 4% per additional leech
            local tmpLeeches = tmpPlayer:GetCollectibleNum(CollectibleType.COLLECTIBLE_LEECH)
            if tmpLeeches > 0 and 100 * math.random() < 5 then
                if tmpPlayer:GetHearts() < tmpPlayer:GetMaxHearts() then
                    tmpPlayer:AddHearts(1)
                    SFXManager():Play(SoundEffect.SOUND_VAMP_GULP)
                elseif PST:GetBlackHeartCount(tmpPlayer) < 6 and 100 * math.random() < 25 then
                    tmpPlayer:AddBlackHearts(1)
                    SFXManager():Play(SoundEffect.SOUND_VAMP_GULP, 0.9, 2, false, 0.85)
                end
            end
        end

        -- Feared mob kill
        if entity:GetFearCountdown() > 0 then
            -- Mod: % chance for feared enemies to release 3-4 homing tears on death that cause fear
            tmpMod = PST:getTreeSnapshotMod("fearedTearBurst", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local totalTears = math.random(3, 4)
                for _=1,totalTears do
                    local newTear = Game():Spawn(EntityType.ENTITY_TEAR, TearVariant.DARK_MATTER, entity.Position, RandomVector() * 6, PST:getPlayer(), 0, Random() + 1)
                    newTear:ToTear():AddTearFlags(TearFlags.TEAR_HOMING | TearFlags.TEAR_FEAR)
                    newTear:ToTear().FallingSpeed = -1
                    newTear.CollisionDamage = math.min(20, math.max(3, entity.MaxHitPoints * 0.04))
                    newTear.Color = PST:RGBColor(120, 30, 182)
                end
            end

            -- Mod: % chance to receive 1/2 a black heart when killing a feared enemy if you have less than 3 black hearts, up to twice per room
            tmpMod = PST:getTreeSnapshotMod("blackHeartFearKill", 0)
            if tmpMod > 0 and PST:GetBlackHeartCount(PST:getPlayer()) < 6 and PST:getTreeSnapshotMod("blackHeartFearKillGiven", 0) < 2 and
            100 * math.random() < tmpMod then
                PST:getPlayer():AddBlackHearts(1)
                PST:addModifiers({ blackHeartFearKillGiven = 1 }, true)
            end

            -- Mod: % chance to gain +0.02 luck when killing a feared enemy, up to a total +3
            tmpMod = PST:getTreeSnapshotMod("fearedKillLuck", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("fearedKillLuckBuff", 0) < 3 and 100 * math.random() < tmpMod then
                PST:addModifiers({ luck = 0.02, fearedKillLuckBuff = 0.02 }, true)
            end
        end

        -- Cosmic Realignment node
        if PST:cosmicRCharPicked(PlayerType.PLAYER_SAMSON_B) then
            local cosmicRCache = PST:getTreeSnapshotMod("cosmicRCache", PST.treeMods.cosmicRCache)
            local tmpPlayer = PST:getPlayer()
            -- Tainted Samson, +2% all stats when killing a monster, up to 10%
            if cosmicRCache.TSamsonBuffer < 10 then
                cosmicRCache.TSamsonBuffer = cosmicRCache.TSamsonBuffer + 2
                tmpPlayer:AddCacheFlags(PST.allstatsCache, true)
            end
        elseif PST:cosmicRCharPicked(PlayerType.PLAYER_THEFORGOTTEN_B) then
            -- Tainted Forgotten, bosses drop an additional soul heart
            if NPCisBoss then
                local isBone = 100 * math.random() < 50
                Game():Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_HEART,
                    entity.Position,
                    Vector.Zero,
                    nil,
                    isBone and HeartSubType.HEART_BONE or HeartSubType.HEART_SOUL,
                    Random() + 1
                )
            end
        end
    else
        -- Familiar death
        if entity.Type == EntityType.ENTITY_FAMILIAR then
            local tmpFamiliar = entity:ToFamiliar()
            if tmpFamiliar then
                -- Blood clot death
                if tmpFamiliar.Variant == FamiliarVariant.BLOOD_BABY then
                    -- Mod: chance for blood clots to drop their respective heart type on death, which vanishes after 2.5 seconds
                    local tmpMod = PST:getTreeSnapshotMod("clotHeartDrop", 0)
                    local clotType = tmpFamiliar.SubType + 1
                    if tmpMod > 0 and clotHeartTypes[clotType] ~= nil and 100 * math.random() < tmpMod then
                        local tmpHeart = Game():Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_HEART,
                            tmpFamiliar.Position,
                            RandomVector() * 3,
                            nil,
                            clotHeartTypes[clotType],
                            Random() + 1
                        ):ToPickup()
                        tmpHeart.Timeout = 90
                    end

                    -- Mod: chance to gain luck when a blood clot is destroyed
                    tmpMod = PST:getTreeSnapshotMod("clotDestroyedLuck", 0)
                    if tmpMod > 0 and 100 * math.random() < tmpMod then
                        PST:addModifiers({ luck = 0.03 }, true)
                    end
                -- Wisp death
                elseif tmpFamiliar.Variant == FamiliarVariant.WISP then
                    -- Chaotic Wisps node (Bethany's tree)
                    if PST:getTreeSnapshotMod("chaoticWisps", false) then
                        local chaoticWispsInit = PST:getTreeSnapshotMod("chaoticWispsInit", {})
                        for i, tmpID in ipairs(chaoticWispsInit) do
                            if tmpID == tmpFamiliar.InitSeed then
                                table.remove(chaoticWispsInit, i)
                                break
                            end
                        end
                    end

                    -- Mod: % tears per active wisp
                    if PST:getTreeSnapshotMod("soulWispTears", 0) > 0 then
                        PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
                    end
                end
            end
        end
    end
end