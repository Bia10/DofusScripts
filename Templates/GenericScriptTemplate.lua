----------------------
-- Generic settings --
----------------------
-- FOLLOW_NORMAL = true 

-- Items to automatically delete when out of combat
AUTO_DELETE = {

}

-- Ressources to gather if availible at map
GATHER = {

}

-- Minimum number of monsters in mob group to attack it
MIN_MONSTERS = 1

-- Maximum number of monsters in mob group to attack it
MAX_MONSTERS = 4

-- Required monsters in mob group to attack it
FORCE_MONSTERS = {

}

-- Forbidden monsters in mob group to never attack it
FORBIDDEN_MONSTERS = {

}

--------------------
-- Main Functions --
--------------------

-- This executes only when below banking % of pods
function move()
    return {
        -- map defined by X, Y pos, path to change to next map by top edge of map box
        { map = "4,-19", path = "top" },
        -- map defined by X, Y pos, path to change map specifies map box edge and also concrete cellId to use
        { map = "0,0", path = "left(364)" },
    }
end

-- This executes only when above % of pods set to bank or when returning from bank to fight area
function bank()
    return {
        -- normal move
        { map = "5,-16", path = "left" },
        -- map defined by mapId, interact with banker and deposit all, exit bank via cellId
        { map = "9856523", npcBank = true, path = "406" },
    }
end

-- This executes only when in ghost mode
function phenix()
    return {
        { map = "-3,-12", path = "right" },
        -- map defines by by X, Y pos, door action demands interaction with object of objId
        { map = "4,-20", door = "254" },
    }
end

-- This executes if script abnormaly terminates (crash, disconnect etc...)
function stopped()
    global:printError("Warning script terminated!")
    -- Reload script
    -- global:reloadScript()
    -- Disconnect
    -- global:disconnect()
end