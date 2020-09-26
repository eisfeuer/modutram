local SlotFactory = require('modutram.slot.SlotFactory')

local GridSlotBuilder = {}

function GridSlotBuilder:new(o)
    o = o or {}
    setmetatable(o, self)

    self.__index = self
    return o
end

function GridSlotBuilder:placeGridSlots(slotConfigRepository)
    if self.grid:isEmpty() then
        local slotFactory = SlotFactory:new{config = self.config}
        return slotFactory:makeAnySlot(slotConfigRepository, 0, 0, 0)
    end

    local slotCollection = {}

    self.grid:eachColumn(function (column)
        self:placeGridSlotsFromColumn(column, slotConfigRepository, slotCollection)
        
        if column.gridX > 0 then
            local neighborColumnGridX = column.gridX + 1

            if not self.grid:hasColumn(neighborColumnGridX) then
                self:placeGridSlotsRightFromColumn(column, slotConfigRepository, slotCollection)
            end
        elseif column.gridX < 0 then
            local neighborColumnGridX = column.gridX - 1

            if not self.grid:hasColumn(neighborColumnGridX) then
                self:placeGridSlotsLeftFromColumn(column, slotConfigRepository, slotCollection)
            end
        else
            if not self.grid:hasColumn(column.gridX - 1) then
                self:placeGridSlotsLeftFromColumn(column, slotConfigRepository, slotCollection)
            end
            if not self.grid:hasColumn(column.gridX + 1) then
                self:placeGridSlotsRightFromColumn(column, slotConfigRepository, slotCollection)
            end
        end
    end)

    return slotCollection
end

function GridSlotBuilder:placeGridSlotsFromColumn(column, slotConfigRepository, slotCollection)
    local slotFactory = SlotFactory:new{config = self.config}
    local placeSlotPositions = {}

    -- place already existing slots
    column:eachGridModule(function (gridModule)
        placeSlotPositions[gridModule:getGridY()] = true
        table.insert(slotCollection, slotFactory:makeSlotAtGridModule(slotConfigRepository, gridModule))
    end)

    -- place top/bottom neighbor slotConfigRepository
    column:eachGridModule(function (gridModule)
        local gridYBelow = gridModule:getGridY() - 1
        local gridYAbove = gridModule:getGridY() + 1

        if not placeSlotPositions[gridYBelow] then
            placeSlotPositions[gridYBelow] = true
            for _, slot in pairs(slotFactory:makeSlotsBelowGridModule(slotConfigRepository, gridModule)) do
                table.insert(slotCollection, slot)
            end
        end

        if not placeSlotPositions[gridYAbove] then
            placeSlotPositions[gridYAbove] = true
            for _, slot in pairs(slotFactory:makeSlotsAboveGridModule(slotConfigRepository, gridModule)) do
                table.insert(slotCollection, slot)
            end
        end
    end)
end

function GridSlotBuilder:placeGridSlotsLeftFromColumn(column, slotConfigRepository, slotCollection)
    local slotFactory = SlotFactory:new{config = self.config}

    column:eachGridModule(function (gridModule)
        for _, slot in pairs(slotFactory:makeSlotsLeftFromGridModule(slotConfigRepository, gridModule)) do
            table.insert(slotCollection, slot)
        end
    end)
end

function GridSlotBuilder:placeGridSlotsRightFromColumn(column, slotConfigRepository, slotCollection)
    local slotFactory = SlotFactory:new{config = self.config}

    column:eachGridModule(function (gridModule)
        for _, slot in pairs(slotFactory:makeSlotsRightFromGridModule(slotConfigRepository, gridModule)) do
            table.insert(slotCollection, slot)
        end
    end)
end

return GridSlotBuilder