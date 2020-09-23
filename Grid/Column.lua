-- @module modutram.grid.Column
local Column = {}

function Column:new(o)
    o = o or {}

    local initialModule = o.initialModule
    if not initialModule then
        error ('Column MUST have a initialModule property')
    end

    o.gridX = initialModule:getGridX()
    o.xPos = initialModule:getXPosInCm()
    o.type = initialModule:getType()

    o.topGridY = initialModule:getGridY()
    o.bottomGridY = initialModule:getGridY()

    o.gridModules = {
        [initialModule:getGridY()] = initialModule
    }

    o.initialModule = nil

    setmetatable(o, self)
    self.__index = self

    return o
end

function Column:addGridModule(gridModule)
    self.gridModules[gridModule:getGridY()] = gridModule
    self.topGridY = math.max(self.topGridY, gridModule:getGridY())
    self.bottomGridY = math.min(self.bottomGridY, gridModule:getGridY())
end

function Column:getGridModule(gridY)
    return self.gridModules[gridY]
end

function Column:hasGridModule(gridY)
    return self:getGridModule(gridY) ~= nil
end

return Column