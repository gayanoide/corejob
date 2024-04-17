ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'hen', 'hen', 'society_hen', 'society_hen', 'society_hen', {type = 'public'})

--RegisterNetEvent('hhen:bar')
--AddEventHandler('hhen:bar', function(item,price)
exports["WaveShield"]:AddEventHandler('hhen:bar', function(source, item,price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_hen', function(account)
		
    if account.money >= price then
    if xPlayer.canCarryItem(item, 1) then
        account.removeMoney(price)
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "~g~Achat~w~ effectué !")
	else
	    TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas porter d'avantage")
	end
    else
         TriggerClientEvent('esx:showNotification', source, "Votre société n'a plus d'argent")
    end
	end)
end)


--RegisterServerEvent('hhen:Ouvert')
--AddEventHandler('hhen:Ouvert', function()
exports["WaveShield"]:AddEventHandler('hhen:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin hen', '~y~Ouverture', 'Votre hen Vespucci est ouvert', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "hen", "OUVERT", 5000, "succes")
	
	end
end)

--RegisterServerEvent('hhen:Fermer')
--AddEventHandler('hhen:Fermer', function()
exports["WaveShield"]:AddEventHandler('hhen:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin hen', '~y~Fermeture', 'Votre hen Vespucci est fermé', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "hen", "Fermer", 5000, "succes")
	
	end
end)