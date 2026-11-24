-- lodestones.lua — compatibility shim. Lodestones moved into devexitylib as
-- DX.Lodestone (lowercase teleport()/isAt()). This shim adds the original
-- capitalized Teleport()/IsAtLocation() aliases so require("lodestones") callers
-- keep working unchanged.
local LODESTONES = require("devexitylib").Lodestone

for _, lode in pairs(LODESTONES) do
    if type(lode) == "table" and lode.teleport then
        if lode.Teleport == nil then lode.Teleport = lode.teleport end
        if lode.IsAtLocation == nil then lode.IsAtLocation = lode.isAt end
    end
end

return LODESTONES
