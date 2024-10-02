function PST:onInput(entity, inputHook, buttonAction)
	if not entity then return end

    local cancelInput = false

	local player = entity:ToPlayer()
	if player then
        -- Statue Pilgrimage node (Jacob & Esau's tree)
        if PST:getTreeSnapshotMod("statuePilgrimage", false) then
            -- Cancel Esau shooting inputs while he's transformed with Gnawed Leaf
            if player:GetPlayerType() == PlayerType.PLAYER_ESAU and PST.specialNodes.esauIsStatue then
                if buttonAction == ButtonAction.ACTION_SHOOTUP or buttonAction == ButtonAction.ACTION_SHOOTDOWN or
                buttonAction == ButtonAction.ACTION_SHOOTLEFT or buttonAction == ButtonAction.ACTION_SHOOTRIGHT then
                    cancelInput = true
                end
            end
        end

        -- Shadowmeld item - Disable inputs during transition
        if PST.specialFX.shadowmeldTransition then
            cancelInput = true
        end
	end

    if cancelInput then
        if inputHook == InputHook.IS_ACTION_PRESSED or inputHook == InputHook.IS_ACTION_TRIGGERED then
            return false
        elseif inputHook == InputHook.GET_ACTION_VALUE then
            return 0
        end
    end
end

function PST:IsButtonTriggered(button, controllerId)
    if controllerId == 0 then return Input.IsButtonTriggered(button, controllerId)
    else
        local triggered = false
        for i=1,8 do
            if Input.IsButtonTriggered(button, i) then triggered = true end
            if triggered then break end
        end
        return triggered
    end
end
function PST:IsButtonPressed(button, controllerId)
    if controllerId == 0 then return Input.IsButtonPressed(button, controllerId)
    else
        local triggered = false
        for i=1,8 do
            if Input.IsButtonPressed(button, i) then triggered = true end
            if triggered then break end
        end
        return triggered
    end
end

function PST:IsActionTriggered(button, controllerId)
    if controllerId == 0 then return Input.IsActionTriggered(button, controllerId)
    else
        local triggered = false
        for i=1,8 do
            if Input.IsActionTriggered(button, i) then triggered = true end
            if triggered then break end
        end
        return triggered
    end
end
function PST:IsActionPressed(button, controllerId)
    if controllerId == 0 then return Input.IsActionPressed(button, controllerId)
    else
        local triggered = false
        for i=1,8 do
            if Input.IsActionPressed(button, i) then triggered = true end
            if triggered then break end
        end
        return triggered
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
            if (not checkPressed and PST:IsButtonTriggered(tmpInput, controllerId)) or
            (checkPressed and PST:IsButtonPressed(tmpInput, controllerId)) then
                return true
            end
        else
            if (not checkPressed and PST:IsActionTriggered(tmpInput, controllerId)) or
            (checkPressed and PST:IsActionPressed(tmpInput, controllerId)) then
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

    local shiftHeld = PST:IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, 0) or PST:IsButtonPressed(Keyboard.KEY_RIGHT_SHIFT, 0)
    local ctrlHeld = PST:IsButtonPressed(Keyboard.KEY_LEFT_CONTROL, 0) or PST:IsButtonPressed(Keyboard.KEY_RIGHT_CONTROL, 0)
    local actionItemHeld = PST:IsActionPressed(ButtonAction.ACTION_ITEM, 1)

    local bindData = PST.config.keybinds[keybindID]
    local keyCheck = (((not bindData.shift and not shiftHeld) or (bindData.shift and shiftHeld) or bindData.allowShift) and
        ((not bindData.ctrl and not ctrlHeld) or (bindData.ctrl and ctrlHeld) or bindData.allowCtrl) and
        PST:isAnyInputActive(bindData.keyboardButton, 0, false, checkPressed))

    local controlCheck = (((not bindData.actionItem and not actionItemHeld) or (bindData.actionItem and actionItemHeld) or bindData.allowActionItem) and
        PST:isAnyInputActive(bindData.controllerAction, 1, true, checkPressed))

    return keyCheck or controlCheck
end