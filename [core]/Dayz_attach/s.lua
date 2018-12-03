objektyAttach = {}
objektyAttach["Plecaki"] = {}
objektyAttach["BronieNaPlecachA"] = {}
objektyAttach["BronieNaPlecachB"] = {}
objektyAttach["BronieNaPlecachC"] = {}
objektyAttach["TrzymaneBronie"] = {}

function laduj()
	plecaki={}
	bronie={}
  przedmiotyModele = {}
	q=exports.db:q("select ID,model from przedmioty")
  for i,v in ipairs(q)do
    przedmiotyModele[v.ID] = v.model
  end
	q=exports.db:q("select * from plecaki")
	for i,v in ipairs(q) do
    local x,y,z,rx,ry,rz = unpack(split(v.offset,","))
		plecaki[v.pojemnosc]={v.pojemnosc,v.ID,{x,y,z,rx,ry,rz,true}}
	end
	q=exports.db:q("SELECT * FROM bronie")
	for i,v in ipairs(q) do
		bronie[v.bron_przedmiot]=v
	end
	
end
laduj()

function clearAttachedElementForPlayer(player)
  for i,v in pairs(objektyAttach) do
    if objektyAttach[i][player] then
      exports.bone_attach:detachElementFromBone(objektyAttach[i][player])
      destroyElement(objektyAttach[i][player])
      objektyAttach[i][player] = false
    end
  end
end
function updateAttachForPlayer(plr,usun,arg1,arg2)
	clearAttachedElementForPlayer(plr)
	if usun then return end
	-- PLECAK
	plecak=plecaki[getElementData(plr,"sloty")]
	if not plecak then plecak=plecaki[8] end
	objektyAttach["Plecaki"][plr] = createObject(przedmiotyModele[plecak[2]],0,0,0)
	exports.bone_attach:attachElementToBone(objektyAttach["Plecaki"][plr],plr,3,unpack(plecak[3]))
  if(arg2 ~= 0)then
    local currentWeapon = exports.dayz_core:getCurrentSlotFromWeapon(plr,arg2)
    if(currentWeapon)then
      local model = plr:getData("aktualnabron_"..currentWeapon)
      if(model and przedmiotyModele[model])then
        objektyAttach["TrzymaneBronie"][plr] = createObject(przedmiotyModele[model],0,0,0,0,0,0,true)
        exports.bone_attach:attachElementToBone(objektyAttach["TrzymaneBronie"][plr],plr,12,0,0,0,180,90,180)
        iprint(objektyAttach["TrzymaneBronie"][plr])
      end
    end
  end
  --[[
	local bron=getElementData(plr,"_Aktualnabron_1_")
	if bron and bron~="" then
		local bronT = bronie[bron]
		if bronT and bronT.id_broni~=arg2 or not arg2 then
			objektyAttach["BronieNaPlecachA"][plr] = createObject(bronT.id_objektu, x, y, z)
			setObjectScale(objektyAttach["BronieNaPlecachA"][plr], 0.875)
			exports.bone_attach:attachElementToBone(objektyAttach["BronieNaPlecachA"][plr],plr, 3, 0.17,-0.05,0.2,176,240,0)
		end
	end]]
end


setTimer(function()
	for i,v in ipairs(getElementsByType("player")) do
		updateAttachForPlayer(v)
	end
end,100,1)

function spawnGracza()
	updateAttachForPlayer(source)
end
addEventHandler("onPlayerSpawn",getRootElement(),spawnGracza)

function zmianaBroni(pre,cur)
	updateAttachForPlayer(source,false,pre,cur)
end
addEventHandler("onPlayerWeaponSwitch",getRootElement(),zmianaBroni)

function quitPlayer()
	clearAttachedElementForPlayer(source)
end
addEventHandler("onPlayerQuit",getRootElement(),quitPlayer)
