-----------------------------
-- Effect zone class definition --
-----------------------------
EffectZone = {
    Id = 0,
    RawDisplayZone = "",
    IsDefaultPreviewZoneHidden = "",
    CasterMask = "",
    RawActivationZone = "",
    ActivationMask = ""
}

----------
-- Ctor --
----------
function EffectZone:new(thisObj, id, rawDisplayZone, isDefaultPreviewZoneHidden, casterMask, rawActivationZone,
                        activationMask
)
    thisObj = thisObj or {}
    setmetatable(thisObj, self)
    self.__index = self

    self.Id = id
    self.RawDisplayZone = rawDisplayZone
    self.IsDefaultPreviewZoneHidden = isDefaultPreviewZoneHidden
    self.CasterMask = casterMask
    self.RawActivationZone = rawActivationZone
    self.ActivationMask = activationMask

    return thisObj
end
