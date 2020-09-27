return function (result, groundFace, fillTexture, strokeTexture)
    table.insert(result.groundFaces, {  
        face = groundFace,
        modes = {
            {
                type = "FILL",
                key = fillTexture or "shared/asphalt_01.gtex.lua"
            },
            {
                type = "STROKE_OUTER",
                key = strokeTexture or "street_border.lua"
            },
        },
    })

    local terrainAlignmentLists = {
        { type = "EQUAL", faces = { groundFace } },
    }

    for i = 1, #terrainAlignmentLists do
        local t = terrainAlignmentLists[i]
        table.insert(result.terrainAlignmentLists, t)
    end
end