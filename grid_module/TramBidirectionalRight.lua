local Tram = require('modutram.grid_module.Tram')

-- @module modutram.grid_module.TramBidirectionalRight
local TramBidirectionalRightClass = {}

function TramBidirectionalRightClass:new(Tram)
    local TramBidirectionalRight = Tram
    TramBidirectionalRight.class = 'TramBidirectionalRight'

    return TramBidirectionalRight
end

function TramBidirectionalRightClass.getParentClass()
    return Tram
end

return TramBidirectionalRightClass