local characterEquipment = {}

characterEquipment.Slots = {
    { SlotIndex = 0, SlotNameEn = "Amulet" },
    { SlotIndex = 1, SlotNameEn = "Weapon" },
    { SlotIndex = 2, SlotNameEn = "Ring Left" },
    { SlotIndex = 3, SlotNameEn = "Belt" },
    { SlotIndex = 4, SlotNameEn = "Ring Right" },
    { SlotIndex = 5, SlotNameEn = "Boots" },
    { SlotIndex = 6, SlotNameEn = "Hat" },
    { SlotIndex = 7, SlotNameEn = "Cape" },
    { SlotIndex = 8, SlotNameEn = "Pet" },
    { SlotIndex = 9, SlotNameEn = "First Dofus Slot" },
    { SlotIndex = 10, SlotNameEn = "Second Dofus Slot" },
    { SlotIndex = 11, SlotNameEn = "Third Dofus Slot" },
    { SlotIndex = 12, SlotNameEn = "Fouth Dofus Slot" },
    { SlotIndex = 13, SlotNameEn = "Fifth Dofus Slot" },
    { SlotIndex = 14, SlotNameEn = "Sixth Dofus Slot" },
    { SlotIndex = 15, SlotNameEn = "Shield" },
    { SlotIndex = 16, SlotNameEn = "Mount" }
}

characterEquipment.ItemType = {
    BELT = 10
}

function characterEquipment.SlotNameToIndex(slotName)
    for _, value in pairs(characterEquipment.Slots) do
        if value.SlotNameEn == slotName then
            return value.SlotIndex
        end
    end
end

function characterEquipment.GetNameFromGid(itemGid)
    return inventory:itemNameId(itemGid)
end

function characterEquipment.HasItem(itemGid)
    return inventory:itemCount(itemGid) > 0
end

function characterEquipment.GetSlotNameFromType(itemGid)
    if inventory:itemTypeId(itemGid) == characterEquipment.ItemType.BELT then
        for key, value in pairs(characterEquipment.Slots) do
            if characterEquipment.Slots[key].SlotIndex == 3 then
                return characterEquipment.Slots[key].SlotNameEn
            end
        end
    end
end

function characterEquipment.CanEquip(itemGid, equpmentSlotName)
    local itemLevelRequirement = inventory:itemLevelId(itemGid)
    local playerLevel = character:level()
    --local isEquipmentSlotUsable = characterEquipment.IsSlotUsable(equpmentSlotName)

    return characterEquipment.HasItem(itemGid) and playerLevel >= itemLevelRequirement
end

function characterEquipment.EquipIntoSlot(itemGid, equpmentSlotName)
    local equpmentSlotIndex = characterEquipment.SlotNameToIndex(equpmentSlotName)

    if inventory:equipItem(itemGid, equpmentSlotIndex) == true then
        global:printMessage("[CharacterEquipment] equiped item: " .. itemGid .. " into slot: " .. equpmentSlotName)
        return
    end

    global:printMessage("[CharacterEquipment] failed to equip item: " ..
        itemGid .. " into slot: " .. equpmentSlotName)
end

function characterEquipment.EquipMultipleItems(itemsDict)
    for key, _ in pairs(itemsDict) do
        if characterEquipment.CanEquip(itemsDict[key].ItemGid, itemsDict[key].SlotName) then
            characterEquipment.EquipIntoSlot(itemsDict[key].ItemGid, itemsDict[key].SlotName)
        end
    end
end

return characterEquipment
