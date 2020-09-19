# modutram
Modular Tram Station Framework for Transport Fever 2

## Build own tram station

If your modules doesn't to the standard station, you can define a station with our own namespace and change the properties that you need to.

Your module types must start with the prefix `modutra_your_namespace`.  
In following examples I use the namespace `my_tram_station`

To create the nessecarry modul list you must add this code to your mod.lua.
```lua
local modulesForMyTramStation = {}
local modulesInGame = api.res.moduleRep.getAll()

for _, moduleFileName in ipairs(modulesInGame) do
    local module = api.res.moduleRep.get(api.res.moduleRep.find(moduleFileName))
    if ModuleRepository.isModutramItem(module, 'my_tram_station') then
        table.insert(modulesForMyTramStation, ModuleRepository.convertModule(module, 'my_tram_station'))
    end
end

local motrasStation = api.res.constructionRep.get(api.res.constructionRep.find('station/tram/my_tram_station.con'))
motrasStation.updateScript.fileName = "construction/station/tram/my_tram_station.updateFn"
motrasStation.updateScript.params = {modules = modulesForMyTramStation}
```