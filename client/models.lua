Models = {}
Models.replace = {
  [2942] = {dff = "files/models/atm/atm.dff", txd = "files/models/atm/atm.txd", col = "files/models/atm/atm.col"},
  [10820] = {dff = "files/models/bridge/baybridge.dff", txd = "files/models/bridge/baybridge.txd", col = "files/models/bridge/baybridge.col"},
  [7079] = {txd = "files/models/bridge/baybridge.txd"}
}

Models.Init = function()
  for k,v in pairs(Models.replace) do
    if v.txd then
      local txd = engineLoadTXD(v.txd)
      engineImportTXD(txd, k)
    end
    if v.dff then
      local dff = engineLoadDFF(v.dff)
      engineReplaceModel ( dff, k )
    end
    if v.col then
      local col = engineLoadCOL(v.col)
      engineReplaceCOL(col, k)
    end
  end

  for i=11379, 11382 do
    removeWorldModel(i, 1000, -1397.8000488281, 826.40002441406, 47.200000762939)
  end
end
