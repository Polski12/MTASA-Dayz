_root=getResourceRootElement(getThisResource())
function zaloguj(login,haslo)
	q=exports.db:q("select haslo,ID from konta where login=? limit 1",login)
	if #q==0 then
		return outputChatBox("[BŁĄD]#FF9900 Takie konto nie istnieje",client,255,255,255,true)
	end
	haslo_=haslo
	if passwordVerify(haslo, q[1]["haslo"]) then
		haslo_="*POPRAWNE*"
		outputChatBox("[SUKCES]#FF9900 Hasło poprawne!",client,255,255,255,true)
		fadeCamera(client,false)
		triggerClientEvent(client,"onPlayerDoneLogin",client)
		setTimer(function(plr)
      exports.Dayz_spawn:spawnDayZPlayer(plr,true)
			fadeCamera(plr,true)
      plr:setData("joinTime",getTickCount(),false)
		end,1250,1,client)
    exports.db:e("insert into logi_konta values(NULL,now(),?,?,?,?,?)",login,client.serial,client.ip,"logowanie", "login "..tostring(login))
    local acc = getAccount(login)
    if(acc)then
      logIn(client,acc,string.sub(md5(haslo_),1,24))
    end
    setElementData(client,"uid",q[1]["ID"],false)
    setElementData(client,"login",login)
	else
		outputChatBox("[BŁĄD]#FF9900 Błędne hasło!",client,255,255,255,true)
    exports.db:e("insert into logi_konta values(NULL,now(),?,?,?,?,?)",login,client.serial,client.ip,"próba zalogowania", "użyte hasło "..tostring(haslo_)..", login "..tostring(login))
	end
end
addEvent("wyslij_zaloguj",true)
addEventHandler("wyslij_zaloguj",_root,zaloguj)

function zarejestruj(login,haslo)
	q=exports.db:q("select login from konta where login=? limit 1",login)
	if #q>0 then
		return outputChatBox("[BŁĄD]#FF9900 Taki login jest już zajęty!",client,255,255,255,true)
	end
	serial=getPlayerSerial(client)
	ip=getPlayerIP(client)
	q=exports.db:q("select count(serial) as serial,count(ip) as ip from konta where serial=? || ip=? limit 6",serial,ip)
	if q[1]["serial"]>=3 or q[1]["ip"]>=3 then
		return outputChatBox("[BŁĄD]#FF9900 Posiadasz abyt dużo kont! Jeśli masz problem, zgłoś się na forum: www.niceshot.eu",client,255,255,255,true)
	end
	sql="insert into konta values(null,?,?,?,?,now(),'')"
  pass = passwordHash(haslo,"bcrypt",{})
	exports.db:e(sql,login,pass,serial,ip)
	outputChatBox("[SUKCES]#FF9900Konto zarejestrowane pomyślnie! Teraz możesz się zalogować",client,255,255,255,true)
  addAccount(login,string.sub(md5(haslo),1,24))
  exports.Dayz_spawn:spawnDayZPlayer(client)
end
addEvent("wyslij_zarejestruj", true)
addEventHandler("wyslij_zarejestruj",_root,zarejestruj)

addEventHandler("onPlayerJoin", getRootElement(),
  function()
    fadeCamera(source, true) 
    setCameraMatrix(source, -256.76953125,-426.6572265625,12.220329284668, -159.232421875,-332.634765625,11.737413406372)
  end
)