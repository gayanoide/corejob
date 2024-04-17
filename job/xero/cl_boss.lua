ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}
local societyxeromoney = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(10) 
end)
RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)  
	PlayerData.job2 = job2  
	Citizen.Wait(10) 
end)

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
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

function Bossxero()
  local hxero = RageUI.CreateMenu("Actions Patron", "xero")
  hxero:SetRectangleBanner(0, 13, 219)
    RageUI.Visible(hxero, not RageUI.Visible(hxero))

            while hxero do
                Citizen.Wait(0)
                    RageUI.IsVisible(hxero, true, true, true, function()

                    if societyxeromoney ~= nil then
                        RageUI.ButtonWithStyle("Argent de la société :", nil, {RightLabel = "$" .. societyxeromoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            xeroboss()
                            RageUI.CloseAll()
                        end
                    end)

                        
                    end, function()
                end)
            if not RageUI.Visible(hxero) then
            hxero = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'xero' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'xero' and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, xero.pos.boss.position.x, xero.pos.boss.position.y, xero.pos.boss.position.z)
        if dist3 <= 7.0 and xero.jeveuxmarker then
            Timer = 0
            DrawMarker(20, xero.pos.boss.position.x, xero.pos.boss.position.y, xero.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 13, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.0 then
                Timer = 0   
                        SetTextComponentFormat('STRING')
			    AddTextComponentString("~INPUT_PICKUP~ pour ouvrir les actions patron")
			    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1,51) then
                        RefreshxeroMoney()        
                        Bossxero()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshxeroMoney()
    if ESX.PlayerData.job == 'xero' and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyhimmoMoney(money)
        end, ESX.PlayerData.job.name)
    elseif ESX.PlayerData.job2 == 'xero' and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyhimmoMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyxeroMoney(money)
    societyxeromoney = ESX.Math.GroupDigits(money)
end

function xeroboss()
    TriggerEvent('esx_society:openBossMenu', 'xero', function(data, menu)
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


RegisterNetEvent('xero:bossmenu')
AddEventHandler('xero:bossmenu', function(type, data)
	--xeroboss()
    TriggerEvent('esx_society:openBossMenu', 'xero', function(data, menu)
        --menu.close()
    end, {wash = false})
end)

exports.ox_target:addBoxZone(
    {
        coords = vec3(301.03, -1268.13, 29.31),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'xero:bossmenu',
                icon = 'fa-solid fa-cube',
                label = 'Acceder a l\'ordinateur',
            },
        },
        minZ = 34.50,
        maxZ = 35.50,
    }
)