local pojazdy = {}
local pojazdyKategorie = {}
local pojazdySpawny = {}
local pojazdyTypy = {}
local domyslnaProporcja = {}
function update()
  local qPojazdy = exports.db:q("select * from pojazdy")
  local qPojazdySpawny = exports.db:q("select * from pojazdy_spawny")
  local qPojazdyTypy = exports.db:q("select * from pojazdy_typy")
  for i,v in ipairs(qPojazdy)do
    pojazdy[v.ID] = v
    if(not pojazdyKategorie[v.typ])then
      pojazdyKategorie[v.typ] = {}
    end
    table.insert(pojazdyKategorie[v.typ],v.ID)
  end
  for i,v in ipairs(qPojazdySpawny)do
    if(not pojazdySpawny[v.typ])then
      pojazdySpawny[v.typ] = {}
    end
    x,y,z,r = unpack(split(v.pozycja,","))
    table.insert(pojazdySpawny[v.typ],{tonumber(x),tonumber(y),tonumber(z),tonumber(r)})
  end
  for i,v in ipairs(qPojazdyTypy)do
    pojazdyTypy[v.typ] = 1/v.proporcje
    domyslnaProporcja[v.typ] = 0
  end
end
update()

function getMostNeededVehicleType()
  local currentVehicles = getElementsByType("vehicle",resourceRoot)
  local proportion = domyslnaProporcja
  local mostNeeded = "auto_4drzwiowe"
  local mostNeededNumber = 99999
  for i,v in ipairs(currentVehicles)do
    local data = pojazdy[v.model]
    if(data)then
      proportion[data.typ] = proportion[data.typ] + pojazdyTypy[data.typ]
    end
  end
  for i,v in pairs(proportion)do
    if(mostNeededNumber > v)then
      mostNeededNumber = v
      mostNeeded = i
    end
  end
  return mostNeeded
end

function getVehicleTypeRandomSpawnPosition(vehicleType)
  local currentVehicles = getElementsByType("vehicle",resourceRoot)
  local free = {}
  for _,position in ipairs(pojazdySpawny[vehicleType] or {})do
    notFree = false;
    for _,vehicle in ipairs(currentVehicles)do
      if(getDistanceBetweenPoints3D(position[1],position[2],position[3],getElementPosition(vehicle)) < 5)then
        notFree = true
        do break end
      end
    end
    if(not notFree)then
      table.insert(free,position)
    end
  end
  if(#free == 0)then return false end
  return free[math.random(#free)]
end

function getRandomVehicleIDByType(vehicleType)
  if(pojazdyKategorie[vehicleType] and #pojazdyKategorie[vehicleType] > 0)then
    return pojazdyKategorie[vehicleType][math.random(#pojazdyKategorie[vehicleType])]
  else
    return false
  end
end

function createDayzVehicle(id,x,y,z,rx,ry,rz)
  local dane = pojazdy[id]
  if(dane)then
    local vehicle = createVehicle(id,x,y,z,rx,ry,rz)
    if(vehicle)then
      local offset = split(dane.offset,",")
      local collision = createColSphere(0,0,0,dane.kolizja)
      attachElements(collision,vehicle,offset[1],offset[2],offset[3])
      setElementData(vehicle, "parent", collision)
      setElementData(collision, "parent", vehicle)
      setElementData(collision, "interakcja", "pojazd")
      setElementData(collision, "opis", dane.nazwa)
      setElementData(collision, "sloty", dane.sloty, false)
      if(dane.silnik > 0)then
        setElementData(collision, "silnik", {math.random(0,dane.silnik),dane.silnik})
      else
        setElementData(collision, "silnik", {0,0})
      end
      if(dane.zbiorniki > 0)then
        local zbiornikiRandom = math.random(0,dane.zbiorniki)
        setElementData(collision, "zbiorniki", {zbiornikiRandom,dane.zbiorniki})
        if(zbiornikiRandom > 0)then
          setElementData(collision, "paliwo", {math.random(0,dane.limit_paliwa),dane.limit_paliwa})
        else
          setElementData(collision, "paliwo", {0,dane.limit_paliwa})
        end
      else
          setElementData(collision, "zbiorniki", {0,0})
          setElementData(collision, "paliwo", {0,0})
      end
      if(dane.kola > 0)then
        setElementData(collision, "kola", {math.random(0,dane.kola),dane.kola})
      else
        setElementData(collision, "kola", {0,0})
      end
      return vehicle
    end
  end
  return false
end

function spawnVehicle()
  local v = getMostNeededVehicleType()
  local randomSpawn = getVehicleTypeRandomSpawnPosition(v)
  if(randomSpawn)then
    local id = getRandomVehicleIDByType(v)
    createDayzVehicle(id,randomSpawn[1],randomSpawn[2],randomSpawn[3],0,0,randomSpawn[4])
  end
end
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()
spawnVehicle()