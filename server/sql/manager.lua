SQLManager = {}

SQLManager.PreGenerate = function()
  for key, value in pairs(DBSchema) do
    for i, field in pairs(value) do
      if field.include then
        if not DBSchemaIncludes[field.include] then
          outputDebugString("Failed to find definition for sql include "..tostring(field.include), 1)
        else
          local incl = DBSchemaIncludes[field.include]

          DBSchema[key][i].include = nil
          for k,v in pairs(incl) do
            if not DBSchema[key][i][k] then
              DBSchema[key][i][k] = v
            end
          end
        end
      end
    end
  end
end

SQLManager.Validate = function()
  SQLManager.PreGenerate()
  local handle = SQL.Query("SELECT TABLE_NAME as name FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE' AND TABLE_SCHEMA=?", Config.Get("db.dbname"))
  local result = SQL.Poll(handle, -1)
  local found = {}

  for k,v in pairs(result) do
    if DBSchema[v.name] then
      found[v.name] = true
      SQLManager.ValidateTable(v["name"], DBSchema[v["name"]])
    end
  end
  for k,v in pairs(DBSchema) do
    if not found[k] then
      SQLManager.CreateTable(k, v)
    end
  end
  SQLManager.ValidateReferences()
end

SQLManager.ValidateTable = function(name, structure)
  local shandle = SQL.Query(string.format("SHOW columns FROM `%s`.`%s`", Config.Get("db.dbname"), name))
  local struc = SQL.Poll(shandle, -1)

  for k,v in pairs(structure) do
    local found;
    local cname = v.name

    if v.reference then
      cname = v.reference.joinColumn.name
    end

    for k2,v2 in pairs(struc) do

      if(v2["Field"]==cname)then
        found = k2
        break
      end
    end

    if found then
      local updateRequired = false

      if(v.datatype)then
        if(v.length)then
          if not (string.lower(struc[found]["Type"]) == string.lower(string.format("%s(%i)", v.datatype, v.length))) then
            updateRequired = true
          end
        else
          local pos = string.find(struc[found]["Type"], "(", 1, true)
          if not pos then
            if string.lower(struc[found]["Type"]) ~= string.lower(v.datatype) then
              outputDebugString(string.lower(struc[found]["Type"]).." "..string.lower(v.datatype))
              updateRequired = true
            end
          else
            if string.lower(string.sub(struc[found]["Type"], 0, (#struc[found]["Type"] - pos + 2)*-1)) ~= string.lower(v.datatype) then
              updateRequired = true
            end
          end
        end
      end

      if(v.nullable)then
        if not struc[found]["Null"]=="YES" then
          updateRequired = true
        end
      else
        if not struc[found]["Null"]=="NO" then
          updateRequired = true
        end
      end

      if updateRequired then
        local sql = string.format("ALTER TABLE `%s`.`%s`", Config.Get("db.dbname"), name)

        sql = sql..string.format(" CHANGE COLUMN `%s` %s", cname, SQLManager.GenerateColumn(v))

        SQL.Exec(sql)
      end
    else
      local sql = string.format("ALTER TABLE `%s`.`%s`", Config.Get("db.dbname"), name)

      sql = sql..string.format(" ADD COLUMN %s", SQLManager.GenerateColumn(v))

      SQL.Exec(sql)
    end
  end
end

SQLManager.CreateTable = function(tableName, structure)
  local sql = string.format("CREATE TABLE `%s`.`%s` (", Config.Get("db.dbname"), tableName)

  local first = true
  local primarykey

  for i, data in pairs(structure) do
    local qr = string.format("%s", SQLManager.GenerateColumn(data))

    if not first then
      qr = ", "..qr
    end
    first = false

    if(data.primarykey)then
      primarykey = data.name
    end

    sql = sql..qr
  end

  if primarykey then
    sql = sql..string.format(", PRIMARY KEY (`%s`)", primarykey)
  end
  sql = sql..");"
  outputServerLog(sql)
  SQL.Exec(sql)
end

SQLManager.ValidateReferences = function()
  local sql = string.format("SELECT * FROM information_schema.KEY_COLUMN_USAGE WHERE table_schema = '%s' AND CONSTRAINT_NAME != 'PRIMARY'", Config.Get("db.dbname"))
  local handle = SQL.Query(sql)
  local result = SQL.Poll(handle, -1)
  for tableName, data in pairs(DBSchema) do
    for _, column in pairs(data) do
      if column.reference then
        local hasReference = false
        for _, v in pairs(result) do
          if v.TABLE_NAME == tableName then
            if v.COLUMN_NAME == column.reference.joinColumn.name then
              if v.REFERENCED_TABLE_NAME == column.reference.targetEntity then
                if v.REFERENCED_COLUMN_NAME == column.reference.joinColumn.referencedColumnName then
                  hasReference = true
                end
              end
            end
          end
        end
        if not hasReference then
          local sql = string.format("ALTER TABLE `%s`.`%s` ADD FOREIGN KEY (`%s`) REFERENCES `%s`.`%s`(`%s`);", Config.Get("db.dbname"), tableName, column.reference.joinColumn.name, Config.Get("db.dbname"), column.reference.targetEntity, column.reference.joinColumn.referencedColumnName)
          SQL.Exec(sql)
        end
      end
    end
  end
end

SQLManager.GenerateColumn = function(data)
  local sql = string.format("`%s`", data.name)

  if(data.reference)then
    sql = string.format("`%s`", data.reference.joinColumn.name)
    local dtmp
    for k,v in ipairs(DBSchema[data.reference.targetEntity]) do
      if v.name == data.reference.joinColumn.referencedColumnName then
        dtmp = v
        break
      end
    end

    if(dtmp.datatype)then
      if(dtmp.length)then
        sql = sql..string.format(" %s(%i)", dtmp.datatype, dtmp.length)
      else
        sql = sql..string.format(" %s", dtmp.datatype)
      end

      if(data.nullable)then
        sql = sql.." NULL"
      else
        sql = sql.." NOT NULL"
      end
    end
  else
    if(data.datatype)then
      if(data.length)then
        sql = sql..string.format(" %s(%i)", data.datatype, data.length)
      else
        sql = sql..string.format(" %s", data.datatype)
      end
    end

    if not data.default then
      if(data.nullable)then
        sql = sql.." NULL"
      else
        sql = sql.." NOT NULL"
      end
    end

    if(data.autoincrement)then
      sql = sql.." AUTO_INCREMENT"
    end

    if(data.default)then
      if type(data.default) == "number" then
        sql = sql.." NULL DEFAULT "..data.default
      elseif type(data.default) == "string" then
        sql = sql.." NULL DEFAULT \""..data.default.."\""
      end
    end
  end

  return sql
end
