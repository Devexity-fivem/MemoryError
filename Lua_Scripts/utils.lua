-- utils.lua — compatibility shim. The unified library absorbed this module;
-- every function maps onto devexitylib (DX.*). Kept so `require("utils")` callers
-- (utils.new(), UTILS:method(), UTILS.method(), UTILS.ORES/RUNES) keep working.
local API = require("api")
local DX = require("devexitylib")

local UTILS = {}
UTILS.__index = UTILS

function UTILS.new()
    local self = setmetatable({}, UTILS)
    return self
end

-- data tables
UTILS.ORES = DX.Data.Ores
UTILS.RUNES = DX.Data.Runes

---@param rune table entry from UTILS.RUNES / DX.Data.Runes ({ID=..., INV_VB=...})
---@return number
function UTILS.getRuneCountInventory(rune)
    return DX.Skilling.runeCount(rune)
end

---@return boolean
function UTILS:antiIdle()
    return DX.Game.antiIdle()
end

UTILS.isEmpty = DX.Util.isEmpty
UTILS.tableIncludes = DX.Util.tableIncludes
UTILS.UserDataToVector = DX.Util.userdataToTable
UTILS.randomSleep = DX.Wait.randomSleep
UTILS.UserDataToString = DX.Util.userdataToString
UTILS.tableToString = DX.Util.tableToString

---@return boolean
function UTILS:gameStateChecks()
    return DX.Game.stateChecks()
end

UTILS.waitForAnimation = DX.Wait.forAnimation

---@return boolean
function UTILS.CanUseLodestone()
    return DX.Game.canUseLodestone()
end

UTILS.waitForPlayerAtCoords = DX.Wait.forCoords
UTILS.GetLabelFromArgument = DX.Util.labelOf
UTILS.concatenateTables = DX.Util.concat
UTILS.getDistinctValues = DX.Util.distinct
UTILS.getDistinctByProperty = DX.Util.distinctBy

---@return boolean
function UTILS:DO_RandomEvents()
    return DX.Game.handleRandomEvents()
end

---@param barNumber number
---@return boolean
function UTILS.LoadActionBar(barNumber)
    return DX.Interface.loadActionBar(barNumber)
end

UTILS.countTicks = DX.Wait.ticks
UTILS.rangeSleep = DX.Wait.sleep

---@param conditionFunc function
---@param timeout number|nil seconds
---@param message string|nil
---@return boolean
function UTILS.SleepUntil(conditionFunc, timeout, message, ...)
    return DX.Wait.forCondition(conditionFunc, timeout or 10, message or "SleepUntil",
        { randomEvents = true, stateChecks = true, checkLoopy = true })
end

---@param conditionFunc function
---@param timeout number|nil seconds
---@param message string|nil
---@param loopy boolean|nil keep waiting only while loopyloop is on
---@return boolean
function UTILS.SleepUntilWithoutChecks(conditionFunc, timeout, message, loopy, ...)
    return DX.Wait.forCondition(conditionFunc, timeout or 10, message or "SleepUntilWithoutChecks",
        { randomEvents = false, stateChecks = false, checkLoopy = loopy ~= false })
end

UTILS.isWorldSelectionOpen = DX.Interface.isWorldSelectionOpen
UTILS.isCraftingInterfaceOpen = DX.Interface.isCraftingOpen
UTILS.isChooseOptionInterfaceOpen = DX.Interface.isChooseOptionOpen
UTILS.isCookingInterfaceOpen = DX.Interface.isCookingOpen
UTILS.isSmeltingInterfaceOpen = DX.Interface.isSmeltingOpen
UTILS.isTeleportSeedInterfaceOpen = DX.Interface.isTeleportSeedOpen

---@return boolean
function UTILS.isAuraActive()
    return DX.Player.isAuraActive()
end

---@param skill string ability name on the action bar
---@return boolean
function UTILS.isSkillQueued(skill)
    return DX.Ability.isQueued(skill)
end

---@param skill string
---@return boolean
function UTILS.canQueueSkill(skill)
    return DX.Ability.canQueue(skill)
end

---@param skill string
---@return boolean
function UTILS.canUseSkill(skill)
    return DX.Ability.canUse(skill)
end

---Get an ability entry when it is on the bar and usable.
---@param skillName string
---@return Abilitybar|nil
function UTILS.getSkillOnBar(skillName)
    local skillOnAB = API.GetABs_name1(skillName)
    if DX.Ability.canUse(skillName) then
        return skillOnAB
    end
    return nil
end

---@return boolean
function UTILS.surge()
    return DX.Ability.surge()
end

---@param destinationTile FFPOINT
---@return boolean
function UTILS.dive(destinationTile)
    return DX.Ability.dive(destinationTile)
end

---Find an item entry in the inventory.
---@param itemId number
---@return table|nil inv_Container_struct
function UTILS.findItemInInventory(itemId)
    local ok, inventory = pcall(API.ReadInvArrays33)
    if not ok or inventory == nil then return nil end
    for _, item in pairs(inventory) do
        local id = item.item_id or item.itemid1
        if id == itemId then
            return item
        end
    end
    return nil
end

UTILS.isPrayersTabOpen = DX.Prayer.isTabOpen
UTILS.isUsingNormalPrayers = DX.Prayer.usingNormal
UTILS.isUsingCurses = DX.Prayer.usingCurses
UTILS.isUsingNormalMagic = DX.Magic.isNormal
UTILS.isUsingAncientMagic = DX.Magic.isAncient
UTILS.isUsingLunarMagic = DX.Magic.isLunar
UTILS.isSoulSplitting = DX.Prayer.isSoulSplit
UTILS.isDeflectMelee = DX.Prayer.isDeflectMelee
UTILS.isDeflectMagic = DX.Prayer.isDeflectMagic
UTILS.isDeflectRange = DX.Prayer.isDeflectRanged
UTILS.isDeflectNecro = DX.Prayer.isDeflectNecro
UTILS.togglePrayerWindow = DX.Prayer.toggleTab
UTILS.getFamiliarDuration = DX.Summoning.familiarMinutesLeft
UTILS.isChronicleAttractionActive = DX.Prayer.isChronicleAttractionActive
UTILS.hasChronicleAttraction = DX.Prayer.hasChronicleAttraction
UTILS.playerInArea = DX.Player.inArea
UTILS.isCoordInArea = DX.Player.coordInArea
UTILS.getAmountInOrebox = DX.Skilling.oreBoxCount
UTILS.NoteItem = DX.Skilling.noteItem

local instance = UTILS.new()
return instance
