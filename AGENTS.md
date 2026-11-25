# MemoryError workspace notes

## Project

- RS3 only. `Lua_Scripts/apiosrs.lua` exists but is intentionally unused — never depend on it.
- `Lua_Scripts/devexitylib/` is the unified helper library (`local DX = require("devexitylib")`): `devexitylib.lua` (DX.* namespaces) + `bank.lua` (DX.Bank / Bank Toolbox by Spectre011) + README. Root `Lua_Scripts/devexitylib.lua` and `Lua_Scripts/bank.lua` are forwarding shims (`require("devexitylib.devexitylib")` / `require("devexitylib.bank")`) so existing requires keep working. Prefer DX over legacy libs; v1.2.0 made `utils.lua`, `lodestones.lua`, `slib.lua`, `potionrecipes.lua` (+`skilling/` copy), `quest.lua`, `spectre.lua` into compat shims returning DX tables, so old scripts keep working — new code should call `DX.*` directly.
- DX v1.2.0 modules: `DX.Act` (verified `{action,route}` pairs for DoAction_*), `DX.Vars` (varbit reads + `DX.Vars.ID` names), `DX.Objects`/`DX.NPC`/`DX.Ground` (find+interact), `DX.Walk` (`to`/`navigate` via `API.StarPathWalker`/`waitArrived`/`waitSettled`), `DX.Dialog`, `DX.Session` (xp/hr stats), `DX.GUI`+`DX.Config` (house purple theme + per-character JSON), `DX.run` (main-loop runner: stateChecks+randomEvents+error guard+console dump), `DX.Prayer.flick`, `DX.Herblore` (potionrecipes merge), vendored `DX.Quest`/`DX.Spectre`/`DX.Slib` (Spectre011 libs from github spectre011-code/Public-ME-Scripts — slib.lua is the FULL 5.8k-line lib, superset of the old local 53-line slib).
- `DX.Slib.ChatMessages` is intentionally left empty at require time — upstream populated it via `API.GatherEvents_chat_check()` which destructively drains the shared chat buffer; it's filled lazily by `Slib:RecentMessageCheck` instead.
- Bank Toolbox is merged into devexitylib as `DX.Bank` — same `BANK:`/`DX.Bank:` method API (`DX.Bank:IsOpen()`, `DX.Bank:Withdraw(id)`). Most collection-box methods keep the upstream `Colletion` typo for compatibility.
- `devexitylib/tools/` — vendored Spectre011 dev utilities (unmodified, credits in headers): `bank_evaluator.lua` (bank CSV export w/ wiki prices), `interface_exporter.lua` (recursive interface dump), `vb_scanner.lua` (live ImGui varbit scanner). CSVs land in `Lua_Scripts\Exports\`.
- `api.lua` is bot-provided and may be overwritten by client updates — annotation fixes there may need re-applying.

## BotMCP (live game access)

MemoryError exposes a JSON-RPC MCP server — use it to verify API assumptions against live game data instead of guessing.

- Endpoint: `POST http://127.0.0.1:18642/mcp` (RS3). Other ports: 18643 RuneLite, 18644 OSRS.
- List all ~306 commands:
  `{"jsonrpc":"2.0","method":"get_registry","params":[{}],"id":1}`
- Run one:
  `{"jsonrpc":"2.0","method":"invoke","params":[{"method":"Player.Name","params":{}}],"id":1}`
- Saved registry dump: `C:\Users\pablo\dx_test\botmcp_registry.json`
- Useful: `Inventory.GetItems`, `Inventory.ReadInvArrays33`, `Cache.GetItem`/`Cache.FindItems` (noted/stackable/value/ge_limit/params), `Perks.*`, `GrandExchange.*`, `StarPath.*`, `InterfaceReadOnDemand`, `Player.*`, `Skills.*`, `Bank.*`, `Equipment.*`.
- Bridge source (verified 2026-11-17): `pp9999/ME_Releases` → `MemoryError/botclientmcp/mcp_botclient.py` is only a Python FastMCP stdio adapter that forwards to the DLL's HTTP JSON-RPC; the server itself is closed-source inside the injected DLL. That repo's `.vscode/mcp.json` registers it for ports 18642/18643/18644.
- Top-level (non-`invoke`) read-only methods verified live: `get_player`, `get_localplayer`, `get_main_data`, `get_tile {x,y,plane}`, `get_entities {types,ids,names,max_dist}` (returns `id,name,type,typeName,tile,distance,action,uid` — use it to verify object IDs/types/actions), `get_events`, `get_spawned_objects`, `get_hooks`, `get_console`. Not in the current build: `get_player_tile`, `astar_path`.
- Never call side-effect methods while monitoring: `mem_write`, `mem_patch`, `mouse_*`, `set_packet_capture`, `set_debug_hooks`, `SetLoopyLoop`, `RandomEvents`, `Interact.*`, `DoAction_*`.
- `Skills.GetAll`/`Skills.GetByName` return `level`/`boosted` only — no XP. For XP use top-level `get_events`: `xp` events carry the skill's total `xp`, and `chat` events carry game messages (e.g. porter/Grace of the Elves "You transport to your bank: 4 x Pure essence."). It appears to return only events since the previous call. With porters/Grace of the Elves, gathered items never reach the inventory, so inventory deltas show nothing.
- **Fast bridge (preferred for monitoring):** MCP server `botmcp-rs3`, registered in `.devin/mcp_config.local.json` → `C:\Users\pablo\dx_test\mcp_src\botmcp_fast.py` (venv `mcp_src\.venv`, `mcp==1.30.0`; deps pinned in `requirements.lock.txt` / `constraints.txt` to releases ≥7 days old). Tools: `check_connection`, `snapshot`, `inventory`, `wait_for`, `monitor`, `entities` (numeric `type`), `tile`, `console`, `find_command`, `invoke`, `item_info`, `find_items`. Use `wait_for`/`monitor` instead of repeated polling calls.
- Safe by default: `invoke` only allows the 155-command `READ_ONLY` allowlist (fail-closed). `--allow-unsafe` lifts it and adds `raw_rpc` — never register the bridge with that flag. Live read-only tests: `mcp_src\.venv\Scripts\python.exe mcp_src\test_botmcp_fast.py`. `Cache.FindItems` name search is case-sensitive.

## Verified data shapes (live, 2026-11-12)

- `API.ReadInvArrays33()` — the **bridge** marshals `inv_Container_struct[]` fields `item_id`, `item_name`, `item_stack`, `item_slot`, `item_noted`, etc., but the **in-client** call returns userdata whose elements do NOT expose `item_name`/`item_id` (verified live: `findClueItem` diag printed nil for both). Do NOT use it in scripts — use `Inventory:GetItems()` instead.
- `API.Container_Get_all(93)` — same caveat; verified shape is the bridge's marshaling, in-client struct fields differ.
- `Inventory:GetItems()` — the reliable in-script inventory read: `InventoryItem[]` `{id, name, amount, slot, xp}` — **no noted flag**. Via MCP `Inventory.GetItems`, empty slots appear as `id = -1`, `name = ""` — filter `id <= 0`.
- `IInfo` fields (`itemid1`, `itemid1_size`, `textitem`, `id1/id2/id3`, `hov`) apply to interface scanners only: `ScanForInterfaceTest2GetAll`, `LootWindow_GetData`, `GetEquipSlot`, `FetchBankArray`.
- `Cache.GetItem` returns `noted`, `stackable`, `value`, `ge_limit`, `high_alch`, `alchable`, `tradeable`, `category`, `params`, `worn_options`.

## Conventions

- Script headers: `--[[ # Script Name / # Description / # Autor / # Version / # Datum --]]`
- Main loop: `while API.Read_LoopyLoop() do ... end`; stop with `API.Write_LoopyLoop(false)`; `API.RandomSleep2` for delays; `API.logError` for errors.
- ImGui UIs must not perform game actions in render callbacks — set flags, consume in main loop. Guard sections with pcall; keep Begin/End and Push/Pop balanced.
- Runtime globals (`FFPOINT`, `WPOINT`, `ImGui*` enums, `Inventory`, `Bank`, etc.) are declared in root `.luarc.json` — add new ones there, don't stub them.
- Lodestone ids = interface 1092 component ids (verified live 2026-12 via `InterfaceReadOnDemand{id:1092}`): contiguous 8-33, then Prifddinas = 34, City of Um = 35, Wendlewick = 41; ids 36-40 do not exist in the interface.
- UI style: match `skilling/NecromancyRituals/NecroRitualsGUI.lua` — purple palette `dark{0.08,0.05,0.12}` / `medium{0.15,0.08,0.20}` / `light{0.25,0.12,0.35}` / `bright{0.45,0.20,0.55}` / `glow{0.65,0.30,0.80}`, green accent `{0.30,0.70,0.40}`; per-character JSON config files (`<script>-<player>.config.json`) via `API.JsonEncode`/`JsonDecode`. Used by `skilling/DevexityThievingAIO.lua` and `bossing/ClueAIOGWD1.lua`.
- Test scripts (Lupa-based smoke tests): `C:\Users\pablo\dx_test\`.
- Git repo: `github.com/Devexity-fivem/MemoryError`, branch `main` — **only devexitylib is published** (the lib, its shims, `.gitignore`, `.luarc.json`, `AGENTS.md`). Do NOT commit the script dirs (`skilling/`, `bossing/`, `afk/`, `clues/`, `posd/`, `minigames/`, etc.) — they're private/untracked on purpose. `.gitignore` also covers `*.bak`, runtime-generated `*.config.json`, binaries, logs, and client placeholders.

## Known-stale/unreliable client reads (verified 2026-11)

- `Player.Animation` / `Player.InteractingNpc` (and in-client `API.CheckAnim`) go stale during wisp channeling and some gathering actions — they report idle/none while the player is actively working. Do NOT use them alone to detect channeling or progress.
- Reliable substitutes: inventory quantity deltas (`Inventory:GetItems()`), `API.GetSkillXP` deltas, position deltas, and object presence via `API.GetAllObjArrayInteract` / MCP `RandomEvent`.
- `devexitylib.lua` `DX.State` wraps this: `newTracker({xpSkills})`, `tracker:sample()` per loop, `:isChanneling()`, `:idleSec()`, `:isActive()`, `:waitForProgress()`, plus `DX.State.itemCount(ids)` and `DX.State.objectsPresent(ids)`.
- `sol.std::vector` userdata from API calls may be 0- or 1-indexed and breaks `pairs()` — always iterate via the DX.State/DX.Util helpers, not `pairs`.
- `DX.PlayerManager` (devexitylib, ported from sonsonmagro/Sonsons-Player-Manager v1.2.4): one-instance survival/buff manager. `pm = DX.PlayerManager.new(config)`; per loop call `pm:update()` then `pm:manageHealth()` / `pm:managePrayer()` / `pm:manageBuffs(buffDefs)`. Config: `health`/`prayer` tiered thresholds `{type="percent"|"current", value}` (normal/critical/special), `locations` (static `{x,y,range,z?}` or `detector` fn), `statuses` (`{name, condition(self), execute(self), priority}` — lowest priority number wins, dispatched in `update()`), `panicTeleport` (default true), `debug`. Buff defs: `{buffName, buffId, execute():bool, canApply?, toggle?, refreshAt? sec, untoggleBelow? sec}` — `toggle=true` buffs are switched OFF when `canApply` goes false. Uses `Inventory:GetItems()`/`Contains`, `Equipment:Contains`/`DoAction`, `DoAction_Inventory1(id)`, VB 679 adrenaline. Smoke test: `dx_test/smoke_pm.py`.

## Box-trap hunting (verified live 2026-11-20, Isafdar grenwalls)

- Box trap 10008: inventory op1 "Lay" (`API.DoAction_Inventory1(10008, 0, 1, API.OFF_ACT_GeneralInterface_route)`, lays on the player's tile, then the game steps the player 1 tile west). Ground ops: op1 "Lay", op3 "Take" — same layout as the Sprite lure 19807, so ground Lay = `API.DoAction_G_Items_r2(0x2a, API.OFF_ACT_Boxtrap_route, {10008}, 50, tile, r)` (inferred, not yet confirmed live) and Take = `API.OFF_ACT_Pickup_route`.
- Classify trap objects (type 0) by AllObject `.Action`, not id: "Dismantle" = armed (19187), "" = transition (~1.2s; 19188 before a failed trigger, 28909/28910 before a catch), "Rebuild" = sprung/failed (19192; Rebuild = dismantle + relay), "Check" = caught (28906 grenwall; other shaking-box ids 19189-19191, 28913, 28920-28929). Two objects can coexist on a tile during transitions.
- Laying shows the ground item 10008 for ~1.2–1.9s before the armed object appears. Laying from inventory on a tile that holds a ground trap fails ("There are too many traps on the floor to lay one here"). Uncaught traps collapse back to ground item 10008 ~60s after arming.
- Check walks the player onto the trap tile, returns the trap to inventory, gives ~19 Grenwall spikes (12539) + Bones (526) + ~799 Hunter XP. Grace of the elves (porter) banks the herb drops.
- `get_events`' first call dumps a long chat backlog. `API.GatherEvents_chat_check` is destructive and shared with other consumers (see notes in `skilling/dung/Dung.lua`), so don't make a script depend on chat.
- `Player.Animation` / get_player `animId` read -1 for the whole lay (polled at 100ms), so don't gate on animation. Gate on the post-lay step instead: ~0.6s after the trap arms the game moves the player one tile west, and the player stops ~1.4–1.5s after arming. Acting earlier cuts the step off (GrenwallTraps `waitLaySettled`).
- Het's Oasis flower bushes (golden rose farm, verified live 2026-11-20): each bush has a contiguous 4-id block per growth state — Rose `122504-122507`, Iris `122508-122511`, Hydrangea `122512-122515` (FiddleyHunter.lua; hollyhock UNVERIFIED — live-scan before use). Same block position = same state: bare/budding/blooming all show action "Cultivate"; the 4th shows "Harvest" (name stays "(blooming)"). ~4min per cycle unfertilised. Random events: `Pesty scarab` NPC `28671` action `Shoo` (~30s unattended, eats progress); nutritious gasses = type-4 highlight entity `7620` + chat "Nutritious gasses engulf your flowers" (~5s window, re-click Cultivate for bonus). Farming XP ticks every 0.6s while cultivating — the reliable channel signal (anim stays -1). Items: Roses `52807`, Irises `52808`, Hydrangeas `52809`, Hollyhocks `52810`, Golden roses `52811` (all stackable — no banking needed).
- Script: `skilling/GrenwallTraps.lua`. Smoke test: `dx_test/smoke_grenwall.py` (Lupa, simulated world + virtual clock). Read-only live trap watcher: `python dx_test/watch_traps.py <seconds>` (per-tile transitions, position, inventory and chat).
