ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}
local societykoimoney = nil

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

function Bosskoi()
  local hkoi = RageUI.CreateMenu("Actions Patron", "koi")
  hkoi:SetRectangleBanner(0, 13, 219)
    RageUI.Visible(hkoi, not RageUI.Visible(hkoi))

            while hkoi do
                Citizen.Wait(0)
                    RageUI.IsVisible(hkoi, true, true, true, function()

                    if societykoimoney ~= nil then
                        RageUI.ButtonWithStyle("Argent de la société :", nil, {RightLabel = "$" .. societykoimoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            koiboss()
                            RageUI.CloseAll()
                        end
                    end)

                        
                    end, function()
                end)
            if not RageUI.Visible(hkoi) then
            hkoi = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'koi' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'koi' and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, koi.pos.boss.position.x, koi.pos.boss.position.y, koi.pos.boss.position.z)
        if dist3 <= 7.0 and koi.jeveuxmarker then
            Timer = 0
            DrawMarker(20, koi.pos.boss.position.x, koi.pos.boss.position.y, koi.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 13, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.0 then
                Timer = 0   
                        SetTextComponentFormat('STRING')
			    AddTextComponentString("~INPUT_PICKUP~ pour ouvrir les actions patron")
			    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1,51) then
                        RefreshkoiMoney()        
                        Bosskoi()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshkoiMoney()
    if ESX.PlayerData.job == 'koi' and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyhimmoMoney(money)
        end, ESX.PlayerData.job.name)
    elseif ESX.PlayerData.job2 == 'koi' and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyhimmoMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietykoiMoney(money)
    societykoimoney = ESX.Math.GroupDigits(money)
end

function koiboss()
    TriggerEvent('esx_society:openBossMenu', 'koi', function(data, menu)
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


RegisterNetEvent('koi:bossmenu')
AddEventHandler('koi:bossmenu', function(type, data)
	koiboss()
end)
RegisterNetEvent('koi:annonce')
AddEventHandler('koi:annonce', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'koi' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'koi' then
       	exports.ox_lib:showContext('koimenu')
	else
		ESX.ShowNotification("~y~ta pas acces miskin")
	end
end)

exports.ox_target:addBoxZone(
    {
        coords = vec3(-1044.96, -1491.79, 5.30),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'koi:bossmenu',
                icon = 'fa-solid fa-cube',
                label = 'Acceder a l\'ordinateur',
            },
            {
                name = 'poly',
                event = 'koi:annonce',
                icon = 'fa-solid fa-cube',
                label = 'Faire une Annonce',
            },
        },
        minZ = 5.0,
        maxZ = 6.0,
    }
)

exports.ox_lib:registerContext({
    id = 'koimenu',
    title = 'Faire une annonce',
    options = {
        {
            title = 'Ouvert',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!")  	 
				exports["WaveShield"]:TriggerServerEvent('hkoi:Ouvert')    
            end,
        },
        {
            title = 'Fermer',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!") 
                exports["WaveShield"]:TriggerServerEvent('hkoi:Fermer')  
            end,
        },
    },
})