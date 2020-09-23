# modutram
Modular Tram Station Framework for Transport Fever 2

## Build own module

There are two main module types.  
Grid modules are mainly track and platform modules.  
Asset modules are modules you are placing on other modules. 

A module will be defined by it's type. The type of every module must start with `modutram`. If your module is for a station with specific namespace you have to append the namespace. E.g. when the station has the namespace `berlin` your module type must start with `modutram_berlin`.

After the modutram and namespace prefix the type must include the slot type. See at the table below which slot type you need for your module.
Example `modutram_asset` or `modutram_berlin_asset` for a specific namespace.

### Grid Modules
Grid module must have the module width in cm at the and of the type string. The width postfix must have the format `280cm`.
The whole type looks like this: `modutram_berlin_tram_up_280cm`

### Asset Module
Asset and decoration modules may have a postfix when you want to specify special asset or decoration slots at your modules.
For example you can define a type `modutram_asset_bench` if you have a specific slot for benches.

### List of slot types
| Module Type  | Slot type                | constant                   | id | description                                         |
|:------------:|:------------------------:|:--------------------------:|:--:|:--------------------------------------------------- |
| Grid Module  | tram_bidirectional_left  | t.TRAM_BIDIRECTIONAL_LEFT  | 8  | Tram Tracks in both directions (left hand traffic)  |
| Grid Module  | tram_bidirectional_right | t.TRAM_BIDIRECTIONAL_RIGHT | 9  | Tram Tracks in both directions (right hand traffic) |
| Grid Module  | tram_up                  | t.TRAM_UP                  | 10 | One way tram track up                               |
| Grid Module  | tram_down                | t.TRAM_DOWN                | 11 | One way tram track down                             |
| Grid Module  | bus_bidirectional_left   | t.BUS_BIDIRECTIONAL_LEFT   | 16 | Bus Tracks in both directions (left hand traffic)   |
| Grid Module  | bus_bidirectional_right  | t.BUS_BIDIRECTIONAL_LEFT   | 16 | Bus Tracks in both directions (left hand traffic)   |
| Grid Module  | bus_up                   | t.BUS_UP                   | 18 | One way bus track up                                |
| Grid Module  | bus_down                 | t.BUS_DOWN                 | 19 | One way bus track down                              |
| Grid Module  | train                    | t.TRAIN                    | 24 | Train track                                         |
| Grid Module  | platform_none            | t.PLATFORM_NONE            | 32 | Platform without waiting lanes (passengerEdge)      |
| Grid Module  | platform_island          | t.PLATFORM_ISLAND          | 33 | Platform with stop at both sides                    |
| Grid Module  | platform_left            | t.PLATFORM_LEFT            | 34 | Platform with stop at the left side                 |
| Grid Module  | platform_right           | t.PLATFORM_RIGHT           | 35 | Platform with stop at the right side                |
| Asset Module | asset                    | t.ASSET                    | 40 | Asset Module                                        |
| Asset Module | decoration               | t.DECORATION               | 48 | Decoration Module ("Asset" placed on asset module)  |

### Access to modutram
You have access to modutram from your module by calling
```lua
result.modutram
```
in your module updateFn().

### Access to current module
You have access to the current module in your module file by calling the `getModule()` with the given `slotId` as param
```lua
updateFn = function(result, transform, tag, slotId)
    local module = result.modutram:getModule(slotId)
end
```

## Build own tram station

If your modules doesn't to the standard station, you can define a station with our own namespace and change the properties that you need to.

Your module types must start with the prefix `modutra_your_namespace`.  
In following examples I use the namespace `my_tram_station`

The updateFn() of your construction has to be empty, because it will be overriden by postRunFn().
```lua
-- ...
updateFn = function() {
    
}
-- ...
```

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

Create a file `construction/station/tram/my_tram_station`.script` and put folliwing code in it
```lua
local Modutram = require('modutram.modutram')

function data()
    return {
        updateFn = function (params, paramsFromModLua)
            local config = {
                gridModuleLength = 18, -- length (size on y axis) of a module
                baseHeight = 0, -- offset of the ground level compared to the ground level of the game
                -- @todo put config example here
            }

            local result = { }
            Modutram.initialize(params, paramsFromModLua, config):bindToResult(result)

            return result
        end
    }
end
```