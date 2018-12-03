local hospitalPacks = {}
local hospitalItems = {}
function update()
  local q=exports.db:q("select * from szpital")
  for i,v in ipairs(q)do
    table.insert(hospitalPacks,split(v.pozycja,","))
  end
  q=exports.db:q("select * from przedmioty where ID between 3000 and 3100")
  for i,v in ipairs(q)do
    table.insert(hospitalItems,v.ID)
  end
end
update()

function updateHospitals()
  for i, box in pairs(hospitalCol) do
    for _, items in ipairs(hospitalItems) do
      local randomNumber = math.random(1, 10)
      if randomNumber >= 2 then
        setElementData(hospitalCol[i], items, math.random(1, 5))
      end
    end
  end
  setTimer(updateHospitals, 3600000, 1)
end

hospitalCol = {}
function createHospitalPacks()
  number1 = 0
  for i, box in ipairs(hospitalPacks) do
    number1 = number1 + 1
    local x, y, z = box[1], box[2], box[3]
    object = createObject(1558, x, y, z, nil, nil, nil)
    hospitalCol[i] = createColSphere(x, y, z, 2)
    setElementData(hospitalCol[i], "parent", object)
    setElementData(hospitalCol[i], "hospitalbox", true)
    setElementData(hospitalCol[i], "MAX_Slots", 20)
    for _, items in ipairs(hospitalItems) do
      local randomNumber = math.random(1, 10)
      if randomNumber >= 2 then
        setElementData(hospitalCol[i], items, math.random(1, 5))
      end
    end
  end
  setTimer(updateHospitals, 3600000, 1)
end
createHospitalPacks()