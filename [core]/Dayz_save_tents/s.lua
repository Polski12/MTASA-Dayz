function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

local items = {};
function update()
  items = {};
  local q=exports.db:q("select * from przedmioty")
  for i,v in ipairs(q)do
    table.insert(items,v.ID)
  end
end
update()

function createEmptyTent(x,y,z, rot)
  local tent = createObject(3243, x,y,z, 0, 0, rot)
  local x2,y2 = exports.dayz_core:getPointFromDistanceRotation(x,y,1,-rot)
  tentCol = createColSphere(x2,y2, z, 2)
  setElementData(tentCol, "interakcja", "namiot")
  setElementData(tentCol, "opis", "Namiot")
  setElementData(tentCol, "sloty", 100, false)
  setElementParent(tentCol,tent)
  return tent,tentCol
end

function getLastSave()
  local q = exports.db:q("select max(ID) as i from zapis_namioty")
  if(q)then
    return q[1].i
  else
    return false
  end
end

function save()
  local tents = {}
  for i,v in ipairs(getElementsByType("object",resourceRoot))do
    local tent = {}
    local x,y,z = getElementPosition(v)
    local _,_,r = getElementRotation(v)
    tent.p = {math.round(x,2),math.round(y,2),math.round(z,2),math.round(r,2)}
    local tentCol = v.children[1]
    tent.m = v.model
    tent.s = tentCol:getData("sloty") or 100
    tent.i = {}
    for _,itemID in ipairs(items) do
      local q=tentCol:getData(itemID)
      if(q and q>0)then
        tent.i[itemID] = q
      end
    end
    table.insert(tents,tent)
  end
  if(#tents == 0)then return false end
  exports.db:e("insert into zapis_namioty values(null,now(),?)",toJSON(tents,true))
  return getLastSave()
end

function clearTents()
  for i,v in ipairs(getElementsByType("object",resourceRoot))do
    v:destroy()
  end
end

function load(id)
  local q = exports.db:q("select * from zapis_namioty where ID = ? limit 1",id)
  if(q and #q > 0)then
    q = q[1]
    local tents = fromJSON(q.dane)
    if(#tents > 0)then
      clearTents()
      for i,v in ipairs(tents)do
        local tent,tentCol = createEmptyTent(v.p[1],v.p[2],v.p[3],v.p[4])
        for item,ammount in pairs(v.i)do
          tentCol:setData(tonumber(item),tonumber(ammount),false)
        end
        tentCol:setData("sloty",v.s or 100)
        if(v.m)then
          tent.model = v.m
        end
      end
    end
  end
end

function loadLast()
  local last = getLastSave()
  if(last)then
    load(last)
  end
end

addEventHandler ( "onResourceStop", resourceRoot, 
  function ( resource )
    save()
  end 
)

addEventHandler ( "onResourceStart", resourceRoot, 
  function ( resource )
    loadLast()
  end 
)