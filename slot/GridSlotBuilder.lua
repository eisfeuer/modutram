local SlotFactory = require('modutram.slot.SlotFactory')

local GridSlotBuilder = {}

function GridSlotBuilder:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function GridSlotBuilder:placeGridSlots(slotConfigRepository)
    local slotFactory = SlotFactory:new{config = self.config}

    if self.grid:isEmpty() then
        return slotFactory:makeAnySlot(slotConfigRepository, 0, 0, 0)
    end

    return {}
end

return GridSlotBuilder