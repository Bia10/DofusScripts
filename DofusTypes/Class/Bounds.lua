-----------------------------
-- Bounds class definition --
-----------------------------
local Bounds = {
    PosX = 0,
    PosY = 0,
    Width = 0,
    Height = 0
}

----------
-- Ctor --
----------
function Bounds:new(thisObj, posX, posY, width, height)
    thisObj = thisObj or {}
    setmetatable(thisObj, self)
    self.__index = self

    self.PosX = posX
    self.PosY = posY
    self.Width = width
    self.Height = height

    return thisObj
end

-------------
-- Methods --
-------------
function Bounds:getArea()
    return self.Height * self.Width
end

return Bounds
