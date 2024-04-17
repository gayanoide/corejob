ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}
local societyfermemoney = nil

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

function Bossferme()
  local hferme = RageUI.CreateMenu("Actions Patron", "ferme")
    RageUI.Visible(hferme, not RageUI.Visible(hferme))

            while hferme do
                Citizen.Wait(0)
                    RageUI.IsVisible(hferme, true, true, true, function()

                    if societyfermemoney ~= nil then
                        RageUI.ButtonWithStyle("Argent de la société :", nil, {RightLabel = "$" .. societyfermemoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            fermeboss()
                            RageUI.CloseAll()
                        end
                    end)

                        
                    end, function()
                end)
            if not RageUI.Visible(hferme) then
            hferme = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ferme' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'ferme' and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ferme.pos.boss.position.x, ferme.pos.boss.position.y, ferme.pos.boss.position.z)
        if dist3 <= 50.0 and ferme.jeveuxmarker then
            Timer = 0
            DrawMarker(20, ferme.pos.boss.position.x, ferme.pos.boss.position.y, ferme.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        SetTextComponentFormat('STRING')
			    --AddTextComponentString("~INPUT_PICKUP~ pour ouvrir les actions patron")
			    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1,51) then
                        RefreshfermeMoney()          
                        Bossferme()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshfermeMoney()
    if ESX.PlayerData.job == 'ferme' and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyhimmoMoney(money)
        end, ESX.PlayerData.job.name)
    elseif ESX.PlayerData.job2 == 'ferme' and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyhimmoMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyfermeMoney(money)
    societyfermemoney = ESX.Math.GroupDigits(money)
end

function fermeboss()
    TriggerEvent('esx_society:openBossMenu', 'ferme', function(data, menu)
        menu.close()
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




RegisterNetEvent('ferme:annonce')
AddEventHandler('ferme:annonce', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ferme' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'ferme' then
       	exports.ox_lib:showContext('fermemenu')
	else
		ESX.ShowNotification("~y~ta pas acces miskin")
	end
end)

RegisterNetEvent('ferme:bossmenu')
AddEventHandler('ferme:bossmenu', function(type, data)
	fermeboss()
end)

exports.ox_target:addBoxZone(
    {
        coords = vec3(2226.71, 5619.09, 54.30),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'ferme:bossmenu',
                icon = 'fa-solid fa-cube',
                label = 'Acceder a l\'ordinateur',
            },
            {
                name = 'poly',
                event = 'ferme:annonce',
                icon = 'fa-solid fa-cube',
                label = 'Faire une Annonce',
            },
        },
        minZ = 54.00,
        maxZ = 55.00,
    }
)




exports.ox_lib:registerContext({
    id = 'fermemenu',
    title = 'Faire une annonce',
    options = {
        {
            title = 'Ouvert',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!")  	 
				exports["WaveShield"]:TriggerServerEvent('hferme:Ouvert')    
            end,
        },
        {
            title = 'Fermer',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!") 
                exports["WaveShield"]:TriggerServerEvent('hferme:Fermer')  
            end,
        },
    },
})