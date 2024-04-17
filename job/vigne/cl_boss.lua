ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}
local societyvignemoney = nil

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

function Bossvigne()
  local hvigne = RageUI.CreateMenu("Actions Patron", "vigne")
    RageUI.Visible(hvigne, not RageUI.Visible(hvigne))

            while hvigne do
                Citizen.Wait(0)
                    RageUI.IsVisible(hvigne, true, true, true, function()

                    if societyvignemoney ~= nil then
                        RageUI.ButtonWithStyle("Argent de la société :", nil, {RightLabel = "$" .. societyvignemoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            vigneboss()
                            RageUI.CloseAll()
                        end
                    end)

                        
                    end, function()
                end)
            if not RageUI.Visible(hvigne) then
            hvigne = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'vigne' and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, vigne.pos.boss.position.x, vigne.pos.boss.position.y, vigne.pos.boss.position.z)
        if dist3 <= 50.0 and vigne.jeveuxmarker then
            Timer = 0
            DrawMarker(20, vigne.pos.boss.position.x, vigne.pos.boss.position.y, vigne.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        SetTextComponentFormat('STRING')
			    --AddTextComponentString("~INPUT_PICKUP~ pour ouvrir les actions patron")
			    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if IsControlJustPressed(1,51) then
                        RefreshvigneMoney()          
                        Bossvigne()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshvigneMoney()
    if ESX.PlayerData.job == 'vigne' and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyhimmoMoney(money)
        end, ESX.PlayerData.job.name)
    elseif ESX.PlayerData.job2 == 'vigne' and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyhimmoMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyvigneMoney(money)
    societyvignemoney = ESX.Math.GroupDigits(money)
end

function vigneboss()
    TriggerEvent('esx_society:openBossMenu', 'vigne', function(data, menu)
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

RegisterNetEvent('vigne:annonce')
AddEventHandler('vigne:annonce', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'vigne' or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'vigne' then
       	exports.ox_lib:showContext('vignemenu')
	else
		ESX.ShowNotification("~y~ta pas acces miskin")
	end
end)


RegisterNetEvent('vigne:bossmenu')
AddEventHandler('vigne:bossmenu', function(type, data)
	vigneboss()
end)

exports.ox_target:addBoxZone(
    {
        coords = vec3(-1897.09, 2068.73, 141.00),
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'poly',
                event = 'vigne:bossmenu',
                icon = 'fa-solid fa-cube',
                label = 'Acceder a l\'ordinateur',
            },
            {
                name = 'poly',
                event = 'vigne:annonce',
                icon = 'fa-solid fa-cube',
                label = 'Faire une Annonce',
            },
        },
        minZ = 140.50,
        maxZ = 141.50,
    }
)


exports.ox_lib:registerContext({
    id = 'vignemenu',
    title = 'Faire une annonce',
    options = {
        {
            title = 'Ouvert',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!")  	 
				exports["WaveShield"]:TriggerServerEvent('hvigne:Ouvert')    
            end,
        },
        {
            title = 'Fermer',
            progress = '100',
            onSelect = function()
                --print("Pressed the button!") 
                exports["WaveShield"]:TriggerServerEvent('hvigne:Fermer')  
            end,
        },
    },
})