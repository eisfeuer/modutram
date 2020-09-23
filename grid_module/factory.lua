local t = require("modutram.types")
local GridModule = require("modutram.grid_module.Base")

-- @module modutram.grid_module.factory
local factory = {}

local classes = {
    [t.VOID] = GridModule,
    [t.TRAM_BIDIRECTIONAL_LEFT] = require("modutram.grid_module.TramBidirectionalLeft"),
    [t.TRAM_BIDIRECTIONAL_RIGHT] = require("modutram.grid_module.TramBidirectionalRight"),
    [t.TRAM_UP] = require("modutram.grid_module.TramUp"),
    [t.TRAM_DOWN] = require("modutram.grid_module.TramDown"),
    [t.BUS_BIDIRECTIONAL_LEFT] = require("modutram.grid_module.BusBidirectionalLeft"),
    [t.BUS_BIDIRECTIONAL_RIGHT] = require("modutram.grid_module.BusBidirectionalRight"),
    [t.BUS_UP] = require("modutram.grid_module.BusUp"),
    [t.BUS_DOWN] = require("modutram.grid_module.BusDown"),
    [t.TRAIN] = require("modutram.grid_module.Train"),
    [t.PLATFORM_NONE] = require("modutram.grid_module.PlatformNone"),
    [t.PLATFORM_ISLAND] = require("modutram.grid_module.PlatformIsland"),
    [t.PLATFORM_LEFT] = require("modutram.grid_module.PlatformLeft"),
    [t.PLATFORM_RIGHT] = require("modutram.grid_module.PlatformRight"),
}

function factory.getClass(slot_type)
    return classes[slot_type]
end

function factory.make(slot, grid, config)
    local gridModuleClass = factory.getClass(slot.type)

    local rootClass = GridModule:new{
        slot = slot,
        grid = grid,
        config = config
    }

    if slot.type == t.VOID then
        return rootClass
    end

    if slot.type == t.TRAIN then
        return gridModuleClass:new(rootClass)
    end

    local parentClass = gridModuleClass.getParentClass():new(rootClass)

    return gridModuleClass:new(parentClass)
end

return factory