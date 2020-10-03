local except = require("modutram.helper.except")
local optional = require('modutram.helper.optional')
local t = require('modutram.types')

-- @module modutram.grid_module.Base
local GridModuleBase = {}

local gridTypes = {
    t.TRAM_BIDIRECTIONAL_LEFT,
    t.TRAM_BIDIRECTIONAL_RIGHT,
    t.TRAM_UP,
    t.TRAM_DOWN,
    t.BUS_BIDIRECTIONAL_LEFT,
    t.BUS_BIDIRECTIONAL_RIGHT,
    t.BUS_UP,
    t.BUS_DOWN,
    t.TRAIN,
    t.PLATFORM_NONE,
    t.PLATFORM_ISLAND,
    t.PLATFORM_LEFT,
    t.PLATFORM_RIGHT,
}

function GridModuleBase:new(o)
    o = o or {}
    
    if not o.slot then
        error('Grid Module MUST have a slot attribute')
    end

    o.class = 'Base'
    o.config = o.config or {}
    o.options = o.options or {}
    o.possibleLeftNeighbors = gridTypes
    o.possibleRightNeighbors = gridTypes

    setmetatable(o, self)
    self.__index = self

    return o
end

function GridModuleBase:getSlotId()
    return self.slot.id
end

function GridModuleBase:getModuleType()
    return self.slot.moduleType
end

function GridModuleBase:getType()
    return self.slot.type
end

function GridModuleBase:getGridX()
    return self.slot.gridX
end

function GridModuleBase:getGridY()
    return self.slot.gridY
end

function GridModuleBase:getAbsoluteX()
    return self.slot.xPos / 100
end

function GridModuleBase:getAbsoluteY()
    if not self.config.gridModuleLength then
        return nil
    end

    return self.config.gridModuleLength * self:getGridY()
end

function GridModuleBase:getAbsoluteZ()
    return self.config.baseHeight
end

function GridModuleBase:getOption(key, default)
    return self.options[key] or optional(self.slot:getOptions())[key] or default
end

function GridModuleBase:setOption(key, value)
    self.options[key] = value
end

function GridModuleBase:setOptions(options)
    for key, value in pairs(options) do
        self:setOption(key, value)
    end
end

function GridModuleBase:isBlank()
    return self:getType() == t.VOID
end

function GridModuleBase:isPlatform()
    return false
end

function GridModuleBase:isTrack()
    return false
end

function GridModuleBase:isTram()
    return false
end

function GridModuleBase:isBus()
    return false
end

function GridModuleBase:isTrain()
    return false
end

function GridModuleBase:isRail()
    return self:isTram() or self:isTrain()
end

function GridModuleBase:getXPosInCm()
    return self.slot.xPos
end

function GridModuleBase:getGrid()
    return self.grid
end

function GridModuleBase:hasNeighborLeft()
    return self:getGrid():has(self:getGridX() - 1, self:getGridY())
end

function GridModuleBase:getNeighborLeft()
    return self:getGrid():get(self:getGridX() - 1, self:getGridY())
end

function GridModuleBase:hasNeighborRight()
    return self:getGrid():has(self:getGridX() + 1, self:getGridY())
end

function GridModuleBase:getNeighborRight()
    return self:getGrid():get(self:getGridX() + 1, self:getGridY())
end

function GridModuleBase:hasNeighborTop()
    return self:getGrid():has(self:getGridX(), self:getGridY() + 1)
end

function GridModuleBase:getNeighborTop()
    return self:getGrid():get(self:getGridX(), self:getGridY() + 1)
end

function GridModuleBase:hasNeighborBottom()
    return self:getGrid():has(self:getGridX(), self:getGridY() - 1)
end

function GridModuleBase:getNeighborBottom()
    return self:getGrid():get(self:getGridX(), self:getGridY() - 1)
end

function GridModuleBase:handleTerminals(terminalHandleFunc)
    self.terminalHandleFunc = terminalHandleFunc
end

function GridModuleBase:callTerminalHandleFunc(terminalGroup)
    if self.terminalHandleFunc then
        self.terminalHandleFunc(terminalGroup)
    end
end

return GridModuleBase