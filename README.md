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
updateFn = function(result, transform, tag, slotId)
    local modutram = result.modutram
end
```
in your module updateFn().

### Access to modules

#### Access to current module
You have access to the current module in your module file by calling the `getModule()` with the given `slotId` as param
```lua
updateFn = function(result, transform, tag, slotId)
    local module = result.modutram:getModule(slotId)
end
```

#### Access to neighbor modules
You will get access to the neighbor modules by using following methods
```
updateFn = function(result, transform, tag, slotId)
    local module = result.modutram:getModule(slotId)

    local leftNeightbor = module:getNeighborLeft() -- left from current module
    local rightNeighbor = module:getNeighborRight() -- right from current module
    local neighborTop = module:getNeighborTop() -- above current module
    local neighborBottom = module:getNeighborBottom() -- below current module

    -- checking whether there is a neighbor
    module:hasNeighborLeft() -- false in this case
    module:hasNeighborRight() -- false in this case
    module:hasNeighborTop() -- false in this case
    module:hasNeighborBottom() -- false in this case
end
```

#### Access to any module
You will get access to any module by grid coordinates

```
-- getting the module which is three steps left from current module
updateFn = function(result, transform, tag, slotId)
    local module = result.modutram:getModule(slotId)

    local otherModule = result.modutram:getModuleAt(module:getGridX() - 3, module:getGridY())

    -- checking for a module at grid coordinate
    result.modutram:isModuleAt(module:getGridX() - 3, module:getGridY()) -- false in this case
end
```

#### Get module from coorinate with no existing module
If you will access to a module which not exists via neighbor function or `getModuleAt()` you will get a void module which is like a dummy.
You can use the neighbor function like a normal module

To check whether there is a void module you can call `module:isBlank()`

### Tracks and Streets
ATTENTION: Don't add tracks or street in the `handleTerminals()` or `handleLanes()` function.

#### Streets
To add a street to you module, you can use the funtion `modutram:addStreet(streetType, tram, edges, relativeSnapNodes)`
Params:
  streetType: street lua file (e.g. 'country_new_small.lua'),
  tram: 'YES', 'NO', or 'ELECTRIC' - Tram rails on the street
  edges: street edges (see the [official modding documentation](https://www.transportfever2.com/wiki/doku.php?id=modding:constructionbasics#edge_lists) for more details)
  relativeSnapNodes (snap node relative to your own nodes - snap node of 0 means the first node of your edges)

#### Tracks
To add tracks to your module, you can use the function `modutram:addTrack(trackType, catenary, edges, relativeSnapNodes)`
Params:
  trackType: rail track lua file (e.g. 'high_speed.lua'),
  catenary: true or false - tracks has catenary
  edges: street edges (see the [official modding documentation](https://www.transportfever2.com/wiki/doku.php?id=modding:constructionbasics#edge_lists) for more details)
  relativeSnapNodes (snap node relative to your own nodes - snap node of 0 means the first node of your edges)

### Lanes and Terminals
Lanes are models with pathes for road vehicles (including tram), passengers and cargo. How lane models structured and works you can see in the [official transport fever 2 modding documentation](https://www.transportfever2.com/wiki/doku.php?id=modding:resourcetypes:mdl#transport_network_provider).
I recommmend to separate lane models from "real" models because lanes are place conditionalle how modules are placed.

Terminals are lane models which has a vehicle node (node where a vehicle stops), passenger edge (edge where passenger waits), passenger node (node where the passengers exits a vehicle) or combined.

Modutram offers two function to handle lanes and terminals

#### handleTerminals
The `handleTerminals()` function will be called when you module is part of a terminal group. A terminal group include the module where a vehicle stops and all modules where passengers leaves the vehicle or are waiting for it.
The `handleTerminals()` function has one parameter `terminalGroup`. Terminal Models MUST to be added via the `terminalGroup` model. Otherwise there won't be bind each other to a valid terminal group. 

##### Properties
The `terminalGroup` has three properties:
- trackDirection ('left' or 'right'): relevant for platforms - Direction of the current handled tracks - the `handleTerminals()` my be called twice for each trackDirection on islandPlatforms.
- platformDirection ('left' or 'right'): relevant for tracks -  Direction of the current handled platform - the `handleTerminals()` my be called twice for each track on bidirectional track modules.
- vehicleStopAlignment ('top' or 'middle'): relevant for tracks - Position of the stop node relative to the track module to create a stop node at the center of the whole terminal group.

##### adding passenger and cargo terminals
To add a passenger or a cargo terminal you have to call `terminalGroup:addTerminalModel(modelId, modelTransformation, modelTerminalId)` on a platform module
params:
  modelId: Id (filename of the mdl file) of the terminal model
  transformation: tranformation matrix (pivot center of the station) of the terminal model
  modelTerminalId (optional, default = 0): Id of the terminal defined in the terminal model
Return: position in the result.models (starting from 0)

Example
```lua
module:handleTerminals(function (terminalGroup)
    terminalGroup:addTerminalModel('station/tram/modular_tram_station/path/passenger_terminal.mdl', transform)
end)
```

You can use an existing model as terminal using `terminalGroup:attachTerminal(modelPosition, modelTerminalId)`
params:
  modelPosition: position of the model in the result.models (starting from 0)
  modelTerminalId (optional, default = 0): Id of the terminal defined in the terminal model

##### adding vehicle terminals
To add a vehicle terminal you have to call `terminalGroup:addVehicleTerminalModel(modelId, modelTransformation, modelTerminalId)` on a track module.
The pareters are the same as passenger/cargo modules

Example:
```lua
module:handleTerminals(function (terminalGroup)
    if terminalGroup.vehicleStopAlignment == 'top' then
        terminalGroup:addVehicleTerminalModel("station/tram/modular_tram_station/path/tram_stop_top.mdl", transform)
    else
        terminalGroup:addVehicleTerminalModel("station/tram/modular_tram_station/path/tram_stop_middle.mdl", transform)
    end
end)
```

You can use an existing model as vehicle terminal using `terminalGroup:attachVehicleTerminal(modelPosition, modelTerminalId)`
The pareters are the same as passenger/cargo modules

##### adding combined terminals
To add a vehicle and passenger/cargo terminal you can call `terminalGroup:addVehicleAndPassengerTerminalModel(modelId, modelTransformation, modelTerminalId)` (Parameters like the other above)

#### adding tracks
ATTENTION don't create tracks in the handleTerminals() function. It may crash the game

the `addTrack()` function returns an index. This index is the first node of the passed in edges.
You can use this index to add a vehicleNode on this track.

To add a vehicle node use `terminalGroup:attachVehicleTrackNode(edgeListType, catenaryOrTram, nodeIndex)`
Params
- edgeListType: lua file of track or street (e.g. high_speed.lua)
- catenaryOrTram: true or false if track; 'NO', 'YES', 'ELECTRIC' if street
- nodeIndex: node index (returned by the `addTrack()`/`addStreet()` function)

If you want to add the first node of your edges add the node position to the index.

Example:
```lua
local nodeIndex = modutram:addTrack("high_speed.lua", true, {
    {{-10, 0, 0}, {10, 0, 0,}},
    {{0, 0, 0}, {10, 0, 0,}},

    {{0, 0, 0}, {10, 0, 0,}}, -- node to attach
    {{10, 0, 0}, {10, 0, 0,}},
})

module:handleTerminals(function (terminalGroup)
    terminalGroup:attachVehicleTrackNode("high_speed.lua", true, nodeIndex + 2)
end)
```

##### disable terminal handling
You can disable terminal handling for you module a track or platform by adding 'hasTerminals = false' to the modutram metradata.

```
metadata = {
    modutram = {
        hasTerminals = false
    }
},
```

#### handleLanes()
The `handleLanes()` function will be called in all grid modules which are not part of a terminal. These models will be added at the normal way by useing the addModelFn().

### Utils
Utils are tiny various functions which make module building easier.

#### makeGroundFaceFromGridModule
`local makeGroundFaceFromGridModule = require("modutram.utils.makeGroundFaceFromGridModule")`

Makes a ground face (necessary for groundFaces and terrainAlignment). The size of the ground face is the size of grid module.
Params:
  `gridModule`: Module which position and sizes are should be used for
  `transform`: Module pivot point transformation
Return: the ground face (as table)

```
local module = result.modutram:getModule(slotId)
local groundFace = makeGroundFaceFromGridModule(module, transform)
```

#### makeLot
`local makeLot = require("modutram.utils.makeLot")`

Makes ground faces and terraign alignment and adds it to the result table
Params:
  `result`: Result table to add
  `groundFace`: Ground face to create the lot
  `fillTexture`(optional): Ground Texture for the plain
  `strokeTexture`(optional): Ground Texture for the stroke

```
local module = result.modutram:getModule(slotId)
local groundFace = makeGroundFaceFromGridModule(module, transform)
makeLot(result, groundFace, "shared/asphalt_01.gtex.lua", "street_border.lua")
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