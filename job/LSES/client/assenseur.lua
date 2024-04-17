function OpenMenuAscenseurPolice()
    local Ascenseurppolice = RageUI.CreateMenu("Ascenseur", "L.S.E.S")
    --Ascenseurppolice:SetRectangleBanner(0, 0, 255)
    RageUI.Visible(Ascenseurppolice, not RageUI.Visible(Ascenseurppolice))
    while Ascenseurppolice do
        Citizen.Wait(0)
            RageUI.IsVisible(Ascenseurppolice, true, true, true, function()

                for k,v in pairs(Config.posascenseur) do
                    RageUI.ButtonWithStyle(v.name, nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            DoScreenFadeOut(1000)
                            Wait(1000)
                            FreezeEntityPosition(PlayerPedId(), true)
                            tp(v.x, v.y, v.z)
                            FreezeEntityPosition(PlayerPedId(), false)
                            Wait(900)
                            DoScreenFadeIn(1000)
                            RageUI.CloseAll()
                        end
                    end)
                end
            end, function()
            end)
                if not RageUI.Visible(Ascenseurppolice) then Ascenseurppolice = RMenu:DeleteType("L.S.M.C", true)
        end
    end
end

function tp(x,y,z)
	SetEntityCoords(PlayerPedId(), x, y, z - 0.9)
end

Citizen.CreateThread(function ()
    while true do
        local time = 1000
        for k, v in pairs(Config.posascenseur) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local coords = vector3(v.x, v.y, v.z)
            local dist = GetDistanceBetweenCoords(plyCoords, coords, true)

            if dist <= 1.5 then
                time = 5
                --ESX.ShowHelpNotification("Appuyer sur ~INPUT_TALK~ pour choisir votre ~b~étage~s~.")
                RageUI.Text({ message = "~y~[E]~s~ pour choisir votre étage", time_display = 1 })
                if IsControlJustPressed(1, 51) then
                    OpenMenuAscenseurPolice()
                end
            end   
        end 
        Wait(time)
    end
end)