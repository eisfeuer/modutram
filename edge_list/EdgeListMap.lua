local EdgeListMap = {}

function EdgeListMap:new(o)
    if not (o and o.edgeLists) then
        error("Required Property edgeLists is missing")
    end

    setmetatable(o, self)
    self.__index = self

    self.edgeListMap = {}

    for _, edgeList in ipairs(o.edgeLists) do
        if edgeList.type and edgeList.params and edgeList.params.type then
            if edgeList.params.catenary ~= nil then
                self:registerEdgeList(edgeList, edgeList.type, edgeList.params.type, edgeList.params.catenary)
            elseif edgeList.params.tramTrackType then
                self:registerEdgeList(edgeList, edgeList.type, edgeList.params.type, edgeList.params.tramTrackType)
            end
        end
    end

    return o
end

function EdgeListMap:registerEdgeList(edgeList, edgeListType, typeParam, catenaryOrTram)
    if not self.edgeListMap[edgeListType] then
        self.edgeListMap[edgeListType] = {}
    end

    if not self.edgeListMap[edgeListType][typeParam] then
        self.edgeListMap[edgeListType][typeParam] = {}
    end

    self.edgeListMap[edgeListType][typeParam][catenaryOrTram] = edgeList
end

function EdgeListMap:getTypeAndParamKey(paramValue)
    if paramValue == true or paramValue == false then
        return 'TRACK', 'catenary'
    end

    if paramValue == 'YES' or paramValue == 'NO' or paramValue == 'ELECTRIC' then
        return 'STREET', 'tramTrackType'
    end

    error('No supported catenaryOrTram param given. The param MUST be true/false for Track types or YES/NO/ELECTRIC for Street types')
end

function EdgeListMap:getEdgeList(edgeListType, typeParam, catenaryOrTram)
    if not self.edgeListMap[edgeListType] then
        return nil
    end

    if not self.edgeListMap[edgeListType][typeParam] then
        return nil
    end

    return self.edgeListMap[edgeListType][typeParam][catenaryOrTram]
end

function EdgeListMap:createEdgeList(edgeListType, typeParam, catenaryOrTram, paramKey)
    local newEdgeList = {
        type = edgeListType,
        params = {
            ["type"] = typeParam,
            [paramKey] = catenaryOrTram
        },
        edges = {},
        snapNodes = {},
        tag2nodes = {},
        freeNodes = {}
    }

    table.insert(self.edgeLists, newEdgeList)
    self:registerEdgeList(newEdgeList, edgeListType, typeParam, catenaryOrTram)

    return newEdgeList
end

function EdgeListMap:getOrCreateEdgeList(typeParam, catenaryOrTram)
    local edgeListType, paramKey = self:getTypeAndParamKey(catenaryOrTram)
    return self:getEdgeList(edgeListType, typeParam, catenaryOrTram) or self:createEdgeList(edgeListType, typeParam, catenaryOrTram, paramKey)
end

function EdgeListMap:getEdgeLists()
    return self.edgeLists
end

function EdgeListMap:getIndexOfFirstNodeInEdgeList(typeParam, catenaryOrTram)
    local edgeListType, paramKey = self:getTypeAndParamKey(catenaryOrTram)
    local nodesBeforFirstNode = 0

    for i, edgeList in ipairs(self.edgeLists) do
        if edgeList.type == edgeListType and edgeList.params.type == typeParam and edgeList.params[paramKey] == catenaryOrTram then
            return nodesBeforFirstNode
        end
        nodesBeforFirstNode = nodesBeforFirstNode + #edgeList.edges
    end

    return 0
end

return EdgeListMap