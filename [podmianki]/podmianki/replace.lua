local weapons = {
   {fileName="ak47", model=355},{fileName="colt", model=346},
   {fileName="m4", model=356},{fileName="magnum", model=348},
   {fileName="mp5", model=353},{fileName="shotgun", model=349},
   {fileName="sniper", model=358},{fileName="uzi", model=352},
   {fileName="katana", model=339},{fileName="baseball", model=336},
   {fileName="silen", model=347}, {fileName="spaz", model=351},{fileName="off", model=350}, {fileName="lee", model=357}
}
 
function load()
    for index, weapon in pairs(weapons) do
        tex = engineLoadTXD ( "models/weap/"..weapon.fileName.. ".txd", weapon.model )
        engineImportTXD ( tex, weapon.model )
        mod = engineLoadDFF ( "models/weap/"..weapon.fileName.. ".dff", weapon.model )
        engineReplaceModel ( mod, weapon.model )
    end
end
 
addEventHandler("onClientResourceStart",resourceRoot,
function ()
        setTimer ( load, 1000, 1)
end)

--PRZEDMIOTY

txd = engineLoadTXD('przedmioty/luneta.txd');
engineImportTXD(txd, 1510);
dff = engineLoadDFF('przedmioty/luneta.dff', 1510);
engineReplaceModel(dff, 1510);

txd = engineLoadTXD('przedmioty/tankparts.txd');
engineImportTXD(txd, 1008);
dff = engineLoadDFF('przedmioty/tankparts.dff', 1008);
engineReplaceModel(dff, 1008);

txd = engineLoadTXD('przedmioty/woda.txd');
engineImportTXD(txd, 2683);
dff = engineLoadDFF('przedmioty/woda.dff', 2683);
engineReplaceModel(dff, 2683);

txd = engineLoadTXD('przedmioty/Bandage.txd');
engineImportTXD(txd, 1578);
dff = engineLoadDFF('przedmioty/Bandage.dff', 1578);
engineReplaceModel(dff, 1578);

txd = engineLoadTXD('przedmioty/esc.txd');
engineImportTXD(txd, 2673);
dff = engineLoadDFF('przedmioty/esc.dff', 2673);
engineReplaceModel(dff, 2673);

txd = engineLoadTXD('przedmioty/morphine.txd');
engineImportTXD(txd, 1579);
dff = engineLoadDFF('przedmioty/morphine.dff', 1579);
engineReplaceModel(dff, 1579);

txd = engineLoadTXD('przedmioty/tentz.txd');
engineImportTXD(txd, 1279);
dff = engineLoadDFF('przedmioty/tentz.dff', 1279);
engineReplaceModel(dff, 1279);

txd = engineLoadTXD('przedmioty/map.txd');
engineImportTXD(txd, 1277);
dff = engineLoadDFF('przedmioty/map.dff', 1277);
engineReplaceModel(dff, 1277);

txd = engineLoadTXD('przedmioty/GPS.txd');
engineImportTXD(txd, 2976);
dff = engineLoadDFF('przedmioty/GPS.dff', 2976);
engineReplaceModel(dff, 2976);

txd = engineLoadTXD('przedmioty/watch.txd');
engineImportTXD(txd, 2710);
dff = engineLoadDFF('przedmioty/watch.dff', 2710);
engineReplaceModel(dff, 2710);

txd = engineLoadTXD('przedmioty/rawmeat.txd');
engineImportTXD(txd, 2804);
dff = engineLoadDFF('przedmioty/rawmeat.dff', 2804);
engineReplaceModel(dff, 2804);

txd = engineLoadTXD('przedmioty/blood.txd');
engineImportTXD(txd, 1580);
dff = engineLoadDFF('przedmioty/blood.dff', 1580);
engineReplaceModel(dff, 1580);

txd = engineLoadTXD('przedmioty/hospitalbox.txd');
engineImportTXD(txd, 1558);
dff = engineLoadDFF('przedmioty/hospitalbox.dff', 1558);
engineReplaceModel(dff, 1558);

txd = engineLoadTXD('przedmioty/painkiller.txd');
engineImportTXD(txd, 2709);
dff = engineLoadDFF('przedmioty/painkiller.dff', 2709);
engineReplaceModel(dff, 2709);

txd = engineLoadTXD('przedmioty/hitpak.txd');
engineImportTXD(txd, 1576);
dff = engineLoadDFF('przedmioty/hitpak.dff', 1576);
engineReplaceModel(dff, 1576);

txd = engineLoadTXD('przedmioty/fak.txd');
engineImportTXD(txd, 2891);
dff = engineLoadDFF('przedmioty/fak.dff', 2891);
engineReplaceModel(dff, 2891);

--txd = engineLoadTXD('flara.txd');
--engineImportTXD(txd, 324);
--dff = engineLoadDFF('flara.dff', 324);
--engineReplaceModel(dff, 324);

itemTXD = engineLoadTXD ("przedmioty/soda_can.txd");
engineImportTXD (itemTXD, 2647);
itemDFF = engineLoadDFF ("przedmioty/soda_can.dff", 2647);
engineReplaceModel (itemDFF, 2647);

itemTXD = engineLoadTXD ("przedmioty/beans_can.txd");
engineImportTXD (itemTXD, 2601);
itemDFF = engineLoadDFF ("przedmioty/beans_can.dff", 2601);
engineReplaceModel (itemDFF, 2601);

itemTXD = engineLoadTXD ("przedmioty/pasta_can.txd");
engineImportTXD (itemTXD, 2770);
itemDFF = engineLoadDFF ("przedmioty/pasta_can.dff", 2770);
engineReplaceModel (itemDFF, 2770);

txd = engineLoadTXD('przedmioty/kukmit.txd');
engineImportTXD(txd, 2806);
dff = engineLoadDFF('przedmioty/kukmit.dff', 2806);
engineReplaceModel(dff, 2806);

txd = engineLoadTXD('przedmioty/tulboks.txd');
engineImportTXD(txd, 2969);
dff = engineLoadDFF('przedmioty/tulboks.dff', 2969);
engineReplaceModel(dff, 2969);

txd = engineLoadTXD('przedmioty/drynwo.txd');
engineImportTXD(txd, 1463);
dff = engineLoadDFF('przedmioty/drynwo.dff', 1463);
engineReplaceModel(dff, 1463);

txd = engineLoadTXD('przedmioty/kanister.txd');
engineImportTXD(txd, 1650);
dff = engineLoadDFF('przedmioty/kanister.dff', 1650);
engineReplaceModel(dff, 1650);

txd = engineLoadTXD('przedmioty/silnik.txd');
engineImportTXD(txd, 929);
dff = engineLoadDFF('przedmioty/silnik.dff', 929);
engineReplaceModel(dff, 929);

txd = engineLoadTXD('przedmioty/drut.txd');
engineImportTXD(txd, 933);
dff = engineLoadDFF('przedmioty/drut.dff', 933);
engineReplaceModel(dff, 933);

txd = engineLoadTXD('przedmioty/kolo.txd');
engineImportTXD(txd, 1073);
dff = engineLoadDFF('przedmioty/kolo.dff', 1073);
engineReplaceModel(dff, 1073);

itemTXD = engineLoadTXD ("przedmioty/pistol_ammo.txd");
engineImportTXD (itemTXD, 3013);
itemDFF = engineLoadDFF ("przedmioty/pistol_ammo.dff", 3013);
engineReplaceModel (itemDFF, 3013);

itemTXD = engineLoadTXD ("przedmioty/shotgun_ammo.txd");
engineImportTXD (itemTXD, 2039);
itemDFF = engineLoadDFF ("przedmioty/shotgun_ammo.dff", 2039);
engineReplaceModel (itemDFF, 2039);

itemTXD = engineLoadTXD ("przedmioty/smg_ammo.txd");
engineImportTXD (itemTXD, 2041);
itemDFF = engineLoadDFF ("przedmioty/smg_ammo.dff", 2041);
engineReplaceModel (itemDFF, 2041);

itemTXD = engineLoadTXD ("przedmioty/sniper_ammo.txd");
engineImportTXD (itemTXD, 2358);
itemDFF = engineLoadDFF ("przedmioty/sniper_ammo.dff", 2358);
engineReplaceModel (itemDFF, 2358);

itemTXD = engineLoadTXD ("przedmioty/assault_ammo.txd");
engineImportTXD (itemTXD, 1271);
itemDFF = engineLoadDFF ("przedmioty/assault_ammo.dff", 1271);
engineReplaceModel (itemDFF, 1271);

itemTXD = engineLoadTXD("przedmioty/backpack_small.txd")
engineImportTXD(itemTXD, 3026)
itemDFF = engineLoadDFF("przedmioty/backpack_small.dff", 3026)
engineReplaceModel(itemDFF, 3026)

itemTXD = engineLoadTXD("przedmioty/backpack_alice.txd")
engineImportTXD(itemTXD, 1248)
itemDFF = engineLoadDFF("przedmioty/backpack_alice.dff", 1248)
engineReplaceModel(itemDFF, 1248)

itemTXD = engineLoadTXD("przedmioty/backpack_coyote.txd")
engineImportTXD(itemTXD, 1252)
itemDFF = engineLoadDFF("przedmioty/backpack_coyote.dff", 1252)
engineReplaceModel(itemDFF, 1252)

itemTXD = engineLoadTXD("przedmioty/backpack_czech.txd")
engineImportTXD(itemTXD, 1575)
itemDFF = engineLoadDFF("przedmioty/backpack_czech.dff", 1575)
engineReplaceModel(itemDFF, 1575)

itemTXD = engineLoadTXD("przedmioty/backpack_marines.txd")
engineImportTXD(itemTXD, 2289)
itemDFF = engineLoadDFF("przedmioty/backpack_marines.dff", 2289)
engineReplaceModel(itemDFF, 2289)

itemTXD = engineLoadTXD("przedmioty/backpack_military.txd")
engineImportTXD(itemTXD, 2288)
itemDFF = engineLoadDFF("przedmioty/backpack_military.dff", 2288)
engineReplaceModel(itemDFF, 2288)