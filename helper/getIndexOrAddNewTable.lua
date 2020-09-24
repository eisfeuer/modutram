return function (affectedTable, index)
    if affectedTable[index] then
        return affectedTable[index]
    end

    local subtable = {}
    affectedTable[index] = subtable

    return subtable
end