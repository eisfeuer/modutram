local Station = require('modutram.Station')

local Modutram = {}

function Modutram.initialize(params, paramsFromModLua, config)
    return Station:new{}
end

return Modutram