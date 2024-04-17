ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'tps', 'tps', 'society_tps', 'society_tps', 'society_tps', {type = 'public'})

--RegisterNetEvent('htps:bar')
--AddEventHandler('htps:bar', function(item,price)
exports["WaveShield"]:AddEventHandler('htps:bar', function(source, item,price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tps', function(account)
		
    if account.money >= price then
    if xPlayer.canCarryItem(item, 1) then
        account.removeMoney(price)
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "~g~Achat~w~ effectué !")
	else
	    --TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas porter d'avantage")
	end
    else
         TriggerClientEvent('esx:showNotification', source, "Votre société n'a plus d'argent")
    end
	end)
end)


--RegisterServerEvent('htps:Ouvert')
--AddEventHandler('htps:Ouvert', function(source)
exports["WaveShield"]:AddEventHandler('htps:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin tps', '~y~Ouverture', 'Votre tps Vespucci est ouvert', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "tps", "OUVERT", 5000, "succes")
	
	end
end)

--RegisterServerEvent('htps:Fermer')
--AddEventHandler('htps:Fermer', function()
exports["WaveShield"]:AddEventHandler('htps:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin tps', '~y~Fermeture', 'Votre tps Vespucci est fermé', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "tps", "Fermer", 5000, "succes")
	
	end
end)