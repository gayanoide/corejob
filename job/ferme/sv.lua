ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'ferme', 'ferme', 'society_ferme', 'society_ferme', 'society_ferme', {type = 'public'})

--RegisterNetEvent('hferme:bar')
--AddEventHandler('hferme:bar', function(item, price)
exports["WaveShield"]:AddEventHandler('hferme:bar', function(source, item, price)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ferme', function(account)
        if account.money >= price then
            if xPlayer.canCarryItem(item, 1) then
                account.removeMoney(price)
                xPlayer.addInventoryItem(item, 1)
                TriggerClientEvent('esx:showNotification', _source, "~g~Achat~w~ effectué !")
            else
                TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas porter d'avantage")
            end
        else
            TriggerClientEvent('esx:showNotification', _source, "Votre société n'a plus d'argent")
        end
    end)
end)


--RegisterServerEvent('hferme:Ouvert')
--AddEventHandler('hferme:Ouvert', function()
exports["WaveShield"]:AddEventHandler('hferme:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'L\'ferme', '~y~Ouverture', 'Votre club l\'ferme est ouvert', 'ferme', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "La Bonne Miche", "OUVERT", 5000, "succes")
	
	end
end)

--RegisterServerEvent('hferme:Fermer')
--AddEventHandler('hferme:Fermer', function()
exports["WaveShield"]:AddEventHandler('hferme:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		--TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'L\'ferme', '~y~Fermeture', 'Votre club l\'ferme est fermé', 'ferme', 2)
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "La Bonne Miche", "FERMER", 5000, "succes")
	
	end
end)

--RegisterNetEvent('hferme:giveitem')
--AddEventHandler('hferme:giveitem', function()
exports["WaveShield"]:AddEventHandler('hferme:giveitem', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    	if xPlayer.canCarryItem('orange', 1) then
        	xPlayer.addInventoryItem('orange', 1)        
		else
	    	--TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas porter d'avantage")
		end
end)

--RegisterServerEvent('hferme:exchange')
--AddEventHandler('hferme:exchange', function()
exports["WaveShield"]:AddEventHandler('hferme:exchange', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem('orange').count
	if count >= 2 then
        xPlayer.removeInventoryItem('orange', 2)
		xPlayer.addInventoryItem('jusorange', 1)
	else 
		--TriggerClientEvent('esx:showNotification', source, "Tu n'as plus assez de matière première")
	end
end)

--RegisterServerEvent('hferme:sell')
--AddEventHandler('hferme:sell', function()
exports["WaveShield"]:AddEventHandler('hferme:sell', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem('jusorange').count
	local pay = math.random(10, 10)*count
	local pay2 = math.random(5, 8)*count
	if count >= 1 then
        xPlayer.removeInventoryItem('jusorange', count)
		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ferme', function(account)
			account.addMoney(pay2)
		end)
		xPlayer.addAccountMoney('bank', pay)
	
	else 
		--TriggerClientEvent('esx:showNotification', source, "Tu n'as plus assez de matière première")
	end
		
end)
