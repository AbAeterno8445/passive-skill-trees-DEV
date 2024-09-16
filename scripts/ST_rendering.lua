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
	if not PST.config.floatingTexts then return end

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

local chroniclerUISprite = Sprite("gfx/items/starcursed_jewels.anm2", true)
chroniclerUISprite:Play("Chronicler UI", true)

-- Rendering function
function PST:Render()
	local screenRatioX = Isaac.GetScreenWidth() / 480
	local screenRatioY = Isaac.GetScreenHeight() / 270

	local room = PST:getRoom()
	--local gamePaused = Game():IsPaused()

	-- XP bar
	local hudVisible = Game():GetHUD():IsVisible()
	if PST.config.drawXPbar and hudVisible then
		local charData = PST:getCurrentCharData()
		if charData then
			local barPos = Vector(112 * screenRatioX, Isaac.GetScreenHeight() - 12)
			local barPerc = math.min(1, charData.xp / math.max(1, charData.xpRequired))
			local barPercGlobal = math.min(1, PST.modData.xp / math.max(1, PST.modData.xpRequired))
			local barScale = Vector(screenRatioX, math.min(1, screenRatioY))

			xpbarTempSprite.Scale = barScale
			xpbarFullSprite.Scale = barScale
			xpbarSprite.Scale = barScale
			xpbarSprite:Render(barPos)

			if PST.modData.xpObtained > 0 then
				-- Character temp xp bar
				local tempBarPercent = math.min(1, (charData.xp + PST.modData.xpObtained) / math.max(1, charData.xpRequired))
				xpbarTempSprite:Render(barPos, Vector(barWidth * tempBarPercent, 8), Vector(barWidth, 16))

				-- Global temp xp bar
				tempBarPercent = math.min(1, (PST.modData.xp + PST.modData.xpObtained) / math.max(1, PST.modData.xpRequired))
				xpbarTempSprite:Render(barPos, Vector(barWidth * tempBarPercent, 16), Vector(barWidth, 8))
			end

			-- Character xp
			if charData.xp > 0 then
				xpbarFullSprite:Render(barPos, Vector(barWidth * barPerc, 8), Vector(barWidth, 16))
			end

			-- Global xp
			if PST.modData.xp > 0 then
				xpbarFullSprite:Render(barPos, Vector(barWidth * barPercGlobal, 16), Vector(barWidth, 8))
			end

			-- Level text
			local levelStr = "LV " .. charData.level
			luaminiFont:DrawStringScaled(levelStr, barPos.X - luaminiFont:GetStringWidth(levelStr) - 6, barPos.Y - 12, 1, 1, KColor(0.84, 0.5, 1, 0.7))

			-- Global level text
			levelStr = "G.LV " .. PST.modData.level
			luaminiFont:DrawStringScaled(levelStr, barPos.X - luaminiFont:GetStringWidth(levelStr) - 6, barPos.Y - 5, 1, 1, KColor(0.1, 0.4, 1, 0.7))
		end
	end

	-- Ancient starcursed jewel: Chronicler Stone UI
	if hudVisible then
		if PST:SC_getSnapshotMod("chroniclerStone", false) then
			local remaining = math.max(0, PST:getTreeSnapshotMod("SC_chroniclerRooms", 0))
			local tmpColor = KColor(1, 0.6, 0.6, 1)
			if remaining == 0 then
				tmpColor = KColor(0.6, 0.9, 1, 1)
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
	if tmpMod > 0 and PST:getPlayer():GetCard(0) == Card.CARD_CRACKED_KEY then
		tempestasFont:DrawString("x" .. tostring(tmpMod + 1), Isaac.GetScreenWidth() - 16, Isaac.GetScreenHeight() - 14, KColor(1, 1, 1, 1))
	end

	-- Mod: rune shards can stack
	if PST:getTreeSnapshotMod("runeshardStacking", false) then
		tmpMod = PST:getTreeSnapshotMod("runeshardStacks", 0)
		if tmpMod > 0 and PST:getPlayer():GetCard(0) == Card.RUNE_SHARD then
			tempestasFont:DrawString("x" .. tostring(tmpMod + 1), Isaac.GetScreenWidth() - 16, Isaac.GetScreenHeight() - 14, KColor(1, 1, 1, 1))
		end
	end

	-- Helping Hands node (T. Lost's tree) (Holy Card stacks text)
	tmpMod = PST:getTreeSnapshotMod("holyCardStacks", 0)
	if tmpMod > 0 and PST:getPlayer():GetCard(0) == Card.CARD_HOLY then
		tempestasFont:DrawString("x" .. tostring(tmpMod + 1), Isaac.GetScreenWidth() - 16, Isaac.GetScreenHeight() - 14, KColor(1, 1, 1, 1))
	end

	-- Manage floating texts
    if floatTextDelay > 0 then
        floatTextDelay = floatTextDelay - 1
    elseif floatTextDelay == 0 and #floatTextQueue > 0 then
        table.insert(floatingTexts, floatTextQueue[1])
        table.remove(floatTextQueue, 1)
        floatTextDelay = floatTextDelayDefault
    end

	if #floatingTexts > 0 then
		local player = PST:getPlayer()
        for i = #floatingTexts, 1, -1 do
            local textFX = floatingTexts[i]
			local worldPos = room:WorldToScreenPosition(textFX.position)
			local textX = worldPos.X
			local textY = worldPos.Y
            if textFX.playerRelative then
				if not room:IsMirrorWorld() then
					worldPos = room:WorldToScreenPosition(Vector(player.Position.X, player.Position.Y))
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
end

-- Render Cosmic Realignment completion marks on relevant characters (original marks take priority)
local markLayerOverrides = {
    [CompletionType.ULTRA_GREEDIER] = 8,
    [CompletionType.DELIRIUM] = 0,
    [CompletionType.MOTHER] = 10,
    [CompletionType.BEAST] = 11
}
function PST:cosmicRMarksRender(markSprite, markPos, markScale, playerType)
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