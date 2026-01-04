fx_version 'cerulean'
game 'gta5'

author 'Aapoxz'
description 'Simppeli Autokauppa'
version '1.2.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'oxmysql',
    'ox_target'
}
