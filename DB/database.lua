CDatabase={
	sHost='127.0.0.1',
	sUser='mta_dayz',
	sPass='V8MC8urbKDA6LJuA',
	sDBname='mta_dayz',
	iPort=3306,
	hCon=false
}

function CDatabase.init()
	CDatabase.hCon=dbConnect("mysql", 'dbname=' ..CDatabase.sDBname.. ';host=' ..CDatabase.sHost, CDatabase.sUser, CDatabase.sPass, "share=1")
	if CDatabase.hCon~=false and CDatabase.hCon then
		outputDebugString('[DB] * Pomyslnie polaczono!',0,0,255,0)
		q("SET NAMES utf8;")
		setTimer(q,1000*60*2,0,'SET NAMES utf8;')
	else
		outputDebugString('[DB] * Wystąpil blad podczas polaczenia!',0,255,0,0)
		stopResource(getThisResource())
	end
end

function CDatabase.destroy()
	CDatabase.sHost=nil
	CDatabase.sUser=nil
	CDatabase.sPass=nil
	CDatabase.iPort=nil
	if isElement(CDatabase.hCon) then destroyElement(CDatabase.hCon) end
end

function q(sQuery, ...)
	local qHandler=dbQuery(CDatabase.hCon, sQuery, ...)
	local result, iRows, sError=dbPoll(qHandler, 90)
	if result==nil then
		result, iRows, sError=dbPoll(qHandler, -1)
		if result==nil then
			dbFree(qHandler)
			outputDebugString('Max query runtime reached: ' ..sQuery.. '|' ..iRows.. '|' ..sError)
			return false
		end
	end
	if result==false then
		outputDebugString('Error executing query: ' ..sQuery.. '|' ..iRows.. '|' ..sError)
		return false
	end
	return result, iRows, (sError or '-')
end

function getSingleRow(sQuery, ...)
	local qHandler=dbQuery(CDatabase.hCon, sQuery, ...)
	if not qHandler then return nil end
	local rows=dbPoll(qHandler, -1)
	if not rows then return nil end
	return rows[1]
end

function getRows(sQuery, ...)
	local qHandler=dbQuery(CDatabase.hCon, sQuery, ...)
	if not qHandler then return nil end
	local rows=dbPoll(qHandler, -1)
	if not rows then return nil end
	return rows
end

function e(sQuery, ...)
	return dbExec(CDatabase.hCon, sQuery, ...)
end

-- event
addEventHandler('onResourceStart', resourceRoot, function()
	CDatabase.init()
end)

addEventHandler('onResourceStop', resourceRoot, function()
	CDatabase.destroy()
end)

function now(dni)
	return q("select now() + interval ? day as data;",dni)[1]["data"]
end