function PST:preUpdate()
    -- Pause game while tree screen is open
    if Isaac.IsInGame() and PST.treeScreen.open then
        return true
    end
end