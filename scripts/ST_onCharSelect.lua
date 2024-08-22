-- On selecting a character in menu (uses completion mark render callback)
function PST:onCharSelect(_, _, _, charID)
	if not Isaac.IsInGame() then
		if MenuManager.GetActiveMenu() == MainMenuType.CHARACTER and (charID ~= PST.selectedMenuChar or (charID == 0 and PST.modData.charData["Isaac"] == nil)) then
			local charName = PST.charNames[1 + charID]
			if charName ~= nil then
				PST:charInit(charName)
				PST.selectedMenuChar = charID
			else
				-- Attempt to init unknown character
				local charConfig = EntityConfig.GetPlayer(charID)
				if charConfig then
					PST:initUnknownChar(charConfig:GetName(), charConfig:IsTainted())
					if PST.modData.charData[charConfig:GetName()] ~= nil then
						PST.selectedMenuChar = charID
					else
						PST.selectedMenuChar = -1
					end
				else
					PST.selectedMenuChar = -1
				end
			end
		end
	end
end