function PST:onInput(entity, inputHook, buttonAction)
	if not entity then return end

	local player = entity:ToPlayer()
	if player then
        -- Statue Pilgrimage node (Jacob & Esau's tree)
        if PST:getTreeSnapshotMod("statuePilgrimage", false) then
            -- Cancel Esau shooting inputs while he's transformed with Gnawed Leaf
            if player:GetPlayerType() == PlayerType.PLAYER_ESAU and PST.specialNodes.esauIsStatue then
                if buttonAction == ButtonAction.ACTION_SHOOTUP or buttonAction == ButtonAction.ACTION_SHOOTDOWN or
                buttonAction == ButtonAction.ACTION_SHOOTLEFT or buttonAction == ButtonAction.ACTION_SHOOTRIGHT then
                    if inputHook == InputHook.IS_ACTION_PRESSED or inputHook == InputHook.IS_ACTION_TRIGGERED then
                        return false
                    elseif inputHook == InputHook.GET_ACTION_VALUE then
                        return 0
                    end
                end
            end
        end
	end
end