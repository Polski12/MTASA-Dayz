rootDayzElements = createElement("rootDayzElements")
forPlacing = {
  -- granadeDestroy
  -- "blood" of placed model
  -- 0 = unbreakable from weapons
  -- sound when hit
  -- sound when destroy
  -- disapear after ms, 0 = never
  -- model id
  -- colsize; nil = nie twórz
  -- onPlaceFunction
  -- alternativePlaceFunction
  [4800] = { true, 5000, nil, nil, 1000*30, 1337, nil, function(player, element)

  end, nil},
  [4801] = { true, 2000, nil, nil, 1000*60*60*2, 823, nil, function(player, element)

  end, nil},
  [4802] = { true, 0, nil, nil, 1000*30, 1337, nil, function(player, element)
    iprint("postawił flare")
  end, nil},
  [4803] = { true, 0, nil, nil, 1000*30, 1337, nil, function(player, element)
    iprint("postawił flare")
  end, nil},
  [4804] = { true, 0, nil, nil, 1000*30, 1337, nil, function(player, element)
    iprint("postawił flare")
  end, nil},
  [4805] = { false, 0, nil, nil, 0, 1337, nil, nil, function(player)
    local x, y, z = getElementPosition(player)
    local rot = getPedRotation(player)
    local x2,y2 = exports.dayz_core:getPointFromDistanceRotation(x,y,3,-rot)
    exports.Dayz_save_tents:createEmptyTent(x2,y2,z,rot-180)
  end},
  [4805] = { false, 0, nil, nil, 0, 1337, nil, nil, function(player)
    local x, y, z = getElementPosition(player)
    local rot = getPedRotation(player)
    local x2,y2 = exports.dayz_core:getPointFromDistanceRotation(x,y,3,-rot)
    local tent,tentCol = exports.Dayz_save_tents:createEmptyTent(x2,y2,z,rot-180)
    tentCol:setData("sloty",250,false)
  end},
  
}