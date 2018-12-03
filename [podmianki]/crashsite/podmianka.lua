col = engineLoadCOL ( "meszek.col" )
engineReplaceCOL ( col, 13611 )
engineSetModelLODDistance ( 13611, 1000 )

txd = engineLoadTXD('hunter.txd');
engineImportTXD(txd, 13611);
dff = engineLoadDFF('hunter.dff', 13611);
engineReplaceModel(dff, 13611);