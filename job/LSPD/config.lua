Config                            = {}
Config.DrawDistance               = 25.0
Config.Type = 21
Config.Locale = 'fr'
Config.WebHookPlainte = "https://discord.com/api/webhooks/990330913030287441/BNccD-ZuNrh_hponSLJX_ndCIUVpiyVheQoMAsNtPX0H3o7nng1xNsN5IJRpo5PEqNhB" 
Config.Logs_Fouille = "https://discord.com/api/webhooks/990330913030287441/BNccD-ZuNrh_hponSLJX_ndCIUVpiyVheQoMAsNtPX0H3o7nng1xNsN5IJRpo5PEqNhB"
--Config.Logs_Objets_depot = "https://discord.com/api/webhooks/990330913030287441/BNccD-ZuNrh_hponSLJX_ndCIUVpiyVheQoMAsNtPX0H3o7nng1xNsN5IJRpo5PEqNhB"
--Config.Logs_Objets_retrait = "https://discord.com/api/webhooks/990330913030287441/BNccD-ZuNrh_hponSLJX_ndCIUVpiyVheQoMAsNtPX0H3o7nng1xNsN5IJRpo5PEqNhB"
--Config.Logs_Armes_depot = "https://discord.com/api/webhooks/990330913030287441/BNccD-ZuNrh_hponSLJX_ndCIUVpiyVheQoMAsNtPX0H3o7nng1xNsN5IJRpo5PEqNhB"
--Config.Logs_Armes_retrait = "https://discord.com/api/webhooks/990330913030287441/BNccD-ZuNrh_hponSLJX_ndCIUVpiyVheQoMAsNtPX0H3o7nng1xNsN5IJRpo5PEqNhB"
Config.Logs_PriseFin_Service = "https://discord.com/api/webhooks/1017560076665503874/e4oo-UgzmdWbIAWvz5PFN7N-PUC54XZJmLaHZZ0xur_nyLAsw71eoypx4GwaiH29AIBO" -- Fait
Config.Logs_Amende = "https://discord.com/api/webhooks/990330913030287441/BNccD-ZuNrh_hponSLJX_ndCIUVpiyVheQoMAsNtPX0H3o7nng1xNsN5IJRpo5PEqNhB"
Config.EnableESXIdentity = true
------------------
Config.Grade_Pour_Objets = 0  -- Accès Menu objets 
Config.Grade_Pour_Zone = 5  -- Accès Menu objets 
Config.Grade_Pour_Chien = 4 -- Accès Menu chien 
Config.Grade_Pour_Camera = 2 -- Accès Menu caméra 
Config.Grade_Pour_AvisRecherche = 1 -- Accès Menu adr 
--------------------
Config.Grade_Pour_PPA = 11 -- retirer/donner ppa
------------------

Config.pos = {
    blip = {
        position = {x = -1096.64, y = -849.99, z = 4.88}
    },
    boss = {
        position = {x = 467.89, y = -975.13, z = 35.89}
    },
}

Config.posascenseur = {
    {x= -1096.64, y = -849.99, z = 4.88, name = "-1 Cellules"},
    {x= -1096.64, y = -849.99, z = 10.27, name = "-2 Saisies"},
    {x= -1096.64, y = -849.99, z = 13.69, name = "-3 Armurerie et garage"},
    {x= -1096.64, y = -849.99, z = 19.0, name = "1 Accueil"},
    {x= -1096.64, y = -849.99, z = 26.82, name = "3 Salle de dispatch"},
    {x= -1096.64, y = -849.99, z = 30.76, name = "4 Centre des opérations"},
    {x= -1096.64, y = -849.99, z = 34.37, name = "5 Bureau du Capitaine"},
    {x= -1096.64, y = -849.99, z = 38.24, name = "6 Helipad"}
}

cfg_police = {
    props = {
        {label = "Barrière L.S.P.D", prop = "prop_mp_barrier_02b"},
        {label = "Barrière métal", prop = "ba_prop_battle_barrier_02a"},
        {label = "Route fermé", prop = "prop_barrier_work04a"},
        {label = "Barrière Directionnel", prop = "prop_mp_arrow_barrier_01"},
        {label = "Cone", prop = "prop_roadcone02a"},
        {label = "Herse", prop = "p_ld_stinger_s"},
        {label = "Cone lumière", prop = "prop_air_conelight"},
        {label = "Spot", prop = "prop_worklight_03a"},
        {label = "Fence", prop = "prop_fncsec_03b"},
        {label = "Bloc", prop = "prop_plas_barier_01a"},
        {label = "Slow down", prop = "stt_prop_track_slowdown"}
    }
}