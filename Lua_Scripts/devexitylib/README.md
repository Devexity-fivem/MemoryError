# devexitylib

Unified RuneScape 3 helper library for MemoryError bot scripts — everything lives under the `DX` namespace. Version 1.1.0.

Requires the bot-provided `api` module (`require("api")`) and client globals (`FFPOINT`, `Interact`, `Inventory`, ...). No API calls are made at load time, so it is safe to require at the top of any script.

## Install

Copy this whole folder into your scripts directory (e.g. `Lua_Scripts/`). The forwarding shims `devexitylib.lua` and `bank.lua` next to it keep `require("devexitylib")` / `require("bank")` working — you can also require the inner module directly:

```lua
local DX   = require("devexitylib")        -- via shim -> devexitylib/devexitylib.lua
local BANK = require("bank")               -- via shim -> DX.Bank
-- or explicitly:
local DX   = require("devexitylib.devexitylib")
local BANK = require("devexitylib.bank")
```

## Modules

| Namespace | Contents |
|---|---|
| `DX.Data` | Static id tables: `Ores`, `Runes`, `Food`, `Potions`, `Locations`, `Objects`, `AbilityIds`, `BuffIds`, `DebuffIds`, `Abilities`, `Buffs`, `Debuffs` |
| `DX.Util` | `isEmpty`, `tableIncludes`, `concat`, `distinct`, `distinctBy`, `labelOf`, `userdataToTable`, `userdataToString`, `tableToString` |
| `DX.Game` | `isLoggedIn`, `isRunning`, `stateChecks`, `antiIdle`, `handleRandomEvents`, `canUseLodestone` |
| `DX.Wait` | `sleep`, `randomSleep`, `forCondition`, `ticks`, `forAnimation`, `forCoords` |
| `DX.State` | `itemCount`, `objectsPresent`, `newTracker` — reliable progress/channel detection (XP deltas, inventory deltas, object presence) since `Player.Animation` goes stale |
| `DX.Interface` | `isWorldSelectionOpen`, `isCraftingOpen`, `isCookingOpen`, `isSmeltingOpen`, `isTeleportSeedOpen`, `isNoneOpen`, `openInventory`, `openLootWindow`, `lootAll`, `loadActionBar` |
| `DX.Player` | `coordInArea`, `inArea`, `inRect`, `hasTarget`, `targetId`, `isTargeting`, `isTargetingId`, `waitForTarget`, `waitForTargetId`, `moveAndAttack`, `isAuraActive` |
| `DX.Ability` | `get`, `isReady`, `use`, `useSpecial`, `canUse`, `anyQueued`, `isQueued`, `canQueue`, `surge`, `dive` |
| `DX.Prayer` | `isTabOpen`, `toggleTab`, `usingNormal`, `usingCurses`, `isActive`, `isSoulSplit`, `isDeflectMelee/Magic/Ranged/Necro`, `activate`, `deactivate`, `flick`, `restore` |
| `DX.Magic` | `isNormal`/`isAncient`/`isLunar`, `highAlch`, `disassemble` |
| `DX.Consumables` | `eat`, `isOverloaded`, `drinkOverload`, `drink`, `hasItems` |
| `DX.Necro` | `necrosisStacks`, `soulStacks`, `conjuresAlive`, `inLivingDeath`, `canUseSpec`, `livingDeathRotation`, `bestAbility`, `bestAbilityNoUltimates`, `revoSupport`, `aoe` |
| `DX.Summoning` | `familiarMinutesLeft`, `renewAtWarRetreat` |
| `DX.WarRetreat` | `isAt`, `teleport`, `prepare` |
| `DX.Skilling` | `oreBoxCount`, `runeCount`, `noteItem` |
| `DX.Lodestone` | `teleport(lode)`, `isAt(lode)` plus prebuilt lodestones: `DX.Lodestone.FALADOR`, `.LUMBRIDGE`, `.TIRANNWN`, `.ASHDALE`, ... |
| `DX.PlayerManager` | One-instance survival/buff manager. `pm = DX.PlayerManager.new(config)`, then per loop: `pm:update()`, `pm:manageHealth()`, `pm:managePrayer()`, `pm:manageBuffs(buffDefs)` |
| `DX.Bank` | Bank Toolbox (below) |

## DX.Bank — Bank Toolbox

Merged from bank.lua ("Bank Toolbox" v1.2.1 by Spectre011). Same `BANK:`-style API:

```lua
local DX = require("devexitylib")
local BANK = DX.Bank   -- or: local BANK = require("bank")

if not BANK:IsOpen() then BANK:Open() end        -- nearest banker/booth/chest
BANK:DepositInventory()
BANK:DepositEquipment()
BANK:Withdraw(4151)          -- qty set by SetQuantity / Withdraw1/5/10/X/All
BANK:WithdrawAll(995)        -- coins
BANK:Deposit(2347)           -- or Deposit1/5/10/X/All
BANK:Equip(4151)
BANK:LoadLastPreset()
BANK:Close()
```

Other groups: bank contents (`Contains`, `ContainsAny`, `GetItemAmount`, `GetTotalSpaces`/`GetUsedSpaces`/`GetFreeSpaces`, `IsEquipped`), tabs & quantities (`GetOpenedTab`, `OpenTab`, `GetTransferTab`, `SetTransferTab`, `GetQuantitySelected`, `SetQuantity`, note mode), presets (`SavePreset`, `LoadPreset`, `PresetSettings*`), deposit box (`DepositBoxIsOpen/Open/Close`, `DepositBoxContains`, `DepositBoxDeposit*`), collection box (`ColletionBoxIsOpen/Open`, `ColletionBoxHasItems`, `ColletionBoxCollectToInventory/ToBank`), bank PIN (`IsPINOpen`, `EnterPIN`), and skilling deposit helpers (`WoodBoxDepositLogs`, `OreBoxDepositOres`, `SoilBoxDepositSoil`, ...).

Data tables: `DX.Bank.Banks` (nearest-bank NPC/object list), `DX.Bank.Interfaces` (interface scanner definitions), `DX.Bank.Items` (ore/wood box ids).

> Note: most collection-box methods keep the upstream `Colletion` spelling (only `CollectionBoxClose` is spelled correctly) — preserved for compatibility.

## PlayerManager quick start

```lua
local DX = require("devexitylib")
local pm = DX.PlayerManager.new({
    health  = { normal = { type = "percent", value = 50 }, critical = { type = "percent", value = 20 } },
    prayer  = { normal = { type = "percent", value = 30 } },
    locations = { { x = 3000, y = 3500, range = 20 } },  -- or detector fn
    panicTeleport = true,
    debug = false,
})
-- per loop:
pm:update()
pm:manageHealth()
pm:managePrayer()
pm:manageBuffs({ { buffName = "Rigour", buffId = 2448, execute = function() return needsRigour end } })
```

See `DX.PlayerManager` section in `devexitylib.lua` for the full config shape (statuses, locations, buff defs with `toggle`/`refreshAt`/`untoggleBelow`).

## Version

`DX.VERSION` — currently `1.1.0`.
