ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}
local societyambulancemoney = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)
RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)  
	PlayerData.job2 = job2  
	Citizen.Wait(5000) 
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

---------------- FONCTIONS ------------------

function Bossambulance()
  local hambulance = RageUI.CreateMenu("Actions Patron", "ambulance")
  hambulance:SetRectangleBanner(0, 55, 95)
    RageUI.Visible(hambulance, not RageUI.Visible(hambulance))

            while hambulance do
                Citizen.Wait(0)
                    RageUI.IsVisible(hambulance, true, true, true, function()

                    if societyambulancemoney ~= nil then
                        RageUI.ButtonWithStyle("Argent de la société :", nil, {RightLabel = "$" .. societyambulancemoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Accéder aux actions de Management", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ambulanceboss()
                            RageUI.CloseAll()
                        end
                    end)

                        
                    end, function()
                end)
            if not RageUI.Visible(hambulance) then
            hambulance = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'ambulance' and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ambulance.pos.boss.position.x, ambulance.pos.boss.position.y, ambulance.pos.boss.position.z)
        if dist3 <= 7.0 and ambulance.jeveuxmarker then
            Timer = 0
            DrawMarker(20, ambulance.pos.boss.position.x, ambulance.pos.boss.position.y, ambulance.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 55, 95, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.0 then
                Timer = 0   
                        SetTextComponentFormat('STRING')
			    AddTextComponentString("~INPUT_PICKUP~ pour ouvrir les actions patron")
			    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1,51) then
                        RefreshambulanceMoney()          
                        Bossambulance()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshambulanceMoney()
    if ESX.PlayerData.job == 'ambulance' and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyhimmoMoney(money)
        end, ESX.PlayerData.job.name)
    elseif ESX.PlayerData.job2 == 'ambulance' and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyhimmoMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyambulanceMoney(money)
    societyambulancemoney = ESX.Math.GroupDigits(money)
end

function ambulanceboss()
    TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
        --menu.close()
    end, {wash = false})
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

RegisterNetEvent('ambulance:bossmenu')
AddEventHandler('ambulance:bossmenu', function(type, data)
	ambulanceboss()
end)

exports.ox_target:addBoxZone(
    {
        coords = vec3(350.97, -582.20, 43.67),
        size = vec3(0.3, 0.3, 0.3),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'box',
                event = 'ambulance:bossmenu',
                icon = 'fa-solid fa-cube',
                label = 'Acceder a l\'ordinateur',
            },
        },
        minZ = 43.20,
        maxZ = 44.20,
    }
)