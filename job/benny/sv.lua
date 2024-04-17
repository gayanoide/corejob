ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_society:registerSociety', 'benny', 'benny', 'society_benny', 'society_benny', 'society_benny', {type = 'public'})

--RegisterServerEvent('hbenny:Ouvert')
--AddEventHandler('hbenny:Ouvert', function()
exports["WaveShield"]:AddEventHandler('hbenny:Ouvert', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "benny", "OUVERT", 5000, "succes")
	
	end
end)

exports["WaveShield"]:AddEventHandler('hbenny:Fermer', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "benny", "Fermer", 5000, "succes")
	
	end
end)

exports["WaveShield"]:AddEventHandler('hbenny:deplacement', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent("rtx_notify:Notify", xPlayers[i], "benny", "Un dépanneur est disponible en déplacement", 5000, "info")
	end
end)