local Transf = require("transf")

return function (result, gridModule)
    local modutram = result.modutram

    table.insert(result.colliders, { 
        type = "BOX",
        transf = Transf.transl({x = gridModule:getAbsoluteX(), y = gridModule:getAbsoluteY(), z = 2}),
        params = {
            halfExtents = {gridModule:getOption("widthInCm", 1) / 200 - 0.0001, modutram.config.gridModuleLength / 2 - 0.0001, 2},
        }
    })
end