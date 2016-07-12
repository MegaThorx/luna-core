ORM = {}
ORM.prefix = "Db"
--[[
  TODO
  Allow DbOject with Find
]]

ORM.Init = function()
  for tableName, columns in pairs(DBSchema) do
    local newName = ORM.prefix..Utils.FirstToUpper(tableName)
    _G[newName] = {}

    _G[newName]["GetFromElement"] = function(element)
      for k, v in pairs(columns) do
        if v.primarykey then
          local key = ElementData.Get(element, tableName.."."..v.name)
          if key then
            return _G[newName]["FindOneBy"..Utils.FirstToUpper(v.name)](key)
          end
        end
      end
      return false
    end

    _G[newName]["Create"] = function()
      return ORM.GenerateObject(tableName, nil)
    end

    _G[newName]["Find"] = function(where, orderBy)
      local sql = "SELECT * FROM "..tableName

      local wString = ORM.GenerateWhere(tableName, where)
      if wString ~= "" then
        sql = sql.." WHERE "..wString
      end

      local oString = ORM.GenerateOrderBy(orderBy)

      if oString ~= "" then
        sql = sql.." ORDER BY "..oString
      end

      local handle = SQL.Query(sql)
      local result, count = SQL.Poll(handle, -1)
      if count > 0 then
        return ORM.GenerateObjects(tableName, result)
      end

      return false
    end

    for _, data in pairs(columns) do
      local func = "FindBy"..Utils.FirstToUpper(data.name)
      _G[newName][func] = function(where, orderBy)
        local handle = SQL.Query("SELECT * FROM "..tableName.." WHERE " .. data.name .. " = ?", where)
        local result, count = SQL.Poll(handle, -1)
        if count > 0 then
          return ORM.GenerateObjects(tableName, result)
        end
        return false
      end
    end


    _G[newName]["FindOne"] = function(where, orderBy)
      local sql = "SELECT * FROM "..tableName

      local wString = ORM.GenerateWhere(tableName, where)
      if wString ~= "" then
        sql = sql.." WHERE "..wString
      end

      local oString = ORM.GenerateOrderBy(orderBy)

      if oString ~= "" then
        sql = sql.." ORDER BY "..oString
      end

      sql = sql.." LIMIT 1"
      local handle = SQL.Query(sql)
      local result, count = SQL.Poll(handle, -1)
      if count > 0 then
        return ORM.GenerateObject(tableName, result[1])
      end

      return false
    end

    for _, data in pairs(columns) do
      local func = "FindOneBy"..Utils.FirstToUpper(data.name)
      _G[newName][func] = function(where, orderBy)

        if data.reference then
          local handle = SQL.Query("SELECT * FROM "..tableName.." WHERE " .. data.reference.joinColumn.name .. " = ? LIMIT 1", where["Get"..Utils.FirstToUpper(data.reference.joinColumn.referencedColumnName)]())
          local result, count = SQL.Poll(handle, -1)
          if count > 0 then
            return ORM.GenerateObject(tableName, result[1])
          end
        else
          local handle = SQL.Query("SELECT * FROM "..tableName.." WHERE " .. data.name .. " = ? LIMIT 1", where)
          local result, count = SQL.Poll(handle, -1)
          if count > 0 then
            return ORM.GenerateObject(tableName, result[1])
          end
        end
        return false
      end
    end

  end
end

ORM.GenerateWhere = function(tableName, where)
  local wString = ""

  if where then
    for k, v in pairs(where) do
      if wString ~= "" then
        wString = wString.." AND "
      end

      local val = v
      local key = k

      if type(v) == "table" then
        local data = ORM.GetDataForColumn(tableName, k)
        val = v["Get"..Utils.FirstToUpper(data.reference.joinColumn.referencedColumnName)]()
        key = data.reference.joinColumn.name
      end

      wString = wString..key.." = "..SQL.PrepareString(val)
    end
  end

  return wString
end

ORM.GenerateOrderBy = function(orderBy)
  local oString = ""


  return oString
end

ORM.GenerateObjects = function(tableName, data)
  local objs = {}
  for i, v in ipairs(data) do
    objs[i] = ORM.GenerateObject(tableName, v)
  end
  return objs
end

ORM.GetDataForColumn = function(tableName, column)
  for k,v in pairs(DBSchema[tableName]) do
    if v.name == column then
      return v
    elseif v.reference and v.reference.joinColumn.name == column then
      return v
    end
  end
  return false
end

ORM.GenerateObject = function(tableName, data)
  local obj = {}
  local private = {}
  local isModified = false
  local modified = {}
  local struct = DBSchema[tableName]
  local isNew = false
  if data == nil then
    isNew = true
    data = {}
  end

  for _, column in pairs(struct) do
    local name = Utils.FirstToUpper(column.name)
    local columnName = column.name

    if column.reference then
      columnName = column.reference.joinColumn.name
    end

    -- GETTER
    obj["Get"..name] = function()
      if column.reference then
        return _G[ORM.prefix..Utils.FirstToUpper(column.reference.targetEntity)].FindOneById(data[columnName])
      else
        return data[columnName]
      end
    end

    -- SETTER
    if not column.primarykey then
      obj["Set"..name] = function(value)
        if column.reference then
          if value then
            if value["Get"..Utils.FirstToUpper(column.reference.joinColumn.referencedColumnName)]() then
              data[columnName] = value["Get"..Utils.FirstToUpper(column.reference.joinColumn.referencedColumnName)]()
              isModified = true
              modified[columnName] = true
              return true
            end
          end
          return false
        else
          if column.unique then
            if _G[ORM.prefix..Utils.FirstToUpper(tableName)]["FindOneBy"..Utils.FirstToUpper(column.name)](value) then
              return false
            end

            data[columnName] = value
            modified[columnName] = true
            isModified = true
            return true
          else
            data[columnName] = value
            modified[columnName] = true
            isModified = true
            return true
          end
        end
      end
    end
  end

  obj["CopyDataToElement"] = function(element)
    for _, column in pairs(struct) do
      local name = column.name
      local columnName = column.name

      if column.reference then
        columnName = column.reference.joinColumn.name
      end

      if column.custom and (column.custom.storeClient or column.custom.storeServer) then
        ElementData.Set(element, tableName.."."..name, data[columnName], column.custom.storeClient)
      end
    end
  end


  obj["CopyDataFromElement"] = function(element)
    for _, column in pairs(struct) do
      local name = column.name
      local columnName = column.name

      if column.reference then
        columnName = column.reference.joinColumn.name
      end

      if column.custom and (column.custom.storeClient or column.custom.storeServer) then
        if column.custom.autoSave then
          local val = ElementData.Get(element, tableName.."."..name)
          if val then
            obj["Set"..Utils.FirstToUpper(column.name)](val)
          end
        end
      end
    end
  end

  obj["Persist"] = function(force)
    if isModified == false then return false end

    if not isNew then
      local upd = ""
      for k,v in pairs(data) do
        if modified[k] then
          if upd ~= "" then
            upd = upd..", "
          end
          upd = upd..SQL.PrepareString(k.." = ?", v)
        end
      end

      local handle = SQL.Query("UPDATE `".. tableName .."` SET "..upd.." WHERE id = ?", data.id)
      local _, count = SQL.Poll(handle, -1)
      if count == 1 then
        modified = {}
        return true
      end
    else
      local ins = "INSERT INTO `%s` (%s) VALUES (%s);"
      local keys = ""
      local values = ""

      for k,v in pairs(data) do
        if modified[k] then
          if keys ~= "" then
            keys = keys..", "
          end
          keys = keys..k

          if values ~= "" then
            values = values..", "
          end
          values = values..SQL.PrepareString("?", v)
        end
      end

      ins = string.format(ins, tableName, keys, values)

      local handle = SQL.Query(ins)
      local _, count = SQL.Poll(handle, -1)
      if count == 1 then
        modified = {}
        return true
      end
    end

    return false
  end

  return obj
end

ORM.Test = function()
  outputServerLog("------------")
  outputServerLog("> Test 1 <")
  local tick = getTickCount()
  SQL.StartCounter()
  SQL.StartCollectionServingTime()

  for i=1, 1000 do
    --local account = DbAccounts.FindOneByUsername("Klausela")
    --local bankaccount = DbBankAccounts.FindOneById(1)
    --bankaccount.GetAccount().GetUsername()
    --bankaccount.SetAccount(account)
    --bankaccount.Persist()
    --bankaccount.GetAccount().GetUsername()
  end
  local diff = getTickCount() - tick
  local count = SQL.StopCounter()
  local timings = SQL.StopCollectionServingTime()
  local average = 0
  local amount = 0

  for i,v in ipairs(timings) do
    amount = amount + 1
    average = average + v
  end

  average = average / amount


  outputServerLog(count.." requests")
  outputServerLog(average * 1000 .."µs average response time")
  outputServerLog(diff.."ms")
  outputServerLog("------------")
  outputServerLog("> Test 2 <")

  local tick = getTickCount()

  --local account = DbAccounts.FindOneByUsername("Klausela")
  --local bankaccount = DbBankAccounts.FindOneById(1)
  --for i=1, 100000 do
  --  bankaccount.GetId()
  --end

  local diff = getTickCount() - tick

  outputServerLog(diff.."ms")
  --[[
  local account = DbAccounts.FindOneByUsername("Klausela")

  local element = createElement("test")
  account.CopyDataToElement(element)
  outputDebugString(tostring(ElementData.Get(element, "accounts.id")))
  local acc = DbAccounts.GetFromElement(element)
  outputDebugString(tostring(acc))
  outputDebugString(tostring(acc.GetUsername()))]]

    --for k,v in pairs(account) do
    --  outputServerLog(k)
    --end

    --outputServerLog(tostring(account.GetName()))
    --outputServerLog(tostring(account.SetName("MegaThorx")))
    --outputServerLog(tostring(account.GetName()))
    --outputServerLog(tostring(account.Persist()))


      --for k,v in pairs(bankaccount) do
      --  outputServerLog(k)
      --end

  --[[
  local account = DbAccounts.FindOneByName("Klausela")
  local bankaccount = DbBankAccounts.FindOneById(1)
  outputServerLog(tostring(bankaccount))
  outputServerLog("-------")
  outputServerLog(tostring(bankaccount.GetAccount().GetName()))
  outputServerLog(tostring(bankaccount.SetAccount(account)))
  outputServerLog(tostring(bankaccount.Persist()))
  outputServerLog(tostring(bankaccount.GetAccount().GetName()))
  outputServerLog("-------")
  local bankaccount = DbBankAccounts.FindOneByAccount(account)
  outputServerLog(tostring(bankaccount.GetAccount().GetName()))

  outputServerLog("-------")
  local accounts = DbAccounts.Find({})
  for k,v in pairs(accounts) do
    outputServerLog(tostring(v.GetId()).." "..tostring(v.GetName()))
  end
  outputServerLog("-------")


  outputServerLog("-------")
  local accounts = DbAccounts.Find({id = 4, playtime = 10})
  for k,v in pairs(accounts) do
    outputServerLog(tostring(v.GetId()).." "..tostring(v.GetName()))
  end
  outputServerLog("-------")
  local bankAccounts = DbBankAccounts.Find({account = account})
  for k,v in pairs(bankAccounts) do
    outputServerLog(tostring(v.GetId()))
  end
  outputServerLog("-------")

  local acc = DbAccounts.Create()
  if not acc.SetName("Johannes") then
    outputServerLog("failed to set name")
  end

  outputServerLog("name "..tostring(acc.GetName()))

  if not acc.Persist() then
    outputServerLog("failed to create new account")
  end]]

end

addCommandHandler("create", function(player, cmd, name)
  local acc = DbAccounts.Create()
  acc.SetName(name)

  if not acc.Persist() then
    outputServerLog("failed to create new account")
    return
  end
  outputServerLog("created new account "..acc.GetName())
end)
