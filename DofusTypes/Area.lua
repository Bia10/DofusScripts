----------------------
-- Area Class definition --
----------------------
Area = {
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

-- Creating an object
Area = Area:new()

-- Calling method
Area:getSize()

-----------------------------
-- Bounds Class definition --
-----------------------------
Bounds = {
    PosX = 0,
    PosY = 0,
    Width = 0,
    Height = 0,
}

----------
-- Ctor --
----------
function Bounds:new(thisObj, posX, posY, Width, height)
    thisObj = thisObj or {}
    setmetatable(thisObj, self)
    self.__index = self

    self.PosX = posX
    self.PosY = posY
    self.Width = Width
    self.Height = height

    return thisObj
end

-------------
-- Methods --
-------------
function Bounds:getArea()
    return self.Height * self.Width
end
