for i=0,20000 do
  if(fileExists("modele/"..i..".dff"))then
    local txd = engineLoadTXD("modele/"..i..".txd")
    engineImportTXD(txd, i)
    local dff = engineLoadDFF("modele/"..i..".dff", i)
    engineReplaceModel(dff, i)
  end
end