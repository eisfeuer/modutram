local optional = require('modutram.helper.optional')
local t = require('modutram.types')

local GridModuleBase = {}

function GridModuleBase:new(o)
    o = o or {}
    
    if not o.slot then
        error('Grid Module MUST have a slot attribute')
    end

    o.config = o.config or {}
    o.options = o.options or {}

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

function GridModuleBase:getXPosInCm()
    return self.slot.xPos
end

return GridModuleBase