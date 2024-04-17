shared_script '@WaveShield/resource/waveshield.lua' --this line was automatically written by WaveShield


fx_version 'adamant'

game 'gta5'

dependencies {
    'es_extended'
}

shared_script {
    "@es_extended/imports.lua",


    "/**/config.lua",
}


client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    '@es_extended/locale.lua',

	'/**/cl.lua',
	'/**/cl_rush.lua',
	'/**/cl_boss.lua',

    '/benny/towing.lua',

    '/LSES/client/assenseur.lua',
    '/LSES/client/wheelchair.lua',
    '/LSES/config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',
    
    '/**/sv.lua',
}




files {
    '/LSES/data/*.meta',
    '/LSES/data/*.xml',
    '/LSES/data/*.dat',
    '/LSES/data/*.ytyp',
}


data_file 'HANDLING_FILE'            '/LSES/data/handling*.meta'
data_file 'VEHICLE_LAYOUTS_FILE'    '/LSES/data/vehiclelayouts*.meta'
data_file 'VEHICLE_METADATA_FILE'    '/LSES/data/vehicles*.meta'
data_file 'CARCOLS_FILE'            '/LSES/data/carcols*.meta'
data_file 'VEHICLE_VARIATION_FILE'    '/LSES/data/carvariations*.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' '/LSES/data/*unlocks.meta'
data_file 'PTFXASSETINFO_FILE' '/LSES/data/ptfxassetinfo.meta'

data_file 'DLC_ITYP_REQUEST' '/LSES/stream/propsfivem/vw_prop_vw_casino_art_02.ytyp'

