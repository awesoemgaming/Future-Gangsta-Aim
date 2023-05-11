local Future = nil
local gangstaAimEnabled = false

Citizen.CreateThread(function()
    while Future == nil do
        TriggerEvent('QBCore:GetObject', function(obj) Future = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('Future_gangaim:toggle')
AddEventHandler('Future_gangaim:toggle', function()
    gangstaAimEnabled = not gangstaAimEnabled

    if not gangstaAimEnabled then
        local playerPed = GetPlayerPed(-1)
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 38) then
            TriggerEvent('Future_gangaim:toggle')
        end

        if gangstaAimEnabled then
            local playerPed = GetPlayerPed(-1)

            if IsPedArmed(PlayerPedId(), 7) and not IsPlayerFreeAiming(PlayerId()) then
                ClearPedSecondaryTask(playerPed)
                SetEnableHandcuffs(playerPed, false)
            elseif IsPlayerFreeAiming(PlayerId()) and not IsEntityPlayingAnim(playerPed, Config.aimanimdict, Config.aimanimdicttype, 3) then
                RequestAnimDict(Config.aimanimdict)
                while (not HasAnimDictLoaded(Config.aimanimdict)) do
                    Citizen.Wait(100)
                end

                SetEnableHandcuffs(playerPed, true)
                TaskPlayAnim(playerPed, Config.aimanimdict, Config.aimanimdicttype, 8.0, 2.5, -1, 49, 0, 0, 0, 0)
            end
        end
    end
end)
