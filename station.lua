local Config = require('modutram.config.Config')
local Slot = require('modutram.slot.Slot')
local Grid = require('modutram.grid.Grid')
local GridModuleFactory = require('modutram.grid_module.factory')
local GridSlotBuilder = require('modutram.slot.GridSlotBuilder')
local SlotConfigRepository = require('modutram.slot.SlotConfigRepository')
local optional = require('modutram.helper.optional')

-- @module modutram.station
local Station = {}

function Station:new(o)
    o = o or {}

    o.config = Config:new(o.config)
    o.grid = Grid:new{config = o.config}

    setmetatable(o, self)
    self.__index = self
    return o
end

function Station:bindToResult(result)
    local gridSlotBuilder = GridSlotBuilder:new{grid = self.grid, config = self.config}
    local slotConfigRepository = SlotConfigRepository.makeWithParams(optional(self.paramsFromModLua).modules or {})

    result.modutram = self
    result.models = result.models or {}
    result.slots = gridSlotBuilder:placeGridSlots(slotConfigRepository)

    if #result.models == 0 then
        table.insert(result.models, {
            id = 'asset/icon/marker_question.mdl',
            transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
        })
    end
end

function Station:registerModule(slotId, moduleData)
    local slot = Slot:new({id = slotId, moduleData = moduleData})
    local gridModule = GridModuleFactory.make(slot, self.grid, self.config)

    self.grid:set(gridModule)
    return gridModule
end

function Station:registerAllModules(modulesFromParams)
    for slotId, moduleData in pairs(modulesFromParams) do
        self:registerModule(slotId, moduleData)
    end
end

function Station:getModule(slotId)
    local slot = Slot:new({id = slotId})

    return self.grid:get(slot.gridX, slot.gridY)
end

function Station:getModuleAt(gridX, gridY)
    return self.grid:get(gridX, gridY)
end

function Station:isModuleAt(gridX, gridY)
    return self.grid:has(gridX, gridY)
end

return Station