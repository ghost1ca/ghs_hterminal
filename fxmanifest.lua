fx_version 'cerulean'
games { 'gta5' }

author 'Ghost1ca <ghostica@usp.ro>'
description 'Hacking is the best'
version '1.0.0'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/style.css",
    "html/script.js"
}

shared_scripts {
    'shared/commands.lua',
    'shared/config.lua',
    'shared/functions.lua'
}