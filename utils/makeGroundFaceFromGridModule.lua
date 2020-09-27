local modulesutil = require("modulesutil")

return function (gridModule, transform)
    local halfWidth = gridModule:getOption('widthInCm', 200) / 200
    local halfLength = gridModule.config.gridModuleLength / 2

    local terrainFace = {
        { halfWidth, halfLength, 0.0, 1.0 },
        {-halfWidth, halfLength, 0.0, 1.0 },
        { -halfWidth, -halfLength, 0.0, 1.0 },
        { halfWidth, -halfLength, 0.0, 1.0 },
    }
    modulesutil.TransformFaces(transform, terrainFace)

    return terrainFace
end