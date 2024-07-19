-- On selecting a character in menu (uses completion mark render callback)
function PST:onCharSelect(_, _, _, charID)
	if Isaac.GetPlayer() == nil then
		if MenuManager.GetActiveMenu() == MainMenuType.CHARACTER and charID ~= PST.selectedMenuChar then
			local charName = PST.charNames[1 + charID]
			PST:charInit(charName)
			PST.selectedMenuChar = charID
		end
	end
end