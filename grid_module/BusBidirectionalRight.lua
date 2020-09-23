local Bus = require('modutram.grid_module.Bus')

-- @module modutram.grid_module.BusBidirectionalRight
local BusBidirectionalRightClass = {}

function BusBidirectionalRightClass:new(Bus)
    local BusBidirectionalRight = Bus
    BusBidirectionalRight.class = 'BusBidirectionalRight'

    return BusBidirectionalRight
end

function BusBidirectionalRightClass.getParentClass()
    return Bus
end

return BusBidirectionalRightClass