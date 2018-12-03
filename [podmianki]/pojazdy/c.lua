for i=400,611 do
  if(fileExists("podmianki/"..i..".txd"))then
    local txd = engineLoadTXD("podmianki/"..i..".txd")
    engineImportTXD(txd, i)
    local dff = engineLoadDFF("podmianki/"..i..".dff", i)
    engineReplaceModel(dff, i)
  end
end