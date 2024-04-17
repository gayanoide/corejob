ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'bell', 'bell', 'society_bell', 'society_bell', 'society_bell', {type = 'public'})

--RegisterNetEvent('hbell:bar')
--AddEventHandler('hbell:bar', function(source, item,price)
exports["WaveShield"]:AddEventHandler('hbell:bar', function(source, item,price)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_bell', function(account)
		
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


--RegisterServerEvent('hbell:Ouvert')
--AddEventHandler('hbell:Ouvert', function(source)
exports["WaveShield"]:AddEventHandler('hbell:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin Bell', '~y~Ouverture', 'Votre bell Vespucci est ouvert', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "Cluckin Bell", "OUVERT", 5000, "succes")
	
	end
end)

--RegisterServerEvent('hbell:Fermer')
--AddEventHandler('hbell:Fermer', function(source)
exports["WaveShield"]:AddEventHandler('hbell:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Clubin Bell', '~y~Fermeture', 'Votre bell Vespucci est fermé', 'BURGER_SHOT', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "Cluckin Bell", "Fermer", 5000, "succes")
	
	end
end)

--RegisterNetEvent('hbell:giveitem')
--AddEventHandler('hbell:giveitem', function()
exports["WaveShield"]:AddEventHandler('hbell:giveitem', function(source)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.canCarryItem('chickenrush', 1) then
        xPlayer.addInventoryItem('chickenrush', 1)  
	else
	    TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas porter d'avantage")
	end
end)

--RegisterServerEvent('hbell:exchange')
--AddEventHandler('hbell:exchange', function()
exports["WaveShield"]:AddEventHandler('hbell:exchange', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem('chickenrush').count
	if count >= 1 then
        xPlayer.removeInventoryItem('chickenrush', 1)
		xPlayer.addInventoryItem('chikencutrush', 1)
	else 
		--TriggerClientEvent('esx:showNotification', source, "Tu n'as plus assez de matière première")
	end
end)

--RegisterServerEvent('hbell:sell')
--AddEventHandler('hbell:sell', function()
exports["WaveShield"]:AddEventHandler('hbell:sell', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem('chikencutrush').count
	local pay = math.random(10, 10)*count
	local pay2 = math.random(5, 8)*count
	if count >= 1 then
        xPlayer.removeInventoryItem('chikencutrush', count)
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_bell', function(account)
			account.addMoney(pay2)
		end)		
		xPlayer.addAccountMoney('bank', pay)
	else 
		--TriggerClientEvent('esx:showNotification', source, "Tu n'as plus assez de matière première")
	end
		
end)