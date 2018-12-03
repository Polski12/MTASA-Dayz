sx,sy=guiGetScreenSize()
screenWidth,screenHeight=guiGetScreenSize()
render=false

addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  dayzVersion = "MTA:DayZ NS 0.0.0"
  versionLabel = guiCreateLabel(1, 1, 0.3, 0.3, dayzVersion, true)
  guiSetSize(versionLabel, guiLabelGetTextExtent(versionLabel), guiLabelGetFontHeight(versionLabel), false)
  x, y = guiGetSize(versionLabel, true)
  guiSetPosition(versionLabel, 1 - x, 1 - y * 1.8, true)
  guiSetAlpha(versionLabel, 0.5)
end)

function dxDrawEmptyRectangle(startX,startY,endX,endY,color,width,postGUI)
	dxDrawLine ( startX,startY,startX+endX,startY,color,width,postGUI )
	dxDrawLine ( startX,startY,startX,startY+endY,color,width,postGUI )
	dxDrawLine ( startX,startY+endY,startX+endX,startY+endY, color,width,postGUI )
	dxDrawLine ( startX+endX,startY,startX+endX,startY+endY,color,width,postGUI )
end

function math.round(number,decimals,method)
    decimals = decimals or 2
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number*factor)/factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function rysuj()
  local aktualnaKolizia = getElementData(localPlayer,"currentCol")
	if not aktualnaKolizia or not isElement(aktualnaKolizia) or getPedOccupiedVehicle(localPlayer) then
		return pokazukryj(false)
	end
  x,y,z = getElementPosition(aktualnaKolizia)
  xx,yy=getScreenFromWorldPosition(x,y,z,0,false)
  if xx and yy then
    dxDrawRectangle(xx-100,yy-50,200,100,tocolor(50,50,50,200))
    parentelement=getElementData(aktualnaKolizia,"parent")
    pojazdname=""
    if parentelement then
      if getElementType(parentelement)=="vehicle" then
        pojazdname=getVehicleName(parentelement)
      end
    end
    dxDrawText(opis,xx-100,yy-50,xx+100,yy+50,tocolor(255,255,255,255),1,"sans","center","center")
  end
  if opcje then
    i = 0
    for k,v in ipairs(opcje) do
      i = i + 1
      dxDrawRectangle(20,sy/2+i*20,220,19,tocolor(50,50,50,200))
      if i==zaznaczony then
        dxDrawEmptyRectangle(20,sy/2+i*20,220,19,tocolor(0,255,0,255))
      end
      dxDrawText(v,20,sy/2+i*20,220,(sy/2+i*20)+20,tocolor(255,255,255,255),1,"sans","center","center")
    end
    dxDrawRectangle(20,sy/2+(#opcje+1)*20,220,19,tocolor(0,0,0,255))
    dxDrawText(opis,20,sy/2+(#opcje+1)*20,220,(sy/2+(#opcje+1)*20)+20,tocolor(0,255,0,255),1,"sans","center","center")
  end
end

playerTarget = false
function targetingActivated(target)
  if target and getElementType(target) == "player" then
    playerTarget = target
  else
    playerTarget = false
  end
end
addEventHandler("onClientPlayerTarget", getRootElement(), targetingActivated)

function pokazukryj(bol)
	if bol then
		if not render then
			render=true
			addEventHandler("onClientRender",root,rysuj)
		end
	else
		if render then
			render=false
			removeEventHandler("onClientRender",root,rysuj)
		end
	end
end

function scrolup()
	if not zaznaczony then return false end
	zaznaczony=zaznaczony-1
	if zaznaczony<1 and opcje then
		zaznaczony=#opcje
	end
end
function scroldown()
	if not zaznaczony then return false end
	zaznaczony=zaznaczony+1
	if opcje and zaznaczony>#opcje then
		zaznaczony=1
	end
end
bindKey("mouse_wheel_up","down",scrolup)
bindKey("mouse_wheel_down","down",scroldown)

function uzyj()
	local aktualnaKolizja=getElementData(localPlayer,"currentCol")
	if aktualnaKolizja and opcje then
		opcj=opcje[zaznaczony]
    if(opcj)then
      triggerServerEvent("uzyj",resourceRoot,aktualnaKolizja,opis,opcj)
    end
	end
end
bindKey("x","down",uzyj)

function pokazInfo(theElement,md)
	if getElementInterior(theElement)==getElementInterior(source) and theElement and getElementDimension(theElement)==getElementDimension(source) then
		if md then
			local int=getElementData(source,"interakcja")
			if int and theElement==localPlayer and int ~="player" then
        setElementData(localPlayer,"currentCol",source,false)
        if(interkacja[int])then
          opcje=interkacja[int]
          zaznaczony=1
          opis = getElementData(source,"opis")
          pokazukryj(true)
        end
			end
		end
	end
end
function ukryjInfo(theElement,md)
	if md then
		if theElement==localPlayer then
			setElementData(localPlayer,"currentCol",false,false)
			pokazukryj(false)
      opcje = nil
      exports.dayz_inventory:clearLootGridList()
		end
	end
end
addEventHandler("onClientColShapeHit",getRootElement(),pokazInfo)
addEventHandler("onClientColShapeLeave",getRootElement(),ukryjInfo)

function rysuj_hud_pojazdu()
	local veh=getPedOccupiedVehicle(localPlayer)
	if not veh then
		return removeEventHandler("onClientRender",root,rysuj_hud_pojazdu)
	end
  local collision = veh:getData("parent")
  if(not collision)then
    return setVehicleEngineState(veh,true)
  end
	local p=getElementData(collision,"interakcja")
	if(not p)then
    return setVehicleEngineState(veh,true)
  end
  local silnik = getElementData(collision, "silnik")
  local zbiorniki = getElementData(collision, "zbiorniki")
  local kola = getElementData(collision, "kola")
  local paliwo = getElementData(collision, "paliwo")
  local engineStatus = true
	if silnik[1] >= silnik[2] then
		silnik="#00ff00Silnik: "..silnik[1].."/"..silnik[2]
	else
		silnik="#ff0000Silnik: "..silnik[1].."/"..silnik[2]
    engineStatus = false
	end
  
	if zbiorniki[1] >= zbiorniki[2] then
		zbiornik="#00ff00Zbiorniki: "..zbiorniki[1].."/"..zbiorniki[2]
	else
		zbiornik="#ff0000Zbiorniki: "..zbiorniki[1].."/"..zbiorniki[2]
    engineStatus = false
	end
  
  if kola[1] >= kola[2] then
		kola="#00ff00Koła: "..kola[1].."/"..kola[2]
	else
		kola="#ff0000Koła: "..kola[1].."/"..kola[2]
    engineStatus = false
	end
  
  if paliwo[1] > 0 or paliwo[2] == 0 then
		paliwo="#00ff00Paliwo: "..paliwo[1].."/"..paliwo[2]
	else
    paliwo="#ff0000Paliwo: "..paliwo[1].."/"..paliwo[2]
    engineStatus = false
	end
  
  setVehicleEngineState(veh,engineStatus)
	dxDrawText(silnik.."\n"..kola.."\n"..zbiornik.."\n"..paliwo,0,0,sx,40,tocolor(255,255,255,255),1.2,"sans","center","top",false,false,false,true)
end
function wejscie_do_pojazdu()
	addEventHandler("onClientRender",root,rysuj_hud_pojazdu)
end
addEventHandler("onClientPlayerVehicleEnter",localPlayer,wejscie_do_pojazdu)
addEventHandler("onClientRender",root,rysuj_hud_pojazdu)
function wyjscie_z_pojazdu()
	removeEventHandler("onClientRender",root,rysuj_hud_pojazdu)
end
addEventHandler("onClientPlayerVehicleExit",localPlayer,wyjscie_z_pojazdu)

function targetingActivated(target)
	nacelowanyGracz=target
end
addEventHandler("onClientPlayerTarget",getRootElement(),targetingActivated)

fading = 0
fading2 = "up"

function drawHud()
	if fading >= 0 and fading2 == "up" then
		fading = fading+5
	elseif fading <= 255 and fading2 == "down" then
		fading = fading-5
	end
	if fading == 0 then
		fading2 = "up"
	elseif fading == 255 then
		fading2 = "down"
	end
	dxDrawImage(screenWidth*0.9325,screenHeight*0.410,screenHeight*0.075,screenHeight*0.075,"ikony/sound.png",0,0,0,tocolor(0,255,0))
	local sound = getElementData(localPlayer,"halas") or 0/20
	if sound > 1 then
		dxDrawImage(screenWidth*0.9075,screenHeight*0.410,screenHeight*0.075,screenHeight*0.075,"ikony/level_" .. sound .. ".png",0,0,0,tocolor(0,255,0))
	end
	dxDrawImage(screenWidth*0.9325,screenHeight*0.480,screenHeight*0.075,screenHeight*0.075,"ikony/eye.png",0,0,0,tocolor(0,255,0))
	local sound = getElementData(localPlayer,"widzialnosc") or 0/20
	if sound > 1 then
		dxDrawImage(screenWidth*0.9075,screenHeight*0.480,screenHeight*0.075,screenHeight*0.075,"ikony/level_" .. sound .. ".png",0,0,0,tocolor(0,255,0))
	end
	if getElementData(localPlayer,"zlamana_noga") then
		dxDrawImage(screenWidth*0.9375,screenHeight*0.550,screenHeight*0.065,screenHeight*0.065,"ikony/brokenbone.png",0,0,0,tocolor(255,255,255))
	end
	local humanity = getElementData(localPlayer,"ludzkosc")
	if (humanity or 0) > 0 then
		do
			local humanity = getElementData(localPlayer,"ludzkosc")/9.8
			r,g,b = 255-humanity,humanity,0
		end
	else
		r,g,b = 255,0,0
	end
	dxDrawImage(screenWidth*0.925,screenHeight*0.610,screenHeight*0.1,screenHeight*0.1,"ikony/bandit.png",0,0,0,tocolor(r,g,b))
	local temperature = math.round(getElementData(localPlayer,"temperatura"),2)
	r,g,b = 0,255,0
	value = 0
	if temperature > 40 then
		r,g,b = 255,0,0
		value = 1
	elseif temperature < 32 then
		r,g,b = 0,0,255
		value = 1
	end
	if value > 0 then
		dxDrawImage(screenWidth*0.94,screenHeight*0.690,screenHeight*0.065,screenHeight*0.065,"ikony/temperature.png",0,0,0,tocolor(r,g,b,fading))
	else
		dxDrawImage(screenWidth*0.94,screenHeight*0.690,screenHeight*0.065,screenHeight*0.065,"ikony/temperature.png",0,0,0,tocolor(r,g,b))
	end
	r,g,b = 0,255,0
	local blood = getElementData(localPlayer,"krew")/47.2
	r,g,b = 255-blood,blood,0
	dxDrawImage(screenWidth*0.94,screenHeight*0.760,screenHeight*0.065,screenHeight*0.065,"ikony/blood.png",0,0,0,tocolor(r,g,b))
	if 0 < getElementData(localPlayer,"krwawienie") then
		dxDrawImage(screenWidth*0.94,screenHeight*0.760,screenHeight*0.065,screenHeight*0.065,"ikony/medic.png",0,0,0,tocolor(255,255,255,fading))
	end
	r,g,b = 0,255,0
	local food = getElementData(localPlayer,"glod")*2.55
	r,g,b = 255-food,food,0
	if food < 15 then
		dxDrawImage(screenWidth*0.94,screenHeight*0.830,screenHeight*0.065,screenHeight*0.065,"ikony/food.png",0,0,0,tocolor(r,g,b,fading))
	else
		dxDrawImage(screenWidth*0.94,screenHeight*0.830,screenHeight*0.065,screenHeight*0.065,"ikony/food.png",0,0,0,tocolor(r,g,b))
	end

	r,g,b = 0,255,0
	local thirst = getElementData(localPlayer,"pragnienie")*2.55
	r,g,b = 255-thirst,thirst,0
	if thirst < 15 then
		dxDrawImage(screenWidth*0.94,screenHeight*0.9,screenHeight*0.065,screenHeight*0.065,"ikony/thirsty.png",0,0,0,tocolor(r,g,b,fading))
	else
		dxDrawImage(screenWidth*0.94,screenHeight*0.9,screenHeight*0.065,screenHeight*0.065,"ikony/thirsty.png",0,0,0,tocolor(r,g,b))
	end
end
function hud()
	if(getElementData(localPlayer,"logedin"))then
    drawHud()
    --local x,y,z = getElementPosition(localPlayer)
    local x,y,z = getCameraMatrix()
    mojagrupa=getElementData(localPlayer,"grupa")
    sojusze=getElementData(getLocalPlayer(),"grupa_sojusze")
    if nacelowanyGracz and isElement(nacelowanyGracz) and getElementType(nacelowanyGracz)=="player" then
      local px,py,pz = getElementPosition(nacelowanyGracz)
      local w = dxGetTextWidth(text,1.03,"default-bold")
      local sx,sy = getScreenFromWorldPosition(px,py,pz+0.95,0.06)
      grupa=getElementData(nacelowanyGracz,"grupa")
      text=getPlayerName(nacelowanyGracz)
      if grupa and mojagrupa[1] == grupa[1] then
        dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(0,255,0,200),1.00,"default-bold")
      elseif grupa and sojusze[mojagrupa[1]..":"..grupa[1]] then
        dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(0,0,255,200),1.00,"default-bold")
      else
        dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(255,0,0,200),1.00,"default-bold")
      end
    end
    for i,player in ipairs(getElementsByType("player")) do
      if player ~= localPlayer then
        if getElementInterior(localPlayer)==getElementInterior(player) and getElementDimension(localPlayer)==getElementDimension(player) then
          setPlayerNametagShowing(player,false)
          local px,py,pz = getElementPosition(player)
          local pdistance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
          if pdistance <= 3 then
            local sx,sy = getScreenFromWorldPosition(px,py,pz+0.95,0.06)
            if sx and sy then
              text = string.gsub(getPlayerName(player),"#%x%x%x%x%x%x","")
              local w = dxGetTextWidth(text,1.03,"default-bold")
              grupa=getElementData(player,"grupa")
              if grupa and mojagrupa and mojagrupa[1] == grupa[1] then
                dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(0,255,0,200),1.00,"default-bold")
              elseif grupa and sojusze[mojagrupa[1]..":"..grupa[1]] then
                dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(0,0,255,200),1.00,"default-bold")
              else
                dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(255,0,0,200),1.00,"default-bold")
              end
            end
          end
        end
      end
    end
    local vehicle = getPedOccupiedVehicle(localPlayer)
    for i,veh in ipairs(getElementsByType("vehicle")) do
      if veh ~= vehicle then
        if getElementInterior(localPlayer)==getElementInterior(veh) and getElementDimension(localPlayer)==getElementDimension(veh) then
          local px,py,pz = getElementPosition(veh)
          local vehID = getElementModel(veh)
          local pdistance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
          if pdistance <= 6 then
            local sx,sy = getScreenFromWorldPosition(px,py,pz+0.95,0.06)
            if sx and sy then
              local w = dxGetTextWidth(getVehicleName(veh),1.02,"default-bold")
              dxDrawText(getVehicleName(veh).." : "..veh.model,sx-w/2,sy,sx-w/2,sy,tocolor(100,255,100,200),1.02,"default-bold")
            end
          end
        end
      end
    end
  end
end
addEventHandler("onClientRender",root,hud)

function playerStatsClientSite()
	toggleControl("radar",true)
	showPlayerHudComponent("all",false)
	showPlayerHudComponent("crosshair",true)
	showPlayerHudComponent("weapon",true)
	setPlayerHudComponentVisible("ammo",true)
	toggleControl("radar",false)
	showPlayerHudComponent("clock",false)
	showPlayerHudComponent("radar",false)
	showPlayerHudComponent("money",false)
	showPlayerHudComponent("health",false)
	showPlayerHudComponent("breath",false)
	if getElementData(localPlayer,"logedin")==false then return end
	if getElementData(localPlayer,4005) or 0 >= 1 then
		toggleControl("radar",true)
	else
		forcePlayerMap(false)
	end
	if getElementData(localPlayer,4006) or 0 >= 1 then
		showPlayerHudComponent("radar",true)
	end
	--if 1 <= getElementData(localPlayer,"Watch") then
	--	showPlayerHudComponent("clock",true)
	--end TODO
end
playerStatsClientSite()
setTimer(playerStatsClientSite,1000,0)

statsWindows = guiCreateStaticImage(0.85,0.18,0.15,0.20,"ikony/debugtlo.png",true)
guiSetAlpha(statsWindows,0.8)

statsLabel = guiCreateLabel(0,0,1,1,"",true,statsWindows)
guiSetFont(statsLabel,"default-bold-small")
guiLabelSetColor(statsLabel,0,255,0)
guiLabelSetVerticalAlign ( statsLabel,"center" )
guiLabelSetHorizontalAlign ( statsLabel,"center" )

function showDebugMonitor ()
    local visible = guiGetVisible(statsWindows)
	if visible then
		guiSetVisible(statsWindows,true)
	else
		guiSetVisible(statsWindows,false)
		end
end
bindKey("F5","down",showDebugMonitor)

function showDebugMintorOnLogin ()
    guiSetVisible(statsWindows,true)
end
addEvent("onClientPlayerDayZLogin",true)
addEventHandler("onClientPlayerDayZLogin",root,showDebugMintorOnLogin)

function refreshDebugMonitor()
    if getElementData(getLocalPlayer(),"logedin") then
      local zombiealive = getElementData(getRootElement(),"zombiesalive") or 0
      local zombietotal = getElementData(getRootElement(),"zombiestotal") or 0
      local zabitezombie = getElementData(getLocalPlayer(),"aktualne_zabite_zombie")
      local morderstwa = getElementData(getLocalPlayer(),"aktualne_zabici_gracze")
      local krew = getElementData(getLocalPlayer(),"krew")
      local temp = getElementData(getLocalPlayer(),"temperatura")
      local ludzk = getElementData(getLocalPlayer(),"ludzkosc")

      guiSetText(statsLabel,string.format([[Krew: %s/12000
Zombie Żywe/Suma: %s/%s
Zabite zombie: %s
Zabici gracze: %s
Temperatura: %s
Ludzkość: %s]],krew,zombiealive,zombietotal,zabitezombie,morderstwa,math.round(temp,2),ludzk))
    end
end
setTimer(refreshDebugMonitor,2000,0)
function showDebugMonitor()
  local visible = guiGetVisible(statsWindows)
  guiSetVisible(statsWindows,not visible)
end
bindKey("F5","down",showDebugMonitor)

function showDebugMintorOnLogin()
  guiSetVisible(statsWindows,true)
end
setTimer(refreshDebugMonitor,1000,0)

if getElementData(localPlayer,"logedin") then
    guiSetVisible(statsWindows,true)
else
    guiSetVisible(statsWindows,false)
end
refreshDebugMonitor()

addEventHandler("onClientResourceStart", getResourceRootElement(),
function()
	guiSetInputMode("no_binds_when_editing")
end)

addEventHandler ( "onClientPlayerSpawn", getLocalPlayer(), function()
  if(source == localPlayer)then
    guiSetVisible(statsWindows,true)
    refreshDebugMonitor()
  end
end )