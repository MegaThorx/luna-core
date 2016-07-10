Element = {}

--[[Element.SetData = function(element, data, table)

  for k,v in pairs(data) do
    if (SQL_STRUCTURE[table][k].custom and (SQL_STRUCTURE[table][k].custom.storeClient or SQL_STRUCTURE[table][k].custom.storeServer)) then
      if SQL_STRUCTURE[table][k].custom.storeClient then
        ElementData.Set(element, k, v, true)
      else
        ElementData.Set(element, k, v, false)
      end
    end
  end
end]]


Element.SaveData = function(element, tableName)
  local data = _G["Db"..Utils.FirstToUpper(tableName)].GetFromElement(element)

  if data then
    data.CopyDataFromElement(element)
    return data.Persist()
  end

  return false
end

Element.Destroy = function(element)
  return destroyElement(element)
end
