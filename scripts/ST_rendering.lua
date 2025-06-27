local floatingTexts = {}
local floatTextDelayDefault = 22
local floatTextDelay = 0
local floatTextQueue = {}

function PST:resetFloatingTexts()
	floatingTexts = {}
	floatTextQueue = {}
end

local miniFont = Font()
miniFont:Load("font/cjk/lanapixel.fnt")

local luaminiFont = Font()
luaminiFont:Load("font/luaminioutlined.fnt")

local tempestasFont = Font()
tempestasFont:Load("font/pftempestasevencondensed.fnt")

-- Create a floating fading text
---@param text string -- Text to display
---@param position Vector -- Text position
---@param color Color -- Text color
---@param speed number -- How quickly the text rises up in pixels per frame
---@param totalSteps number -- How many frames the text lasts. Used for fading effect
---@param playerRelative boolean -- Whether the text should stick to the player. If true, the position vector becomes relative to the player
function PST:createFloatTextFX(text, position, color, speed, totalSteps, playerRelative)
	if not PST.config.floatingTexts or not Isaac.IsInGame() then return end

	local tmpText = {
		text = text,
		position = position,
		color = color,
		startAlpha = color.A,
		speed = speed,
		totalSteps = totalSteps,
		playerRelative = playerRelative,
		step = 0
	}
    if floatTextDelay == 0 then
	    table.insert(floatingTexts, tmpText)
        floatTextDelay = floatTextDelayDefault
    else
        table.insert(floatTextQueue, tmpText)
    end
end

local floatingIcons = {}
local floatIconDelay = 0
local floatIconQueue = {}

-- Create a floating fading icon (sprite)
function PST:createFloatIconFX(sprite, position, speed, totalSteps, playerRelative, noDelay)
	if not PST.config.floatingTexts then return end

	local tmpIcon = {
		sprite = sprite,
		position = position,
		speed = speed,
		totalSteps = totalSteps,
		playerRelative = playerRelative,
		step = 0
	}
	if floatIconDelay == 0 or noDelay then
		table.insert(floatingIcons, tmpIcon)
		floatIconDelay = floatTextDelayDefault
	else
		table.insert(floatIconQueue, tmpIcon)
	end
end

-- XP bar setup
local barWidth = 256
local xpbarSprite = Sprite("gfx/ui/skilltrees/xp_bar.anm2", true)
local xpbarFullSprite = Sprite("gfx/ui/skilltrees/xp_bar.anm2", true)
local xpbarTempSprite = Sprite("gfx/ui/skilltrees/xp_bar.anm2", true)
xpbarSprite.Color.A = 0.7
xpbarFullSprite.Color.A = 0.7
xpbarTempSprite.Color.A = 0.7
xpbarSprite:Play("BarEmpty", true)
xpbarFullSprite:Play("BarFull", true)
xpbarTempSprite:Play("BarTemp", true)

local xpbeamSprite = Sprite("gfx/ui/skilltrees/xp_bar.anm2", true)
xpbeamSprite.Color.A = 0.7

local chroniclerUISprite = Sprite("gfx/items/starcursed_jewels.anm2", true)
chroniclerUISprite:Play("Chronicler UI", true)

local expedUISprite = Sprite("gfx/ui/skilltrees/nodes/expedition_nodes.anm2", true)

local animFXList = {}
-- Spawn an animated effect using the given anm2 path. Returns the new sprite object in case further manipulation is needed
---@param FXSpritePath string
---@param spriteAnim string
---@param position Vector
---@param frameFuncs? table -- e.g. {[5] = function() print("Frame 5 reached") end}
function PST:createAnimFXAt(FXSpritePath, spriteAnim, position, frameFuncs)
	local newSprite = Sprite(FXSpritePath, true)
	newSprite:Play(spriteAnim, true)
	table.insert(animFXList, {
		sprite = newSprite,
		pos = position,
		frameFuncs = frameFuncs
	})
	return newSprite
end

function PST:clearAnimFXList()
	animFXList = {}
end

-- Rendering function
function PST:Render()
	-- Support for Epiphany's character menu
	if Epiphany and Epiphany.character_menu_visible then
		local charIndex = Epiphany.current_door % Epiphany.num_doors
		local selCharType = Epiphany.table_aside_type_id[charIndex]
		local epCharName = Epiphany.table_name[selCharType]
		if epCharName and epCharName ~= "NOT_MADE" and PST.charNames[1 + selCharType] == nil then
			-- Initialize tarnished character
			local charConfig = EntityConfig.GetPlayer(selCharType)
			if charConfig then
				-- Account for zero-width character at the beginning of tarnished char name
				local tmpCharName = "Tr. " .. string.sub(charConfig:GetName(), 4)
				PST:initUnknownChar(tmpCharName, false, 1 + selCharType)
			end
		end
	end

	-- Input: Open tree menu (in-game)
	if Isaac.IsInGame() then
		if PST:isKeybindActive(PSTKeybind.OPEN_TREE) or (not PST.treeScreen.open and PST:IsActionTriggered(ButtonAction.ACTION_ITEM, 1)) then
			if not PST.treeScreen.open then
				PST:openTreeMenu()
			else
				PST:closeTreeMenu()
			end
		end
	end

	local player = PST:getPlayer()
	local screenRatioX = Isaac.GetScreenWidth() / 480
	local screenRatioY = Isaac.GetScreenHeight() / 270

	local room = PST:getRoom()
	--local gamePaused = Game():IsPaused()

	-- XP bar
	local hudVisible = Game():GetHUD():IsVisible()
	if PST.config.drawXPbar and hudVisible then
		local charData = PST:getCurrentCharData()
		if charData then
			local tmpScale = PST.config.xpbarScale or 1
			local barPos = Vector(112 * screenRatioX * (1 + (1 - tmpScale)), Isaac.GetScreenHeight() - 12)
			local barPerc = math.min(1, charData.xp / math.max(1, charData.xpRequired))
			local barPercGlobal = math.min(1, PST.modData.xp / math.max(1, PST.modData.xpRequired))
			local barScale = Vector(screenRatioX, math.min(1, screenRatioY)) * tmpScale

			if not PST.config.xpbarStyle or PST.config.xpbarStyle == 1 then
				xpbarTempSprite.Scale = barScale
				xpbarFullSprite.Scale = barScale
				xpbarSprite.Scale = barScale
				xpbarSprite:Render(barPos)
			end

			-- Temp xp
			if PST.modData.xpObtained > 0 then
				if not PST.config.xpbarStyle or PST.config.xpbarStyle == 1 then
					-- Character temp xp bar
					local tempBarPercent = math.min(1, (charData.xp + PST.modData.xpObtained) / math.max(1, charData.xpRequired))
					xpbarTempSprite:Render(barPos, Vector(barWidth * tempBarPercent, 8), Vector(barWidth, 16))

					-- Global temp xp bar
					tempBarPercent = math.min(1, (PST.modData.xp + PST.modData.xpObtained) / math.max(1, PST.modData.xpRequired))
					xpbarTempSprite:Render(barPos, Vector(barWidth * tempBarPercent, 16), Vector(barWidth, 8))
				elseif PST.config.xpbarStyle == 2 or PST.config.xpbarStyle == 3 then
					-- Beam style
					local beamY = Isaac.GetScreenHeight() - 2
					if PST.config.xpbarStyle == 3 then
						beamY = 2
					end
					-- Character temp xp bar
					local tempBarPercent = math.min(1, (charData.xp + PST.modData.xpObtained) / math.max(1, charData.xpRequired))
					xpbeamSprite:SetFrame("Beams", 2)
					local linkBeam = Beam(xpbeamSprite, 1, false, false)
					local startPos = Vector(0, beamY)
					local endPos = Vector(Isaac.GetScreenWidth() * tempBarPercent, beamY)
					linkBeam:Add(startPos, 0)
					linkBeam:Add(endPos, 256)
					linkBeam:Render()

					beamY = Isaac.GetScreenHeight() - 1
					if PST.config.xpbarStyle == 3 then
						beamY = 1
					end
					-- Global temp xp bar
					tempBarPercent = math.min(1, (PST.modData.xp + PST.modData.xpObtained) / math.max(1, PST.modData.xpRequired))
					startPos = Vector(0, beamY)
					endPos = Vector(Isaac.GetScreenWidth() * tempBarPercent, beamY)
					linkBeam:Add(startPos, 0)
					linkBeam:Add(endPos, 256)
					linkBeam:Render()
				end
			end

			-- Character xp
			if charData.xp > 0 then
				if not PST.config.xpbarStyle or PST.config.xpbarStyle == 1 then
					xpbarFullSprite:Render(barPos, Vector(barWidth * barPerc, 8), Vector(barWidth, 16))
				elseif PST.config.xpbarStyle == 2 or PST.config.xpbarStyle == 3 then
					local beamY = Isaac.GetScreenHeight() - 1
					if PST.config.xpbarStyle == 3 then
						beamY = 1
					end
					-- Beam style
					xpbeamSprite:SetFrame("Beams", 1)
					local linkBeam = Beam(xpbeamSprite, 1, false, false)
					local startPos = Vector(0, beamY)
					local endPos = Vector(Isaac.GetScreenWidth() * barPercGlobal, beamY)
					linkBeam:Add(startPos, 0)
					linkBeam:Add(endPos, 256)
					linkBeam:Render()
				end
			end

			-- Global xp
			if PST.modData.xp > 0 then
				if not PST.config.xpbarStyle or PST.config.xpbarStyle == 1 then
					xpbarFullSprite:Render(barPos, Vector(barWidth * barPercGlobal, 16), Vector(barWidth, 8))
				elseif PST.config.xpbarStyle == 2 or PST.config.xpbarStyle == 3 then
					local beamY = Isaac.GetScreenHeight() - 2
					if PST.config.xpbarStyle == 3 then
						beamY = 2
					end
					-- Beam style
					xpbeamSprite:SetFrame("Beams", 0)
					local linkBeam = Beam(xpbeamSprite, 1, false, false)
					local startPos = Vector(0, beamY)
					local endPos = Vector(Isaac.GetScreenWidth() * barPerc, beamY)
					linkBeam:Add(startPos, 0)
					linkBeam:Add(endPos, 256)
					linkBeam:Render()
				end
			end

			if not PST.config.xpbarStyle or PST.config.xpbarStyle == 1 then
				-- Level text
				local levelStr = "LV " .. charData.level
				luaminiFont:DrawStringScaled(levelStr, barPos.X - luaminiFont:GetStringWidth(levelStr) * tmpScale - 6, barPos.Y - 12 * tmpScale, tmpScale, tmpScale, PST.kcolors.LEVEL_PURPLE)

				-- Global level text
				levelStr = "G.LV " .. PST.modData.level
				luaminiFont:DrawStringScaled(levelStr, barPos.X - luaminiFont:GetStringWidth(levelStr) * tmpScale - 6, barPos.Y - 5 * tmpScale, tmpScale, tmpScale, PST.kcolors.GLOBAL_BLUE)
			elseif PST.config.xpbarStyle == 2 or PST.config.xpbarStyle == 3 then
				-- Beam style texts
				local tmpY = Isaac.GetScreenHeight() - 16 * tmpScale
				local levelStr = "LV " .. charData.level
				luaminiFont:DrawStringScaled(levelStr, 2, tmpY, tmpScale, tmpScale, PST.kcolors.LEVEL_PURPLE)

				levelStr = "G.LV " .. PST.modData.level
				luaminiFont:DrawStringScaled(levelStr, Isaac.GetScreenWidth() - luaminiFont:GetStringWidth(levelStr) - 2, tmpY, tmpScale, tmpScale, PST.kcolors.GLOBAL_BLUE)
			end
		end
	end

	if hudVisible then
		-- Expedition run UI icon
		if PST:getTreeSnapshotMod("isExpedRun", false) then
			local tmpFrame = 0
			if PST:getTreeSnapshotMod("isExpedUber", false) then
				tmpFrame = 2
			end
			expedUISprite:SetFrame("UI", tmpFrame)
			if PST:isKeybindActive(PSTKeybind.TREE_TAB, true) and expedUISprite.Color.A < 1 then
				expedUISprite.Color.A = expedUISprite.Color.A + 0.05
			elseif expedUISprite.Color.A > 0.25 then
				expedUISprite.Color.A = expedUISprite.Color.A - 0.05
			end
			expedUISprite:Render(Vector(8, 8))
		end

		-- Sidereal Artifact UI
		if PST:isRunSidereal() and PST.config.sideArtiUI then
			local charData = PST:getCurrentCharData()
			if charData and #charData.northArtis > 0 and #charData.southArtis > 0 then
				expedUISprite:SetFrame("UI", 1)
				if PST:isKeybindActive(PSTKeybind.TREE_TAB, true) and expedUISprite.Color.A < 1 then
					expedUISprite.Color.A = expedUISprite.Color.A + 0.05
				elseif expedUISprite.Color.A > 0.25 then
					expedUISprite.Color.A = expedUISprite.Color.A - 0.05
				end
				expedUISprite:Render(Vector(8, 22))
				local tmpMeridion = charData.southArtis[1]
				local tmpColor = KColor(1, 1, 1, expedUISprite.Color.A)
				if PST.specialNodes.sideArtiCD > 0 then
					tmpColor = KColor(1, 0.3, 0.3, expedUISprite.Color.A)
				end
				PST.miniFont:DrawStringScaled(PST:getTreeSnapshotMod("sideArtiEnergy", 0) .. "/" .. PST.sideArtiData[tmpMeridion].energyReq, 3, 22, 0.5, 0.5, tmpColor)
			end
		end

		-- Ancient starcursed jewel: Chronicler Stone UI
		if PST:SC_getSnapshotMod("chroniclerStone", false) then
			local remaining = math.max(0, PST:getTreeSnapshotMod("SC_chroniclerRooms", 0))
			local tmpColor = PST.kcolors.RED2
			if remaining == 0 then
				tmpColor = PST.kcolors.SKY_BLUE
			end

			local drawX = 16 * screenRatioX
			local drawY = Isaac.GetScreenHeight() - 16 * screenRatioY
			chroniclerUISprite:Render(Vector(drawX, drawY))
			miniFont:DrawString(tostring(remaining), drawX + 7 * screenRatioX, drawY - 6 * screenRatioY, tmpColor)
		end
	end
	-- Ancient starcursed jewel: Nullstone (poof FX)
	if PST.specialNodes.SC_nullstonePoofFX then
		local fxPos = Vector(PST.specialNodes.SC_nullstonePoofFX.x, PST.specialNodes.SC_nullstonePoofFX.y)
		if fxPos.X ~= 0 or fxPos.Y ~= 0 then
			if PST.specialNodes.SC_nullstonePoofFX.sprite and not PST.specialNodes.SC_nullstonePoofFX.sprite:IsFinished() then
				PST.specialNodes.SC_nullstonePoofFX.sprite:Render(room:WorldToScreenPosition(fxPos))
				PST.specialNodes.SC_nullstonePoofFX.sprite:Update()
			end
			if PST.specialNodes.SC_nullstonePoofFX.stoneSprite and PST.specialNodes.SC_nullstonePoofFX.stoneSprite.Color.A > 0 then
				local newAlpha = math.max(0, PST.specialNodes.SC_nullstonePoofFX.stoneSprite.Color.A - 0.03)
				PST.specialNodes.SC_nullstonePoofFX.stoneSprite.Color = Color(1, 1, 1, newAlpha)
				PST.specialNodes.SC_nullstonePoofFX.stoneSprite:Render(room:WorldToScreenPosition(fxPos))
			end
		end
	end
	-- Ancient starcursed jewel: Crimson Warpstone (cracked key stacks text)
	local tmpMod = PST:getTreeSnapshotMod("SC_crimsonWarpKeyStacks", 0)
	if tmpMod > 0 and player:GetCard(0) == Card.CARD_CRACKED_KEY then
		tempestasFont:DrawString("x" .. tostring(tmpMod + 1), Isaac.GetScreenWidth() - 16, Isaac.GetScreenHeight() - 14, PST.kcolors.WHITE)
	end

	-- Mod: rune shards can stack
	if PST:getTreeSnapshotMod("runeshardStacking", false) then
		tmpMod = PST:getTreeSnapshotMod("runeshardStacks", 0)
		if tmpMod > 0 and player:GetCard(0) == Card.RUNE_SHARD then
			tempestasFont:DrawString("x" .. tostring(tmpMod + 1), Isaac.GetScreenWidth() - 16, Isaac.GetScreenHeight() - 14, PST.kcolors.WHITE)
		end
	end

	-- Helping Hands node (T. Lost's tree) (Holy Card stacks text)
	tmpMod = PST:getTreeSnapshotMod("holyCardStacks", 0)
	if tmpMod > 0 and player:GetCard(0) == Card.CARD_HOLY then
		tempestasFont:DrawString("x" .. tostring(tmpMod + 1), Isaac.GetScreenWidth() - 16, Isaac.GetScreenHeight() - 14, PST.kcolors.WHITE)
	end

	local isEvenFrame = room:GetFrameCount() % 2 == 0
	-- Shadowmeld item transition phase
	if PST.specialFX.shadowmeldTransition and not Game():IsPaused() then
		PST.specialFX.shadowmeldStep = PST.specialFX.shadowmeldStep + 1

		-- Player & siren minion fade out
		local playerSprite = player:GetSprite()
		local playerChange = false
		if PST.specialFX.shadowmeldStep < 6 then
			playerSprite.Color.A = math.max(0, playerSprite.Color.A - 0.2)
			playerChange = true
		end

		-- SFX
		if PST.specialFX.shadowmeldStep == 7 then
			SFXManager():Play(SoundEffect.SOUND_PORTAL_OPEN)
		end

		PST.specialFX.shadowmeldStartFX:Render(room:WorldToScreenPosition(PST.specialFX.shadowmeldStartPos))
		if isEvenFrame then PST.specialFX.shadowmeldStartFX:Update() end

		-- Start end portal sprite
		if PST.specialFX.shadowmeldStartFX:IsEventTriggered("StartEndPortal") or PST.specialFX.shadowmeldStartFX:WasEventTriggered("StartEndPortal") then
			PST.specialFX.shadowmeldEndFX:Render(room:WorldToScreenPosition(PST.specialFX.shadowmeldEndPos))
			if isEvenFrame then PST.specialFX.shadowmeldEndFX:Update() end
		end

		-- Player teleport
		if PST.specialFX.shadowmeldStartFX:IsEventTriggered("Teleport") then
			SFXManager():Play(SoundEffect.SOUND_PORTAL_SPAWN)
		end
		if PST.specialFX.shadowmeldStartFX:IsEventTriggered("Teleport") or PST.specialFX.shadowmeldStartFX:WasEventTriggered("Teleport") then
			player.Position = PST.specialFX.shadowmeldEndPos
		end

		-- Mod: % chance to cause a dark explosion when reappearing with Shadowmeld, dealing 100% damage to nearby enemies and fearing them
		if PST.specialFX.shadowmeldEndFX:IsEventTriggered("ExplosionTrigger") then
			tmpMod = PST:getTreeSnapshotMod("shadowmeldExplosion", 0)
			if tmpMod > 0 and 100 * math.random() < tmpMod then
				PST.specialNodes.shadowmeldExplosionFX.position = player.Position + Vector(0, -50)
				PST.specialNodes.shadowmeldExplosionFX.sprite:Play("Idle", true)
				SFXManager():Play(SoundEffect.SOUND_PORTAL_SPAWN, 1, 0, false, 0.8 + 0.2 * math.random())
			end
		end

		-- Transition done
		if PST.specialFX.shadowmeldEndFX:IsEventTriggered("TransitionDone") then
			player:SetMinDamageCooldown(30)
			PST.specialFX.shadowmeldTransition = false
		end

		-- Player & Siren minion fade in
		if PST.specialFX.shadowmeldEndFX:IsEventTriggered("FadeIn") or PST.specialFX.shadowmeldEndFX:WasEventTriggered("FadeIn") then
			playerSprite.Color.A = math.min(1, playerSprite.Color.A + 0.2)
			playerChange = true
		end
		if playerChange then
			local sirenMinionID = Isaac.GetEntityVariantByName("Siren Minion")
			if sirenMinionID ~= -1 then
				local sirenMinions = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, sirenMinionID)
				for _, tmpMinion in ipairs(sirenMinions) do
					tmpMinion:GetSprite().Color.A = playerSprite.Color.A
				end
			end
		end
	end

	-- Shadowmeld explosion FX & damage
	local shadowmeldFXData = PST.specialNodes.shadowmeldExplosionFX
	if (shadowmeldFXData.position.X ~= 0 or shadowmeldFXData.position.Y ~= 0) and not Game():IsPaused() then
		if not shadowmeldFXData.sprite:IsFinished() then
			shadowmeldFXData.sprite:Render(room:WorldToScreenPosition(shadowmeldFXData.position))
			if isEvenFrame then
				shadowmeldFXData.sprite:Update()
				if shadowmeldFXData.sprite:IsEventTriggered("DamageTick") then
					SFXManager():Play(SoundEffect.SOUND_PORTAL_SPAWN, 1, 0, false, 0.8 + 0.2 * math.random())
					for _, tmpEntity in ipairs(Isaac.FindInRadius(player.Position, 140, EntityPartition.ENEMY)) do
						local tmpNPC = tmpEntity:ToNPC()
						if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
							local tmpDmg = math.min(8, (player.Damage * (0.75 + PST:getTreeSnapshotMod("shadowmeldExplosionDmg", 0) / 100)) / 3)
							tmpNPC:TakeDamage(tmpDmg, 0, EntityRef(player), 0)
							tmpNPC:AddFear(EntityRef(player), 90)
						end
					end
				end
			end
		else
			shadowmeldFXData.position = Vector.Zero
		end
	end

	-- Shadowmeld marker removal with drop key
	if Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) and (PST:getTreeSnapshotMod("shadowmeld", false) or
	player:HasCollectible(Isaac.GetItemIdByName("Shadowmeld"))) then
		local tmpMarkers = Isaac.FindByType(EntityType.ENTITY_EFFECT, PST.shadowmeldMarkerEffectID)
		for _, marker in ipairs(tmpMarkers) do
			marker:Remove()
		end
	end

	if not Game():IsPaused() then
		-- Ancient weapon mod: Precise Seeker (marked enemy effect)
		local tmpEnemy = PST.specialNodes.ancwep_preciseSeekerMarked
		if tmpEnemy then
			PST.specialNodes.ancwep_preciseSeekerSprite:Render(Isaac.WorldToScreen(tmpEnemy.Position))
			if isEvenFrame then
				PST.specialNodes.ancwep_preciseSeekerSprite:Update()
				if PST.specialNodes.ancwep_preciseSeekerSprite:IsFinished() then
					PST.specialNodes.ancwep_preciseSeekerSprite:Play("Default", true)
				end
			end
		end

		-- Ancient weapon mod: Quicksilver (parrying input)
		tmpMod = PST:getSnapAstralWepMod("quicksilver")
		if tmpMod and Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) and
		PST.specialNodes.ancwep_quicksilverParryCD == 0 then
			-- Parrying frames
			PST.specialNodes.ancwep_quicksilverParrying = 7
			player:SetColor(Color(1, 1, 1, 1, 0.8, 0.8, 0.8), PST.specialNodes.ancwep_quicksilverParrying, 1, true, false)
			SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN)

			PST.specialNodes.ancwep_quicksilverParryCD = math.ceil(tmpMod[1] * 30)
		end

		-- Heartblessed chest FX
		if isEvenFrame then PST.specialFX.heartbless:Update() end

		-- Manage floating texts
		if floatTextDelay > 0 then
			floatTextDelay = floatTextDelay - 1
		elseif floatTextDelay == 0 and #floatTextQueue > 0 then
			table.insert(floatingTexts, floatTextQueue[1])
			table.remove(floatTextQueue, 1)
			floatTextDelay = floatTextDelayDefault
		end

		if #floatingTexts > 0 then
			for i = #floatingTexts, 1, -1 do
				local textFX = floatingTexts[i]
				local worldPos = room:WorldToScreenPosition(textFX.position)
				local textX = worldPos.X
				local textY = worldPos.Y
				if textFX.playerRelative then
					if not room:IsMirrorWorld() then
						worldPos = room:WorldToScreenPosition(player.Position)
					else
						-- Calculate diametric opposite X if in mirror world
						local newX = room:GetCenterPos().X - (player.Position.X - room:GetCenterPos().X)
						worldPos = room:WorldToScreenPosition(Vector(newX, player.Position.Y))
					end
					textX = worldPos.X + textFX.position.X - string.len(textFX.text) * 3
					textY = worldPos.Y + textFX.position.Y - 40
				else
					textX = textX - string.len(textFX.text) * 3
					textY = textY - 20
				end

				textY = textY - textFX.step * textFX.speed

				Isaac.RenderText(
					textFX.text,
					textX,
					textY,
					textFX.color.R,
					textFX.color.G,
					textFX.color.B,
					textFX.color.A - textFX.startAlpha * textFX.step / textFX.totalSteps
				)

				textFX.step = textFX.step + 1
				if textFX.step >= textFX.totalSteps then
					table.remove(floatingTexts, i)
				end
			end
		end

		-- Manage floating icons
		if floatIconDelay > 0 then
			floatIconDelay = floatIconDelay - 1
		elseif floatIconDelay == 0 and #floatIconQueue > 0 then
			table.insert(floatingIcons, floatIconQueue[1])
			table.remove(floatIconQueue, 1)
			floatIconDelay = floatTextDelayDefault
		end

		if #floatingIcons > 0 then
			for i = #floatingIcons, 1, -1 do
				local tmpIcon = floatingIcons[i]
				local worldPos = room:WorldToScreenPosition(tmpIcon.position)
				local iconX = worldPos.X
				local iconY = worldPos.Y
				if tmpIcon.playerRelative then
					if not room:IsMirrorWorld() then
						worldPos = room:WorldToScreenPosition(player.Position)
					else
						local newX = room:GetCenterPos().X - (player.Position.X - room:GetCenterPos().X)
						worldPos = room:WorldToScreenPosition(Vector(newX, player.Position.Y))
					end
					iconX = worldPos.X + tmpIcon.position.X
					iconY = worldPos.Y + tmpIcon.position.Y - 30
				else
					iconY = iconY - 10
				end

				iconY = iconY - tmpIcon.step * tmpIcon.speed

				tmpIcon.sprite:Render(Vector(iconX, iconY))
				tmpIcon.sprite.Color.A = (tmpIcon.totalSteps - tmpIcon.step) / tmpIcon.totalSteps

				tmpIcon.step = tmpIcon.step + 1
				if tmpIcon.step >= tmpIcon.totalSteps then
					table.remove(floatingIcons, i)
				end
			end
		end

		-- Special anim FX
		if #animFXList > 0 then
			for i = #animFXList, 1, -1 do
				local tmpFX = animFXList[i]
				local worldPos = room:WorldToScreenPosition(tmpFX.pos)
				if room:IsMirrorWorld() then
					local newX = room:GetCenterPos().X - (tmpFX.pos.X - room:GetCenterPos().X)
					worldPos = room:WorldToScreenPosition(Vector(newX, tmpFX.pos.Y))
				end

				tmpFX.sprite:Render(worldPos)
				-- Sprite update + associated frame funcs
				if isEvenFrame then
					tmpFX.sprite:Update()

					if tmpFX.frameFuncs then
						for frame, func in pairs(tmpFX.frameFuncs) do
							if tmpFX.sprite:GetFrame() == frame then
								func()
							end
						end
					end
				end

				if tmpFX.sprite:IsFinished() then
					table.remove(animFXList, i)
				end
			end
		end
	end
end

-- Render Cosmic Realignment completion marks on relevant characters (original marks take priority)
local markLayerOverrides = {
    [CompletionType.ULTRA_GREEDIER] = 8,
    [CompletionType.DELIRIUM] = 0,
    [CompletionType.MOTHER] = 10,
    [CompletionType.BEAST] = 11
}
function PST:cosmicRMarksRender(markSprite, markPos, markScale, playerType)
	-- Invariably hide marks when viewing tree
	if PST.treeScreen.open then
		return false
	end

	if PST.config.specialMarkRendering then
		local pTypeStr = tostring(playerType)
		local markPathNormal = "gfx/ui/completion_widget.png"
		local markPathCosmic = "gfx/ui/skilltrees/completion_widget_cosmic.png"
		if Game():IsPauseMenuOpen() then
			markPathNormal = "gfx/ui/completion_widget_pause.png"
			markPathCosmic = "gfx/ui/skilltrees/completion_widget_pause_cosmic.png"
		end

		for compMark=0,14 do
			local layerID = compMark + 1
			-- Marks that match the corresponding sprite layer
			if compMark == 9 then layerID = compMark end

			local override = false
			if markLayerOverrides[compMark] ~= nil then
				layerID = markLayerOverrides[compMark]
				override = true
			end

			if PST.modData.cosmicRCompletions[pTypeStr] ~= nil then
				local hasMark = Isaac.GetCompletionMark(playerType, compMark)
				if PST.modData.cosmicRCompletions[pTypeStr][tostring(compMark) .. "hard"] and hasMark < 2 then
					markSprite:ReplaceSpritesheet(layerID, markPathCosmic, true)
					markSprite:SetLayerFrame(layerID, 2)
				elseif PST.modData.cosmicRCompletions[pTypeStr][tostring(compMark)] and hasMark == 0 then
					markSprite:ReplaceSpritesheet(layerID, markPathCosmic, true)
					markSprite:SetLayerFrame(layerID, 1)
				elseif not override then
					markSprite:ReplaceSpritesheet(layerID, markPathNormal, true)
				end
			else
				markSprite:ReplaceSpritesheet(layerID, markPathNormal, true)
			end
		end
	end
end