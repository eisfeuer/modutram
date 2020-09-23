local Bus = require('modutram.grid_module.Bus')

-- @module modutram.grid_module.BusBidirectionalLeft
local BusBidirectionalLeftClass = {}

function BusBidirectionalLeftClass:new(Bus)
    local BusBidirectionalLeft = Bus
    BusBidirectionalLeft.class = 'BusBidirectionalLeft'

    return BusBidirectionalLeft
end

function BusBidirectionalLeftClass.getParentClass()
    return Bus
end

return BusBidirectionalLeftClass