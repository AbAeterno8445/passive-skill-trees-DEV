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

function PST:isAnyInputActive(inputParam, controllerId, isAction, checkPressed)
    if not inputParam then return false end

    local tmpInputList = {}
    if type(inputParam) ~= "table" then
        table.insert(tmpInputList, inputParam)
    else
        tmpInputList = inputParam
    end

    for _, tmpInput in ipairs(tmpInputList) do
        if not isAction then
            if (not checkPressed and Input.IsButtonTriggered(tmpInput, controllerId)) or
            (checkPressed and Input.IsButtonPressed(tmpInput, controllerId)) then
                return true
            end
        else
            if (not checkPressed and Input.IsActionTriggered(tmpInput, controllerId)) or
            (checkPressed and Input.IsActionPressed(tmpInput, controllerId)) then
                return true
            end
        end
    end
    return false
end

-- Check whether the given keybind ID from config.keybinds is active
---@param keybindID PSTKeybind Keybind ID, matching key in PST.config.keybinds
---@param checkPressed? boolean Function uses triggered check by default. Set this to true to check pressed instead
---@return boolean
function PST:isKeybindActive(keybindID, checkPressed)
    if not PST.config.keybinds[keybindID] then
        return false
    end

    local shiftHeld = Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0) or Input.IsButtonPressed(Keyboard.KEY_RIGHT_SHIFT, 0)
    local ctrlHeld = Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, 0) or Input.IsButtonPressed(Keyboard.KEY_RIGHT_CONTROL, 0)
    local actionItemHeld = Input.IsActionPressed(ButtonAction.ACTION_ITEM, 1)

    local bindData = PST.config.keybinds[keybindID]
    local keyCheck = (((not bindData.shift and not shiftHeld) or (bindData.shift and shiftHeld) or bindData.allowShift) and
        ((not bindData.ctrl and not ctrlHeld) or (bindData.ctrl and ctrlHeld) or bindData.allowCtrl) and
        PST:isAnyInputActive(bindData.keyboardButton, 0, false, checkPressed))

    local controlCheck = (((not bindData.actionItem and not actionItemHeld) or (bindData.actionItem and actionItemHeld) or bindData.allowActionItem) and
        PST:isAnyInputActive(bindData.controllerAction, 1, true, checkPressed))

    return keyCheck or controlCheck
end