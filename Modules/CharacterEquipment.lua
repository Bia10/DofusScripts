local characterEquipment = {}

characterEquipment.Slots = {
    { SlotIndex = 0, SlotNameEn = "Amulet" },
    { SlotIndex = 1, SlotNameEn = "Weapon" },
    { SlotIndex = 2, SlotNameEn = "Ring Left" },
    { SlotIndex = 3, SlotNameEn = "Belt" },
}

function characterEquipment.SlotNameToIndex(slotName)
    for _, value in pairs(characterEquipment.Slots) do
        if value.SlotNameEn == slotName then
            return value.SlotIndex
        end
    end
end

function characterEquipment.HasItem(itemGid)
    if inventory:itemCount(itemGid) > 0 then
        return true
    end

    return false
end

function characterEquipment.EquipIntoSlot(itemGid, equpmentSlotName)
    if characterEquipment.HasItem(itemGid) then
        local equpmentSlotIndex = characterEquipment.SlotNameToIndex(equpmentSlotName)

        if inventory:equipItem(itemGid, equpmentSlotIndex) == true then
            global:printMessage("[CharacterEquipment] equiped item: " .. itemGid .. " into slot: " .. equpmentSlotName)
            return
        end

        global:printMessage("[CharacterEquipment] failed to equip item: " .. itemGid .. " into slot: " .. equpmentSlotName)
    end
end

return characterEquipment
