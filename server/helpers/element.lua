Element = {}

Element.SetData = function(element, data, table)

  for k,v in pairs(data) do
    if (SQL_STRUCTURE[table][k].custom and (SQL_STRUCTURE[table][k].custom.storeClient or SQL_STRUCTURE[table][k].custom.storeServer)) then
      if SQL_STRUCTURE[table][k].custom.storeClient then
        ElementData.Set(element, k, v, true)
      else
        ElementData.Set(element, k, v, false)
      end
    end
  end
end


Element.SaveData = function(element, table)
    local query = "UPDATE "..table.." SET "
    
    for k,v in pairs(SQL_STRUCTURE[table]) do
      if SQL_STRUCTURE[table][k].custom and SQL_STRUCTURE[table][k].custom.autoSave then
        if query ~= "UPDATE "..table.." SET " then
          query = query..", "
        end
        query = query..SQL.PrepareString(k.." = ?", ElementData.Get(element, k))
      end
    end
    query = query.." WHERE id = ?"

    SQL.Exec(query, ElementData.Get(element, "id"))
end

Element.Destroy = function(element)
  return destroyElement(element)
end
