----------------------
-- Area class definition --
----------------------
local Area = {
    Id = 0,
    NameId = 0,
    SuperAreaId = 0,
    ContainHouses = false,
    ContainPaddocks = false,
    Bounds = nil,
    WorldmapId = 0,
    HasWorldMap = false,
    HasSuggestion = false,
}

----------
-- Ctor --
----------
function Area:new(thisObj, id, nameId, superAreaId, containHouses, containPaddocks, bounds, worldmapId, hasWorldMap,
                  hasSuggestion)
    -- if i dont reference thisObj then create new empty table
    thisObj = thisObj or {}
    -- set metatable of thisObj to metatable of this class
    setmetatable(thisObj, self)
    -- if indexing in thisObj metatable fails, index in this class metatable
    self.__index = self

    self.Id = id
    self.NameId = nameId
    self.SuperAreaId = superAreaId
    self.ContainHouses = containHouses
    self.ContainPaddocks = containPaddocks
    self.Bounds = bounds
    self.WorldmapId = worldmapId
    self.HasWorldMap = hasWorldMap
    self.HasSuggestion = hasSuggestion

    return thisObj
end

-------------
-- Methods --
-------------
function Area:getSize()
    return self.Bounds:getArea()
end

function Area:__tostring()
    return "Area Id: " .. self.Id .. ""
end

return Area
