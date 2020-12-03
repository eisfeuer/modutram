local Transf = require("transf")

return function (result, gridModule)
    local modutram = result.modutram

    table.insert(result.colliders, { 
        type = "BOX",
        transf = Transf.transl({x = gridModule:getAbsoluteX(), y = gridModule:getAbsoluteY(), z = 2}),
        params = {
            halfExtents = {gridModule:getOption("widthInCm", 1) / 200, modutram.config.gridModuleLength / 2, 2},
        }
    })
end