-- Resource Metadata
fx_version 'cerulean'
game 'gta5'

lua54 'yes'

-- What to run
client_scripts {
    'config.lua',
    'client/cl_*.lua'
} 
server_scripts {
    'config.lua',
    'server/kerosine.lua',
    'server/coke.lua'
} 

shared_scripts {
	"@es_extended/imports.lua",
    '@ox_lib/init.lua'
}