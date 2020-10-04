local Slot = require("modutram.slot.Slot")

local GridModuleBlueprint = {}

function GridModuleBlueprint:new(o)
    o = o or self

    if not o.slotType then
        error("GridModuleBlueprint object MUST have a slotType attribute")
    end
    if not o.moduleName then
        error("GridModuleBlueprint object MUST have a moduleName attribute")
    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function GridModuleBlueprint:place(result, xPos, gridX, gridY)
    result[Slot.makeId({type = self.slotType, gridX = gridX, gridY = gridY, xPos = xPos})] = self.moduleName
    if self.assets then
        self.assets:place(result, gridX, gridY)
    end
end

return GridModuleBlueprint