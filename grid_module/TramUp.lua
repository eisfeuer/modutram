local Tram = require('modutram.grid_module.Tram')

-- @module modutram.grid_module.TramUp
local TramUpClass = {}

function TramUpClass:new(Tram)
    local TramUp = Tram
    TramUp.class = 'TramUp'

    return TramUp
end

function TramUpClass.getParentClass()
    return Tram
end

return TramUpClass