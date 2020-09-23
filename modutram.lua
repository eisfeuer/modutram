local Station = require('modutram.Station')

local Modutram = {}

function Modutram.initialize(params, paramsFromModLua, config)
    local station = Station:new{}

    station:registerAllModules(params.modules)

    return station
end

return Modutram