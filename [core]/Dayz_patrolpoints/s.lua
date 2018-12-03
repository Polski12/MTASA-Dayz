local patrolPoints = {}
function update()
  local q=exports.db:q("select * from stacje")
  for i,v in ipairs(q)do
    table.insert(patrolPoints,split(v.pozycja,","))
  end
end
update()

for i, patrol in ipairs(patrolPoints) do
  local patrolCol = createColSphere(patrol[1], patrol[2], patrol[3], 3)
  setElementData(patrolCol, "interakcja", "stacja")
  setElementData(patrolCol, "opis", "Stacja paliw")
end
