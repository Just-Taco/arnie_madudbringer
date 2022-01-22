--[[
░█████╗░██████╗░███╗░░██╗██╗███████╗
██╔══██╗██╔══██╗████╗░██║██║██╔════╝
███████║██████╔╝██╔██╗██║██║█████╗░░
██╔══██║██╔══██╗██║╚████║██║██╔══╝░░
██║░░██║██║░░██║██║░╚███║██║███████╗
╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝╚═╝╚══════╝
--]]

-- Starter settings --

madrute = false
tagetmad = false
bil = false
madafleveret = false

Citizen.CreateThread(function()
    while true do
       Citizen.Wait(1)
       for k,v in pairs(cfg.Start) do
   DrawMarker(1, 151.88554382324,-1478.3123779297,29.357027053833-0.99, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 217, 28, 28, 200, 0, 0, 0, 50)
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v[1], v[2], v[3]) < 2 then
            DrawText3Ds(v[1], v[2], v[3]+0.15, "~r~[E]~w~ - Start madrute")
            if IsControlJustPressed(1, 38) then
              exports['mythic_notify']:DoHudText('inform', 'Du har nu startet en madrute! Tag hen og hent maden på venstre side!', { ['g'] = '#ffffff', ['w'] = '#000000' })
              Citizen.Wait(1000)
              madrute = true
            end
          end
       end
    end
end)

RegisterCommand("arnieergangsta", function()
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_VALET", 0, true)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for k,v in pairs(cfg.Hentmad) do
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v[1], v[2], v[3]) < 2 then
                    if madrute == true then
                        if tagetmad == false then
                    DrawText3Ds(v[1], v[2], v[3]+0.15, "~r~[E]~w~ - Tag maden")
                    if IsControlJustPressed(1, 38) then
                    Citizen.Wait(200)
                    exports['progressBars']:startUI(9000, "Tager maden...")
                    FreezeEntityPosition(PlayerPedId(), true)
                    TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_BUM_BIN', 0, true)
                    Citizen.Wait(9100)
                    FreezeEntityPosition(PlayerPedId(), false)
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    exports['mythic_notify']:DoHudText('inform', 'Gå om bagved igen, der er der en bil du kan køre i og en GPS!', { ['g'] = '#ffffff', ['w'] = '#000000' })
                    tagetmad = true
                    TriggerEvent('SpawnBil')
                    TriggerEvent('Aflever:maden')
                        end
                    end
                end
              end
            end
        end
    end)

    RegisterNetEvent('SpawnBil')
    AddEventHandler('SpawnBil',function()
      local spawncar = true
      local lockpick = true
      local vehiclehash = GetHashKey("Rhapsody")
      RequestModel(vehiclehash)
      while not HasModelLoaded(vehiclehash) do
          RequestModel(vehiclehash)
          Citizen.Wait(1)
      end
      local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(1), 0, 10.0, 0)
      local spawned_car = CreateVehicle(vehiclehash,154.22692871094,-1482.0850830078,28.832084655762, true, false)
      SetEntityAsMissionEntity(spawned_car, true, true)
      spawncar = true
    end)

    RegisterNetEvent('Aflever:maden')
    AddEventHandler('Aflever:maden', function()
        local player = GetPlayerPed(-1)
        num = math.random(1,20) 
        SetNewWaypoint(cfg.Afleveremaden[num].x, cfg.Afleveremaden[num].y, cfg.Afleveremaden[num].z)
    end)

                            Citizen.CreateThread(function()
                            while true do
                                Citizen.Wait(-1)
                                if tagetmad == true then
                                    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), cfg.Afleveremaden[num].x, cfg.Afleveremaden[num].y, cfg.Afleveremaden[num].z) < 2 then
                                        DrawText3Ds(cfg.Afleveremaden[num].x, cfg.Afleveremaden[num].y, cfg.Afleveremaden[num].z+0.10, "~r~[E]~w~ Aflever maden")
                                        if IsControlJustPressed(1, 38) then
                                            exports['progressBars']:startUI(3000, "Afleverer maden...")
                                            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WINDOW_SHOP_BROWSE", 0, true)
                                            Citizen.Wait(3000)
                                            local ped = PlayerPedId()
                                            local x,y,z = table.unpack(GetEntityCoords(ped, false))
                                            local streetName, crossing = GetStreetNameAtCoord(x, y, z)
                                            streetName = GetStreetNameFromHashKey(streetName)
                                            ClearPedTasksImmediately(GetPlayerPed(-1))
                                            TriggerServerEvent('Betaling')
                                            Citizen.Wait(1)
                                            exports['mythic_notify']:DoHudText('inform', 'Du har nu modtaget lidt penge! Du kan altid tage hen og hent mad og aflevere igen!', { ['g'] = '#ffffff', ['w'] = '#000000' })
                                            Citizen.Wait(1000)
                                            tagetmad = false
                                            madafleveret = true
                                        end
                                    end
                                end
                            end
                        end)
                        

-- 3D TEXT -- 
    function DrawText3Ds(x,y,z, text)
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        local px,py,pz=table.unpack(GetGameplayCamCoords())

        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 20, 20, 20, 150)
    end