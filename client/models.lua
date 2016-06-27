Models = {}
Models.replace = {
  --[2942] = {dff = "files/models/atm/atm.dff", txd = "files/models/atm/atm.txd", col = "files/models/atm/atm.col"}
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
end
