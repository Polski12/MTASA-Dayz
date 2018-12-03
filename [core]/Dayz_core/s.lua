function animacja(kto,animacja)
	if animacja=="uzywa" then
		setPedAnimation(kto,"BOMBER","BOM_Plant",1200,false,false,nil,false)
	elseif animacja=="jedz" then
		setPedAnimation(kto, "FOOD", "EAT_Burger",1000, false, false, nil, false)
	end
end

function update()
  local qPrzedmioty=exports.db:q("select * from przedmioty")
  local qBronie=exports.db:q("select * from bronie")
  przedmiotyKategorie = {}
  przedmioty = {}
  bronie = {}
  for i,v in ipairs(qPrzedmioty)do
    if(not przedmiotyKategorie[v.kategoria])then
      przedmiotyKategorie[v.kategoria]={}
    end
    if(v.subkategoria and not przedmiotyKategorie[v.kategoria][v.subkategoria])then
      przedmiotyKategorie[v.kategoria][v.subkategoria]={}
    end
    if(v.subkategoria)then
      table.insert(przedmiotyKategorie[v.kategoria][v.subkategoria],v.ID)
    else
      table.insert(przedmiotyKategorie[v.kategoria],v.ID)
    end
    przedmioty[v.ID] = v
  end
  for i,v in ipairs(qBronie)do
    bronie[v.bron_przedmiot] = {v.obrazenia,v.bron_gta,v.domyslna_amunicja,v.dzwiek_strzalu,v.dzwiek_przeladowania,v.zasieg,v.dzwiek}
  end
  setElementData(root,"przedmioty",przedmioty)
  setElementData(root,"przedmiotyKategorie",przedmiotyKategorie)
  setElementData(root,"bronie",bronie)
end
update()

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end