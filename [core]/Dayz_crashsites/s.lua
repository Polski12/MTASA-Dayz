local heliCrashSites = {}
local heliCrashSitesItems = {}
function update()
  local q=exports.db:q("select * from crashsity_pozycje")
  for i,v in ipairs(q)do
    table.insert(heliCrashSites,split(v.pozycja,","))
  end
  q=exports.db:q("select * from  crashsity_przedmioty")
  for i,v in ipairs(q)do
    table.insert(heliCrashSitesItems,{v.przedmiot,v.szansa,v.ilosc})
  end
end
update()

function math.percentChance(percent, repeatTime)
  local hits = 0
  for i = 1, repeatTime do
    local number = math.random(0, 200) / 2
    if percent >= number then
      hits = hits + 1
    end
  end
  return hits
end

function createHeliCrashSite()
  if cargoCol then
    destroyElement(getElementData(cargoCol, "parent"))
    destroyElement(cargoCol)
  end
  local item_id = math.random(#(heliCrashSites))
  local x, y, z = heliCrashSites[item_id][1], heliCrashSites[item_id][2], heliCrashSites[item_id][3]
  cargobob = createVehicle(548, x, y, z, nil, nil, nil)
  setElementHealth(cargobob, 0)
  setElementFrozen(cargobob, true)
  cargoCol = createColSphere(x, y, z, 3)
  setElementData(cargoCol, "parent", cargobob, false)
  setElementData(cargoCol, "helicrash", true)
  setElementData(cargoCol, "sloty", 0, false)
  for i, item in ipairs(heliCrashSitesItems) do
    local value = math.percentChance(v[2], 1)
    if(value > 0)then
      setElementData(cargoCol, item[1], math.random(item[3]))
    end
  end
  setTimer(createHeliCrashSite, 3600000, 1)
end
createHeliCrashSite()