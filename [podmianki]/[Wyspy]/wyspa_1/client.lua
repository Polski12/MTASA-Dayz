addEventHandler('onClientResourceStart', resourceRoot,
function()

local txd = engineLoadTXD('podmianka.txd',true)
engineImportTXD(txd, 2270)
local dff = engineLoadDFF('podmianka.dff', 0)
engineReplaceModel(dff, 2270)
local col = engineLoadCOL('podmianka.col')
engineReplaceCOL(col, 2270)
engineSetModelLODDistance(2270, 50000)

createObject(2270,-3200.6999511719,3200.0300292969,-33,0.0000000,0.0000000,0.0000000,false) --4
createObject(2270,-3200.6999511719,3200.0300292969,-33,0.0000000,0.0000000,0.0000000,true) --4
--setLowLODElement(v)
end)