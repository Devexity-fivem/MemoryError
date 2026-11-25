# devexitylib

Unified RuneScape 3 helper library for MemoryError bot scripts — everything lives under the `DX` namespace. Version 1.3.0.

Requires the bot-provided `api` module (`require("api")`) and client globals (`FFPOINT`, `Interact`, `Inventory`, ...). No API calls are made at load time, so it is safe to `require` at the top of any script.

## Install

Copy this folder into your scripts directory (e.g. `Lua_Scripts/`). Then:

```lua
local DX   = require("devexitylib")          -- devexitylib/devexitylib.lua (or via shim)
local BANK = require("devexitylib.bank")     -- DX.Bank, also reachable as require("bank")
```

## Quick start — a complete script skeleton

```lua
local API = require("api")
local DX  = require("devexitylib")

local ORE_BOX = 44785
local ROCK    = { 113028, 113029 }   -- object ids
local LOOT    = { 453 }              -- ground item ids

local session = DX.Session.new({ "Mining" })

DX.run(function()
    -- 1. interact with the nearest matching object
    if not DX.State.objectsPresent(ROCK, 8, { 0 }) then
        DX.Walk.navigate(FFPOINT.new(3289, 3304, 0))     -- long-range walk
        return
    end
    DX.Objects.interact(ROCK, { op = DX.Act.OBJ_OP1, maxdist = 8 })
    DX.Wait.ticks(1)

    -- 2. survival + looting
    DX.Consumables.eat(DX.Data.Food, 50)
    DX.Ground.loot({ ids = LOOT, maxdist = 10, radius = 10 })

    -- 3. report
    print(string.format("XP/hr: %s | rocks: %d", session:xpHr("Mining"), session:count("rocks")))
end, { consoleFile = "miner_console.txt" })
```

`DX.run` owns the main loop: it checks login/lobby state every iteration, dismisses random events, `pcall`-guards your step (an error logs and continues instead of killing the script), and periodically saves the console. Your function is one **loop step** — keep it short and non-blocking; use `DX.Wait` for deliberate pauses.

## Conventions worth knowing once

- **Everything is dot-call**: `DX.Objects.find(...)`, not `DX.Objects:find(...)`. The vendored libraries (`DX.Bank`, `DX.Quest`, `DX.Slib`, `DX.PlayerManager`) keep their original `:`-method style.
- **Entity types** (used by `find`/`present` scans): `0` = scenery object, `1` = NPC, `3` = ground item, `12` = decorative object. `DX.Objects`, `DX.NPC`, `DX.Ground` already pick the right defaults.
- **Actions** are `{ action, route }` pairs in `DX.Act` — verified menu slots (`DX.Act.OBJ_OP1`, `DX.Act.NPC_ATTACK`, `DX.Act.TAKE`, ...). Pass as `op`: `DX.Objects.interact(id, { op = DX.Act.OBJ_OP3 })`. If you need a custom pair, pass `action`/`route` explicitly or sniff the right one with the client's DoAction debug.
- **Distances are tiles.** `maxdist` defaults to 50 on scans — always pass a smaller sane value; scanning is the expensive part of a loop.
- **`sol::vector` returns** (e.g. `GetAllObjArray1`) break `pairs()` and may be 0-indexed — wrap them with `DX.Util.userdataToTable` before iterating, or use `ipairs` where the function documents it.
- **`Player.Animation` / `API.CheckAnim` go stale** during channeling — never gate progress on animation alone. Use `DX.State` (below).

## Module index

| Namespace | Contents |
|---|---|
| `DX.Data` | Static id tables: `Ores`, `Runes`, `Food`, `Potions`, `Locations`, `Objects`, `AbilityIds`, `BuffIds`, `DebuffIds`, `Abilities`, `Buffs`, `Debuffs` |
| `DX.Util` | `isEmpty`, `tableIncludes`, `concat`, `distinct`, `distinctBy`, `labelOf`, `userdataToTable`, `userdataToString`, `tableToString` |
| `DX.Game` | `isLoggedIn`, `isRunning`, `stateChecks`, `antiIdle`, `handleRandomEvents`, `canUseLodestone` |
| `DX.Wait` | `sleep`, `randomSleep`, `forCondition`, `ticks`, `forAnimation`, `forCoords` |
| `DX.State` | `itemCount`, `objectsPresent`, `newTracker` — progress/channel detection |
| `DX.Interface` | `isWorldSelectionOpen`, `isCraftingOpen`, `isCookingOpen`, `isSmeltingOpen`, `isTeleportSeedOpen`, `isNoneOpen`, `openInventory`, `openLootWindow`, `lootAll`, `loadActionBar` |
| `DX.Player` | `coordInArea`, `inArea`, `inRect`, `hasTarget`, `targetId`, `isTargeting`, `waitForTarget`, `moveAndAttack`, `isAuraActive` |
| `DX.Ability` | `get`, `isReady`, `use`, `useSpecial`, `canUse`, `anyQueued`, `isQueued`, `canQueue`, `surge`, `dive` |
| `DX.Prayer` | `isTabOpen`, `toggleTab`, `usingNormal`, `usingCurses`, `isActive`, `isSoulSplit`, `isDeflectMelee/Magic/Ranged/Necro`, `activate`, `deactivate`, `flick`, `restore` |
| `DX.Magic` | `isNormal`/`isAncient`/`isLunar`, `highAlch`, `disassemble` |
| `DX.Consumables` | `eat`, `isOverloaded`, `drinkOverload`, `drink`, `hasItems` |
| `DX.Necro` | `necrosisStacks`, `soulStacks`, `conjuresAlive`, `inLivingDeath`, `canUseSpec`, `livingDeathRotation`, `bestAbility`, `bestAbilityNoUltimates`, `revoSupport`, `aoe` |
| `DX.Summoning` | `familiarMinutesLeft`, `renewAtWarRetreat` |
| `DX.WarRetreat` | `isAt`, `teleport`, `prepare` |
| `DX.Skilling` | `oreBoxCount`, `runeCount`, `noteItem` |
| `DX.Lodestone` | `teleport(lode)`, `isAt(lode)` + prebuilt lodestones (`FALADOR`, `LUMBRIDGE`, `WENDLEWICK`, `UM`, ...) |
| `DX.Act` | Verified menu-option `{action, route}` pairs: `OBJ_OP1..OBJ_EX`, `NPC_TALK/NPC_OP2/NPC_OP3/NPC_A7/NPC_ATTACK`, `TAKE`, `TAKE_IDX`, `BOX_TRAP` |
| `DX.Vars` | `get`, `state`, `stateInOrder`, `isSet`, `isSetInOrder` + `DX.Vars.ID` named varbits |
| `DX.Objects` | `find`, `first`, `present`, `firstNear`, `interact`, `interactNear`, `direct` |
| `DX.NPC` | `find`, `first`, `present`, `count`, `firstByName`, `interact`, `interactName`, `talk`, `attack`, `interactInArea`, `direct` |
| `DX.Ground` | `find`, `first`, `present`, `take`, `takeDirect`, `loot` |
| `DX.Walk` | `to`, `click`, `navigate`, `canReach`, `toLocation`, `distTo`, `isMoving`, `waitArrived`, `waitSettled`, `toAndWait` |
| `DX.Dialog` | `isOpen`, `continue`, `space`, `key`, `option`, `optionIndex`, `waitOpen`, `waitAndContinue`, `waitAndKey`, `said`, `readNpc`, `readPlayer` |
| `DX.Session` | `DX.Session.new(skills)` → `elapsed`, `fmtElapsed`, `xpGained`, `xpTotal`, `xpHr`, `etaLevel`, `counter`, `bump`, `count`, `rate` |
| `DX.GUI` | House purple theme + widgets: `colors`, `buttons` (presets), `sectionHeader`, `bigButton`, `statRow`, `progressBar`, `checkbox`, `sliderInt`, `tooltip` |
| `DX.Config` | Per-character JSON settings: `path`, `save`, `load`, `loadInto` |
| `DX.PlayerManager` | One-instance survival/buff manager (see section below) |
| `DX.Bank` | Bank Toolbox (see section below) |
| `DX.Herblore` | Potion recipe DB + `GetCraftingPlan(targetId)` |
| `DX.Quest` / `DX.Spectre` / `DX.Slib` | Vendored Spectre011 libraries (see Credits) |

## Cookbook

### Movement — `DX.Walk` + `DX.Lodestone`

```lua
DX.Walk.to(tile)                          -- short hop, local mover
DX.Walk.click(tile)                       -- minimap click
DX.Walk.navigate(tile)                    -- long-range StarPath pathing
DX.Walk.canReach(tile, true, 2)           -- StarPath reachability, tolerance 2
DX.Walk.waitArrived(tile, 1, 10)          -- block until within 1 tile (10s cap)
DX.Walk.waitSettled()                     -- block until moving+anim stop
DX.Walk.toAndWait(tile, 1)                -- walk + waitArrived in one call

DX.Lodestone.teleport(DX.Lodestone.FALADOR)   -- all lodestones prebuilt:
DX.Lodestone.isAt(DX.Lodestone.FALADOR)       -- FALADOR, LUMBRIDGE, WENDLEWICK, UM, ...
```

`navigate` handles multi-leg paths; `waitArrived`/`waitSettled` are the fix for "click sent while still walking gets eaten" — always wait for arrival before the next interaction.

### Objects, NPCs, ground items

```lua
local rock = DX.Objects.first({ 113028 }, 15)          -- nearest AllObject or nil
DX.Objects.interact({ 113028 }, { op = DX.Act.OBJ_OP1 })
DX.Objects.interactNear({ 101910 }, tile, 3)           -- object near a tile, not near you
DX.Objects.direct(rock, DX.Act.OBJ_EX)                 -- act on an object you already have

DX.NPC.firstByName({ "Banker" }, 20)
DX.NPC.talk({ 2724 }, { maxdist = 15 })
DX.NPC.attack({ 29355 }, { op = DX.Act.NPC_ATTACK })

DX.Ground.loot({                                       -- area loot (opens loot window itself
    ids = LOOT, maxdist = 15, radius = 15,             --  if useKeybindToOpen is set)
    options = { useKeybindToOpen = true, keybindVK = 0xDC,
                lootAllWhenFull = true, allowStackablesAlreadyHeld = true }
})
DX.Ground.takeDirect(item, DX.Act.TAKE)                -- direct Take on a found item
```

Ground items report an empty `action` string — `DX.Ground.*` uses the non-action-filtered scan for this reason; don't swap in `GetAllObjArrayInteract`-style scans for ground items.

### Combat — `DX.Ability`, `DX.Prayer`, `DX.Consumables`, `DX.Necro`

```lua
DX.Ability.use("Soul Sap")          -- by name, or id via DX.Data.AbilityIds
DX.Ability.isReady("Death Skulls")  -- off cooldown + enough adrenaline
DX.Ability.surge()                  -- movement helpers handle facing
DX.Ability.dive(tile)

DX.Prayer.activate(26033, 26033)    -- (abilityId, buffId): toggles only if buff missing
DX.Prayer.flick(26033, 26033)       -- toggle-on-if-inactive (abilityId, buffId)
DX.Prayer.restore(30)               -- sip restore below 30% points

DX.Consumables.eat(DX.Data.Food, 50)
DX.Consumables.drinkOverload()      -- tracks its own timer
DX.Consumables.drink({ 3024, 3026, 3028, 3030 }, nil)  -- super restore doses

DX.Necro.necrosisStacks()           -- VB-backed stack reads
DX.Necro.inLivingDeath()
DX.Necro.bestAbility()              -- ready-to-use priority pick
```

For "keep player alive" boilerplate, use `DX.PlayerManager` (config: health/prayer thresholds, food/potion auto-detection, excalibur + elven shard, buff management, panic Wars teleport) — see the section further down.

### Banking — `DX.Bank` (Bank Toolbox)

```lua
if not BANK:IsOpen() then BANK:Open() end        -- nearest banker/booth/chest
BANK:DepositInventory()
BANK:DepositEquipment()
BANK:Withdraw(4151)          -- qty from SetQuantity / Withdraw1/5/10/X/All
BANK:WithdrawAll(995)
BANK:Deposit(2347)
BANK:Equip(4151)
BANK:LoadLastPreset()        -- fastest resupply: deposit bag + withdraw preset
BANK:Close()
```

Also: contents (`Contains`, `GetItemAmount`, `GetFreeSpaces`), tabs/quantities, presets (`SavePreset`, `LoadPreset`, `PresetSettings*`), deposit box, collection box (`ColletionBox*` — upstream typo kept), PIN entry, and skilling boxes (`WoodBoxDepositLogs`, `OreBoxDepositOres`, `SoilBoxDepositSoil`).

### Dialogs — `DX.Dialog`

```lua
if DX.Dialog.isOpen() then
    DX.Dialog.continue()              -- or .space(), .key(n), .option("Yes")
end
DX.Dialog.waitAndContinue(5)          -- open + continue, 5s cap
DX.Dialog.optionIndex("Craft")
```

### Session stats — `DX.Session`

```lua
local s = DX.Session.new({ "Thieving", "Agility" })
s:bump("picks")                        -- your own counters
print(s:xpHr("Thieving"), s:etaLevel("Thieving", 99), s:rate("picks"), s:fmtElapsed())
```

### Reliable progress detection — `DX.State`

`Player.Animation`/`CheckAnim` return idle while you're actively channeling some actions. Track XP deltas / inventory deltas / object presence instead:

```lua
local t = DX.State.newTracker({ xpSkills = { "Divination" } })
-- per loop:
local _, changed = t:sample()
if t:isChanneling() then ... end       -- XP or inventory is moving
if t:idleSec() > 10 then ... end       -- nothing changed in 10s -> stalled
DX.State.itemCount({ 29313 })
DX.State.objectsPresent({ 122504 }, 20, { 0 })
```

### Waits — `DX.Wait`

```lua
DX.Wait.sleep(1200, 200, 400)          -- randomized 1.2s ± jitter
DX.Wait.ticks(2)                       -- game ticks
DX.Wait.forCondition(function()        -- poll until true / timeout
    return DX.Objects.present({ 101909 }, 10, { 12 })
end, 10, "threshold appeared")
DX.Wait.forCoords(tile, 1, 8)
```

All `DX.Wait` sleeps bail early when the script is stopped (`Read_LoopyLoop` false).

### GUI + saved settings — `DX.GUI`, `DX.Config`

```lua
-- inside your ImGui render callback (never do game actions here — set flags
-- and consume them in the main loop)
if DX.GUI.bigButton("Pause", "pause") then paused = true end   -- presets: pause/resume/stop
DX.GUI.sectionHeader("Stats")
DX.GUI.statRow("XP/hr", session:xpHr("Mining"))
DX.GUI.progressBar(frac, "Level " .. lvl)
DX.GUI.checkbox(S, "enabled", "Enabled")          -- writes S.enabled
DX.GUI.sliderInt(S, "radius", "Radius", 1, 20)
DX.GUI.tooltip("explains a control")

-- per-character JSON settings: <tag>-<player>.config.json next to the script
DX.Config.save("myscript", S)
DX.Config.loadInto("myscript", S)                 -- merges saved keys into S
```

`DX.GUI.colors` holds the shared purple palette so UIs look consistent.

## `DX.run` options

```lua
DX.run(stepFn, {
    stateChecks        = true,     -- break on logout/lobby   (default true)
    randomEvents       = true,     -- auto-dismiss events     (default true)
    consoleFile        = "x.txt",  -- periodic console dump
    consoleIntervalSec = 60,
    onErrorSleepMs     = 1000,     -- backoff after a step() error
    onExit             = function() ... end,
})
```

## Compatibility shims

Old library names still work — each returns the matching DX table:

| `require` | resolves to |
|---|---|
| `require("utils")` | DX-backed `UTILS` instance (full old API mapped) |
| `require("lodestones")` | `DX.Lodestone` (+ `Teleport`/`IsAtLocation` aliases) |
| `require("bank")` | `DX.Bank` |
| `require("slib")` | `DX.Slib` |
| `require("potionrecipes")` | `DX.Herblore` |
| `require("quest")` | `DX.Quest` |
| `require("spectre")` | `DX.Spectre` |

## PlayerManager quick start

```lua
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

See the `DX.PlayerManager` section in `devexitylib.lua` for the full config shape (statuses, locations, buff defs with `toggle`/`refreshAt`/`untoggleBelow`).

## Gotchas (learned the hard way)

- **Loot window**: `DoAction_Loot_w` takes items *only while the window is open* — nothing opens it for you. `DX.Ground.loot` (the `_p` "area loot" call) handles open+take itself when `useKeybindToOpen` is set, plus direct-Take fallbacks.
- **Full bags**: `LootOptions.lootAllWhenFull = false` by default — set it true (and `allowStackablesAlreadyHeld`) if your script banks rarely.
- **Don't act inside ImGui render callbacks** — set flags, consume in `DX.run`. And only use the proven widget set (`Begin`/`End`/`Text`/`Button`/`Checkbox`/`SliderInt`/`SameLine`/`Separator`/`ProgressBar`/`PushStyleColor`...) — fancy widgets like `CollapsingHeader` aren't exposed in this build.
- **`GetAllObjArrayInteract` filters to entities with a non-empty `action`** — fine for objects/NPCs, silently empty for ground items (use `DX.Ground.*`).
- **`API.PlayerRegion().z` is a region id, not a plane** — use `API.PlayerCoord().z` for floor level.

## Credits

Vendored components — original authors, repos and versions:

| Section | Source | Upstream version |
|---|---|---|
| `DX.Bank` | [Spectre011](https://github.com/spectre011-code) — Bank Toolbox ([Public-ME-Scripts](https://github.com/spectre011-code/Public-ME-Scripts), MIT license, Discord `not_spectre011`) | v1.2.0 + our fixes |
| `DX.Quest` | Spectre011 — quest.lua (same repo) | v1.1.0 |
| `DX.Spectre` | Spectre011 — spectre.lua (same repo) | v1.0 |
| `DX.Slib` | Spectre011 — slib.lua (same repo) | v1.0.17 |
| `DX.PlayerManager` | [Sonson](https://github.com/sonsonmagro) — [Sonsons-Player-Manager](https://github.com/sonsonmagro/Sonsons-Player-Manager) | v1.2.4 |
| `tools/` | Spectre011 — dev utilities (same repo); Interface Exporter based on [Ernie](https://github.com/Ernestohh/)'s work | Bank Evaluator v1.2.0, Interface Exporter v2.1.0, VB Scanner v1.1.0 |

All other `DX.*` modules are original Devexity work. Vendored sections stay as close to upstream as possible; every local change is noted at the section header in `devexitylib.lua` so upstream diffs stay easy to audit (`sed -n '<section lines>'` + diff against the repo file).

## Tools

Standalone developer utilities vendored under `tools/` — not part of the `DX` namespace, run them as scripts:

- **`tools/bank_evaluator.lua`** — scans the open bank and exports a CSV of every item (id, name, stack, unit value, total) to `Lua_Scripts\Exports\BankEvaluator\`. Prices come from the weirdgloop wiki API when the `Http` global is available, else the client's GE cache. Run with the bank open.
- **`tools/interface_exporter.lua`** — recursively scans game interfaces and dumps them to CSV under `Lua_Scripts\Exports\interfaces\`. Configure the `Config` table at the top of the file (start id, depth, scan delay) before running.
- **`tools/vb_scanner.lua`** — live ImGui varbit/varp/varc scanner with filtering and change detection. Run it, let the initial scan finish, then filter/diff in the window.

## Version

`DX.VERSION` — currently `1.3.0`.

### 1.3.0 — reliability audit

- **`DX.Prayer.flick` signature is now `(abilityId, buffId)`** — the old single-arg `flick(abilityId)` was dead code shadowed by a duplicate definition. `activate`/`deactivate`/`flick` all return booleans now.
- **`DX.Ground.find`/`first`/`present` and `DX.State.objectsPresent` switched to `GetAllObjArray1`** — the interact-filtered scan drops ground items silently (empty `action`).
- **`DX.Util.userdataToTable` handles 0- and 1-indexed `sol::vector`** and passes plain tables through; `DX.Game.handleRandomEvents`/`DX.Interface.lootAll` converted + nil-guarded on the same vector shapes.
- **`DX.Game.stateChecks` resets its not-logged-in counter on success** (was cumulative — six transient checks over a whole session used to kill the script).
- **`DX.Walk.waitArrived` and lodestone arrival checks compare the z-plane** (Prifddinas/Ashdale/Um no longer false-positive "arrived" on the wrong floor).
- **`DX.Wait.sleep` delegates to `RandomSleep2`** (was an `os.clock` re-sleep loop); **`DX.run` throttles the success path** (`opts.loopSleepMs`, default 50ms) so fast step functions don't busy-spin.
- **`DX.Herblore` OVERLOAD_3 recipe: torstol moved to `ingredients[1]`** — the mix is `UseItemOnItem(first, second)` and only torstol-on-extreme opens the overload make-x.
