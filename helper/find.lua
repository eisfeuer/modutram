return function (affectedTable, match)
    for key, value in pairs(affectedTable) do
        if value == match then
            return key
        end
    end

    return nil
end