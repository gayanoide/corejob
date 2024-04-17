ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'diner', 'diner', 'society_diner', 'society_diner', 'society_diner', {type = 'public'})

--RegisterNetEvent('hdiner:bar')
--AddEventHandler('hdiner:bar', function(source, item,price)
exports["WaveShield"]:AddEventHandler('hdiner:bar', function(source, item,price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_diner', function(account)
		
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


--RegisterServerEvent('hdiner:Ouvert')
--AddEventHandler('hdiner:Ouvert', function(source)
exports["WaveShield"]:AddEventHandler('hdiner:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin diner', '~y~Ouverture', 'Votre diner Vespucci est ouvert', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "Diner", "OUVERT", 5000, "succes")
	
	end
end)

--RegisterServerEvent('hdiner:Fermer')
--AddEventHandler('hdiner:Fermer', function(source)
exports["WaveShield"]:AddEventHandler('hdiner:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin diner', '~y~Fermeture', 'Votre diner Vespucci est fermé', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "Diner", "Fermer", 5000, "succes")
	
	end
end)

--RegisterNetEvent('hdiner:giveitem')
--AddEventHandler('hdiner:giveitem', function()
exports["WaveShield"]:AddEventHandler('hdiner:giveitem', function(source)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('chickenrush', 1) then
        xPlayer.addInventoryItem('chickenrush', 1)  
	else
	    TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas porter d'avantage")
	end
end)

--RegisterServerEvent('hdiner:exchange')
--AddEventHandler('hdiner:exchange', function()
exports["WaveShield"]:AddEventHandler('hdiner:exchange', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem('chickenrush').count
	if count >= 1 then
        xPlayer.removeInventoryItem('chickenrush', 1)
		xPlayer.addInventoryItem('chikencutrush', 1)
	else 
		--TriggerClientEvent('esx:showNotification', source, "Tu n'as plus assez de matière première")
	end
end)

--RegisterServerEvent('hdiner:sell')
--AddEventHandler('hdiner:sell', function()
exports["WaveShield"]:AddEventHandler('hdiner:sell', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem('chikencutrush').count
	local pay = math.random(10, 10)*count
	local pay2 = math.random(5, 8)*count
	if count >= 1 then
        xPlayer.removeInventoryItem('chikencutrush', count)
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_diner', function(account)
			account.addMoney(pay2)
		end)		
		xPlayer.addAccountMoney('bank', pay)
	else 
		--TriggerClientEvent('esx:showNotification', source, "Tu n'as plus assez de matière première")
	end
		
end)