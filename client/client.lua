local laptopProp = nil

RegisterNetEvent('hacking:showUI')
AddEventHandler('hacking:showUI', function()
    startHacking()
    SendNUIMessage({
        type = "UI"
    })
    SetNuiFocus(true, true)
    isHacking = true
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    isHacking = false
    stopHacking()
    print("stop")
    cb('ok')
end)

RegisterCommand("hack", function(source, args, rawCommand)
    TriggerEvent('hacking:showUI')
end)

RegisterNUICallback('sendCommand', function(data, cb)
    local command = data.command
    if command == "clear" then
        SendNUIMessage({
            type = "CLEAR_TERMINAL"
        })
    elseif command == "exit" then
        SendNUIMessage({
            type = "hide"
        })
        SetNuiFocus(false, false)
        stopHacking()
    else
        local args = data and data.args[1] or 0
        local args2 = data and data.args[2] or 0
        local output = Commands.execute(command, args, args2)
        SendNUIMessage({
            type = "TERMINAL_OUTPUT",
            output = output
        })
    end
    cb('ok')
end)

-- Function to start hacking
function startHacking()
    isHacking = true
    local playerPed = PlayerPedId()

    -- Load the animation dictionary
    RequestAnimDict("anim@heists@ornate_bank@hack")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@hack") do
        Citizen.Wait(100)
    end

    -- Spawn the laptop prop
    local laptopModel = GetHashKey("prop_laptop_01a")
    RequestModel(laptopModel)
    while not HasModelLoaded(laptopModel) do
        Citizen.Wait(100)
    end

    local playerCoords = GetEntityCoords(playerPed)
    laptopProp = CreateObject(laptopModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)

    -- Attach the laptop to the player
    AttachEntityToEntity(laptopProp, playerPed, GetPedBoneIndex(playerPed, 57005), 0.15, 0.0, -0.05, 0.0, 0.0, 180.0, true, true, false, true, 1, true)

    -- Play the hacking animation
    TaskPlayAnim(playerPed, "anim@heists@ornate_bank@hack", "hack_enter", 8.0, -8.0, -1, 1, 0, false, false, false)
    Citizen.Wait(3000) -- Wait for the enter animation to finish
    TaskPlayAnim(playerPed, "anim@heists@ornate_bank@hack", "hack_loop", 8.0, -8.0, -1, 1, 0, false, false, false)
end

-- Function to stop hacking
function stopHacking()
    isHacking = false
    local playerPed = PlayerPedId()

    -- Clear the player's tasks
    ClearPedTasks(playerPed)

    -- Delete the laptop prop
    if DoesEntityExist(laptopProp) then
        DeleteEntity(laptopProp)
        laptopProp = nil
    end
end